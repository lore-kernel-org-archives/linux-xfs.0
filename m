Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3865CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 May 2022 17:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351629AbiEQRxw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 13:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbiEQRxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 13:53:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BAE3FBEA
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 10:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E955B81B3D
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB171C385B8;
        Tue, 17 May 2022 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652810027;
        bh=cpFcOTJ+8t/5PEIkL/iNVy/T9II0Qj0ROxoj4i4VzkM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qsfHY2yoh9E4YLfa/5LhgyMcE80t7rEXP48bKzthXf2v6U20wtXehTpWmqQ3Gi+Wu
         DPBbVBbq/ZKMPHcXWuYvvpHAyBo0+TAQg0LRXUW5Z0V351ACC+Unur39MqtskOT6Nb
         yI6iQjSSarBDnf4eIECcFICmByKmf7W45ONpP4/wKXG9ffMBlZRVFIZShvwTnBcC+S
         kZD6a7giukWH5d35H/eR22xlsD8xsx/LY35r6V1D/XtcPGb2/k8WmIapH0JbpOX0Ph
         P/j7QBTrshBT/DqeV94ahSLJgxa5LctDX9nBqO6oTSMaPWWwPXAtaDVc5dhF5NNz21
         dm/7znWMTBurQ==
Date:   Tue, 17 May 2022 10:53:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/4] xfs: reject unknown xattri log item filter flags
 during recovery
Message-ID: <YoPhKqgDlrsbGTsB@magnolia>
References: <165267191199.625255.12173648515376165187.stgit@magnolia>
 <165267193475.625255.2721960601959913094.stgit@magnolia>
 <e31cb820dfd42734daeace193e08e1589804047e.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e31cb820dfd42734daeace193e08e1589804047e.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 16, 2022 at 04:56:20PM -0700, Alli wrote:
> On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make sure we screen the "attr flags" field of recovered xattr intent
> > log
> > items to reject flag bits that we don't know about.  This is really
> > the
> > attr *filter* flags, so rename the field and create properly
> > namespaced
> > flags to fill it.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_log_format.h |    9 ++++++++-
> >  fs/xfs/xfs_attr_item.c         |   10 +++++++---
> >  2 files changed, 15 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h
> > b/fs/xfs/libxfs/xfs_log_format.h
> > index f7edd1ecf6d9..5017500bfd8b 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -911,6 +911,13 @@ struct xfs_icreate_log {
> >  #define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
> >  #define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
> >  
> > +#define XFS_ATTRI_FILTER_ROOT		(1u <<
> > XFS_ATTR_ROOT_BIT)
> > +#define XFS_ATTRI_FILTER_SECURE		(1u <<
> > XFS_ATTR_SECURE_BIT)
> > +#define XFS_ATTRI_FILTER_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
> > +#define XFS_ATTRI_FILTER_MASK		(XFS_ATTRI_FILTER_ROOT
> > | \
> > +					 XFS_ATTRI_FILTER_SECURE | \
> > +					 XFS_ATTRI_FILTER_INCOMPLETE)
> > +
> It sounds like your already working on a v2 that doesnt use the new
> flag scheme, but other than that, I think it looks ok.  Thanks!

Yeah.  The new patch simply defines XFS_ATTRI_FILTER_MASK and reuses the
existing XFS_ATTR_{ROOT,SECURE,INCOMPLETE} flags:

/*
 * alfi_attr_filter captures the state of xfs_da_args.attr_filter, so
 * it should never have any other bits set.
 */
#define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
					 XFS_ATTR_SECURE | \
					 XFS_ATTR_INCOMPLETE)

--D

> Allison
> 
> >  /*
> >   * This is the structure used to lay out an attr log item in the
> >   * log.
> > @@ -924,7 +931,7 @@ struct xfs_attri_log_format {
> >  	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
> >  	uint32_t	alfi_name_len;	/* attr name length */
> >  	uint32_t	alfi_value_len;	/* attr value length */
> > -	uint32_t	alfi_attr_flags;/* attr flags */
> > +	uint32_t	alfi_attr_filter;/* attr filter flags */
> >  };
> >  
> >  struct xfs_attrd_log_format {
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 459b6c93b40b..7cbb640d7856 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -353,7 +353,8 @@ xfs_attr_log_item(
> >  						XFS_ATTR_OP_FLAGS_TYPE_
> > MASK;
> >  	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
> >  	attrp->alfi_name_len = attr->xattri_da_args->namelen;
> > -	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
> > +	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter &
> > +						XFS_ATTRI_FILTER_MASK;
> >  
> >  	memcpy(attrip->attri_name, attr->xattri_da_args->name,
> >  	       attr->xattri_da_args->namelen);
> > @@ -500,6 +501,9 @@ xfs_attri_validate(
> >  	if (attrp->alfi_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK)
> >  		return false;
> >  
> > +	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
> > +		return false;
> > +
> >  	/* alfi_op_flags should be either a set or remove */
> >  	switch (op) {
> >  	case XFS_ATTR_OP_FLAGS_SET:
> > @@ -569,7 +573,7 @@ xfs_attri_item_recover(
> >  	args->name = attrip->attri_name;
> >  	args->namelen = attrp->alfi_name_len;
> >  	args->hashval = xfs_da_hashname(args->name, args->namelen);
> > -	args->attr_filter = attrp->alfi_attr_flags;
> > +	args->attr_filter = attrp->alfi_attr_filter &
> > XFS_ATTRI_FILTER_MASK;
> >  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
> >  
> >  	switch (attr->xattri_op_flags) {
> > @@ -658,7 +662,7 @@ xfs_attri_item_relog(
> >  	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
> >  	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
> >  	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
> > -	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
> > +	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
> >  
> >  	memcpy(new_attrip->attri_name, old_attrip->attri_name,
> >  		new_attrip->attri_name_len);
> > 
> 
