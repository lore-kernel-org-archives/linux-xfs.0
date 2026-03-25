Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA833D1CAE
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 11:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774438890; cv=none; b=cA9rorW0pWCQGUoAyxqs86JmAaQ4O8lsrKEmfRE8hXKDAvm4xeBgQzZvbqELeHkrQMYqidLKFIDZ/jtrXNLQDOF3z8Sgb8N4KbFmu8u6e7fa6IGc0uT4YooaC5nSPWgQ2gyNvgnMVlp9uNm5cweOY3mx5J/qZwQrq1Z7BH7mWCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774438890; c=relaxed/simple;
	bh=ld1uLQcQ3wX/aLoEZ5yp05fFuiyLeeDey5H16fj3er4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOehyJOraVJFK+N+lGLzoF9vI5J0MsV8ZTmJPuJMSOb6FNFfbR/Ga1oXBj24qIewMFbOqyYbjeXPmHs+occ7D5cv69Flkt1A5WLYw8JjrH3jWWrUc/HH38moQFcyMbQ10+W4IbWKC75qUmxG0uT3IUYoRWIXztoou6pzEy2SbRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UpeHMCGI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wtu0JiVD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UpeHMCGI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wtu0JiVD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774438888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1xEylKt1sFxQZZ3xBGKJ8RdOSFC0up8CAh1cSzczQVQ=;
	b=UpeHMCGI0OWvsjQMOVzzC4cLslpISysz/kVkR/sZ7aKRK3Sh4CIQRuKbRBB9zDIf5djghI
	5gzo+6rmKZK4xGgR1i2MABBpJQAHMG6hIDNnXIpLSCgvbl++AercDjnevy0+7HE/vcva5W
	QpIuhJAqQfecAPQApahcjNHWSfc1wQQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-rSj0bJ29PL-keuqVUhshiA-1; Wed, 25 Mar 2026 07:41:26 -0400
X-MC-Unique: rSj0bJ29PL-keuqVUhshiA-1
X-Mimecast-MFC-AGG-ID: rSj0bJ29PL-keuqVUhshiA_1774438885
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-439c54e0f6aso652399f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 04:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774438885; x=1775043685; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1xEylKt1sFxQZZ3xBGKJ8RdOSFC0up8CAh1cSzczQVQ=;
        b=Wtu0JiVD+ZOnT8ETY7g0l1DNXcvTd6DywMQLr7hyIW1CO08TGRi+GNMzqixlDsdJRn
         evo01Jx/JvjGV2xcuVSPl8G8gzr8uDz5BV7BI06o9xCV7hU0tIijYgduj7dnV7gqb33W
         HMIDfexok6vAjCZ4n7eyruOrA+GKKYec8uV1he8WsbyeA8hIkiWSoNsVs+iQcmOyby4A
         XKHmYnkZoa/MRTLcfWGONxYkUnaM/+7s5cqgNsC+ZoQxS4/JHwDHea9xQA/URDgwvPH2
         p1P/ocOm+ERXwthsQV2plkzwM2cUJuEJW/cYgPFL43T+fZu8rqYjt6oVfx0vN1yR9e5F
         Bmzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774438885; x=1775043685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xEylKt1sFxQZZ3xBGKJ8RdOSFC0up8CAh1cSzczQVQ=;
        b=eNXOwZeSv2K1SXIEsP9AUSwIusF6GwDdGyQGXhJ2673/QlTv4pupKsTQ4tUUNXp39G
         STJ4l6NC942WX1d1qYqe/lHziU7RgKTPmnJB2NfeTYUL9JK9SYep5yKXQkilP89D8puh
         SKjo4Fhe5JLTS8NZDMlgRUWrW1KzNCRGEaGEgEz2qGaEfNog5r67iMOnti59MVQedE2A
         2Fg1rc3vH1Oi1Sd6MGdG7+fJAjvCLqbsPZclrsO0xpDsKwzL0MDPmVzAAw5RBd954OoE
         Spo6esEy+v4b6UYMCypYodg1AQojxiVsK3kowTni41HBMkVTgwM8x6QBFYQXVja7Dki8
         YNHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKySAR8R2SVEGR++W1EMLUZM3u5t/2hmIAhK8XaxwUyB1HoD0aKEI6aGqc7fPqxCsYFQ4RDWhzHsk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIZRQYlF38OD8ACGD5iaz8km5RKwNjuhs+V+O2PpN7WD9+T1mo
	apoUX+bjNPtHXZyEjgLBB/cM8Uv3Xyzx1+4DCpfW59lGYplAFdyhJCLxFxUL7eWfFMP/DA5UF7U
	Se4qfioRb2oBZpLesWbcU9YM8Tx2jcAekvNEfLxoraVy/JtPT28sQ4bBlmTW9
X-Gm-Gg: ATEYQzzlbPFAE5YOEkg7wXJwsJ8yKqG9X8V6AbRhtcMBo1ZFCd+s8Eqq7FlKko0B3CU
	b7Ao2STLZLOJSPiwf2H4VndH5IGUkYCQ7K/x9fa7LKmF+eb3Tk2JrbGVbmVB9PD85mz29wTc4WI
	xpXex4+3AMTaU7Ipuf0EarlM5wazWNtIKEj0bPReXnSnpU6bQRQ3HXWJjlf8owVi0b0RmnFvB5g
	JP6awGotZiZtGvXYn89/U2OMnxzfj4Zfnq9fciTBVcZJ/yZnwGn6B4IPopfmmh48GK/iYGOBKG0
	Qj3XfWPTJx9QG2+7SIOFwCYRu0lyj/hA7GrfROpojcwBs9+qGSt1HgGV3p0Ev1dlhzihV3kEYzV
	xYysJ7jP6N/BaXw==
X-Received: by 2002:a05:6000:2a09:b0:43b:425b:ec3f with SMTP id ffacd0b85a97d-43b80526465mr7202977f8f.4.1774438885306;
        Wed, 25 Mar 2026 04:41:25 -0700 (PDT)
X-Received: by 2002:a05:6000:2a09:b0:43b:425b:ec3f with SMTP id ffacd0b85a97d-43b80526465mr7202929f8f.4.1774438884770;
        Wed, 25 Mar 2026 04:41:24 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6470c239sm46289550f8f.27.2026.03.25.04.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 04:41:24 -0700 (PDT)
Date: Wed, 25 Mar 2026 12:41:23 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 01/25] fsverity: report validation errors through
 fserror to fsnotify
Message-ID: <3lllvimldwcgi7crh3kgwy3a5z2ng2ugcka52ab47o5mwx4dnu@xyzbelhykn7n>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
 <20260319170231.1455553-2-aalbersh@kernel.org>
 <20260325075402.GA952@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325075402.GA952@lst.de>

On 2026-03-25 08:54:02, Christoph Hellwig wrote:
> On Thu, Mar 19, 2026 at 06:01:48PM +0100, Andrey Albershteyn wrote:
> > Reported verification errors to fsnotify through recently added fserror
> > interface.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Thanks!

> 
> Btw, would it make sense to enhance the interface to tell why the
> data vs considered lost?  i.e. checksum failure vs

> (part of) device disappeared?

isn't it something filesystem should report even before fsverity
gets the page?

-- 
- Andrey

