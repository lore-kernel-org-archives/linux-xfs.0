Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B15C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D6A20BED
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:37:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YhRVYBMm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgIAOhO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgIAOTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 10:19:24 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47517C061247
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 07:18:59 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so690342pjb.4
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 07:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A7Bs08+hU4qQvXldGC3f1WvD5Mr35B4sghoRuEXjco4=;
        b=YhRVYBMm1hxzdZWWZdK9VUsYobSKxjuIK8oesEbVw1nKxmxlwjL9FakaRQFHg1RdEf
         HH7oi3UcfF66/fXuKBI5iNWPoGMXj2Lkncgjpxh66IdKcC6r2TXX6u24LVhBTU3mx5Uo
         yantcAt6AgpCjNAAbuG7/gr7PVO71XZGIiHtzp2gAX8Oapzgj2QLd7pDNikj/fFfBKPc
         bZXRxMFI8Du6SCBnKbc9gK2quPBDWtU6hOLOrzwirlH7BpF+q0U/bZ2AHjwaxcohQRwx
         TyKpl8uyNCY2x+y9yl6Sjpkv+IrC9hYi4ZLqx4MNDUmwPE/nmJKu1U3JHUIroeZIcNSK
         MkGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A7Bs08+hU4qQvXldGC3f1WvD5Mr35B4sghoRuEXjco4=;
        b=qqSv1r2EaW/BSkWsUVG68rVADcV0PUJw8OaIn/EJIkgs+IrEVA+edLDH/EeFvFgbKN
         PF5iVJfO05YUU+hQFeyCduHgC8dztEKDGIaQm4XEW0i0A2JYs+P4kydr2Dy0zLBAKkh4
         WcGElUC3ULulpJ0GupY1r1H7xjmQ1eI5JmSGdYNR9l3awejKyHwpxFluHVWDnXFKSqUV
         PFwE2cRdHCK9l0XxHFcum4f6Y0n/a3atYFy76EkSWj4Em1sxBuWsyt2zC0dvEQLeHQi/
         +E8IU7LOhAs4B5evbFZceC1iJCbFn8KTmPeChkT57S0lAY3vuUWxZhLFoiCMheCm2VBE
         Ibcw==
X-Gm-Message-State: AOAM530kvfJLv+w4GIKaTuyJCf8gNs6iB5vvbdsCMvfx5a9gPzbD1W9o
        frMbbAsTmU0zOvOYJwbnx58=
X-Google-Smtp-Source: ABdhPJy02KYIjar1Y/DB7JYFm7LZJU9foMblC16dOZiEW9sY+v7muS6myJxkEFQbjXHHRIwo9yZNMw==
X-Received: by 2002:a17:902:bd96:b029:d0:5c75:38da with SMTP id q22-20020a170902bd96b02900d05c7538damr1937141pls.1.1598969938771;
        Tue, 01 Sep 2020 07:18:58 -0700 (PDT)
Received: from garuda.localnet ([122.171.183.205])
        by smtp.gmail.com with ESMTPSA id f18sm2111613pfj.35.2020.09.01.07.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 07:18:58 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: Introduce xfs_dfork_nextents() helper
