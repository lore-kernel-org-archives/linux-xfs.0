Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7498138837F
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 11:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774265395; cv=none; b=t0WRbgqUtGqoxPg6MMC/wvx3/ta/AlX+LL3AZAJUCz1HKHzaYMZ1/n7TL1wMFerRq9MTL8EurscQ6uzq5pWNkBYlFAOVEQlWeSQ419V7+jdhUKFGgqsD3HP60RDVmKp27SqAmCrBIJxy8Te3sCVwH+facdv3DMd2S19eOjptcFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774265395; c=relaxed/simple;
	bh=mtzZPfAlTULdy6MHZAQ6Z9uboUcvAm31TEJYbxOo+A0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=THGcqKJIApKbXYBeWU49gOVy4/yn3GteVNoZN87gxwaLAEx/YwwHZAEgT00wzEnCWG0gK+KYNBmW6Lr2F0tKbZhOu2Bxzpc+DOxlC2zNlg84R1ZhOPelX4IbanqD4p8ikG7Tpkvtz565G9OILpYePQ/CkCOhImlfU9n4e0NtJK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R7wY8QXZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JLczlPa1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R7wY8QXZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JLczlPa1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774265391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SI8DtvaSoqHYW2wMAmX29KiYAme/SrV751vNiujPq8U=;
	b=R7wY8QXZTxbp8aDnC6L7rFqsh5gVSfxzqkNliDSOsFrCN32tabsl5OqZ36ITpcFt7XMOTf
	4A7nK5IQroWwkz3lwvyz4TJZ6cZ2ZAKPclwV1PYilkf0/y1O8epKgbmCpuuBdHNBPXaGbH
	PZCegohPOL78VEP+QxUydzUyQo6ot8g=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-U1WMGzKwPBWeEJecAr8YFA-1; Mon, 23 Mar 2026 07:29:49 -0400
X-MC-Unique: U1WMGzKwPBWeEJecAr8YFA-1
X-Mimecast-MFC-AGG-ID: U1WMGzKwPBWeEJecAr8YFA_1774265389
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b07bd30b5eso45577285ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 04:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774265388; x=1774870188; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SI8DtvaSoqHYW2wMAmX29KiYAme/SrV751vNiujPq8U=;
        b=JLczlPa1LGEFUhD6lTIru8Ohzd/p5I5xUWa7X6emwJ/WLT5zZmJy4ESj876ZCA4BoX
         LrkFh51onkJ2fibeDhgeb04Q/M4mQsSn+qHUm29ujF34TxN1uXGqff6lXJm+WSw8nOn6
         kMDKLNatHpsSQPuhl3sIl7nSnk63NJ9J7kp76pzLcMLPHfm1cHiuwF0RhR7e/8a9JGTK
         eCdhFP0JIySiZge0lDJcb1LLFKUGXP/z8M0ku6f3/FuMODYyykzGtBRDzE9TV/m743fW
         Ty3RtE99tMAG3O89ifc4iHfycqKeoWjSDq7BISNuofMHViZrDzGr22KpCwPFH3m6TkX3
         L/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774265388; x=1774870188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SI8DtvaSoqHYW2wMAmX29KiYAme/SrV751vNiujPq8U=;
        b=UdjzTknGTKdSqRSuHHPvUcCRX1Ed+SIXbg9P8aILXhVwo5ZqRkUI+uyyttsCDi7mqk
         C3Qlgq1gYLb0Sk+JWwNMV29zF4VYC+nW2KsKPBAh4K7BZO1fv9rXbvmMmi3K08Np+yx7
         heGEeonge17+LRs/4Qy3f2VmF7X6UMoimuvHHh3tZBH0L67hYULnAXYg19OJf+KOSVc8
         kev9RckwcUFLEIzrwoGrMWAjjrUeXko6R3u2hSkMeq5tamDR/iBy7YUClPmuBqOH5k/h
         XqISoN2u7Z/LmlzqxRhkRFfkT0pghkd7a/jDHjTb4/glbyYrgFqWKbi8qtDT1utwbyjz
         NlZA==
X-Gm-Message-State: AOJu0YxNP6R4AKdJnfEfxO2Z41aydV7LPmZYvllkmpkxJxfhQpBElKfA
	iSz90LK2YuORTFcXEi/y7TmKn2KE2CWC9kf22hOgWsoV0mjefL5WINCdp3zif/5vaazkeYcmrQV
	0Ciow/OkPyTtOk5cUdwgGv5IWaxunKGE5ZK7UMdNzSfuZzae4o984BU9CcXxmVPG3mWS0gA==
X-Gm-Gg: ATEYQzy2Oxggw0gvjnOYMm9zw5hUTWqX5G6w0zT33B2h5gLjEv3hDxJoNFYR8luIXRl
	QyuTq20hlpM8LUuwoKBUXhtM9WFd2suSC6ZHDFOCHKcVoLvoTWPJ6+RrY417QYPSNTrz4bJu8qR
	5Y6borTi5VYj1gWpArnqTzgmu/fJU1nmqzzPfGuKiDUSPWG/AsMF/J80BdH3+wxmjZK7PiCbGuT
	mw179RpSMCC9L08mKSnt0XX45/B+gQia8a9chyErZcLG8ZFDlU92KPgCNqoy4Z2K7WeBY/fznas
	/iyssh3cBoz0XCOmSnj+AHf5vZhpx5Ameg1hrSj27QUXHsXGMm4drCGZZAiq8wtUQPk7JCGv3Y4
	86ziugAEiVCzFED5GhA==
