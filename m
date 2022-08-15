Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F1BC25B08
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Aug 2022 23:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353745AbiHOXi0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Aug 2022 19:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353980AbiHOXhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Aug 2022 19:37:07 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C8F3152425;
        Mon, 15 Aug 2022 13:09:42 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0E76379F0;
        Mon, 15 Aug 2022 15:08:24 -0500 (CDT)
Message-ID: <8d33a7a0-7a7c-47a1-ed84-83fd25089897@sandeen.net>
Date:   Mon, 15 Aug 2022 15:09:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Content-Language: en-US
To:     Petr Vorel <pvorel@suse.cz>, Dave Chinner <david@fromorbit.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>,
        linux-xfs@vger.kernel.org, ltp@lists.linux.it
References: <YvZc+jvRdTLn8rus@pevik> <YvZUfq+3HYwXEncw@pevik>
 <YvZTpQFinpkB06p9@pevik> <20220814224440.GR3600936@dread.disaster.area>
 <YvoSeTmLoQVxq7p9@pevik>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: LTP test df01.sh detected different size of loop device in v5.19
In-Reply-To: <YvoSeTmLoQVxq7p9@pevik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/15/22 4:31 AM, Petr Vorel wrote:
> Hi Dave,
> 
>> On Fri, Aug 12, 2022 at 03:20:37PM +0200, Petr Vorel wrote:
>>> Hi all,
> 
>>> LTP test df01.sh found different size of loop device in v5.19.
>>> Test uses loop device formatted on various file systems, only XFS fails.
>>> It randomly fails during verifying that loop size usage changes:
> 
>>> grep ${TST_DEVICE} output | grep -q "${total}.*${used}" [1]
> 
>>> How to reproduce:
>>> # PATH="/opt/ltp/testcases/bin:$PATH" df01.sh -f xfs # it needs several tries to hit
> 
>>> df saved output:
>>> Filesystem     1024-blocks    Used Available Capacity Mounted on
>>> ...
>>> /dev/loop0          256672   16208    240464       7% /tmp/LTP_df01.1kRwoUCCR7/mntpoint
>>> df output:
>>> Filesystem     1024-blocks    Used Available Capacity Mounted on
>>> ...
>>> tmpfs               201780       0    201780       0% /run/user/0
>>> /dev/loop0          256672   15160    241512       6% /tmp/LTP_df01.1kRwoUCCR7/mntpoint
>>> => different size
>>> df01 4 TFAIL: 'df -k -P' failed, not expected.
> 
>> Yup, most likely because we changed something in XFS related to
>> internal block reservation spaces. That is, the test is making
>> fundamentally flawed assumptions about filesystem used space
>> accounting.
> 
>> It is wrong to assuming that the available capacity of a given empty
>> filesystem will never change.  Assumptions like this have been
>> invalid for decades because the available space can change based on
>> the underlying configuration or the filesystem. e.g. different
>> versions of mkfs.xfs set different default parameters and so simply
>> changing the version of xfsprogs you use between the two comparision
>> tests will make it fail....
> 
>> And, well, XFS also has XFS_IOC_{GS}ET_RESBLKS ioctls that allow
>> userspace to change the amount of reserved blocks. They were
>> introduced in 1997, and since then we've changed the default
>> reservation the filesystem takes at least a dozen times.
> 
> Thanks a lot for valuable info.
> 
>>>> It might be a false positive / bug in the test, but it's at least a changed behavior.
> 
>> Yup, any test that assumes "available space" does not change from
>> kernel version to kernel version is flawed. There is no guarantee
>> that this ever stays the same, nor that it needs to stay the same.
> I'm sorry I was not clear. Test [1] does not measure "available space" between
> kernel releases. It just run df command with parameters, saves it's output
> and compares "1024-blocks" and "Used" columns of df output with stat output:

Annotating what these do...

> 		local total=$(stat -f mntpoint --printf=%b)  # number of blocks allocated
> 		local free=$(stat -f mntpoint --printf=%f)   # free blocks in filesystem
> 		local used=$((total-free))                   # (number of blocks free)
> 
> 		local bsize=$(stat -f mntpoint --printf=%s)  # block size ("for faster transfers")
> 		total=$((($total * $bsize + 512)/ 1024))     # number of 1k blocks allocated?
> 		used=$((($used * $bsize + 512) / 1024))      # number of 1k blocks used?
> 
> And comparison with "$used" is what sometimes fails.
> 
> BTW this happens on both distros when loop device is on tmpfs. I'm trying to
> trigger it on ext4 and btrfs, not successful so far. Looks like it's tmpfs
> related.
> 
> If that's really expected, we might remove this check for used for XFS
> (not sure if check only for total makes sense).

It's kind of hard to follow this test, but it seems to be trying to
ensure that df output is consistent with du (statfs) numbers, before
and after creating and removing a 1MB file.  I guess it's literally
testing df itself, i.e. that it actually presents the numbers it obtained
from statfs.

AFAICT the difference in the failure is 1024 1K blocks, which is the size
the file that's been created and removed during the test.

My best guess is that this is xfs inode deferred inode inactivation hanging
onto the space a little longer than the test expects.

This is probably because the new-ish xfs inode inactivation no longer blocks
on inode garbage collection during statfs().

IOWS, I think the test expects that free space is reflected in statfs numbers
immediately after a file is removed, and that's no longer the case here. They
change in between the df check and the statfs check.

(The test isn't just checking that the values are correct, it is checking that
the values are /immediately/ correct.)

Putting a "sleep 1" after the "rm -f" in the test seems to fix it; IIRC
the max time to wait for inodegc is 1s. This does slow the test down a bit.

-Eric
