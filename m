Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDBE1B4F0A
	for <linux-xfs@vger.kernel.org>; Sat, 21 Mar 2026 18:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774117236; cv=none; b=LQYPXH+8k/NFn6domQfI7QdeVu7dKjdFKnl55kg7TGHCr3NptJgxRhnhOniYqkGinL8szeLJazv6JYQfT4CI2ocUYXkLWDXl17uIjEyp/Wb6tEvDBaG4wjeVRZ6EEyYygyTvvGN2JDaFmJgTo9XUOhC2Yclf2ik/+tEpdiXrUyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774117236; c=relaxed/simple;
	bh=KVsEmfuMLPVRXuref/BrNDmiZ3/ZMgu9cF7/StvDLpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOGlBkkzoexfz1Q67RCFVlcVW9KrLVJLUw2VGuDX7QaEIeBhVo29dgxMwnf+vQ6uzFYtBDJoOFiCRu73G30fKAcWYqxpObzt28NcFnEAe8BWNfdIxLjn7bQn4oy9zoRWhN5J/THpj7aOp6X8s5z06yxt/ufapPZVqP1tsiZvQ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SxDU0Jmw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JNfgCepW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SxDU0Jmw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNfgCepW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774117233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OVuayusj2u0c16Uj7IfHPBBIQtM02hE6HAWZKwfyEiQ=;
	b=SxDU0JmwuT+LEct13k7K70ak4hznR9AVbRrF+Wi5vIrx9pp8lxSSzRF4ZHC6gT2o9AHK3x
	fhh2DIPvKGXYcovytMmJpLmidU6dT/oMMk0Ja/81dGgQHmfvmefaUOuG3C8GS+M5tI8h4f
	PGDFPXLuIOzmM5cwYT4GkznHdIrQhWI=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-gOTKLBJqP3ilG5UL7qi4mA-1; Sat, 21 Mar 2026 14:20:32 -0400
X-MC-Unique: gOTKLBJqP3ilG5UL7qi4mA-1
X-Mimecast-MFC-AGG-ID: gOTKLBJqP3ilG5UL7qi4mA_1774117231
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82c38b85c25so287523b3a.3
        for <linux-xfs@vger.kernel.org>; Sat, 21 Mar 2026 11:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774117231; x=1774722031; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OVuayusj2u0c16Uj7IfHPBBIQtM02hE6HAWZKwfyEiQ=;
        b=JNfgCepWmovdOlzQMzPouqhe9LT3en4XheeYa6vvdtFMz2a6lAhHrhzG/8mz/8HvIF
         fruprtsVu23y0Jz+l0o/QPOIMYgQhVdXFPivi16m3sflCcl9Leq8Q5fMt00OaDyrsROl
         UA6fga0eiy3i8Oktvq4HkDej33Mm7HA5YciHc+gqiGEiDmPyv4b+Pc9T7gnWHEr7VvYf
         Oc0FBBoctCiSuiLBiVTJaS1sLk7Un0si2WvPya9+0zQplUIsIVq/Pa4CmdB3NeNfORrn
         xby3cns+fhY2AG2iWqhNCPs3sPTm6+ny2K2tdFFR6o4vItdeMQdLIeW5oKa/cAksnnao
         Chpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774117231; x=1774722031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OVuayusj2u0c16Uj7IfHPBBIQtM02hE6HAWZKwfyEiQ=;
        b=sgZ1RX0IkCJSvOl1sXTZ07LCJMjOgpI9g5MVlI5Qq+0jRaIJaY7cx8iodvAV8lhFB1
         ojJwND4qm6pTK5BvXZddfPz1k8tq/gJxqRJ8tnh1asYxGZLxtUduj2ATMghGdfOBlW8V
         xFVvyVnAWFK119izN8D2idnv7k5iiaweror7XiJ6rfGbmT/y5kM/xcUa34qe9+cptgFg
         lcH+WO7HRDIT3juqvjIXIKhwZ8jw93EyjXI6d8oNc1SVygYQG8StwMFo4kKmE1MUq6lv
         qTyP1HlVplXHq/zIPol0o7Wdgse+WyBvCwhqI52rHBCKUIi08ol/0RP2jvlYjzYAyCbJ
         uTiQ==
X-Gm-Message-State: AOJu0YztHgj7NAPCMpK6dHYVWODpldmYhAwfMK2LrSvZd69yJPiu/3Vs
	dKAamiJ07m2Khr6NA0/u4SsYmT4CViFH5vT/uHjquyDaNWfmJTZfd0Qqr3dDplsGdnOTt4hFyMk
	rIQKIHhwUvxy0oLRJrH7+5YGGKGVziaXTqEhMKb6A7KK6A8eNgHjVUc4q9e8l0g==
X-Gm-Gg: ATEYQzxqN6J34RsCw8muTQEVcMJK3boYn//JzOF0wc+3oMxz28zdMVILYkZF2RIIont
	acdrKZoAdUDbdySPNM/bh8H/eB0gdFaaVmZ2nzyeaPkkBCjylPc81f6ZvI3iBEg9csPwOSAfh6l
	7a/fxCjy/63JdkVn0AlBtgjYIUwxcsr6qlYDmHz/lIX+kHZD8TdI0FCwHn13mh6haBh5mv7shy7
	qtqhDQ9lb1Ynvvjv2P7Ni1I6shNUK1N9Sbg3vY4jjDnpoFPQL9EyNFk+rwEPqXZn9HSYzFmzYpe
	zuxl34VbfMvRb8sMrmGZRb5DlqsmkZukwoXHxZcwAxR1zgHm00vYo0kvcfO4iE/MC9PkW5M2Osc
	ptg3FIMpnklHx9yW0CQ==
