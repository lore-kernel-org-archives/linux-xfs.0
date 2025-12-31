Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F6C30F52C
	for <linux-xfs@vger.kernel.org>; Wed, 31 Dec 2025 22:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767219847; cv=none; b=a2ot63RMenWqtDlqOXjUzSLtgi4hHGRuZSinOXEmN5vIBidxtHq5BTd9NtvwLog4ykSlICISeXZJ+w8rpEI105uRopgtLhz00Dalm/gIBex+q7dalxUsOuM8Rj+x/mtxujRcuz5Eein7M9scZJ3jniXmeYPApDR7yPYxd8cqOVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767219847; c=relaxed/simple;
	bh=HgcXRUs1WlGpSYLBIN2t9wqZLKEsnBJdnq68x90pWYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k37ymrmz9t57kCwmn/tQ41fdb3dgZuYmh82zpsn7CaRt+3Ci+ueXtTlPeXoCX1lPe3vV2+FQcyzDJkdHxvZ1GyvnuIOC5TyYT9mbpOJbVMLbx5nEI/MJvJuCGfBrcxxd1WfuJnCu7OjWhqWhuEx0ctUYGYHHpnDtxW3fEPy0i7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VstdkSVy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XDD2BVCV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VstdkSVy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XDD2BVCV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767219845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pzg1w7XjpPUiDpJKIbrZBUkh26fh2KWEzx7hjMnlg44=;
	b=VstdkSVyZSHybWaKZcy0MRLWXRIXeMq2ux/61fXRxAVl6gmJ3xqEiUGd+q05PMgXwqDgo0
	NEccz/ZGN+hLkx+DuIBFuwqZlqt/cTiGsoB5i/J7SB5f8PYTjo0B5ijDePZgaes3BEGGOd
	RRv+1khkzHgQk9DU+/ONLrfduq5NI7U=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-QF45ebnDMAWnaT2-QMiYLw-1; Wed, 31 Dec 2025 17:24:03 -0500
X-MC-Unique: QF45ebnDMAWnaT2-QMiYLw-1
X-Mimecast-MFC-AGG-ID: QF45ebnDMAWnaT2-QMiYLw_1767219843
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c904a1168so24283874a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 31 Dec 2025 14:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767219843; x=1767824643; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pzg1w7XjpPUiDpJKIbrZBUkh26fh2KWEzx7hjMnlg44=;
        b=XDD2BVCVMb+Du6dIlULW21WlmeFqq02hdoEdQrUO3cOUxWBUOEqz/nrV2vCJQLIw0L
         f/yDom8ea5UydgktBy3MiYHYhnnv8Zas3ZaraUL2P21waUUeciqJTXbO8+2kzECwzTQQ
         LVTlaVRSxZmKirP5BmJR1ZZNgMneFqHEhYkQVlFmNJWXTqnMpStX6kibmZi8k6DtUUZN
         gNXA0HjhfXiQNL+Z7kNsS8vQspnKE3jUyKUrvu8EYgFdhRYVU3Sl7tobu99Gxgwn42Bp
         pw4f72lwGu0UiDLSETFDDIXyfrjWoNYDfT0BF1IxQegjEn3CvbB4bqp5Htk9Hp/Q+SN8
         1CRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767219843; x=1767824643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pzg1w7XjpPUiDpJKIbrZBUkh26fh2KWEzx7hjMnlg44=;
        b=ISHbZO8HD3yj2wAo+QNYco8oa+OFoyBFhbdctEVEU0l2a1xC3vBn3dvwtaIIvMwzxH
         M5arUM9DGxz2Je42GxJD5e5A/3S4SoW2/SzQg8gDsPNWmgN7ZzgH0NFK2OK/U3lbZon7
         t0P0Zz0PTGouSDeucjtRIphoOOPr+HGdMjDrqM+ZfjUnD2wUjHEirSR0ytZHLJlL7/qA
         0A+ym2AonE3nuo28u6iGJHZ+F3VO5AOHpDsG4Ex9k0ok1Lj6xLbSjBx268TTVyR9L1Zp
         2kxU2R6S0uozWYNuYCQflgDDwyxXe29j0DpuntXlgHa+xfbpLnPdAxJ5B2It4n4vajH7
         ojsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPr9NfFhcbznIyKOFY4XQu1xbouwHGPCjhg3yi7ryu2zNIVEy2+zp+DTc2+//AxAJMLJIfgIGaAOw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/KCxPXY1PG4Ubr6oynUnB5CaHWFOVIMISXvCKDEXLUL6maTUi
	+4LttIYRP9A5Ps1SUf5p1YGO7BVhH9N+U5/gHzq9SWKwBXCT7/gpJIIn9BKzoMv69QAHYOCbYCa
	rYCGY6g33nkFGWI4Y+vkABSBOrv9ImSf7lU2sKAaIQFpKmnuvr3j37uf0LAW4rg==
