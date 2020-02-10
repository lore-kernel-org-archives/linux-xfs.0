Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF68C352A4
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 23:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01E3D2082F
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 23:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBJXkF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 18:40:05 -0500
Received: from sandeen.net ([63.231.237.45]:41316 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbgBJXkF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Feb 2020 18:40:05 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8FBBB2542;
        Mon, 10 Feb 2020 17:40:01 -0600 (CST)
Subject: Re: [PATCH 1/1] xfs: fallback to readonly during recovery
To:     Aaron Sierra <asierra@xes-inc.com>
Cc:     Vincent Fazio <vfazio@xes-inc.com>, linux-xfs@vger.kernel.org
References: <20200210211037.1930-1-vfazio@xes-inc.com>
 <99259ceb-2d0d-1054-4335-017f1854ba14@sandeen.net>
 <829353330.403167.1581373892759.JavaMail.zimbra@xes-inc.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <400031d2-dbcb-a0de-338d-9a11f97c795c@sandeen.net>
Date:   Mon, 10 Feb 2020 17:40:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <829353330.403167.1581373892759.JavaMail.zimbra@xes-inc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/10/20 4:31 PM, Aaron Sierra wrote:
>> From: "Eric Sandeen" <sandeen@sandeen.net>
>> Sent: Monday, February 10, 2020 3:43:50 PM
> 
>> On 2/10/20 3:10 PM, Vincent Fazio wrote:
>>> Previously, XFS would fail to mount if there was an error during log
>>> recovery. This can occur as a result of inevitable I/O errors when
>>> trying to apply the log on read-only ATA devices since the ATA layer
>>> does not support reporting a device as read-only.
>>>
>>> Now, if there's an error during log recovery, fall back to norecovery
>>> mode and mark the filesystem as read-only in the XFS and VFS layers.
>>>
>>> This roughly approximates the 'errors=remount-ro' mount option in ext4
>>> but is implicit and the scope only covers errors during log recovery.
>>> Since XFS is the default filesystem for some distributions, this change
>>> allows users to continue to use XFS on these read-only ATA devices.
>>
>> What is the workload or scenario where you need this behavior?
>>
>> I'm not a big fan of ~silently mounting a filesystem with latent errors,
>> tbh, but maybe you can explain a bit more about the problem you're solving
>> here?
> 
> Hi Eric,
> 
> We use SSDs from multiple vendors that can be configured at power-on (via
> GPIO) to be read-write or write-protected. When write-protected we get I/O
> errors for any writes that reach the device. We believe that behavior is
> correct.
> 
> We have found that XFS fails during log recovery even when the log is clean
> (apparently due to metadata writes immediately before actual recovery).

There should be no log recovery if it's clean ...

And I don't see that here - a clean log on a readonly device simply mounts
RO for me by default, with no muss, no fuss.

# mkfs.xfs -f fsfile
...
# losetup /dev/loop0 fsfile
# mount /dev/loop0 mnt
# touch mnt/blah
# umount mnt
# blockdev --setro /dev/loop0
# dd if=/dev/zero of=/dev/loop0 bs=4k count=1
dd: error writing ‘/dev/loop0’: Operation not permitted
# mount /dev/loop0 mnt
mount: /dev/loop0 is write-protected, mounting read-only
# dmesg
[  419.941649] /dev/loop0: Can't open blockdev
[  419.947106] XFS (loop0): Mounting V5 Filesystem
[  419.952895] XFS (loop0): Ending clean mount
# uname -r
5.5.0

> Vincent and I believe that mounting read-only without recovery should be
> fine even when the log is not clean, since the filesystem will be consistent,
> even if out-of-date.

I think that you may be making too many assumptions here, i.e. that "log
recovery failure leaves the filesystem in a consistent state" - and that
may not be true in all cases.

IOWS, transitioning to a new RO state for your particular case may be safe,
but I'm not sure that's universally true for all log replay failures.

> Our customers' use often requires nonvolatile memory to be write-protected
> or not based on the device being installed in a development or deployed
> system. It is ideal for them to be able to mount their filesystems read-
> write when possible and read-only when not without having to alter mount
> options.

From my example above, I'd like to understand more why/how you have a
clean log that fails to mount by default on a readonly block device...
in my testing, no writes get sent to the device when mounting a clean
log.

-Eric
