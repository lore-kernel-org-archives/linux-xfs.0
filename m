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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA8FC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 09:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D93F227C3
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 09:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgLDJFW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 04:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbgLDJFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 04:05:22 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCD5C061A54
        for <linux-xfs@vger.kernel.org>; Fri,  4 Dec 2020 01:04:36 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id y10so1289724plr.10
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LDhEeiNr4uKszkfCrwZ379LULfFxcwCekoXIioXec9g=;
        b=sT4lPgUCUYjlFhDBOKoHOohKoKBeGv+jodkmdPUYzYSr/gy2NDL04uhMirGLQtBmKs
         KpgRs/EA1PMihsZP3lX4Gi+SSh90ekJ4jiZsgbSMDjWFuoTpLYbB8ALr6LpnHnv346L4
         VyDz602kl4f2hAlIOPlkIGFMXEEx2ftkHWEmkKsW2VYXmUotV5+PVjjT97WKhUzwoqxi
         39C3/efh8uhkU4wx6PTkQ4gcN2hXRZKQiDkk3mrFR2vS14cvT8nqIsjFChEoT8sCrFQM
         4kNsVJwaqWQzAWHyD/yKEhruK4m+JDivePPdytg59/XYrXf+9rfKGaJJ58VJlUtb9u3Y
         gobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LDhEeiNr4uKszkfCrwZ379LULfFxcwCekoXIioXec9g=;
        b=XIYTftPV6bdmjEsFDxdlNN5Q/v8BnwMywCQkrLdnv6GA+aEjtyjyySTx2/KVyFR5op
         nZ3m6gwz80EeUVmWFhQB1O6wxEYnfIs4YQ5diDxzr0WjWj91orcAE2HgkUe3zu7H6eHa
         YpSHPMbarxlg3N0VFA494ag5cqzgaTC3Yba+KpTl8m2GwUE63/3ihkcTjQyjk62WIXEI
         zvxK+Ta0xPGFgMj4mer51wo/KU1adUbP/MOCzSHmY+9Gq+XAPLGJbYlh6CIAO1Dk0m1Y
         HHWJqe3LRfdt2zt9Tk7vLx/mOKWzuLuGidnuGOl+m//ZEOM+l1nTWWIkm6dAtL8aNB6y
         aP/Q==
X-Gm-Message-State: AOAM533bc1niEmsipnJY+k56STF0+jbdPLQNOK8R9ffqte6kJQJQn3Ty
        sSSmYXozbn+sInRyPTV1nDiSEJTZfpw=
X-Google-Smtp-Source: ABdhPJwy42x0qyjwwKIlB95+CVjr3WpaH7ntBJEwC4X2XeoR6tErWuvuVfrFKTWVQzZvVYpTipEhYA==
X-Received: by 2002:a17:902:ab8a:b029:da:13c5:6ed4 with SMTP id f10-20020a170902ab8ab02900da13c56ed4mr3226354plr.56.1607072675716;
        Fri, 04 Dec 2020 01:04:35 -0800 (PST)
Received: from garuda.localnet ([122.171.196.244])
        by smtp.gmail.com with ESMTPSA id t9sm4330126pfq.39.2020.12.04.01.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 01:04:35 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V11 05/14] xfs: Check for extent overflow when adding/removing dir entries