X-Received: by 2002:a05:6a00:228e:b0:827:26b0:58d6 with SMTP id d2e1a72fcca58-82a8c334b58mr6082235b3a.47.1774117231043;
        Sat, 21 Mar 2026 11:20:31 -0700 (PDT)
X-Received: by 2002:a05:6a00:228e:b0:827:26b0:58d6 with SMTP id d2e1a72fcca58-82a8c334b58mr6082214b3a.47.1774117230467;
        Sat, 21 Mar 2026 11:20:30 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0409d148sm4644198b3a.29.2026.03.21.11.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 11:20:30 -0700 (PDT)
Date: Sun, 22 Mar 2026 02:20:25 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug][xfstests xfs/556] inconsistent {HARDIRQ-ON-W} ->
 {IN-HARDIRQ-W} usage
Message-ID: <20260321182025.67uyusy7235akgcu@doltdoltdolt>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
 <20260320163444.GE6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320163444.GE6223@frogsfrogsfrogs>

On Fri, Mar 20, 2026 at 09:34:44AM -0700, Darrick J. Wong wrote:
> On Fri, Mar 20, 2026 at 03:43:03AM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > While running fstests xfs/556 on kernel 7.0.0-rc4+ (HEAD=04a9f1766954), a
> > lockdep warning was triggered indicating an inconsistent lock state for
> > sb->s_type->i_lock_key.
> > 
> > The deadlock might occur because iomap_read_end_io (called from a hardware
> > interrupt completion path) invokes fserror_report, which then calls igrab.
> > igrab attempts to acquire the i_lock spinlock. However, the i_lock is frequently
> > acquired in process context with interrupts enabled. If an interrupt occurs while
> > a process holds the i_lock, and that interrupt handler calls fserror_report, the
> > system deadlocks.
> > 
> > I hit this warning several times by running xfs/556 (mostly) or generic/648
> > on xfs. More details refer to below console log.
> > 
> > Thanks,
> > Zorro
> 
> Does the patch below fix the lockdep complaint for you?  It fixes it
> here on my local machine...

I'll give it a test :)

Thanks,
Zorro

> 
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index fc045f2e4c459e..cf98247e51f81e 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -8,7 +8,15 @@
>  #include "internal.h"
>  #include "trace.h"
>  
> -static void iomap_read_end_io(struct bio *bio)
> +struct iomap_failed_bio {
> +	struct list_head io_list;
> +	struct bio *bio;
> +};
> +
> +static DEFINE_SPINLOCK(failed_read_lock);
> +static LIST_HEAD(failed_read_list);
> +
> +static void __iomap_read_end_io(struct bio *bio)
>  {
>  	int error = blk_status_to_errno(bio->bi_status);
>  	struct folio_iter fi;
> @@ -18,6 +26,61 @@ static void iomap_read_end_io(struct bio *bio)
>  	bio_put(bio);
>  }
>  
> +static void
> +iomap_fail_reads(
> +	struct work_struct	*work)
> +{
> +	struct iomap_failed_bio	*fb;
> +	struct list_head	tmp;
> +	unsigned long		flags;
> +
> +	spin_lock_irqsave(&failed_read_lock, flags);
> +	list_replace_init(&failed_read_list, &tmp);
> +	spin_unlock_irqrestore(&failed_read_lock, flags);
> +
> +	while ((fb = list_first_entry_or_null(&tmp, struct iomap_failed_bio,
> +			io_list))) {
> +		list_del_init(&fb->io_list);
> +		__iomap_read_end_io(fb->bio);
> +		kfree(fb);
> +		cond_resched();
> +	}
> +}
> +
> +static DECLARE_WORK(failed_read_work, iomap_fail_reads);
> +
> +static void iomap_fail_buffered_read(struct iomap_failed_bio *fb)
> +{
> +	unsigned long flags;
> +
> +	/*
> +	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
> +	 * in the fserror code.  The caller no longer owns the fb reference
> +	 * after the spinlock drops.
> +	 */
> +	spin_lock_irqsave(&failed_read_lock, flags);
> +	if (list_empty(&failed_read_list))
> +		WARN_ON_ONCE(!schedule_work(&failed_read_work));
> +	list_add_tail(&fb->io_list, &failed_read_list);
> +	spin_unlock_irqrestore(&failed_read_lock, flags);
> +}
> +
> +static void iomap_read_end_io(struct bio *bio)
> +{
> +	if (bio->bi_status) {
> +		struct iomap_failed_bio *fb = kzalloc_obj(*fb, GFP_ATOMIC);
> +
> +		if (fb) {
> +			fb->bio = bio;
> +			INIT_LIST_HEAD(&fb->io_list);
> +			iomap_fail_buffered_read(fb);
> +			return;
> +		}
> +	}
> +
> +	__iomap_read_end_io(bio);
> +}
> +
>  static void iomap_bio_submit_read(struct iomap_read_folio_ctx *ctx)
>  {
>  	struct bio *bio = ctx->read_ctx;
> 

