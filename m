Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CFCC7EE22
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 22:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjEQWY1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 18:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjEQWY0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 18:24:26 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF7A4EF8
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 15:24:24 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ae50da739dso9752135ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 15:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684362264; x=1686954264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OCwYqiF3ydXVpqLPxGKDXakuzIdWMuk8H1T2ZHJZwpE=;
        b=bki4X1lL+8sTU2ZJZSW6BEfq/zAwYBu9ZzeUI+pFeFm049gFyVCiPj7C/s0OuCAwxf
         8YtI47vfsFK96ncnBPht5LgU7pecq2X3NP0i6W5LT/7RaLs9FJHsUmc6jiukws6IJybC
         trFwfVtI6UxRK7LXLTZgyQyAow1w2vIG1j/OCoAxqIlYCY1q/sy+K7JBqgI8RZ3wb4qV
         1omY0WkV/zS7WA6+zZ82J9iyL5WEpOoW7dWOAnGVBCLtgLYLzB3SGGdn7rqegh1U48iS
         RE2Hmxtg8CvPtcc/F+Toi3t4tM4f3DrPs+QC66ycvzVGjGRSEjNW14q2soS7aTVZ3w4S
         F+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362264; x=1686954264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCwYqiF3ydXVpqLPxGKDXakuzIdWMuk8H1T2ZHJZwpE=;
        b=Znbh2CgOsoGMn8/MNrZGeHtrigFCIHAml6aP03mjrczPRKKiwNqVEieFWFsQ6ifs9m
         Vr5TlFEOW2dkHLemvDSovkQjaqKOgQf9HPpbhagjYcYhxfu88vgNU+gUvLLdgbFZYYTe
         zbdSHnNQQ6ohFfO5oDNXN2OMED+OYhrfytbIRzNMD82OG5zl2K5sgxTVM/G2bxclbw9K
         JC2G5mi7UXLd1iI2hf8I8b158YZVvzxsJODcQQ2GWI/6xiKFjkxBH9TuGPFkd4hAnglb
         Lxn11gs2wEmgo0lEr/UGCX/MfCByoXIm2bXFv/Dh9w+7UXkQRsyRnXoaezTdRN9OiFZj
         J3rA==
X-Gm-Message-State: AC+VfDyofKit4DEpWcQtNcCLVoxS5ES6CDMBA4CwluPyKqjBWw5jpFie
        IlTo5nwZHbiwp1DRKp9aCwfLNNG9voiNOFl/HvA=
X-Google-Smtp-Source: ACHHUZ4FGW4glsuysXg4Ev1C842DuHJZLsnhU2f06MKCtFk0pNtcglXXB8N6r5S2ndpczWRib7Pwzw==
X-Received: by 2002:a17:902:f683:b0:1ab:29bc:bd87 with SMTP id l3-20020a170902f68300b001ab29bcbd87mr318033plg.35.1684362263949;
        Wed, 17 May 2023 15:24:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id f22-20020a170902ab9600b001ac2a73dbf2sm192757plr.291.2023.05.17.15.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:24:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pzPZE-000iQV-1D;
        Thu, 18 May 2023 08:24:20 +1000
Date:   Thu, 18 May 2023 08:24:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: buffer pins need to hold a buffer reference
Message-ID: <ZGVUFJ8uXSUreTPf@dread.disaster.area>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-2-david@fromorbit.com>
 <ZGTPj0ov+95jjpuH@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGTPj0ov+95jjpuH@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 05:58:55AM -0700, Christoph Hellwig wrote:
> On Wed, May 17, 2023 at 10:04:46AM +1000, Dave Chinner wrote:
> > To fix this, we need to ensure that buffer existence extends beyond
> > the BLI reference count checks and until the unpin processing is
> > complete. This implies that a buffer pin operation must also take a
> > buffer reference to ensure that the buffer cannot be freed until the
> > buffer unpin processing is complete.
> 
> Yeah.  I wonder why we haven't done this from the very beginning..

Likely because the whole BLI lifecycle is completely screwed up and
nobody has had the time to understand it fully and fix it properly.

> > +	 /*
> > +	  * Nothing to do but drop the buffer pin reference if the BLI is
> > +	  * still active
> > +	  */
> 
> Nit: this block comment is indentented by an extra space.
> 
> > +	if (!freed) {
> > +		xfs_buf_rele(bp);
> >  		return;
> > +	}
> >  
> >  	if (stale) {
> 
> Nit: this is the only use of the stale variable now, so we might
> as well just drop it.

Actually, after we've dropped the bli reference, it isn't safe to
reference the bli unless we know the buffer is stale. In this case,
we know the bli still exists because the buffer has been locked
since it was marked stale. However, for the other cases the BLI
could be freed from under us as it's reference count is zero and so
the next call to xfs_buf_item_relse() will free it no matter where
it comes from.

The reference counting around BLIs a total mess - this patch just
gets rid of one landmine but there's still plenty more in this code
that need to be untangled.

> >  		ASSERT(bip->bli_flags & XFS_BLI_STALE);
> 
> .. which then also clearly shows this ASSERT is pointless now.

*nod*

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
