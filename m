Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F194A383B0
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 05:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720677081; cv=none; b=Ard3n88jMoECFH+iLFm8xpyzs4Xbx8AUINPpH+BZaKX30N6j0JU8Xr1+kYGlVPO1TmoG2IQiW0easalVUIYJ0N3VKW9PSHMQ73/PbAx71IajcU02hrWgqFj7dw9FJF3Jtpdb3gUaSHmKlTrwvuWnYECSHt4zqhljT7AU+yIHsVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720677081; c=relaxed/simple;
	bh=8npnQIky/nb0FsAuNqsFQIZncFoo2fUjGO3zJhqU49c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMk5bfliH8Rp9YXlg5gyBcurZSVhcsX+6/eiPsUwMAAIxEOwcQHJrvCpybbNmeSU37gdnIn6vBCK4EGa/laB4WzZNlkdHCjm8ltWuspvTSPJB1CWvOGAjH30IdieRW1sC2ue5ZK4Jd72FVZVqgytP5wMD/mZvMldMK64E/+izrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=gTU1N7Qo; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gTU1N7Qo"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3d9306100b5so371500b6e.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2024 22:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720677079; x=1721281879; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p/S/gwUKL7Lr/rDwt/FxHBlOrsHmn9B9oRiZ5ZpDepc=;
        b=gTU1N7QoD3RUfHnGfkKQHP4vpiJIzIq/z0BV9BydImW3kklyF6IGlupcr+gLRXmZhm
         gjBsboKGZlhJTYHd8CpmNwMJacWPjJKlqBCeqoHVgJpn4aEwGWlfL1YTJSIipVrt/jYN
         J+ItXi/gePpujwqJpPyv/fR+eqoWSDZSg1Acuu05qeTDKK/3/f1bwD5UqjP1frmcvzLs
         I7RB+Fxw7obRiqORjJrGFZnWUE9N8JtobGx43raE++foentw2HSDk4ZUARga+3NpO/aw
         Ef/WJvRBc09+9TQwb0VrSZTE+3exb2ZANBsLXQjtBrQnvfK8qeYWerQ/fItzvZ3Dp3a7
         yLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720677079; x=1721281879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/S/gwUKL7Lr/rDwt/FxHBlOrsHmn9B9oRiZ5ZpDepc=;
        b=H7/oMI5fAzIgBo9MP7E54PKWvPDOJNYoPlZhHmVex2kLq84T5yu8reIE+XSQkVimiz
         z5lwnAg3xzOnEzFgboLAhhQJA8k796n7/76Qff86sM3mkCUT6rLB14jPHbSxK0gDQog7
         /54n/eE3TL4DDRzEHLuIui1KhSGXaERcuczC6Ft2r1c6S5Kst5SkuQfWi/aN/iqw4Qcg
         UZKXXuwJKgL0X5YHohjNNOUstkZdyoDLD3RXyL3xqafURZHEjh6jH06tmFW2sCl+tQM/
         89hCosX7TNCls5TdIHe9/KjbcIhGJKtqO7VnWcQCaERTgNGgYMTH4X/0zpvI6rPobcnd
         sDfw==
X-Gm-Message-State: AOJu0YyDI7tDiacGBGW0WZ/yuSDtGyJxsQdaLxZWibhvyVb5yGn5xohT
	RgI/PKTHQ3B6v34F55igFNHtsw/WZqNLDIpPgauSsNGn9txI9DFlBizNPdBQELU=
X-Google-Smtp-Source: AGHT+IFkoZ0ZYiwrjsFYGPCOHC2dTLLDMgHOeggM++DdkKaHE6I9Xh6b1eFlT1naUfYPzwzzKYA13Q==
X-Received: by 2002:a05:6808:23cc:b0:3d2:1ce7:43da with SMTP id 5614622812f47-3d93c08ffadmr8373223b6e.49.1720677079084;
        Wed, 10 Jul 2024 22:51:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-77d603fa713sm3760128a12.25.2024.07.10.22.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 22:51:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sRmi4-00BhyY-0C;
	Thu, 11 Jul 2024 15:51:16 +1000
Date: Thu, 11 Jul 2024 15:51:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update XFS_IOC_DIOINFO memory alignment value
Message-ID: <Zo9y1GXMWRfkw0rD@dread.disaster.area>
References: <20240711003637.2979807-1-david@fromorbit.com>
 <20240711025206.GG612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240711025206.GG612460@frogsfrogsfrogs>

On Wed, Jul 10, 2024 at 07:52:06PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 11, 2024 at 10:36:37AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > As of v6.0, the DIO memory buffer alignment is no longer aligned to
> > the logical sector size of the underlying block device. There is now
> > a specific DMA alignment parameter that memory buffers should be
> > aligned to. statx(STATX_DIOALIGN) gets this right, but
> > XFS_IOC_DIOINFO does not - it still uses the older fixed alignment
> > defined by the block device logical sector size.
> > 
> > This was found because the s390 DASD driver increased DMA alignment
> > to PAGE_SIZE in commit bc792884b76f ("s390/dasd: Establish DMA
> > alignment") and DIO aligned to logical sector sizes have started
> > failing on kernels with that commit. Fixing the "userspace fails
> > because device alignment constraints increased" issue is not XFS's
> > problem, but we really should be reporting the correct device memory
> > alignment in XFS_IOC_DIOINFO.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index f0117188f302..71eba4849e03 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1368,7 +1368,8 @@ xfs_file_ioctl(
> >  		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> >  		struct dioattr		da;
> >  
> > -		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
> > +		da.d_mem = bdev_dma_alignment(target->bt_bdev);
> 
> bdev_dma_alignment returns a mask, so I think you want to add one here?

Ah, yes, good eyes, I forgot to refresh the patch. I'll send an
updated version to the list.

> Though at this point, perhaps DIOINFO should query the STATX_DIOALIGN
> information so xfs doesn't have to maintain this anymore?

We open code the STATX_DIOALIGN stuff in xfs_vn_getattr() ourselves
- there's no point using statx to query information we supply statx
with in the first place.

> (Or just make a helper that statx and DIOINFO can both call?)

If we grow more internal users, then maybe?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