Date:   Tue, 01 Sep 2020 19:48:30 +0530
Message-ID: <1734571.3Z8NNOGFWv@garuda>
In-Reply-To: <20200831204832.GW6096@magnolia>
References: <20200831130010.454-1-chandanrlinux@gmail.com> <20200831130010.454-3-chandanrlinux@gmail.com> <20200831204832.GW6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 1 September 2020 2:18:32 AM IST Darrick J. Wong wrote:
> On Mon, Aug 31, 2020 at 06:30:09PM +0530, Chandan Babu R wrote:
> > This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper
> > function xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents()
> > returns the same value as XFS_DFORK_NEXTENTS(). A future commit which
> > extends inode's extent counter fields will add more logic to this
> > helper.
> > 
> > This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
> > with calls to xfs_dfork_nextents().
> > 
> > No functional changes have been made.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h     |  4 ----
> >  fs/xfs/libxfs/xfs_inode_buf.c  | 29 ++++++++++++++++++++++++-----
> >  fs/xfs/libxfs/xfs_inode_buf.h  |  2 ++
> >  fs/xfs/libxfs/xfs_inode_fork.c | 10 +++++++---
> >  fs/xfs/scrub/inode.c           | 12 +++++++-----
> >  5 files changed, 40 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 31b7ece985bb..5f41e177dbda 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -992,10 +992,6 @@ enum xfs_dinode_fmt {
> >  	((w) == XFS_DATA_FORK ? \
> >  		(dip)->di_format : \
> >  		(dip)->di_aformat)
> > -#define XFS_DFORK_NEXTENTS(dip,w) \
> > -	((w) == XFS_DATA_FORK ? \
> > -		be32_to_cpu((dip)->di_nextents) : \
> > -		be16_to_cpu((dip)->di_anextents))
> >  
> >  /*
> >   * For block and character special files the 32bit dev_t is stored at the
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 5dcd71bfab2e..cce2aa99aad8 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -368,9 +368,11 @@ xfs_dinode_verify_fork(
> >  	struct xfs_mount	*mp,
> >  	int			whichfork)
> >  {
> > -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> > +	uint32_t		di_nextents;
> >  	xfs_extnum_t		max_extents;
> >  
> > +	di_nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
> > +
> >  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
> >  	case XFS_DINODE_FMT_LOCAL:
> >  		/*
> > @@ -401,6 +403,19 @@ xfs_dinode_verify_fork(
> >  	return NULL;
> >  }
> >  
> > +xfs_extnum_t
> > +xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip, int whichfork)
> 
> The first arg probaly should be a (struct xfs_mount *) to save the
> callers some typing.

Hmm. I actually did try that ... but ended up failing. I don't recall the
reason now. I will implement this suggestion.

> 
> > +{
> > +	xfs_extnum_t nextents;
> > +
> > +	if (whichfork == XFS_DATA_FORK)
> > +		nextents = be32_to_cpu(dip->di_nextents);
> > +	else
> > +		nextents = be16_to_cpu(dip->di_anextents);
> > +
> > +	return nextents;
> 
> Would this be cleaner (as well as barf loudly on invalid args)?
> 
> 	switch (whichfork) {
> 	case XFS_DATA_FORK:
> 		return be32_to_cpu(...);
> 	case XFS_ATTR_FORK:
> 		return be16_to_cpu(...);
> 	default:
> 		ASSERT(0);
> 		return 0;
> 	}

Yes, This is much better. I will include this in the next version of the
patchset.

> 
> 
> > +}
> > +
> >  static xfs_failaddr_t
> >  xfs_dinode_verify_forkoff(
> >  	struct xfs_dinode	*dip,
> > @@ -437,6 +452,8 @@ xfs_dinode_verify(
> >  	uint16_t		flags;
> >  	uint64_t		flags2;
> >  	uint64_t		di_size;
> > +	xfs_extnum_t            nextents;
> > +	int64_t			nblocks;
> >  
> >  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
> >  		return __this_address;
> > @@ -467,10 +484,12 @@ xfs_dinode_verify(
> >  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
> >  		return __this_address;
> >  
> > +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
> > +	nextents += xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
> > +	nblocks = be64_to_cpu(dip->di_nblocks);
> > +
> >  	/* Fork checks carried over from xfs_iformat_fork */
> > -	if (mode &&
> > -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> > -			be64_to_cpu(dip->di_nblocks))
> > +	if (mode && nextents > nblocks)
> >  		return __this_address;
> >  
> >  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> > @@ -527,7 +546,7 @@ xfs_dinode_verify(
> >  		default:
> >  			return __this_address;
> >  		}
> > -		if (dip->di_anextents)
> > +		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
> >  			return __this_address;
> >  	}
> >  
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> > index 6b08b9d060c2..a97caf675aaf 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.h
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> > @@ -59,5 +59,7 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
> >  xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
> >  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
> >  		uint64_t flags2);
> > +xfs_extnum_t xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip,
> > +				int whichfork);
> 
> Please try to match the second-line indentation of the declaration above
> it.  Or: two tabs is enough.

Sorry, I missed out on this one. I will fix this up.

