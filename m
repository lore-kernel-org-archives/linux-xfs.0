Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04BF7A13A
	for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 12:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710245415; cv=none; b=dYRnPDo3o/RulQx2WUoREwIhWu8tlzXRFQ/vaOtec2knC9WCVr4MsZdjjC4LLkuu9bpFoPuB428dtPI9Dyc14eSNT6nU25RzssW1kdBPhqJHkNvCvUrLtIEudQ9p2dkGGREVBZvXfmY7a01bGmBcmOo6+OrZinv1P0CVX3fZ8So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710245415; c=relaxed/simple;
	bh=QmejXV0WNaqWu+GRV+FolZ1Mzxp6Le/AUayQOP+glBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFYs/owHzheAnEyWk+ajl/XrmG8rlFO1T959zEqLlFaBefndUz2MCWeLFe5zE13c7fyDYKiRyborkO8nkCuPP/wc3SK8m1AER5ysDhyP9Y3bjjT3U1X+9eJZ3ySWPYuUHp/EE/U5NwAlUhSC7JK9EdunwPgLmI723sSJZ6i5Hjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bHET3Yqx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bHET3Yqx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710245412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=31/cMpUBlNq1dVo/GBGgzVo8ufDRVUmygq7sRPjG1Qc=;
	b=bHET3YqxamXWzM+6S1DIGP3RQl78gEPgE7lvZl9IiRkFNgpK/7ywdGx0bSruJBfGoNb8mj
	vu9pW6jJOcAy4Cdb2x6IQtAR9dPtDIrF+WYDcGfVRGB+Mi6P2wWgfzbRsXjZsvrZW75oON
	TEixnOgKpxqkJTrFN+zUCUNct74Q2+U=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-BLYgTk_8MfSBK-x8mMJf8g-1; Tue, 12 Mar 2024 08:10:11 -0400
X-MC-Unique: BLYgTk_8MfSBK-x8mMJf8g-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a461b967e2cso95095966b.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 05:10:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710245410; x=1710850210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31/cMpUBlNq1dVo/GBGgzVo8ufDRVUmygq7sRPjG1Qc=;
        b=cBWUPGM20rJgVYa4rK+6OAE6c1hds59bAYsd6/oxvOHsufT9UT9z/Rh936ekfUUoRR
         AnBuM74DasygoUgQDdjtxCQrl33SaJ8SAXm6OSFcXMtx8YB48YZv0aMMAD0ka2tORv35
         W7vBts5ZLJ9ni5tO/76sqxzhFoBpSQZ0T1AGMqarS6wy6dU7SLF3sZhScfk0hbT+gNE+
         8Pn6/WXFaU1OCkWtk/bWln27J78MFYpq/gJcsEDDvouZ58W2Kt+nIIC/fcADK+C6AEsi
         Eyaa1kwwoingszV8lV3primROOfZ/uFob1qndQtD1W/cAw7MO86HxXluQE3FTI2OgNJE
         GQ+w==
X-Forwarded-Encrypted: i=1; AJvYcCXBX14NVAf4ZNUGpiIqnEYjutvaO9X8llwQSH0ytYfE7Kj+1cnC/AXzgI6KYWF2xqeX79KPGrX3rzSpx3LfIB/iYx2NxeploiEJ
X-Gm-Message-State: AOJu0YwSa2lPf+j1NB0uI5hCOw9jP2ykHpjcTAWqpHYwSh89r4CRoZp3
	vA2+JP2cACJwXAFUj2YSuTUB2rQxsa2GHsWe5BWdqltAXDmHYD2dYczZ5dqthgl0EwNPUAJ9CgT
	OgDFWbVrL/Tn+rCEL+wfkqwjvZrGWMI8atVjzTI/oI3+ka0J8GP13eTqiaDBgke1g
X-Received: by 2002:a17:906:f854:b0:a45:ab61:7a47 with SMTP id ks20-20020a170906f85400b00a45ab617a47mr110678ejb.16.1710245409329;
        Tue, 12 Mar 2024 05:10:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcFKEllu/5Cbuy41Q4z4pVzuQCoPfYq9eSirKoM2GYu6wrbDVHhEhhps6AcIx6mCLMUFmsaA==
X-Received: by 2002:a17:906:f854:b0:a45:ab61:7a47 with SMTP id ks20-20020a170906f85400b00a45ab617a47mr110620ejb.16.1710245407792;
        Tue, 12 Mar 2024 05:10:07 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id t13-20020a170906a10d00b00a4605a343ffsm3384399ejy.21.2024.03.12.05.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 05:10:07 -0700 (PDT)
Date: Tue, 12 Mar 2024 13:10:06 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, chandan.babu@oracle.com, ebiggers@kernel.org
Subject: Re: [PATCH v5 22/24] xfs: make scrub aware of verity dinode flag
Message-ID: <iag66iabauxkow5z2cn275gjtbaycumf3u6lsyljzuascylbto@d23xbll7dx6n>
References: <20240304191046.157464-2-aalbersh@redhat.com>
 <20240304191046.157464-24-aalbersh@redhat.com>
 <20240307221809.GA1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307221809.GA1927156@frogsfrogsfrogs>

On 2024-03-07 14:18:09, Darrick J. Wong wrote:
> On Mon, Mar 04, 2024 at 08:10:45PM +0100, Andrey Albershteyn wrote:
> > fs-verity adds new inode flag which causes scrub to fail as it is
> > not yet known.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/attr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index 9a1f59f7b5a4..ae4227cb55ec 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> > @@ -494,7 +494,7 @@ xchk_xattr_rec(
> >  	/* Retrieve the entry and check it. */
> >  	hash = be32_to_cpu(ent->hashval);
> >  	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
> > -			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT);
> > +			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT | XFS_ATTR_VERITY);
> 
> Now that online repair can modify/discard/salvage broken xattr trees and
> is pretty close to merging, how can I make it invalidate all the incore
> merkle tree data after a repair?
> 
> --D
> 

I suppose dropping all the xattr XFS_ATTR_VERITY buffers associated
with an inode should do the job.

-- 
- Andrey

