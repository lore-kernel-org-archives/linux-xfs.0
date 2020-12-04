Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FB8C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 09:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F481227BF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 09:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgLDJFC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 04:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgLDJFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 04:05:02 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0610C061A53
        for <linux-xfs@vger.kernel.org>; Fri,  4 Dec 2020 01:04:21 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id o5so3120650pgm.10
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H60VnhjAUj7EARAWCUISwk9emQNR5k9noTPQBdfFHhI=;
        b=D2PLMhSPMnOsUKzT0m4lN1Z5HgK8fnslZI98K8LunF6t4UgnqTnMKqr57jVhpUhvDs
         6GlbwmxnCNDSk5a4H8OeQHYj/LQOeOjvR5CriYXLmaa0TTAxo7W9sLSyuAsC2TSUbAJy
         NMMrVKVGA909CwKxbKrhE+11VfnMziAfkIqbBXcwkO0NOHvQ0sBusFDh8WzBCz/5zs1T
         oPxdaUPl3OCJv+6Mumoad4TC5wbX8w3FiF+VjJVecS7IuRoJcgxLRvPeTVk0iNOOX3wW
         JJQO3+hntZu6IQyy16h/ZjIRqMD/8vCzh/iFVKmEwtFLc/DYvLC/3DHXR/dBcJGhjHCl
         F4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H60VnhjAUj7EARAWCUISwk9emQNR5k9noTPQBdfFHhI=;
        b=TNbvPhXNSe5OGvThEEm63R5PcNv6anw1sq2U8Hqm5mVPsvckD3SecPc7J+sqqtM6A/
         +N7VkPYuv8rqrFj8JE43JydNE3xLRgQtWkw3bPEOf2iV+UmrvKtkNdqhguiVSV6Y/9Rt
         EEcDV6rk05umakPnC2naxVlFzuZJtBwOVaS6o8P56Rc4hafhu81oxu2NvMWSDY87nYwU
         8DReTIPLJPeZNfUYo3c6IQz0I+vcYgAcza73OeWS52nfd61tbv6oIEdk31h73Wip6WLS
         QFphxdfvYR1uy0O75t1IRnju0RejFAyPTFOkcdS+dKMp9RDb1wzyALYznAyCOhZLq/Rq
         XsAg==
X-Gm-Message-State: AOAM532DdyswQ5ITXDCKVJ7a7hG46qph3pd05xpzBkBRL1SL62IUGi1f
        yrcxJuXS3tUWNHB3DDn3ED0=
X-Google-Smtp-Source: ABdhPJywsC27VblXeta47DL7J8+L0SFm3s9oBHlw2T4q19QGPdBBesMsZCK29xfxULJkrhbg9JOkHQ==
X-Received: by 2002:a63:33c5:: with SMTP id z188mr6747983pgz.295.1607072661432;
        Fri, 04 Dec 2020 01:04:21 -0800 (PST)
Received: from garuda.localnet ([122.171.196.244])
        by smtp.gmail.com with ESMTPSA id t16sm3295639pga.51.2020.12.04.01.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 01:04:20 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V11 04/14] xfs: Check for extent overflow when adding/removing xattrs
Date:   Fri, 04 Dec 2020 14:34:17 +0530
Message-ID: <4842874.Y7L5Z29mQF@garuda>
In-Reply-To: <20201203184559.GA106271@magnolia>
References: <20201117134416.207945-1-chandanrlinux@gmail.com> <20201117134416.207945-5-chandanrlinux@gmail.com> <20201203184559.GA106271@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 03 Dec 2020 10:45:59 -0800, Darrick J. Wong wrote:
> On Tue, Nov 17, 2020 at 07:14:06PM +0530, Chandan Babu R wrote:
> > Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
> > added. One extra extent for dabtree in case a local attr is large enough
> > to cause a double split.  It can also cause extent count to increase
> > proportional to the size of a remote xattr's value.
> > 
> > To be able to always remove an existing xattr, when adding an xattr we
> > make sure to reserve inode fork extent count required for removing max
> > sized xattr in addition to that required by the xattr add operation.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       | 20 ++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
> >  2 files changed, 30 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index fd8e6418a0d3..d53b3867b308 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -396,6 +396,8 @@ xfs_attr_set(
> >  	struct xfs_trans_res	tres;
> >  	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
> >  	int			error, local;
> > +	int			iext_cnt;
> > +	int			rmt_blks;
> >  	unsigned int		total;
> >  
> >  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
> > @@ -416,6 +418,9 @@ xfs_attr_set(
> >  	 */
> >  	args->op_flags = XFS_DA_OP_OKNOENT;
> >  
> > +	rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
> > +	iext_cnt = XFS_IEXT_ATTR_MANIP_CNT(rmt_blks);
> 
> These values are only relevant for the xattr removal case, right?
> AFAICT the args->value != NULL case immediately after will set new
> values, so why not just move this into...

The above statements compute the extent count required to remove a maximum
sized remote xattr.

To guarantee that a user can always remove an xattr, the "args->value != NULL"
case adds to the value of iext_cnt that has been computed above. I had
extracted and placed the above set of statements since they were now common to
both "insert" and "remove" xattr operations.

> 
> > +
> >  	if (args->value) {
> >  		XFS_STATS_INC(mp, xs_attr_set);
> >  
> > @@ -442,6 +447,13 @@ xfs_attr_set(
> >  		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> >  		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> >  		total = args->total;
> > +
> > +		if (local)
> > +			rmt_blks = 0;
> > +		else
> > +			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> > +
> > +		iext_cnt += XFS_IEXT_ATTR_MANIP_CNT(rmt_blks);
> >  	} else {
> >  		XFS_STATS_INC(mp, xs_attr_remove);
> 
> ...the bottom of this clause here.
> 
> >  
> > @@ -460,6 +472,14 @@ xfs_attr_set(
> >  
> >  	xfs_ilock(dp, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(args->trans, dp, 0);
> > +
> > +	if (args->value || xfs_inode_hasattr(dp)) {
> 
> Can this simply be "if (iext_cnt != 0)" ?

That would lead to a bug since iext_cnt is computed unconditionally at the
beginning of the function. An extent count reservation will be attempted when
xattr delete operation is executed against an inode which does not have an
associated attr fork. This will cause xfs_iext_count_may_overflow() to
dereference the NULL pointer at xfs_inode->i_afp->if_nextents.

> 
> --D
> 
> > +		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> > +				iext_cnt);
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> > +
> >  	if (args->value) {
> >  		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index bcac769a7df6..5de2f07d0dd5 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -47,6 +47,16 @@ struct xfs_ifork {
> >   */
> >  #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
> >  
> > +/*
> > + * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
> > + * be added. One extra extent for dabtree in case a local attr is
> > + * large enough to cause a double split.  It can also cause extent
> > + * count to increase proportional to the size of a remote xattr's
> > + * value.
> > + */
> > +#define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
> > +	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
> > +
> >  /*
> >   * Fork handling.
> >   */
> 


-- 
chandan



