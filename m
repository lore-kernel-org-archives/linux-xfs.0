Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 879A4C4727D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 09:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3694A2080A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 09:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tytYOb4n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgJFJV1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFJV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 05:21:27 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C6AC061755
        for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2020 02:21:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n14so8668313pff.6
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2020 02:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XqJAFEuF7naGL6sPzTG25w+VDo+6sgoAOk/M0nmeXNs=;
        b=tytYOb4neQnsMfPGwGwCNBtC7ayB0ESIAvmzf837WWQU08p7oktWquccvipyPoq1VG
         2wZh9MD+jDUng9LdpwANG2I7ZfAZHuHbiaKASyEiSXVyYfjaVLGnvapW4LBeHBTSZ9GH
         29ukepjYo2HOBwqgG7bowsBTM4Q3/QIQrQ6F6iL68NZaO7rgrCHts1DnLD/p+U8fEE6D
         Cz6b6O+RmkMQkZEEnBqlTRiAd343nbHQZWA42QqRjF+5nQ/bJXMXAUXGyaAs0MAy8vyy
         dEL4FWdn+4e1nwPDwsxB/OnFVryF+jyYFi7doPTs9PdGkJfigC6Pn12hkMJmeEK/5NPZ
         E4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XqJAFEuF7naGL6sPzTG25w+VDo+6sgoAOk/M0nmeXNs=;
        b=l6KWjncDzvy6WDH9KOtG3CD6iaWPt0YBi8789bRYOZZ47m5i1Q6DyWGZzeEF8masCg
         Q4bkJhvWoHOeQxAjekZZ85E4+kTNOG/k8SDaKZeYLpRUuajugmaXS2aoJwy8dGs6Zj1C
         Ze19wC2n1MhmMaoEJs6CnL5Le0HM3RLt+ci+JQxybssSAnGlmZpypHHh2LQzm/+T1EGF
         BlKRmu/p09mBG8bUXsYbyTHWfsFdgi2Z/IQTR99J5V9JUWM4V82kePId0qMBHUxY2Smw
         B4txKBthDWnzqaR6H+aGf2bkxl5WQJCGpyN7noaCGwnW6PYP6pdeJ2zrHWBvLaDrr7QG
         PIjQ==
X-Gm-Message-State: AOAM532PUxyOm1m5yeDxpQ4IxYU0X8DoQyZXo1EqZ1KBTWIr5eFLOrtb
        AcTdwWq+R0ZGTwoP+eMCH2P3Qnyqg64=
X-Google-Smtp-Source: ABdhPJxdSXFeWysPhi3pk3sgCX7aSrkSdvevvAwBCmi59v2O4cCQViYm/ZpGHAQ88Y2fSJe2S7Zgrw==
X-Received: by 2002:a65:5802:: with SMTP id g2mr3154120pgr.261.1601976087036;
        Tue, 06 Oct 2020 02:21:27 -0700 (PDT)
Received: from garuda.localnet ([122.167.153.52])
        by smtp.gmail.com with ESMTPSA id o38sm2284354pgb.12.2020.10.06.02.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 02:21:26 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 04/12] xfs: Check for extent overflow when adding/removing xattrs
Date:   Tue, 06 Oct 2020 14:51:15 +0530
Message-ID: <3262882.2ycmhBttRE@garuda>
In-Reply-To: <20201006042329.GN49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com> <20201003055633.9379-5-chandanrlinux@gmail.com> <20201006042329.GN49547@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 6 October 2020 9:53:29 AM IST Darrick J. Wong wrote:
> On Sat, Oct 03, 2020 at 11:26:25AM +0530, Chandan Babu R wrote:
> > Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
> > added. One extra extent for dabtree in case a local attr is large enough
> > to cause a double split.  It can also cause extent count to increase
> > proportional to the size of a remote xattr's value.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
> Didn't I already review this?  AFAICT it hasn't changed much, but did
> something change enough to warrant dropping the old RVB tag?

Yes, you had reviewed it earlier. Sorry, I missed out on adding the RVB before
sending the patch.

> 
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       | 13 +++++++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
> >  2 files changed, 23 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index fd8e6418a0d3..be51e7068dcd 100644
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
> > +		if (error)
> > +			goto out_trans_cancel;
> 
> Hmm.  If you hit this while trying to remove an xattr, what then?
> I suppose you really don't want to overflow naextents, but I suppose the
> only other option is to delete the file.  Oh well, attr forks with 65533
> extents should be vanishingly rare, right?  Right? :)

Yes, Deleting the corresponding file would be the only option. If we did allow
this operation to succeed we would end up having a silent corruption of the
attr extent counter.

> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
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



