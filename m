Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD182C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8BAA2087D
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EIjE78oN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIAJp7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgIAJp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 05:45:56 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDF1C061244
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 02:45:56 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x18so270476pll.6
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 02:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QJfjalYPDK9PgE8+HzIZojqOU9rzxr8DNo2bvnJrlZs=;
        b=EIjE78oNqyPUDT6dRs/ieZuqAOHR92S9LQtwH6wKC40Md8UVIA56aJ5vhnXM+Ru6IQ
         dEu9kEPVMIDqnc4Yp05A7qEv9Y4NswfxhE0U/pQfNeuyQWc7gRK222ppksS10p1J+iJa
         n0QihkWlQPcycG+dikuEcWTzF29jBUDIIrI61JOXJBjDD8rpiwicS9rHEb1/NPeLC93m
         baqluir6OAN42oeVRNlMtxeuzljPVFrTmQdeK+BVnekMzZBGqCQTLoS8V8P8h9ntLioV
         gEidXAuVTn1OmOlVPS9uisCUbFiOjl/tmObiTaGY/RK/idQmnTYx7HzLt728OQuzl1JF
         ITeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QJfjalYPDK9PgE8+HzIZojqOU9rzxr8DNo2bvnJrlZs=;
        b=sHrbJWT9kIFN+SOI9xHy+nEIQk+FoP0foYuvvI/d1fSUsTgTm0pNFr0kodzP/fzacS
         6OZDJ8bw3NyaqiUp9a5YM92SmXixbYyLzXQQYrsnscmplLipQ3IojXQ087ao5KsbAnBa
         rJH4CjWM+VHbeNJg1Yrh4c3exY3RCijwlzdjPy6vnBQosuhjZjsvfEQ65E2go0S4Zsui
         iwUSdXQdxq3aLqNW4K9OMIGlv/7THW+myl+DZI8TqK5VpYSQkNQTOLbIjgp+LOpb2LVm
         VP3Y7cptImlcwzb7Q8xhqnlu6bdBuPTZLSmUlzNrTUiiQGMCJ9VZ0D22QBwBC0law/mf
         JU2Q==
X-Gm-Message-State: AOAM531wVM1DMq5PjdemNKIeJKbvLZNTYaJHRKQIA/4m4OtXxw/xTWlj
        oP3jJ5Sml94txDBYNdnGmEw=
X-Google-Smtp-Source: ABdhPJyL/zoDB/xHzJirQkNeXioBa21cYvhpITk+k6tKTFSB9sXel11/+baM25rHU7wCYiQo3Ep3xw==
X-Received: by 2002:a17:90a:d504:: with SMTP id t4mr798022pju.58.1598953555784;
        Tue, 01 Sep 2020 02:45:55 -0700 (PDT)
Received: from garuda.localnet ([122.171.183.205])
        by smtp.gmail.com with ESMTPSA id m25sm1164639pfa.32.2020.09.01.02.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:45:55 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 04/10] xfs: Check for extent overflow when adding/removing xattrs
Date:   Tue, 01 Sep 2020 15:14:43 +0530
Message-ID: <6128468.3vHh2LMAbu@garuda>
In-Reply-To: <20200831163759.GM6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com> <20200820054349.5525-5-chandanrlinux@gmail.com> <20200831163759.GM6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 31 August 2020 10:07:59 PM IST Darrick J. Wong wrote:
> On Thu, Aug 20, 2020 at 11:13:43AM +0530, Chandan Babu R wrote:
> > Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
> > added. One extra extent for dabtree in case a local attr is large enough
> > to cause a double split.  It can also cause extent count to increase
> > proportional to the size of a remote xattr's value.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       | 13 +++++++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.h |  9 +++++++++
> >  2 files changed, 22 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index d4583a0d1b3f..c481389da40f 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -396,6 +396,7 @@ xfs_attr_set(
> >  	struct xfs_trans_res	tres;
> >  	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
> >  	int			error, local;
> > +	int			rmt_blks = 0;
> >  	unsigned int		total;
> >  
> >  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
> > @@ -442,11 +443,15 @@ xfs_attr_set(
> >  		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> >  		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> >  		total = args->total;
> > +
> > +		if (!local)
> > +			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> >  	} else {
> >  		XFS_STATS_INC(mp, xs_attr_remove);
> >  
> >  		tres = M_RES(mp)->tr_attrrm;
> >  		total = XFS_ATTRRM_SPACE_RES(mp);
> > +		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
> >  	}
> >  
> >  	/*
> > @@ -460,6 +465,14 @@ xfs_attr_set(
> >  
> >  	xfs_ilock(dp, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(args->trans, dp, 0);
> > +
> > +	if (args->value || xfs_inode_hasattr(dp)) {
> > +		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> > +				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> 
> What happens if the free space is fragmented and each of these rmt
> blocks results in a separate allocation?

In such a case, We would have "rmt_blks" number of new extents. These are
accounted for by "max(1, rmt_blks)" in XFS_IEXT_ATTR_MANIP_CNT(rmt_blks)
macro. The two arguments to max() i.e. "1" and "rmt_blks" are mutually
exclusive.
"1" occurs when a local value is large enough to cause a double split of a
dabtree leaf.
"rmt_blks" occurs when an xattr value is large enough to be stored
non-locally.

> 
> I'm also not sure why we'd need to account for the remote blocks if
> we're removing an attr?  Those mappings simply go away, right?
>

Lets say the following extent mappings are present in the attr fork of an
inode,
 | Dabtree block | Hole | Dabtree block |

Lets say, to store an xattr's remote value we allocate blocks which cause the
following,
 | Dabtree block | Remote value | Dabtree block |

i.e the region labelled above as "Remote value" is contiguous with both its
neighbours in terms of both "file offset" (belonging to attr fork) and "disk
offset" space. In such a case, xfs_bmap_add_extent_hole_real() would mark the
entire region shown above as just one extent.

A future xattr remove opertion, will fragment this extent into two causing
extent count to increase by 1. Considering the worst case scenario where each
of blocks holding the remote value ends up belonging to such an extent, the
macro XFS_IEXT_ATTR_MANIP_CNT() adds "rmt_blks" number to possible increase in
extent count.

> --D
> 
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> > +
> >  	if (args->value) {
> >  		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 2642e4847ee0..aae8e6e80b71 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -45,6 +45,15 @@ struct xfs_ifork {
> >   * i.e. | Old extent | Hole | Old extent |
> >   */
> >  #define XFS_IEXT_REMOVE_CNT		(1)
> > +/*
> > + * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
> > + * be added. One extra extent for dabtree in case a local attr is
> > + * large enough to cause a double split.  It can also cause extent
> > + * count to increase proportional to the size of a remote xattr's
> > + * value.
> > + */
> > +#define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
> > +	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
> >  
> >  /*
> >   * Fork handling.
> 

-- 
chandan



