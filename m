Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724B3C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 07:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B8B204EC
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 07:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q49a48KD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIAHnT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 03:43:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37465 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726124AbgIAHnT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 03:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598946196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/k3mSSuyvnLMNqYseSFPtLmmsFHgvAmBD+yx8S1i21c=;
        b=Q49a48KDlfa4lVNDS2OKaezgistXMdJEnU9Qpn+KzjHI9hnxXR/+3MkuNUnwtv+xwwDvgH
        0/qczjM5ph/jUno0f+Jb1cHTCMPv4P4WsfU2ZkZ8SWDmtsRDiyWyEcE+gFMUydPIEZsUSr
        NgSrAl5gcSsPxRKK9iq3ghReMBEBKdk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-o8n1z-W6Mquyq_4oXm2TkQ-1; Tue, 01 Sep 2020 03:43:15 -0400
X-MC-Unique: o8n1z-W6Mquyq_4oXm2TkQ-1
Received: by mail-wm1-f72.google.com with SMTP id b73so97019wmb.0
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 00:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=/k3mSSuyvnLMNqYseSFPtLmmsFHgvAmBD+yx8S1i21c=;
        b=j5pOKiY9ShfWNBc6SsJ//flCxSgvK2/PJeZi6R/R6ZDHYaMahNTRSfOnakGiFLvGsU
         8RQ+4prHXQ3CLr6Ab2XyGqKk+w+EqATNjpEnrqXsHHv1kIeFWHpWeBEEFjRxnaODmVec
         yI5JC1R2GRQW/cggL9SRLZLZUYHrJbN0iAd6VdHLNP2qbYC8rShtDIzeG2T3xGWSXZQh
         xXNO4zxmr3lCghXcsOtKD9Io1dlFW8lQaVWrZq/2FmWfyvE7091TAclr34CaV480ffOJ
         6GP6lV2eF1nnOKkEQ1LBweov6dxOhTiqEpyEqCt6PrTkc4z4Cv0sbrq2hv1vLsvUV7CX
         mgrg==
X-Gm-Message-State: AOAM531rGydo6DU3vt4RFT3ytrAEhy1PvN7dgzxx5DiPc+dBHDfw2AU4
        +CRgTaZTKdDbojnkH/6G4+HRuigLHGjaYNyKbwk5K0AJgqY2LhuT9NUGuDFiR+RwJzZtkRN/REP
        it6bq0Bi9lXe7tY+Cb32y
X-Received: by 2002:a5d:4ccb:: with SMTP id c11mr392821wrt.159.1598946193753;
        Tue, 01 Sep 2020 00:43:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3U2GINEbsKhckPlR2OVxrpmE0TruOm0AgcugkcGUAJsqcJwucMKtn+oZFOycirooKUkqX2A==
X-Received: by 2002:a5d:4ccb:: with SMTP id c11mr392797wrt.159.1598946193462;
        Tue, 01 Sep 2020 00:43:13 -0700 (PDT)
Received: from eorzea (ip-89-102-9-109.net.upcbroadband.cz. [89.102.9.109])
        by smtp.gmail.com with ESMTPSA id p9sm838428wrt.21.2020.09.01.00.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 00:43:12 -0700 (PDT)
Date:   Tue, 1 Sep 2020 09:43:11 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: Convert xfs_attr_sf macros to inline functions
Message-ID: <20200901074311.y7kkf5p26tvknk4c@eorzea>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20200831130423.136509-1-cmaiolino@redhat.com>
 <20200831130423.136509-3-cmaiolino@redhat.com>
 <20200831153405.GB6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831153405.GB6096@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 08:34:05AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 31, 2020 at 03:04:21PM +0200, Carlos Maiolino wrote:
> > xfs_attr_sf_totsize() requires access to xfs_inode structure, so, once
> > xfs_attr_shortform_addname() is its only user, move it to xfs_attr.c
> > instead of playing with more #includes.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> /me would have preferred you kill the typedef at the start of the series
> instead of creating new functions with them and then changing them in
> the next patch, but aside from that...