X-Gm-Gg: AY/fxX4WfVpdAsPwmRr8/Z3ahay/j9VCTnbMAVnllcpdPWKrL0ehGaAY2y9YUXa0rMt
	XOYmiEERZNwjGlcJ/a9rNNwBsoVOlP6TmYKtIAtCcfxVWy6dDJuFPuhYS5QgZqUobLr6Jra6heP
	M3PSZgI4vqjr+5JLc4m0RDwO8Mw8MjoE0sXCmRrkUIEDASwYHWriBNFqPUSNOlFBahNIUXjbTrk
	Tk7PxooHBSxahYkHaT73vcdAiBbbaSxmpffANvkMmdtxxaEqtYCIPH4bbRoYJ/V3doFaO/ZUxB+
	u1JiEQu3NqZrroCiA6g1VrteriF1fWWhR5zRjdyuKqxsz/8g+dTBtiUMiNML4E54Sx3XUFOc9FU
	a1a14iHXx1k7vDA1y5zLILgIM2uFvy7M86WduoJHsrmXWh1AHxQ==
X-Received: by 2002:a17:90b:4d87:b0:340:e521:bc73 with SMTP id 98e67ed59e1d1-34e921371c5mr31304910a91.5.1767219842808;
        Wed, 31 Dec 2025 14:24:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHnY9luOFdJ6YVtjjRAjxqjcz7p3sXH9xQ/Aj/NVZyWcSIbJda156hcFdgmayha8ejyLIYCA==
X-Received: by 2002:a17:90b:4d87:b0:340:e521:bc73 with SMTP id 98e67ed59e1d1-34e921371c5mr31304899a91.5.1767219842435;
        Wed, 31 Dec 2025 14:24:02 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34ef44e0b24sm10258518a91.0.2025.12.31.14.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 14:24:01 -0800 (PST)
Date: Thu, 1 Jan 2026 06:23:57 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/649: fix various problems
Message-ID: <20251231222357.lqtaiigycgdy7v4l@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <176590971706.3745129.3551344923809888340.stgit@frogsfrogsfrogs>
 <176590971773.3745129.6098946861687047333.stgit@frogsfrogsfrogs>
 <aUKFBx09MGp4Z2bu@infradead.org>
 <20251218041232.GW7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218041232.GW7725@frogsfrogsfrogs>

On Wed, Dec 17, 2025 at 08:12:32PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 17, 2025 at 02:25:11AM -0800, Christoph Hellwig wrote:
> > On Tue, Dec 16, 2025 at 10:29:56AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Fix a couple of problems with this new test:
> > 
> > It looks like this patch got dropped again?  While my git repository
> > has the commit ID, I can't find the test in the patches-in-queue or
> > for-next branches.
> > 
> > The changes themselves look sane to me.
> 
> You might've pulled my for-next branch.  IIRC I've never sent this one
> to the list, so Zorro has never seen it.

I just checked my mailbox, I didn't find an email with this subject or even
with xfs/649. But our mail server filter out some patch emails sometimes,
so if I missed your patches, please feel free to ping me :)

Thanks,
Zorro

> 
> --D
> 

