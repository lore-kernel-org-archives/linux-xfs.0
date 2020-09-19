Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81D9C43463
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 14:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91D2521481
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 14:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgISOVt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 10:21:49 -0400
Received: from sandeen.net ([63.231.237.45]:52180 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgISOVs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 19 Sep 2020 10:21:48 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E7CCEEDD;
        Sat, 19 Sep 2020 09:20:58 -0500 (CDT)
To:     nitsuga5124 <nitsuga5124@gmail.com>, linux-xfs@vger.kernel.org
References: <2f7bfe5c-13c9-4c12-3c0a-2c1752709749@gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS Disk Repair failing with err 117 (Help Recovering Data)
Message-ID: <2aa1b309-8d7f-1b5a-6826-c31419b2488d@sandeen.net>
Date:   Sat, 19 Sep 2020 09:21:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <2f7bfe5c-13c9-4c12-3c0a-2c1752709749@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/19/20 8:40 AM, nitsuga5124 wrote:
> First of all, i want to say that i think this is not a hardware issue, the hard drive sounds fine and it didn't show any signs of slowness, it's also not very old, got it the 10th of January.
> 
> The entire disk is behind luks encryption:
> ```
> #lsblk
> sdc         8:32   0   3.6T  0 disk
> └─storage 254:1    0   3.6T  0 crypt
> ```
> 
> Recently i've been having some issues where the drive suddenly becomes unreadable (seems to be caused by kited) but all of the times it happened, using `xfs_repair` with the following syntax `sudo xfs_repair /dev/mapper/storage -v`; made the drive readable again, but this time i didn't have this luck, and the drive was unable to be repaired, leading to this error at the end:
> 
> ```
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - agno = 0
> bad hash table for directory inode 128 (no data entry): rebuilding
> rebuilding directory inode 128
> Invalid inode number 0x0
> Metadata corruption detected at 0x56135ef283e8, inode 0x84 data fork
> 
> fatal error -- couldn't map inode 132, err = 117

We need more info:

What kernel version
What xfsprogs version

What were the prior kernel messages
What were the prior xfs_repair messages

> ```
> 
> I ran `xfs_db` to see what was happening on that inode:
> `sudo xfs_db -x -c 'blockget inode 132' /dev/mapper/storage > xfs_db.log`

FWIW, "blockget inode 132" is not a valid command in xfs_db.

Perhaps you mean "blockget -i 132?"

In any case, "blockget" scans the entire disk, and apparently finds lots of
corruption along the way.

Did you unmount and open/unlock the LUKS volume before you ran repair and/or
xfs_db?

> and this are the outputs:
> 
> - stderr:
> ```
> Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 0x1b275ab8/0x1000
> Metadata corruption detected at 0x557ecac7bbfd, xfs_bnobt block 0x1b2d32e0/0x1000

<snip>

> ```
> 
> - stdout:
> It's a 14GB file, i will not send it.
> 
> Help trying to recover the data (move it to another drive) would be great.
> ideally i would fix the error, and i would move the data to another drive, shrink the partition, make a new partition with EXT4 instead of XFS, and move the data to the new partition, shrink, expand, and keep doing that until everything is moved to EXT4 or some other file system, or XFS again without whole drive encryption; i think this issues are occurring because using luks on XFS is not a common thing, so it's probably untested and unstable.

It really should be fine.

> 
> http://xfs.9218.n7.nabble.com/Assert-in-xfs-repair-Phase-7-and-other-xfs-restore-problems-td33368.html

(email above is from 8 years ago)

> I have found a possible solution for this problem in this mailing list.
> The solution looks to be to clear the corrupted inode (132)
> but i'm unable to find a way to do this while the drive is unmounted. Is this possible? if so, how?
> 
> https://forums.unraid.net/topic/66749-xfs-file-system-corruption-safest-way-to-fix/
> 
> I have also found this post on the unraid forums about the same error, (where i also found this email address), and the solution was the use a way older version of xfs_repair, but sadly that solution didn't work (probably because it's way too old?); Can you also confirm that the issue is fixed on xfs_repair xfs_repair version 5.8.0?

It's not clear what the issue is at this point.

XFS doesn't generally see self-induced fs-wide corruption, it is almost always the
result of something gone wrong in the layers below.

While that may sound like deflection, it's my assessment after very many years of
looking into these sorts of issues.

-Eric
