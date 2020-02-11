Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A795C352A3
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 14:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D332E20870
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 14:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgBKOED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 09:04:03 -0500
Received: from xes-mad.com ([162.248.234.2]:32845 "EHLO mail.xes-mad.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgBKOED (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Feb 2020 09:04:03 -0500
Received: from [10.52.16.140] (vfazio1.xes-mad.com [10.52.16.140])
        by mail.xes-mad.com (Postfix) with ESMTP id A6EB12021C;
        Tue, 11 Feb 2020 08:04:01 -0600 (CST)
Subject: Re: [PATCH 1/1] xfs: fallback to readonly during recovery
To:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     Aaron Sierra <asierra@xes-inc.com>, linux-xfs@vger.kernel.org
References: <20200210211037.1930-1-vfazio@xes-inc.com>
 <99259ceb-2d0d-1054-4335-017f1854ba14@sandeen.net>
 <829353330.403167.1581373892759.JavaMail.zimbra@xes-inc.com>
 <400031d2-dbcb-a0de-338d-9a11f97c795c@sandeen.net>
 <20200211125504.GA2951@bfoster>
From:   Vincent Fazio <vfazio@xes-inc.com>
Message-ID: <e8169b53-252b-b133-7bc5-ee5dc206c402@xes-inc.com>
Date:   Tue, 11 Feb 2020 08:04:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200211125504.GA2951@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All,

On 2/11/20 6:55 AM, Brian Foster wrote:
> On Mon, Feb 10, 2020 at 05:40:03PM -0600, Eric Sandeen wrote:
>> On 2/10/20 4:31 PM, Aaron Sierra wrote:
>>>> From: "Eric Sandeen" <sandeen@sandeen.net>
>>>> Sent: Monday, February 10, 2020 3:43:50 PM
>>>> On 2/10/20 3:10 PM, Vincent Fazio wrote:
>>>>> Previously, XFS would fail to mount if there was an error during log
>>>>> recovery. This can occur as a result of inevitable I/O errors when
>>>>> trying to apply the log on read-only ATA devices since the ATA layer
>>>>> does not support reporting a device as read-only.
>>>>>
>>>>> Now, if there's an error during log recovery, fall back to norecovery
>>>>> mode and mark the filesystem as read-only in the XFS and VFS layers.
>>>>>
>>>>> This roughly approximates the 'errors=remount-ro' mount option in ext4
>>>>> but is implicit and the scope only covers errors during log recovery.
>>>>> Since XFS is the default filesystem for some distributions, this change
>>>>> allows users to continue to use XFS on these read-only ATA devices.
>>>> What is the workload or scenario where you need this behavior?
>>>>
>>>> I'm not a big fan of ~silently mounting a filesystem with latent errors,
>>>> tbh, but maybe you can explain a bit more about the problem you're solving
>>>> here?
>>> Hi Eric,
>>>
>>> We use SSDs from multiple vendors that can be configured at power-on (via
>>> GPIO) to be read-write or write-protected. When write-protected we get I/O
>>> errors for any writes that reach the device. We believe that behavior is
>>> correct.
>>>
>>> We have found that XFS fails during log recovery even when the log is clean
>>> (apparently due to metadata writes immediately before actual recovery).
>> There should be no log recovery if it's clean ...
>>
>> And I don't see that here - a clean log on a readonly device simply mounts
>> RO for me by default, with no muss, no fuss.
>>
>> # mkfs.xfs -f fsfile
>> ...
>> # losetup /dev/loop0 fsfile
>> # mount /dev/loop0 mnt
>> # touch mnt/blah
>> # umount mnt
>> # blockdev --setro /dev/loop0
>> # dd if=/dev/zero of=/dev/loop0 bs=4k count=1
>> dd: error writing ‘/dev/loop0’: Operation not permitted
>> # mount /dev/loop0 mnt
>> mount: /dev/loop0 is write-protected, mounting read-only
>> # dmesg
>> [  419.941649] /dev/loop0: Can't open blockdev
>> [  419.947106] XFS (loop0): Mounting V5 Filesystem
>> [  419.952895] XFS (loop0): Ending clean mount
>> # uname -r
>> 5.5.0
>>
I think it's important to note that you're calling `blockdev --setro` 
here, which sets the device RO at the block layer...

As mentioned in the commit message, the SSDs we work with are ATA 
devices and there is no such mechanism in the ATA spec to report to the 
block layer that the device is RO. What we run into is this:

xfs_log_mount
     xfs_log_recover
         xfs_find_tail
             xfs_clear_stale_blocks
                 xlog_write_log_records
                     xlog_bwrite

the xlog_bwrite fails and triggers the call to xfs_force_shutdown. In 
this specific scenario, we know the log is clean as XFS_MOUNT_WAS_CLEAN 
is set in the log flags, however the stale blocks cannot be removed due 
to the device being write-protected. the call to xfs_clear_stale_blocks 
cannot be obviated because, as mentioned before, ATA devices do not have 
a mechanism to report that they're read-only.

>>> Vincent and I believe that mounting read-only without recovery should be
>>> fine even when the log is not clean, since the filesystem will be consistent,
>>> even if out-of-date.
>> I think that you may be making too many assumptions here, i.e. that "log
>> recovery failure leaves the filesystem in a consistent state" - and that
>> may not be true in all cases.
>>
>> IOWS, transitioning to a new RO state for your particular case may be safe,
>> but I'm not sure that's universally true for all log replay failures.
>>
> Agreed. Just to double down on this bit, this is definitely a misguided
> assumption. Generally speaking, XFS logging places ordering rules on
> metadata writes to the filesystem such that we can guarantee we can
> always recover to a consistent point after a crash. By skipping recovery
> of a dirty log, you are actively bypassing that mechanism.
>
> For example, if a filesystem transaction modifies several objects, those
> objects are logged in a transaction and committed to the physical log.
> Once the transaction is committed to the physical log, the individual
> objects are free to be written back in any arbitrary order because of
> the transactional guarantee that log recovery provides. So nothing
> prevents one object from being written back while another is reused (and
> re-pinned) before a crash that leaves the filesystem in a corrupted
> state. Log recovery is required to update the associated metadata
> objects and make the fs consistent again.
>
> In short, it's probably safer to assume any filesystem mounted with a
> dirty log and norecovery is in fact corrupted as opposed to the other
> way around.
>
> Brian
>
>>> Our customers' use often requires nonvolatile memory to be write-protected
>>> or not based on the device being installed in a development or deployed
>>> system. It is ideal for them to be able to mount their filesystems read-
>>> write when possible and read-only when not without having to alter mount
>>> options.
>>  From my example above, I'd like to understand more why/how you have a
>> clean log that fails to mount by default on a readonly block device...
>> in my testing, no writes get sent to the device when mounting a clean
>> log.
>>
>> -Eric
>>
-- 
Vincent Fazio
Embedded Software Engineer - Linux
Extreme Engineering Solutions, Inc
http://www.xes-inc.com

