Return-Path: <SRS0=kaVg=2T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A298BC2D0C0
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Dec 2019 04:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7157C206CB
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Dec 2019 04:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfL2EnZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 28 Dec 2019 23:43:25 -0500
Received: from sandeen.net ([63.231.237.45]:49030 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfL2EnZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 28 Dec 2019 23:43:25 -0500
Received: from [192.168.254.58] (unknown [50.34.188.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0E4D722C5;
        Sat, 28 Dec 2019 22:42:53 -0600 (CST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0 of 512 bytes
From:   Eric Sandeen <sandeen@sandeen.net>
X-Mailer: iPhone Mail (16G140)
In-Reply-To: <CAH3av2k4c63LKQ0eG9twweXEgC7QD7G_w3=c23tSO5rLP_cAfQ@mail.gmail.com>
Date:   Sat, 28 Dec 2019 20:43:02 -0800
Cc:     linux-xfs@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FED1D514-006F-4522-A227-66889C82B82C@sandeen.net>
References: <CAH3av2k4c63LKQ0eG9twweXEgC7QD7G_w3=c23tSO5rLP_cAfQ@mail.gmail.com>
To:     Utpal Bora <cs14mtech11017@iith.ac.in>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Dec 28, 2019, at 3:11 AM, Utpal Bora <cs14mtech11017@iith.ac.in> wrote:
> 
> Hi,
> 
> My XFS home drive is corrupt after trying to extend it with lvm.
> This is what I did to extend the partition.
> 1. Extend Volume group to use a new physical volume of around 1.2TB.
> This was successful without any error.
>    vgextend vg-1 /dev/sdc1
> 
> 2. Extend logical volume (home-lv) to use the free space.
>    lvextend -l 100%FREE /dev/mapper/vg--1-home--lv -r
> 
This probably invoked xfs_growfs

> 3. Resized home-lv and reduce 55 GB
>   lvreduce -L 55G  /dev/mapper/vg--1-home--lv -r
> 
XFS cannot shrink.  This corrupted your filesystem by truncating the block device.

> I assumed that -r will invoke xfs_grow internally.
> Everything was working fine until the server was restarted.
> After restart, the home volume is not mounting. Please see the following.
> 
> server% sudo mount -t xfs /dev/mapper/vg--1-home--lv /home
> mount: /home: can't read superblock on /dev/mapper/vg--1-home--lv.
> 
> server% dmesg| tail
> [162580.208796] attempt to access beyond end of device
> [162580.208800] dm-3: rw=4096, want=6650552320, limit=6640066560
> [162580.208805] XFS (dm-3): last sector read failed

Because you chopped off 55g from the end.

> server% sudo xfs_repair -n

Repair cannot read blocks that have been removed from the filesystem.


> /dev/mapper/vg--1-home--lv
> Phase 1 - find and verify superblock...
> xfs_repair: error - read only 0 of 512 bytes

Failed to read a backup super beyond the end of the reduced lv.

Grow the lv back to 100% I.e. the size before the lvreduce and it’ll probably be ok again

-Eric

> OS: Ubuntu Server 18.04.3
> Kernel: 4.15.0-72-generic
> 
> I have gone through the earlier posts on this subject. They did not help me.
> 
> Is it possible to repair the XFS volume? Kindly suggest.
> 
> Regards,
> 
> Utpal Bora
> Ph.D. Scholar
> Computer Science & Engineering
> IIT Hyderabad
> 