X-Received: by 2002:a17:903:283:b0:2b0:5a4c:726f with SMTP id d9443c01a7336-2b0771d6e70mr123970995ad.15.1774265388243;
        Mon, 23 Mar 2026 04:29:48 -0700 (PDT)
X-Received: by 2002:a17:903:283:b0:2b0:5a4c:726f with SMTP id d9443c01a7336-2b0771d6e70mr123970875ad.15.1774265387744;
        Mon, 23 Mar 2026 04:29:47 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516189sm113434565ad.16.2026.03.23.04.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 04:29:47 -0700 (PDT)
Date: Mon, 23 Mar 2026 19:29:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug][xfstests xfs/556] inconsistent {HARDIRQ-ON-W} ->
 {IN-HARDIRQ-W} usage
Message-ID: <20260323112943.6r5msnibxiacx3df@doltdoltdolt>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
 <20260320163444.GE6223@frogsfrogsfrogs>
 <20260321182025.67uyusy7235akgcu@doltdoltdolt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321182025.67uyusy7235akgcu@doltdoltdolt>

On Sun, Mar 22, 2026 at 02:20:25AM +0800, Zorro Lang wrote:
> On Fri, Mar 20, 2026 at 09:34:44AM -0700, Darrick J. Wong wrote:
> > On Fri, Mar 20, 2026 at 03:43:03AM +0800, Zorro Lang wrote:
> > > Hi,
> > > 
> > > While running fstests xfs/556 on kernel 7.0.0-rc4+ (HEAD=04a9f1766954), a
> > > lockdep warning was triggered indicating an inconsistent lock state for
> > > sb->s_type->i_lock_key.
> > > 
> > > The deadlock might occur because iomap_read_end_io (called from a hardware
> > > interrupt completion path) invokes fserror_report, which then calls igrab.
> > > igrab attempts to acquire the i_lock spinlock. However, the i_lock is frequently
> > > acquired in process context with interrupts enabled. If an interrupt occurs while
> > > a process holds the i_lock, and that interrupt handler calls fserror_report, the
> > > system deadlocks.
> > > 
> > > I hit this warning several times by running xfs/556 (mostly) or generic/648
> > > on xfs. More details refer to below console log.
> > > 
> > > Thanks,
> > > Zorro
> > 
> > Does the patch below fix the lockdep complaint for you?  It fixes it
> > here on my local machine...
> 
> I'll give it a test :)

Hi Darrick,

Your patch is good to me too, my testing tests passed with this patch :)

Thanks,
Zorro

> 
> Thanks,
> Zorro
> 
> > 
> > diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> > index fc045f2e4c459e..cf98247e51f81e 100644
> > --- a/fs/iomap/bio.c
> > +++ b/fs/iomap/bio.c
> > @@ -8,7 +8,15 @@
> >  #include "internal.h"
> >  #include "trace.h"
> >  
> > -static void iomap_read_end_io(struct bio *bio)
> > +struct iomap_failed_bio {
> > +	struct list_head io_list;
> > +	struct bio *bio;
> > +};
> > +
> > +static DEFINE_SPINLOCK(failed_read_lock);
> > +static LIST_HEAD(failed_read_list);
> > +
> > +static void __iomap_read_end_io(struct bio *bio)
> >  {
> >  	int error = blk_status_to_errno(bio->bi_status);
> >  	struct folio_iter fi;
> > @@ -18,6 +26,61 @@ static void iomap_read_end_io(struct bio *bio)
> >  	bio_put(bio);
> >  }
> >  
> > +static void
> > +iomap_fail_reads(
> > +	struct work_struct	*work)
> > +{
> > +	struct iomap_failed_bio	*fb;
> > +	struct list_head	tmp;
> > +	unsigned long		flags;
> > +
> > +	spin_lock_irqsave(&failed_read_lock, flags);
> > +	list_replace_init(&failed_read_list, &tmp);
> > +	spin_unlock_irqrestore(&failed_read_lock, flags);
> > +
> > +	while ((fb = list_first_entry_or_null(&tmp, struct iomap_failed_bio,
> > +			io_list))) {
> > +		list_del_init(&fb->io_list);
> > +		__iomap_read_end_io(fb->bio);
> > +		kfree(fb);
> > +		cond_resched();
> > +	}
> > +}
> > +
> > +static DECLARE_WORK(failed_read_work, iomap_fail_reads);
> > +
> > +static void iomap_fail_buffered_read(struct iomap_failed_bio *fb)
> > +{
> > +	unsigned long flags;
> > +
> > +	/*
> > +	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
> > +	 * in the fserror code.  The caller no longer owns the fb reference
> > +	 * after the spinlock drops.
> > +	 */
> > +	spin_lock_irqsave(&failed_read_lock, flags);
> > +	if (list_empty(&failed_read_list))
> > +		WARN_ON_ONCE(!schedule_work(&failed_read_work));
> > +	list_add_tail(&fb->io_list, &failed_read_list);
> > +	spin_unlock_irqrestore(&failed_read_lock, flags);
> > +}
> > +
> > +static void iomap_read_end_io(struct bio *bio)
> > +{
> > +	if (bio->bi_status) {
> > +		struct iomap_failed_bio *fb = kzalloc_obj(*fb, GFP_ATOMIC);
> > +
> > +		if (fb) {
> > +			fb->bio = bio;
> > +			INIT_LIST_HEAD(&fb->io_list);
> > +			iomap_fail_buffered_read(fb);
> > +			return;
> > +		}
> > +	}
> > +
> > +	__iomap_read_end_io(bio);
> > +}
> > +
> >  static void iomap_bio_submit_read(struct iomap_read_folio_ctx *ctx)
> >  {
> >  	struct bio *bio = ctx->read_ctx;
> > 

