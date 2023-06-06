Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812DEC7EE23
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 00:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjFFAJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 20:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbjFFAJx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 20:09:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197CEFD
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 17:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA3B7627BD
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 00:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C620C433D2;
        Tue,  6 Jun 2023 00:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686010192;
        bh=eo/ubW9cbBbLugUGZ0z935oro4btBYoVqxU7RKfiHYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eiZevtmnRwigakOHLfuVSzGW+vYKUILo8mdnu8ld0b/1Bdk1bKsXkOxxjo5ysCG/q
         aQQrbxnUXy3YTFKQMasJEeas64WdeAlT5nyT07jlgRb8XdviiMfCm7z/rva0P7ROGA
         g6Cte/vvSxFN1QxYdLAmJrmOcNmCj11yj8ShBnhu2FXpbVjuxQiZjeoc/Wihm/fmcm
         pdXAYeHaON/fOuFxSJMh62K1mQzqbUg8I52Sqo2NMR0S1SFE1Uge35sunGUPCZxgDs
         1WzllQpKijZtBmz6j/QpJftDqAfWOZqc4sYTGMhNJupygEqd2VccJOCGk789xLfZIy
         YzgZv1ZJagySw==
Date:   Mon, 5 Jun 2023 17:09:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: for-next rebased to d4d12c02bf5f
Message-ID: <20230606000951.GK1325469@frogsfrogsfrogs>
References: <ZH1tiD4z4/revqp3@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH1tiD4z4/revqp3@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 03:07:20PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> I just rebased the for-next tree to correct a bad fixes tag in
> the tree that was flags by a linux-next sanity check. The code is
> the same, just a commit message needed rewriting, but that means all
> the commit change and you'll need to do forced update if you pulled
> the branch I pushed a few hours ago.
> 
> -Dave.
> 
> ----------------------------------------------------------------
> 
>   git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> 
>   Head Commit: d4d12c02bf5f768f1b423c7ae2909c5afdfe0d5f
> 
>   xfs: collect errors from inodegc for unlinked inode recovery (2023-06-05 14:48:15 +1000)
> 
> ----------------------------------------------------------------
> Darrick J. Wong (1):
>       xfs: fix broken logic when detecting mergeable bmap records
> 
> Dave Chinner (9):
>       xfs: buffer pins need to hold a buffer reference
>       xfs: restore allocation trylock iteration
>       xfs: defered work could create precommits
>       xfs: fix AGF vs inode cluster buffer deadlock
>       xfs: fix double xfs_perag_rele() in xfs_filestream_pick_ag()
>       xfs: fix agf/agfl verification on v4 filesystems
>       xfs: validity check agbnos on the AGFL
>       xfs: validate block number being freed before adding to xefi
>       xfs: collect errors from inodegc for unlinked inode recovery
> 
> Geert Uytterhoeven (1):
>       xfs: Fix undefined behavior of shift into sign bit

Hmm, I don't see "xfs: fix ag count overflow during growfs" in here.
Dave, do you want to do another 6.4 bug release, or throw things back
over the wall so I can merge all the rest of the pending fixes for 6.5?

--D

> 
>  fs/xfs/libxfs/xfs_ag.c          |   5 +++-
>  fs/xfs/libxfs/xfs_alloc.c       |  91 ++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
>  fs/xfs/libxfs/xfs_alloc.h       |   6 ++---
>  fs/xfs/libxfs/xfs_bmap.c        |  10 ++++++--
>  fs/xfs/libxfs/xfs_bmap_btree.c  |   7 ++++--
>  fs/xfs/libxfs/xfs_ialloc.c      |  24 ++++++++++++-------
>  fs/xfs/libxfs/xfs_log_format.h  |   9 ++++++-
>  fs/xfs/libxfs/xfs_refcount.c    |  13 ++++++++---
>  fs/xfs/libxfs/xfs_trans_inode.c | 113 +++++++---------------------------------------------------------------------------------
>  fs/xfs/scrub/bmap.c             |  25 ++++++++++----------
>  fs/xfs/scrub/scrub.h            |   8 +++----
>  fs/xfs/xfs_buf_item.c           |  88 ++++++++++++++++++++++++++++++++++++++++++++++++++------------------
>  fs/xfs/xfs_filestream.c         |   1 -
>  fs/xfs/xfs_icache.c             |  46 +++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_icache.h             |   4 ++--
>  fs/xfs/xfs_inode.c              |  20 +++++-----------
>  fs/xfs/xfs_inode.h              |   2 +-
>  fs/xfs/xfs_inode_item.c         | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode_item.h         |   1 +
>  fs/xfs/xfs_log_recover.c        |  19 +++++++--------
>  fs/xfs/xfs_mount.h              |   1 +
>  fs/xfs/xfs_reflink.c            |   4 +++-
>  fs/xfs/xfs_super.c              |   1 +
>  fs/xfs/xfs_trans.c              |   9 ++++++-
>  24 files changed, 427 insertions(+), 229 deletions(-)
> 
> -- 
> Dave Chinner
> david@fromorbit.com
