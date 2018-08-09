Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730664AbeHINjC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Aug 2018 09:39:02 -0400
Date: Thu, 9 Aug 2018 07:14:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: fatal error -- couldn't map inode 4324730417, err = 117 (Big
 Noob at this please help)
Message-ID: <20180809111437.GB21030@bfoster>
References: <5290c36d-ade4-c74d-c763-9c2fb0dcb126@tpg.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5290c36d-ade4-c74d-c763-9c2fb0dcb126@tpg.com.au>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jason <jncw@tpg.com.au>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 09, 2018 at 05:24:21PM +1000, Jason wrote:
> Gday all
> 
>   Having a problem with an XFS formatted drive and hope someone can help. On
> unraid, got a format error, ran xfs_repair with the -L prefix (4.15 i think
> that whats built in),got the fatal error above and the unraid people sent me
> over here. If somebody could help that would be great thanks . here is the
> output
> 
> 
> Phase 1 - find and verify superblock...
>         - block cache size set to 738560 entries
...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
...
>         - agno = 2
> bad hash table for directory inode 4305076930 (no data entry): rebuilding
> rebuilding directory inode 4305076930
> Invalid inode number 0x0
> xfs_dir_ino_validate: XFS_ERROR_REPORT
> 
> fatal error -- couldn't map inode 4324730417, err = 117﻿

I wonder if this is one of those weird/transient verifier issues we had
from transferring over libxfs code into places where it might trip up
repair from dealing with corrupt objects. I don't recall the exact
signature(s) of that error (or affected releases), but the best first
suggestion is probably to try the latest xfs_repair.

Note that if you're running in a controlled environment where it is
difficult to upgrade or compile xfsprogs, you should be able to create a
metadump, copy the metadump off the system and test out newer repair
executables vs. the (restored) metadump on a development system. If the
latest repair handles the metadump image successfully, you'll still need
to find a way to run it against your original filesystem. If it doesn't,
then perhaps you can share the metadump with a developer to debug.

Brian

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
