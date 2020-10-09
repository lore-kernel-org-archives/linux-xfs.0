Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D87C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 00:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374EC22256
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 00:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I0UEAUG4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgJIAyS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 20:54:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbgJIAyS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 20:54:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602204856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aphFyPqrmDo/Kfsxe3EOT66IGPe/f6DBhRrqpUfQDwY=;
        b=I0UEAUG4N3TW2VXd40byKPiNS3fPDAWA4CLEoSf7CxX9mN+04tcEDnHd4xSbrzZ4s4Aerp
        BHhH6ImUXI2SnxqDtn0sjnyX5Sny1QIvEswFheviBU4k1wLUej5ckv7jpr0UQfp1+NGlVr
        3gpgYJRUxajSbzJNl5DfR/a/AA75w7c=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-TkXoD9e5M6GY3WwksqOIMg-1; Thu, 08 Oct 2020 20:54:14 -0400
X-MC-Unique: TkXoD9e5M6GY3WwksqOIMg-1
Received: by mail-pl1-f200.google.com with SMTP id 10so4848920ple.19
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 17:54:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aphFyPqrmDo/Kfsxe3EOT66IGPe/f6DBhRrqpUfQDwY=;
        b=W8dBcLMFi7vgsUITOnmNK/Bah5sk193KRrjgHdRSLlVhtMXexPraK0R3n3D/A3nfYj
         /tBRXRmh2nH2MLV47ZnMXgMgGTRR6jer9oCX5GetyROtZBN2a5lMluI6tJjH6LeAPK2q
         rBjS3LNrly/g2czydT1I6IoNBVqu1/DL+wA5SGcfRSbSRkEiWZH/rI4nzdvQTTRIGmjx
         mNN2UOeyhneAVv7z/LDSqPK82GhvZcatNBBDKQbRxJSove72wmnmkAaDOUTc386I53gi
         z5LRb8TdDcP3aGNulDukP2DQfdUB9Kl5bgaO+Q2KexGCkZW4J3aI2oI66/8+KTpkzUXW
         2o5w==
X-Gm-Message-State: AOAM532q4i7QaMnDSMBzMssP5JZ2Hsxx7NxInvKSzgiZaBR+gDfP/vk7
        xFa3rituq6YBieq87CUMktWT0J05B6y7l75tNymcxdooSE9Ha9JZJ1Wj4blhrwNNibwkC11qRqi
        YcAgi4TelHEPzymE8ikZi
X-Received: by 2002:a63:f80c:: with SMTP id n12mr1289503pgh.94.1602204853147;
        Thu, 08 Oct 2020 17:54:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQ5ssQp/KKsWwJS30nvMg0fB9kO0WGVrOaWymk6iZPj5NS3/Jh9FwXlfiqUyo6usGG31fmFw==
X-Received: by 2002:a63:f80c:: with SMTP id n12mr1289488pgh.94.1602204852830;
        Thu, 08 Oct 2020 17:54:12 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j19sm8403682pfi.51.2020.10.08.17.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 17:54:12 -0700 (PDT)
Date:   Fri, 9 Oct 2020 08:54:02 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Gao Xiang <hsiangkao@aol.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 2/3] xfs: introduce xfs_validate_stripe_factors()
Message-ID: <20201009005402.GA10631@xiangao.remote.csb>
References: <20201007140402.14295-1-hsiangkao@aol.com>
 <20201007140402.14295-3-hsiangkao@aol.com>
 <20201007222942.GH6540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007222942.GH6540@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 03:29:42PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 07, 2020 at 10:04:01PM +0800, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > Introduce a common helper to consolidate
> > stripe validation process. Also make kernel
> > code xfs_validate_sb_common() use it first.
> 
> Please use all 72(?) columns here.

will fix.

> 
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  libxfs/xfs_sb.c | 54 +++++++++++++++++++++++++++++++++++++++----------
> >  libxfs/xfs_sb.h |  3 +++
> 
> These libxfs changes will have to go through the kernel first.

will send another patch together with the next version.

> 
> >  2 files changed, 46 insertions(+), 11 deletions(-)
> > 
> > diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> > index d37d60b39a52..bd65828c844e 100644
> > --- a/libxfs/xfs_sb.c
> > +++ b/libxfs/xfs_sb.c
> > @@ -357,21 +357,13 @@ xfs_validate_sb_common(
> >  		}
> >  	}
> >  
> > -	if (sbp->sb_unit) {
> > -		if (!xfs_sb_version_hasdalign(sbp) ||
> > -		    sbp->sb_unit > sbp->sb_width ||
> > -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> > -			xfs_notice(mp, "SB stripe unit sanity check failed");
> > -			return -EFSCORRUPTED;
> > -		}
> > -	} else if (xfs_sb_version_hasdalign(sbp)) {
> > +	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {
> 
> Urgh, this logic makes my brain hurt.
> 
> "If the zeroness of sb_unit differs from the unsetness of the dalign
> feature"?  This might need some kind of comment, such as:
> 
> 	/*
> 	 * Either sb_unit and hasdalign are both set, or they are zero
> 	 * and not set, respectively.
> 	 */
> 	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {
> 

Ok, yet I think the comment might describe failure condition (which causes
-EFSCORRUPTED) instead directly, like,

	/*
	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
	 * would imply the image is corrupted.
	 */
 	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {

>
> >  		xfs_notice(mp, "SB stripe alignment sanity check failed");
> >  		return -EFSCORRUPTED;
> > -	} else if (sbp->sb_width) {
> > -		xfs_notice(mp, "SB stripe width sanity check failed");
> > -		return -EFSCORRUPTED;
> >  	}
> >  
> > +	if (!xfs_validate_stripe_factors(mp, sbp->sb_unit, sbp->sb_width, 0))
> > +		return -EFSCORRUPTED;
> >  
> >  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> >  	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
> > @@ -1208,3 +1200,43 @@ xfs_sb_get_secondary(
> >  	*bpp = bp;
> >  	return 0;
> >  }
> > +
> > +/*
> > + * If sectorsize is specified, sunit / swidth must be in bytes;
> > + * or both can be in any kind of units (e.g. 512B sector or blocksize).
> > + */
> > +bool
> > +xfs_validate_stripe_factors(
> > +	struct xfs_mount	*mp,
> > +	int			sunit,
> > +	int			swidth,
> > +	int			sectorsize)
> > +{
> > +	if (sectorsize && sunit % sectorsize) {
> > +		xfs_notice(mp,
> > +"stripe unit (%d) must be a multiple of the sector size (%d)",
> > +			   sunit, sectorsize);
> > +		return false;
> > +	}
> > +
> > +	if ((sunit && !swidth) || (!sunit && swidth)) {
> > +		xfs_notice(mp,
> > +"stripe unit (%d) and width (%d) are partially valid", sunit, swidth);
> 
> I would break these into separate checks and messages.

Ok, will update in the next version.

> 
> > +		return false;
> > +	}
> > +
> > +	if (sunit > swidth) {
> > +		xfs_notice(mp,
> > +"stripe unit (%d) is too large of the stripe width (%d)", sunit, swidth);
> 
> "stripe unit (%d) is larger than the stripe width..."

Will update too.

Thanks,
Gao Xiang

> 
> --D