Yeah, that was my preference too, but I thought "If for any reason, the typdef
cleanups are a bad idea, it will be just easier to drop the patches instead of
rebasing the important ones".

Thanks for the review!

> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_attr.c      | 15 ++++++++++++---
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 16 ++++++++--------
> >  fs/xfs/libxfs/xfs_attr_sf.h   | 23 ++++++++++++++---------
> >  fs/xfs/xfs_attr_list.c        |  4 ++--
> >  4 files changed, 36 insertions(+), 22 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 2e055c079f397..2b48fdb394e80 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -428,7 +428,7 @@ xfs_attr_set(
> >  		 */
> >  		if (XFS_IFORK_Q(dp) == 0) {
> >  			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
> > -				XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen,
> > +				xfs_attr_sf_entsize_byname(args->namelen,
> >  						args->valuelen);
> >  
> >  			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
> > @@ -523,6 +523,15 @@ xfs_attr_set(
> >   * External routines when attribute list is inside the inode
> >   *========================================================================*/
> >  
> > +static inline int xfs_attr_sf_totsize(struct xfs_inode *dp) {
> > +
> > +	xfs_attr_shortform_t *sf =
> > +		(xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
> > +
> > +	return (be16_to_cpu(sf->hdr.totsize));
> > +
> > +}
> > +
> >  /*
> >   * Add a name to the shortform attribute list structure
> >   * This is the external routine.
> > @@ -555,8 +564,8 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
> >  	    args->valuelen >= XFS_ATTR_SF_ENTSIZE_MAX)
> >  		return -ENOSPC;
> >  
> > -	newsize = XFS_ATTR_SF_TOTSIZE(args->dp);
> > -	newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> > +	newsize = xfs_attr_sf_totsize(args->dp);
> > +	newsize += xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
> >  
> >  	forkoff = xfs_attr_shortform_bytesfit(args->dp, newsize);
> >  	if (!forkoff)
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index 7bbc97e0e4d4a..a8a4e21d19726 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -684,9 +684,9 @@ xfs_attr_sf_findname(
> >  	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
> >  	sfe = &sf->list[0];
> >  	end = sf->hdr.count;
> > -	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
> > +	for (i = 0; i < end; sfe = xfs_attr_sf_nextentry(sfe),
> >  			     base += size, i++) {
> > -		size = XFS_ATTR_SF_ENTSIZE(sfe);
> > +		size = xfs_attr_sf_entsize(sfe);
> >  		if (!xfs_attr_match(args, sfe->namelen, sfe->nameval,
> >  				    sfe->flags))
> >  			continue;
> > @@ -733,7 +733,7 @@ xfs_attr_shortform_add(
> >  		ASSERT(0);
> >  
> >  	offset = (char *)sfe - (char *)sf;
> > -	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> > +	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
> >  	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
> >  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> >  	sfe = (xfs_attr_sf_entry_t *)((char *)sf + offset);
> > @@ -792,7 +792,7 @@ xfs_attr_shortform_remove(
> >  	error = xfs_attr_sf_findname(args, &sfe, &base);
> >  	if (error != -EEXIST)
> >  		return error;
> > -	size = XFS_ATTR_SF_ENTSIZE(sfe);
> > +	size = xfs_attr_sf_entsize(sfe);
> >  
> >  	/*
> >  	 * Fix up the attribute fork data, covering the hole
> > @@ -849,7 +849,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
> >  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> >  	sfe = &sf->list[0];
> >  	for (i = 0; i < sf->hdr.count;
> > -				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> > +				sfe = xfs_attr_sf_nextentry(sfe), i++) {
> >  		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> >  				sfe->flags))
> >  			return -EEXIST;
> > @@ -876,7 +876,7 @@ xfs_attr_shortform_getvalue(
> >  	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
> >  	sfe = &sf->list[0];
> >  	for (i = 0; i < sf->hdr.count;
> > -				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> > +				sfe = xfs_attr_sf_nextentry(sfe), i++) {
> >  		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> >  				sfe->flags))
> >  			return xfs_attr_copy_value(args,
> > @@ -951,7 +951,7 @@ xfs_attr_shortform_to_leaf(
> >  		ASSERT(error != -ENOSPC);
> >  		if (error)
> >  			goto out;
> > -		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> > +		sfe = xfs_attr_sf_nextentry(sfe);
> >  	}
> >  	error = 0;
> >  	*leaf_bp = bp;
> > @@ -1049,7 +1049,7 @@ xfs_attr_shortform_verify(
> >  		 * within the data buffer.  The next entry starts after the
> >  		 * name component, so nextentry is an acceptable test.
> >  		 */
> > -		next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
> > +		next_sfep = xfs_attr_sf_nextentry(sfep);
> >  		if ((char *)next_sfep > endp)
> >  			return __this_address;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> > index d93012a0be4d0..48906c5196505 100644
> > --- a/fs/xfs/libxfs/xfs_attr_sf.h
> > +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> > @@ -27,16 +27,21 @@ typedef struct xfs_attr_sf_sort {
> >  	unsigned char	*name;		/* name value, pointer into buffer */
> >  } xfs_attr_sf_sort_t;
> >  
> > -#define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
> > -	(((int)sizeof(xfs_attr_sf_entry_t) + (nlen)+(vlen)))
> >  #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
> >  	(1 << (NBBY*(int)sizeof(uint8_t)))
> > -#define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
> > -	((int)sizeof(xfs_attr_sf_entry_t) + (sfep)->namelen+(sfep)->valuelen)
> > -#define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
> > -	((xfs_attr_sf_entry_t *)((char *)(sfep) + XFS_ATTR_SF_ENTSIZE(sfep)))
> > -#define XFS_ATTR_SF_TOTSIZE(dp)			/* total space in use */ \
> > -	(be16_to_cpu(((xfs_attr_shortform_t *)	\
> > -		((dp)->i_afp->if_u1.if_data))->hdr.totsize))
> >  
> > +static inline int xfs_attr_sf_entsize_byname(uint8_t nlen, uint8_t vlen) {
> > +	return sizeof(xfs_attr_sf_entry_t) + nlen + vlen;
> > +}
> > +
> > +/* space an entry uses */
> > +static inline int xfs_attr_sf_entsize(xfs_attr_sf_entry_t *sfep) {
> > +	return sizeof(xfs_attr_sf_entry_t) + sfep->namelen + sfep->valuelen;
> > +}
> > +
> > +static inline xfs_attr_sf_entry_t *
> > +xfs_attr_sf_nextentry(xfs_attr_sf_entry_t *sfep) {
> > +	return (xfs_attr_sf_entry_t *)((char *)(sfep) +
> > +				       xfs_attr_sf_entsize(sfep));
> > +}
> >  #endif	/* __XFS_ATTR_SF_H__ */
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index 50f922cad91a4..fbe5574f08930 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> > @@ -96,7 +96,7 @@ xfs_attr_shortform_list(
> >  			 */
> >  			if (context->seen_enough)
> >  				break;
> > -			sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> > +			sfe = xfs_attr_sf_nextentry(sfe);
> >  		}
> >  		trace_xfs_attr_list_sf_all(context);
> >  		return 0;
> > @@ -136,7 +136,7 @@ xfs_attr_shortform_list(
> >  		/* These are bytes, and both on-disk, don't endian-flip */
> >  		sbp->valuelen = sfe->valuelen;
> >  		sbp->flags = sfe->flags;
> > -		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> > +		sfe = xfs_attr_sf_nextentry(sfe);
> >  		sbp++;
> >  		nsbuf++;
> >  	}
> > -- 
> > 2.26.2
> > 
> 

-- 
Carlos

