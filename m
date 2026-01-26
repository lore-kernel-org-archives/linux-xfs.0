Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C094A302151
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 11:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769427527; cv=none; b=iCO3h6ZGGb1nTz2GRX2x6RdOGYqkZxXt4xfzgw5jHFW/m1ED3xtc1eZn8J6QcHSw4ZqeN7F+lk5KOtwCNh9XN1Jn8r4RY6FfCEzzUcAvfZOxqtZtROEhCsX+zeg+nvrRRB2ECrt7ndTcEiS8pE0VW7+8K4UGyOMV4AhN6C4Y9jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769427527; c=relaxed/simple;
	bh=1uHeImTsp6sBfS6z2fR4NTz5MZQI5nrGvZIHDs2hZB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q6gI6ms6DE5PaQ4oBaiRmIOwDmtuU4UnaD2COwbWh2ZGx3M9x3gpnI+cjpz3GmVTLY04WgPSICb+nqrVAFLzR6qRADAT5ql0y8iuvVHCk23dGeYpI1P8FRGzqHlZCo/9SGNIH2SYLbSL5zupxUNDhzqNTUDMAg2ZyLz62g2jsGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Czz/MWR5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PSel6C4c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Czz/MWR5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PSel6C4c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769427524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4JuzNiza5HwpYpdBev/Gv0nk5c9jouzzFaS/rXxrFzM=;
	b=Czz/MWR5J+nE49yPrGWfz9AIEOiqAxDLtoYlDVNOhDhBywDCiC1f0+irEU5T1oDZKdLB99
	XFVlF/PM+J68Dq91YWeqZGWarB3L8Dw+0r/wJoESbLY7UUpJiN+dkHe4nhL9dDR6VA2oxT
	GqZUsrCg+yRt+vmxBq/knA/3kyjdYlE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-y6dTDpgBMv6KbV7OCbQOVg-1; Mon, 26 Jan 2026 06:38:43 -0500
X-MC-Unique: y6dTDpgBMv6KbV7OCbQOVg-1
X-Mimecast-MFC-AGG-ID: y6dTDpgBMv6KbV7OCbQOVg_1769427522
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b88389d69d7so385369366b.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 03:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769427521; x=1770032321; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4JuzNiza5HwpYpdBev/Gv0nk5c9jouzzFaS/rXxrFzM=;
        b=PSel6C4cUTO5kpDOzzw2+RKh1rj7UFgs3QMMxlzg6pLGk4pYj15v2Mn5VUR9Esg8tN
         oyrfLyY/KSNNa+qdqwa6kMSFyeOLjk1DKcVuPS13TGVADfRUw7fvahk4pobPz98UbVcy
         no0eJZ30IstOCNKjyjJmiCP55uhbWiRSoEvZSo44uEx1Z9rLxCNdqvxPSBS0jSjz8kH8
         Pq6M+iAUWlZMxUWAKRGPEPfCk5HQZH48tZss8K7nQveyVNKoya+AyIaQhuAETiH/FltO
         gLl+XXE+bautwoPHYPX8EP62mrbDyZOwsxIfVGiQBhYs1fhhnfHH/rAU/PQMjepXnBZk
         vUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769427521; x=1770032321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JuzNiza5HwpYpdBev/Gv0nk5c9jouzzFaS/rXxrFzM=;
        b=ER4OkEOYV2uXP6h4HNOIo+nNMrwTs5wSgh0mw9VBj8uGgDN417b1kiab+4DIbEpIvO
         snzFwrjHcfLPscYOZttt5RANpUGGmIEJLXAtuZgRwKFt3BdGKnBv2oUTKWozDB5E0eYF
         AGKs0UtZmAM/UTxVXwkYG5fZsX4QmrX19h3As223oQwJuINkqEZbvN2RDFVf2yg6WRNE
         jljuiQEDS2h9y73dUdld1l4wspPy7/ZEnHz2uAHx3LtPgPTWr7htzvb7ryDKqeuQ0q10
         DUDSHRUJ9UxVL6WluCLIyIZ0/QeoSrJAk9fbzB79uVrsU11PJxshC6Ls5u8/n6uU/fFE
         uRXA==