> 
> >  
> >  #endif	/* __XFS_INODE_BUF_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 3a084aea8f85..2ce80bb5c70a 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -10,6 +10,7 @@
> >  #include "xfs_format.h"
> >  #include "xfs_log_format.h"
> >  #include "xfs_trans_resv.h"
> > +#include "xfs_sb.h"
> >  #include "xfs_mount.h"
> >  #include "xfs_inode.h"
> >  #include "xfs_trans.h"
> > @@ -104,9 +105,10 @@ xfs_iformat_extents(
> >  	int			whichfork)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_sb		*sbp = &mp->m_sb;
> >  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> > +	int			nex = xfs_dfork_nextents(sbp, dip, whichfork);
> >  	int			state = xfs_bmap_fork_to_state(whichfork);
> > -	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> >  	int			size = nex * sizeof(xfs_bmbt_rec_t);
> >  	struct xfs_iext_cursor	icur;
> >  	struct xfs_bmbt_rec	*dp;
> > @@ -226,6 +228,7 @@ xfs_iformat_data_fork(
> >  	struct xfs_inode	*ip,
> >  	struct xfs_dinode	*dip)
> >  {
> > +	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
> >  	struct inode		*inode = VFS_I(ip);
> >  	int			error;
> >  
> > @@ -234,7 +237,7 @@ xfs_iformat_data_fork(
> >  	 * depend on it.
> >  	 */
> >  	ip->i_df.if_format = dip->di_format;
> > -	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
> > +	ip->i_df.if_nextents = xfs_dfork_nextents(sbp, dip, XFS_DATA_FORK);
> >  
> >  	switch (inode->i_mode & S_IFMT) {
> >  	case S_IFIFO:
> > @@ -286,6 +289,7 @@ xfs_iformat_attr_fork(
> >  	struct xfs_inode	*ip,
> >  	struct xfs_dinode	*dip)
> >  {
> > +	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
> >  	int			error = 0;
> >  
> >  	/*
> > @@ -296,7 +300,7 @@ xfs_iformat_attr_fork(
> >  	ip->i_afp->if_format = dip->di_aformat;
> >  	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
> >  		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> > -	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> > +	ip->i_afp->if_nextents = xfs_dfork_nextents(sbp, dip, XFS_ATTR_FORK);
> >  
> >  	switch (ip->i_afp->if_format) {
> >  	case XFS_DINODE_FMT_LOCAL:
> > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > index 6d483ab29e63..e428ad0eef03 100644
> > --- a/fs/xfs/scrub/inode.c
> > +++ b/fs/xfs/scrub/inode.c
> > @@ -354,7 +354,7 @@ xchk_dinode(
> >  	xchk_inode_extsize(sc, dip, ino, mode, flags);
> >  
> >  	/* di_nextents */
> > -	nextents = be32_to_cpu(dip->di_nextents);
> > +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
> >  	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
> >  	switch (dip->di_format) {
> >  	case XFS_DINODE_FMT_EXTENTS:
> > @@ -371,10 +371,12 @@ xchk_dinode(
> >  		break;
> >  	}
> >  
> > +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
> 
> Might be a good time to change these all to "naextents"?

Sure, I will make the change.

> 
> > +
> >  	/* di_forkoff */
> >  	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
> >  		xchk_ino_set_corrupt(sc, ino);
> > -	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
> > +	if (nextents != 0 && dip->di_forkoff == 0)
> >  		xchk_ino_set_corrupt(sc, ino);
> >  	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
> >  		xchk_ino_set_corrupt(sc, ino);
> > @@ -386,7 +388,6 @@ xchk_dinode(
> >  		xchk_ino_set_corrupt(sc, ino);
> >  
> >  	/* di_anextents */
> > -	nextents = be16_to_cpu(dip->di_anextents);
> >  	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
> >  	switch (dip->di_aformat) {
> >  	case XFS_DINODE_FMT_EXTENTS:
> > @@ -464,6 +465,7 @@ xchk_inode_xref_bmap(
> >  	struct xfs_scrub	*sc,
> >  	struct xfs_dinode	*dip)
> >  {
> > +	xfs_mount_t		*mp = sc->mp;
> 
> Don't increase the usage of structure typedefs, please.

Sorry, I will replace it with 'struct xfs_mount'.

> 
> --D
> 
> >  	xfs_extnum_t		nextents;
> >  	xfs_filblks_t		count;
> >  	xfs_filblks_t		acount;
> > @@ -477,14 +479,14 @@ xchk_inode_xref_bmap(
> >  			&nextents, &count);
> >  	if (!xchk_should_check_xref(sc, &error, NULL))
> >  		return;
> > -	if (nextents < be32_to_cpu(dip->di_nextents))
> > +	if (nextents < xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK))
> >  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
> >  
> >  	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
> >  			&nextents, &acount);
> >  	if (!xchk_should_check_xref(sc, &error, NULL))
> >  		return;
> > -	if (nextents != be16_to_cpu(dip->di_anextents))
> > +	if (nextents != xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
> >  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
> >  
> >  	/* Check nblocks against the inode. */
> 


-- 
chandan