Date:   Fri, 04 Dec 2020 14:34:32 +0530
Message-ID: <15021664.sC18oI5324@garuda>
In-Reply-To: <20201203190422.GB106271@magnolia>
References: <20201117134416.207945-1-chandanrlinux@gmail.com> <20201117134416.207945-6-chandanrlinux@gmail.com> <20201203190422.GB106271@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 03 Dec 2020 11:04:22 -0800, Darrick J. Wong wrote:
> On Tue, Nov 17, 2020 at 07:14:07PM +0530, Chandan Babu R wrote:
> > Directory entry addition/removal can cause the following,
> > 1. Data block can be added/removed.
> >    A new extent can cause extent count to increase by 1.
> > 2. Free disk block can be added/removed.
> >    Same behaviour as described above for Data block.
> > 3. Dabtree blocks.
> >    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
> >    can be new extents. Hence extent count can increase by
> >    XFS_DA_NODE_MAXDEPTH.
> > 
> > To be able to always remove an existing directory entry, when adding a
> > new directory entry we make sure to reserve inode fork extent count
> > required for removing a directory entry in addition to that required for
> > the directory entry add operation.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.h | 13 +++++++++++++
> >  fs/xfs/xfs_inode.c             | 27 +++++++++++++++++++++++++++
> >  fs/xfs/xfs_symlink.c           |  5 +++++
> >  3 files changed, 45 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 5de2f07d0dd5..fd93fdc67ee4 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -57,6 +57,19 @@ struct xfs_ifork {
> >  #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
> >  	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
> >  
> > +/*
> > + * Directory entry addition/removal can cause the following,
> > + * 1. Data block can be added/removed.
> > + *    A new extent can cause extent count to increase by 1.
> > + * 2. Free disk block can be added/removed.
> > + *    Same behaviour as described above for Data block.
> > + * 3. Dabtree blocks.
> > + *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
> > + *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
> > + */
> > +#define XFS_IEXT_DIR_MANIP_CNT(mp) \
> > +	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
> > +
> >  /*
> >   * Fork handling.
> >   */
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 2bfbcf28b1bd..f7b0b7fce940 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1177,6 +1177,11 @@ xfs_create(
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> 
> Er, why did these double since V10?  We're only adding one entry, right?

To be able to always guarantee the removal of an existing directory entry, we
reserve inode fork extent count required for removing a directory entry in
addition to that required for the directory entry add operation.

A bug was discovered when executing the following sequence of
operations,
1. Keep inserting directory entries until the pseudo max extent count limit is
   reached.
2. At this stage, a directory entry remove operation will fail because it
   tries to reserve XFS_IEXT_DIR_MANIP_CNT(mp) worth of extent count. This
   reservation fails since the extent count would go over the pseudo max
   extent count limit as it did in step 1.

We would end up with a directory which can never be deleted.

Hence V11 doubles the extent count reservation for "directory entry insert"
operations. The first XFS_IEXT_DIR_MANIP_CNT(mp) instance is for "insert"
operation while the second XFS_IEXT_DIR_MANIP_CNT(mp) instance is for
guaranteeing a possible future "remove" operation to succeed.

> 
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> >  	/*
> >  	 * A newly created regular or special file just has one directory
> >  	 * entry pointing to them, but a directory also the "." entry
> > @@ -1393,6 +1398,11 @@ xfs_link(
> >  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> >  
> > +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> > +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> 
> Same question here.

Creating a new hard link involves adding a new directory entry. Hence apart
from reserving extent count for directory entry addition we will have to
reserve extent count for a future directory entry removal as well.

> 
> > +	if (error)
> > +		goto error_return;
> > +
> >  	/*
> >  	 * If we are using project inheritance, we only allow hard link
> >  	 * creation in our tree when the project IDs are the same; else
> > @@ -2861,6 +2871,11 @@ xfs_remove(
> >  	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> >  
> > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> >  	/*
> >  	 * If we're removing a directory perform some additional validation.
> >  	 */
> > @@ -3221,6 +3236,18 @@ xfs_rename(
> >  	if (wip)
> >  		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> >  
> > +	error = xfs_iext_count_may_overflow(src_dp, XFS_DATA_FORK,
> > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> > +	if (target_ip == NULL) {
> > +		error = xfs_iext_count_may_overflow(target_dp, XFS_DATA_FORK,
> > +				XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> 
> Why did this change to "<< 1" since V10?

Extent count is doubled since this is essentially a directory insert operation
w.r.t target_dp directory. One instance of XFS_IEXT_DIR_MANIP_CNT(mp) is for
the directory entry being added to target_dp directory and another instance of
XFS_IEXT_DIR_MANIP_CNT(mp) is for guaranteeing a future directory entry
removal from target_dp directory to succeed.

> 
> I'm sorry, but I've lost my recollection on how the accounting works
> here.  This seems (to me anyway ;)) a good candidate for a comment:
> 
> For a rename between dirs where the target name doesn't exist, we're
> removing src_name from src_dp and adding target_name to target_dp.
> Therefore we have to check for DIR_MANIP_CNT overflow on each of src_dp
> and target_dp, right?

Extent count check is doubled since this is a directory insert operation w.r.t
target_dp directory ... One instance of XFS_IEXT_DIR_MANIP_CNT(mp) is for the
directory entry being added to target_dp directory and another instance of
XFS_IEXT_DIR_MANIP_CNT(mp) is for guaranteeing a future directory entry
removal from target_dp directory to succeed.

Since a directory entry is being removed from src_dp, reserving only a single
instance of XFS_IEXT_DIR_MANIP_CNT(mp) would suffice.

> 
> For a rename within the same dir where target_name doesn't yet exist, we
> are removing a name and then adding a name.  We therefore check for iext
> overflow with (DIR_MANIP_CNT * 2), right?  And I think that "target name
> does not exist" is synonymous with target_ip == NULL?

Here again we have to reserve two instances of XFS_IEXT_DIR_MANIP_CNT(mp) for
target_name insertion and one instance of XFS_IEXT_DIR_MANIP_CNT(mp) for
src_name removal. This is because insertion and removal of src_name may each
end up consuming XFS_IEXT_DIR_MANIP_CNT(mp) extent counts in the worst case. A
future directory entry remove operation will require
XFS_IEXT_DIR_MANIP_CNT(mp) extent counts to be reserved.

Also, You are right about "target name does not exist" being synonymous with
target_ip == NULL.

> 
> For a rename where target_name /does/ exist, we're only removing the
> src_name, so we have to check for DIR_MANIP_CNT on src_dp, right?

Yes, you are right.

> 
> For a RENAME_EXCHANGE we're not removing either name, so we don't need
> to check for iext overflow of src_dp or target_dp, right?

You are right. Sorry, I missed this. I will move the extent count reservation
logic to come after the invocation of xfs_cross_rename().

I will also add appropriate comments into xfs_rename() describing the
scenarios that have been discussed above.

PS: I have swapped the order of two comments from your original reply since I
think it is easier to explain the scenarios with the order of
comments/questions swapped.

> 
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> > +
> >  	/*
> >  	 * If we are using project inheritance, we only allow renames
> >  	 * into our tree when the project IDs are the same; else the
> > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > index 8e88a7ca387e..08aa808fe290 100644
> > --- a/fs/xfs/xfs_symlink.c
> > +++ b/fs/xfs/xfs_symlink.c
> > @@ -220,6 +220,11 @@ xfs_symlink(
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> 
> Same question as xfs_create.

This is again similar to adding a new directory entry. Hence, apart from
reserving extent count for directory entry addition we will have to reserve
extent count for a future directory entry removal as well.

> 
> --D
> 
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> >  	/*
> >  	 * Allocate an inode for the symlink.
> >  	 */
> 

-- 
chandan



