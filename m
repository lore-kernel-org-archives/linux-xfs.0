Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7601324468B
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 11:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768303013; cv=none; b=k0JNtOcgb1cDMFRXSJCoq/X1H1tlB0NJFWVenjapaubyJ/wo4ki4AqOzeXHYytfNkz7xnZc8cv6t3MPg9umudfY6LmsbG9WCx7vovRANdez+qhYRfnxTm79C3lkhlx1MuTCOBv56db/7K70Kg9UzRCGfSGAv8H/5SNET+wLMS2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768303013; c=relaxed/simple;
	bh=AmU0GKiuCJ+4Qe+dqer8i7dSl9l/acUK62fHtoMX+Yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLSfics4Vr4vi1ex82S1F5ZngnjptudVWUibbiXtGaakGbaneU4/b2Wy+65/JvX5TOCXCfQikCS5nLqvwNBgVCV3DXvcTNRTWfnLxAsb1iopIzJsb2Ji4RSRuWVRGLmnOMfctI6JSkU69rzT/LNOsIfAfsyaYh8nwS7iWHKgJk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XibTk0kx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oBqk29dQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XibTk0kx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oBqk29dQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768303009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QVvfGyEDgnITgpd/RH07Kuh2vfJUyfB4HEN6kFlg01E=;
	b=XibTk0kxnBpTADmBc+avht2AweO8XOdod+GU2ytz5j+UdZY5vrJrv8Wn+1V5MITjkft4bZ
	FhCKefFy4+OJ9+gxtFQrDAxXTWVSWgihk2nDrAShJDrJdYrKWguD7BNEXCgNhDxVXl44bN
	C/lOGGLmKEdkOz5Jrh/qFlJ710ykvaw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76--sKn75kVOCWLPq5l7FSdyg-1; Tue, 13 Jan 2026 06:16:48 -0500
X-MC-Unique: -sKn75kVOCWLPq5l7FSdyg-1
X-Mimecast-MFC-AGG-ID: -sKn75kVOCWLPq5l7FSdyg_1768303007
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-432a9ef3d86so3898761f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 03:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768303007; x=1768907807; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QVvfGyEDgnITgpd/RH07Kuh2vfJUyfB4HEN6kFlg01E=;
        b=oBqk29dQ5hsDsBxXjUArf5jqwyxwj7srLT17ddmTB7UkWh6daxq2AeRc74g4LCj+eO
         4wce3Ih/PCxAyjLouXx0SWpX6ND2cs4EngWerzWJXB2I3PAl1FhGq7UgeDavR2cSQZ0P
         lnPzV9eck6k48qrhbN8eRdj/V83JQFLDNNkvV8wMNSSkcg7MIpNYLw9k27SQUoI14YRN
         T2YmHDcjCAJAblAM9bVDeCx/hJfMXQh6xh/5KlllxRvcXv2ONPYBeKcLxUephtrhlXVC
         JiH2cFcnpSeCISiLVoUfNE37at6wdrzxNFBgrNt8foVVSmyiw5OjXdGSWU8yacg6/XNh
         Y17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768303007; x=1768907807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QVvfGyEDgnITgpd/RH07Kuh2vfJUyfB4HEN6kFlg01E=;
        b=nIvgIcgIwjNKcH4cwWRZNMDWFTzuNm0oJFjiM3wm2zYCVVDx6y5ZhyTUT+bAZIKpgn
         V7pK51zWRDPY+iIXF6XUpVL7gAnNEjnBLvAu7eEgVrf5kL9xTikTWKXQwgIePnBbGRif
         6JfD+umzOErKwSTMEnio+v6bRaq8Rr/XNt5k4N+73DIjsGIk+3KbepexQCDpT4aYvfjm
         /21AxboG9M2DhGcUY4OirQ8VhrFTT8Lx4ZjVdx/qW0oyLdCR4yq5MVQTQuobituUyKzu
         Yi6504o52FMDcVvFwHB80MohymquO30puuaEgP/aVbRohOnbzQVeFV1lSRyM7At30cjU
         xmHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfLK6gBJ/NatJhJ+772MjBZ3uR+ALZ8YuisTZWswhAh7+QPQNXa+acvxKvQ5xBUyfwOXBSzW3Wr0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsKE+f6FLHpj+y4IXTZaPAFScsQzdK/Q1T4tF+nfW0uZnnsUK6
	4j+xeXjE+WebPvctsYjSC3yfgNXfOO6b5BbaYg/xCgebUR+JCoYvQPwn889ArwSJdH3px7iip52
	g+SdM9yZi0I3Ugcup6L6eM7lyg4LFDPjl5A/duPuEIkJHjAakMujpZ/nNfOMj
X-Gm-Gg: AY/fxX60aOFQqRueSBnfItmbHGoQLTQSS791JpwCmy9ptHnVBGngULElNG+FoUNz7Bd
	6RyjsuBwrw/1p1+1Os8Q8eccFkeR647rRb+RZGWDPQCwMDT8BykS/Qy9uiNXAR/3dppTeX7Kqji
	CODWK7zgtplJBHSBKZ6LyM9S4OKxHJcGkTgEIVMzVN+cO5ZzryH2sgCgYSmMz1+7giaDTx9/teW
	jOFKy10643ab/CGCi6FwQuHuHDMLNHftmUX6K29JAIioZU7OuJ9HgTIYck9H9ep59LUdmLYVcgc
	rA25SwOKK355QtaB52SdzoHJcL87l10PrnruPJkCg2ivFfz0/xTyvC8HPFcNxjb22pTKd8rSqr4
	=
