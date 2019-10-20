Return-Path: <SRS0=FSF3=YN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65642CA9EA0
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 23:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30A6A218BA
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 23:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfJTXaB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Oct 2019 19:30:01 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54058 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbfJTXaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Oct 2019 19:30:01 -0400
Received: from dread.disaster.area (pa49-180-40-48.pa.nsw.optusnet.com.au [49.180.40.48])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F082143E6D2;
        Mon, 21 Oct 2019 10:29:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iMKe6-0002Rz-9m; Mon, 21 Oct 2019 10:29:58 +1100
Date:   Mon, 21 Oct 2019 10:29:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: remove struct xfs_icdinode
Message-ID: <20191020232958.GB8015@dread.disaster.area>
References: <20191020082145.32515-1-hch@lst.de>
 <20191020082145.32515-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020082145.32515-5-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=y881pOMu+B+mZdf5UrsJdA==:117 a=y881pOMu+B+mZdf5UrsJdA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=bWKyRvfsplLIETY6LsgA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 20, 2019 at 10:21:45AM +0200, Christoph Hellwig wrote:
> There is no point in having this sub-structure except for historical
> reasons.  Remove it and just fold the fields into struct xfs_inode.

This is too big to be reviewable. And because it changes stuff like
i_d.di_size, it could affect on-disk inode size updates. Hence I
think this needs to be broken down into smaller patches...

FWIW, A quick glance reveals:

> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ec302b7e48f3..df755de3705c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -62,12 +62,34 @@ xfs_inode_alloc(
>  	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
>  	ip->i_afp = NULL;
>  	ip->i_cowfp = NULL;
> -	ip->i_cnextents = 0;
> -	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
>  	memset(&ip->i_df, 0, sizeof(ip->i_df));
> +
>  	ip->i_flags = 0;
>  	ip->i_delayed_blks = 0;
> -	memset(&ip->i_d, 0, sizeof(ip->i_d));
> +
> +	ip->i_version = 0;
> +	ip->i_format = 0;
> +	ip->i_flushiter = 0;
> +	ip->i_uid = 0;
> +	ip->i_gid = 0;
> +	ip->i_projid = 0;
> +	ip->i_disk_size = 0;
> +	ip->i_nblocks = 0;
> +	ip->i_extsize = 0;
> +	ip->i_nextents = 0;
> +	ip->i_anextents = 0;
> +	ip->i_forkoff = 0;
> +	ip->i_aformat = 0;
> +	ip->i_dmevmask = 0;
> +	ip->i_dmstate = 0;
> +	ip->i_diflags = 0;
> +	ip->i_diflags2 = 0;
> +	ip->i_cowextsize = 0;
> +	ip->i_crtime.tv_sec = 0;
> +	ip->i_crtime.tv_nsec = 0;
> +	ip->i_cnextents = 0;
> +	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;

This is, IMO, a step backards. We're going to end up failing to
initialise new fields correctly with this...

> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index a0ca7ded3ab8..32fbe8feeb0e 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -58,8 +58,25 @@ typedef struct xfs_inode {
>  	unsigned long		i_flags;	/* see defined flags below */
>  	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
>  
> -	struct xfs_icdinode	i_d;		/* most of ondisk inode */
> -
> +	int8_t			i_version;	/* inode version */
> +	int8_t			i_format;	/* data fork format */
> +	uint16_t		i_flushiter;	/* incremented on flush */
> +	uint32_t		i_uid;		/* owner's user id */
> +	uint32_t		i_gid;		/* owner's group id */
> +	uint16_t		i_projid;	/* owner's project id */

This is a bug and should make all the 32-bit project ID tests fail.
If it doesn't them we've got a problem with our test coverage. If it
does fail, then I'm not sure this patchset has been adequately
tested...

It also introduces a hole in the structure.

> +	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
> +	xfs_rfsblock_t		i_nblocks;	/* direct & btree blocks used */
> +	xfs_extlen_t		i_extsize;	/* extent size hint  */
> +	xfs_extnum_t		i_nextents;	/* # of extents in data fork */
> +	xfs_aextnum_t		i_anextents;	/* # of extents in attr fork */
> +	uint8_t			i_forkoff;	/* attr fork offset */
> +	int8_t			i_aformat;	/* attr fork format */
> +	uint32_t		i_dmevmask;	/* DMIG event mask */
> +	uint16_t		i_dmstate;	/* DMIG state info */

If we are cleaning up the icdinode, why do these still exist in
memory?

> +	uint16_t		i_diflags;	/* random flags */
> +	uint64_t		i_diflags2;	/* more random flags */
> +	uint32_t		i_cowextsize;	/* cow extent size hint */
> +	struct timespec64	i_crtime;	/* time created */

And there's another new hole in the structure there, maybe more than
one....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
