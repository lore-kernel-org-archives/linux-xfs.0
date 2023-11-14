Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9D0C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 23:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjKNXqJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjKNXqJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2023 18:46:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1B6DF
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2023 15:46:05 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391E8C433C8;
        Tue, 14 Nov 2023 23:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700005565;
        bh=POLe10N3S0bRRSG5XMaN+1hnK/Na+QbHer3JjCW2bzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sMDLg5qUlCPGFMPcx36T/lCZkVmsmhJYK+4+Ax84m2qyv9mKJyes4wlmV9OYvslHS
         7FkrmTAjouahEoSQhqzxvVg8ZJtoxhySB/3J5slUfm9yrgy1r+qW9iRTUiSRo84JGC
         3hEhIhCdo8TU2DPnhom7TfDEXuOv6A5hytT7EMKmPnp+BJpJcaBgJxlrirXV7lqHGC
         DKzFyd1CltuQ4zh2JnE65PBFh+v7OvwyPCGs6b19MhfvY9PbPZ7KNAw718YqQAga+5
         VmHnrwE4tqiu94KjUj/PAhAV4EbNXvaHBMZdaqUc2x/sz7vOdBf7IWXH8KbTf1cYYK
         3Owgloi1Mx+AQ==
Date:   Tue, 14 Nov 2023 15:46:04 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 217769] XFS crash on mount on kernels >= 6.1
Message-ID: <20231114234604.GA36190@frogsfrogsfrogs>
References: <bug-217769-201763@https.bugzilla.kernel.org/>
 <bug-217769-201763-cky9OQi6cj@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-217769-201763-cky9OQi6cj@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 14, 2023 at 03:57:06PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217769
> 
> Grant Millar (grant@cylo.net) changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |grant@cylo.net
> 
> --- Comment #17 from Grant Millar (grant@cylo.net) ---
> We're experiencing the same bug following a data migration to new servers.
> 
> The servers are all running a fresh install of Debian 12 with brand new
> hardware.
> 
> So far in the past 3 days we've had 2 mounts fail with:
> 
> [28797.357684] XFS (sdn): Internal error xfs_trans_cancel at line 1097 of file
> fs/xfs/xfs_trans.c.  Caller xfs_rename+0x61a/0xea0 [xfs]
> [28797.488475] XFS (sdn): Corruption of in-memory data (0x8) detected at
> xfs_trans_cancel+0x146/0x150 [xfs] (fs/xfs/xfs_trans.c:1098).  Shutting down
> filesystem.
> [28797.488595] XFS (sdn): Please unmount the filesystem and rectify the
> problem(s)
> 
> Both occurred in the same function on separate servers: xfs_rename+0x61a/0xea0
> 
> Neither mounts are the root filesystem.

This should be fixed in 6.6, could you try that and report back?

(See "xfs: reload entire unlinked bucket lists")

--D

> 
> versionnum [0xbcf5+0x18a] =
> V5,NLINK,DIRV2,ATTR,QUOTA,ALIGN,LOGV2,EXTFLG,SECTOR,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT,CRC,FTYPE,FINOBT,SPARSE_INODES,REFLINK,INOBTCNT,BIGTIME
> 
> meta-data=/dev/sdk               isize=512    agcount=17, agsize=268435455 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> data     =                       bsize=4096   blocks=4394582016, imaxpct=50
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Please let me know if I can provide more information.
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