X-Received: by 2002:a05:600c:3e0d:b0:477:63a4:88fe with SMTP id 5b1f17b1804b1-47d84b0a279mr220891125e9.2.1768303006990;
        Tue, 13 Jan 2026 03:16:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFdIEOqsc71XSJgq6BNxiwINXMFW/+1X+/6MZ3YB9J1o13YbvNTcvNa0txlFxOzGEx83ctutA==
X-Received: by 2002:a05:600c:3e0d:b0:477:63a4:88fe with SMTP id 5b1f17b1804b1-47d84b0a279mr220890675e9.2.1768303006513;
        Tue, 13 Jan 2026 03:16:46 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ed98abad1sm33030435e9.10.2026.01.13.03.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 03:16:46 -0800 (PST)
Date: Tue, 13 Jan 2026 12:16:45 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v2 5/22] iomap: integrate fs-verity verification into
 iomap's read path
Message-ID: <vwx7hktpfbdbstxloryrfwcbk373pugjeqcozm7nuvl3uykr5z@gdgmpr7pgp34>
References: <cover.1768229271.patch-series@thinky>
 <fm6mhsjqpa4tgpubffqp6rdeinvjkp6ugdmpafzelydx6sxep2@vriwphnloylb>
 <20260112223555.GL15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112223555.GL15551@frogsfrogsfrogs>

On 2026-01-12 14:35:55, Darrick J. Wong wrote:
> On Mon, Jan 12, 2026 at 03:50:26PM +0100, Andrey Albershteyn wrote:
> > This patch adds fs-verity verification into iomap's read path. After
> > BIO's io operation is complete the data are verified against
> > fs-verity's Merkle tree. Verification work is done in a separate
> > workqueue.
> > 
> > The read path ioend iomap_read_ioend are stored side by side with
> > BIOs if FS_VERITY is enabled.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/iomap/bio.c         | 66 ++++++++++++++++++++++++++++++++++++++++++++++++----
> >  fs/iomap/buffered-io.c | 12 ++++++++-
> >  fs/iomap/ioend.c       | 41 +++++++++++++++++++++++++++++++-
> >  include/linux/iomap.h  | 11 ++++++++
> >  4 files changed, 123 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> > index fc045f2e4c..ac6c16b1f8 100644
> > --- a/fs/iomap/bio.c
> > +++ b/fs/iomap/bio.c
> > @@ -5,6 +5,7 @@
> >   */
> >  #include <linux/iomap.h>
> >  #include <linux/pagemap.h>
> > +#include <linux/fsverity.h>
> >  #include "internal.h"
> >  #include "trace.h"
> >  
> > @@ -18,6 +19,60 @@
> >  	bio_put(bio);
> >  }
> >  
> > +#ifdef CONFIG_FS_VERITY
> 
> Should all this stuff go into fs/iomap/fsverity.c instead of ifdef'd
> around the iomap code?
> 
> <shrug>

oh, sure, this would be better

> 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 79d1c97f02..481f7e1cff 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/writeback.h>
> >  #include <linux/swap.h>
> >  #include <linux/migrate.h>
> > +#include <linux/fsverity.h>
> >  #include "internal.h"
> >  #include "trace.h"
> >  
> > @@ -532,10 +533,19 @@
> >  		if (plen == 0)
> >  			return 0;
> >  
> > +		/* end of fs-verity region*/
> > +		if ((iomap->flags & IOMAP_F_BEYOND_EOF) && (iomap->type == IOMAP_HOLE)) {
> 
> Overly long line.

will fix

> 
> Also, when do we get the combination of BEYOND_EOF && HOLE?  Is that for
> sparse regions in only the merkle tree?  IIRC (and I could be wrong)
> fsverity still wants to checksum sparse holes in the regular file data,
> right?

The _BEYOUND_EOF is only for fsverity metadata. This case handles
the merkle tree tail case/end of tree. 1k fs bs 4k page 1k fsverity
blocks, fsverity requests the page with a tree which is smaller than
4 fsverity blocks (e.g. 3072b). The last 1k block in the page will
be hole. So, just zero out the rest and mark uptodate.

> 
> > +			folio_zero_range(folio, poff, plen);
> > +			iomap_set_range_uptodate(folio, poff, plen);
> > +		}
> >  		/* zero post-eof blocks as the page may be mapped */
> > -		if (iomap_block_needs_zeroing(iter, pos) &&
> > +		else if (iomap_block_needs_zeroing(iter, pos) &&
> 
> 		} else if (...
> 
> (nitpicking indentation)
> 
> >  		    !(iomap->flags & IOMAP_F_BEYOND_EOF)) {
> >  			folio_zero_range(folio, poff, plen);
> > +			if (fsverity_active(iter->inode) &&
> > +			    !fsverity_verify_blocks(folio, plen, poff)) {
> > +				return -EIO;
> > +			}
> >  			iomap_set_range_uptodate(folio, poff, plen);
> >  		} else {
> >  			if (!*bytes_submitted)
> > diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> > index 86f44922ed..30c0de3c75 100644
> > --- a/fs/iomap/ioend.c
> > +++ b/fs/iomap/ioend.c
> > @@ -9,6 +9,8 @@
> >  #include "internal.h"
> >  #include "trace.h"
> >  
> > +#define IOMAP_POOL_SIZE		(4 * (PAGE_SIZE / SECTOR_SIZE))
> 
> How do we arrive at this pool size?  How is it important to have a
> larger bio reserve pool for *larger* base page sizes?

Well, this is just a one which iomap uses by default for read pool.
I'm not sure I know enough to optimize pool size here :)

-- 
- Andrey