X-Forwarded-Encrypted: i=1; AJvYcCVCGgSRGaJMpgbyZ6JRhHdWOctY8zw9Wxufo7Dhf43Mq1UUXYu0Pr+5+8N07wPLTBqnSW6KCz6VL5o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaOsz7OO01Xc2KsYrtp5kYoQ7/01sFHGS4KPe0K/0ripE0AWst
	hpyU8rX+qNaV+4ChphFcgnqveqvbYJ6nunU5Hc9tmRDhgMl2OShNhFcU4Aa/39PzPC0/bdjDjxs
	m7U2CUXWeSibmdRypiGIxALW1PvVX+L+DzXpaVzDuiYQPzdhubi4PJ15cPCp7DtuDSDWS
X-Gm-Gg: AZuq6aLGBXepC10nqbDNUulgVNad6XJ4gcXhrmjUqqO107VkXl+ewbgbE4H07XwdC2c
	paA6T8r0aImo8gXICh9O3Q7vYLR/BZ8fyRBTGLp+qWfGMKQUqbutwXkHmrjjEkvoH9lzYxlFGPD
	/44ZWO9weNTtB6Om82wsvAeu2pUFP7tFbUlus97s2iuq+hGKMS+l3XQYN127A0ZwOz6E2ZYJcp8
	20BOhsValCfdi9mTHRvnXSVMGoESyQRhGA6+BJ3Z9tNK5Zo6PN/oPTnzF7OVVXUvQ6+ypZkMRn8
	78KQFqxIGJNZjOGh6REHfpDorWoIoTilGiBzgJwmm3AIhfg/Dfwjl3+PqQRwgccLe0OaUNYnuMU
	=
X-Received: by 2002:a17:906:6a0b:b0:b79:eba9:83b4 with SMTP id a640c23a62f3a-b8ceed585e1mr334869366b.6.1769427521191;
        Mon, 26 Jan 2026 03:38:41 -0800 (PST)
X-Received: by 2002:a17:906:6a0b:b0:b79:eba9:83b4 with SMTP id a640c23a62f3a-b8ceed585e1mr334867266b.6.1769427520658;
        Mon, 26 Jan 2026 03:38:40 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b885b3d9ae1sm622689466b.13.2026.01.26.03.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 03:38:40 -0800 (PST)
Date: Mon, 26 Jan 2026 12:38:09 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, 
	djwong@kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH v2 2/2] fsverity: add tracepoints
Message-ID: <fr5qdcfxeok2rjtiqwz7jibxccq7ntrczvfcnvv2g3avauljdo@lmzqhlnq3vox>
References: <20260119165644.2945008-1-aalbersh@kernel.org>
 <20260119165644.2945008-3-aalbersh@kernel.org>
 <20260121003917.GC12110@quark>
 <20260124184954.GC2762@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124184954.GC2762@quark>

On 2026-01-24 10:49:54, Eric Biggers wrote:
> [+Cc fsverity@lists.linux.dev]

ops, wrong autocomplete, thanks!

> 
> On Tue, Jan 20, 2026 at 04:39:17PM -0800, Eric Biggers wrote:
> > On Mon, Jan 19, 2026 at 05:56:43PM +0100, Andrey Albershteyn wrote:
> > [...]
> > > +	TP_printk("ino %lu data size %llu tree size %llu block size %u levels %u",
> > [...]
> > > +	TP_printk("ino %lu levels %d block_size %d tree_size %lld root_hash %s digest %s",
> > 
> > Would be nice to make these consistent.  3 of the parameters are the
> > same, but the naming and order differs slightly.
> > 
> > [...]
> > > +	TP_printk("ino %lu pos %lld merkle_blocksize %u",
> > > +		(unsigned long) __entry->ino,
> > > +		__entry->data_pos,
> > > +		__entry->block_size)
> > 
> > Likewise here.  So now we have "block size", "block_size", and
> > "merkle_blocksize", all for the same thing.
> > 
> > > +	TP_printk("ino %lu data_pos %llu hblock_idx %lu level %u hidx %u",
> > > +		(unsigned long) __entry->ino,
> > 
> > And here's data_pos as a %llu, whereas in the previous tracepoint it's
> > just pos as an %lld.
> > 
> > > +TRACE_EVENT(fsverity_verify_merkle_block,
> > > +	TP_PROTO(const struct inode *inode, unsigned long index,
> > > +		 unsigned int level, unsigned int hidx),
> > 
> > And the 'index' here is what the previous one calls 'hblock_idx'.
> > 
> > I think consistent naming would be helpful for people trying to use
> > these tracepoints.
> 
> Andrey, let me know if you're planning to send a new version with the
> naming cleaned up, or if I should do it in a follow-up patch instead.

I will send v2 with renames

-- 
- Andrey

