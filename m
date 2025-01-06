Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA67278F4F
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 20:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736197018; cv=none; b=olzovF5za+hgE2R3iLM1Vk9MB6QHesu7Bee2ps3oMCjfH0hmDqFUAKN/XBLg5nXZrG1D2lRlzw0xuEPcLgcJoF7IeqMY8Kezgg2PnBuq6+xSKDQqzp1nHOWL74SPzNTyWWdZu6hVYUSr+I4jEhKW1Gj3k3v8uJmsuoGdMJW8vnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736197018; c=relaxed/simple;
	bh=/2FXF11MckGjsJj5ezJMIUNifrIKdoRDA82loIhYCCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NrWXslK51KszCOrqto8z2EaPbt8CStW47KFf5Zr5OcTHhq8LsMe4G8/eCMjI6R/rCMIixXWf/mkSjDnGEtjyKEiCLPkl6v7BZbD3XqJYo6W69gfcSnLi3qdVS8j2NTonuS5Hyyww2GF0RSD1YJpVTIbAJYFRvXIhm2TAiCUdU1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HCRG4UPd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HCRG4UPd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736197015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IRiBz9/A9TMmeA2kjXv6FyrilNbAlAl3NYaUdBnt124=;
	b=HCRG4UPdij6izVJ0r08v1PkRmdyXRfn3T1d4DR74L0x1PGn5OS9GP3jK8tjaDxAjNuDR+h
	+u0dbX0Y/ONPZkmXTUyxnCDeQ0yhD7zD4Bjw3teHlj9zDq//n3fz75O8pCyPnizhEOIXZ1
	n5ZrgiWh4ega0Hb4AbCJCnIwQ627wGQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-_4Z5H5JlO6yC9XCoPA4SIQ-1; Mon, 06 Jan 2025 15:56:54 -0500
X-MC-Unique: _4Z5H5JlO6yC9XCoPA4SIQ-1
X-Mimecast-MFC-AGG-ID: _4Z5H5JlO6yC9XCoPA4SIQ
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-436379713baso71910665e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jan 2025 12:56:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736197013; x=1736801813;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRiBz9/A9TMmeA2kjXv6FyrilNbAlAl3NYaUdBnt124=;
        b=SPsxMr1Va1AnJGgk5bQ5dX4NE/HfYMAnL2c3EPs+HQCMThpFA2Vob4dZNiolPO5Vjg
         hHQtzpa5HCmRLPRuAqP0Ff3dssV4NsNBMNEMvWuY5KlAHvNAJHxmszaB5QYFV48a0BHM
         JQwkOgmHtE1KsS65wPAj8NmV1c0X07WtOx1VKTx0bHUqY7PgT0+45pvkCtH2QtF1klLf
         nW0L820BXhl8Er9KiRlJ++/sajug8h5IlY4d+yL4YBS7rIQjY+G61+T8b2xf7/CbgKwJ
         Yn2EKvi9c0ThlqScEKUaunNsEd2p7g8SGM3wiYz3ATaLGOwxPfHg9hTcDFjIceQgD7SZ
         8eQA==
X-Gm-Message-State: AOJu0YzFqlArDUf6jFZXR7INatrDRlZ2DqrHdqQY079n49t+PoWxP4AT
	/bDPXxm/SB9Z9z5UCHYS+SKEeU9zOOd1nQF3ava2PwYw+x3P+x0EBoGONz69k/DPF0T1HQeCQAk
	rLJVUrP3v08AMjhHWBTJQ2I3AFXFZOE2EFphdet//Bid0qqIyS2I+AahOIoeipk5C
X-Gm-Gg: ASbGncvt/WPLcBxm00MjIKLAOAu5gfi3lUiMzOPybbmsOxw2btQF8sZ5IjpQRX4XR6A
	RFsHMM3TeshChs5pCEE12g57Nk4p30jnCOXxPGa4SF+g5dyWpoeYlJUKBlbbO2dZ60CpT7hJAoj
	i0hAEqGR8oUVqO3aWGLBQ40JmP4P7Ftf4tdbC6cIzol0TYqMgp2FIRuLchkfXR//oW1nHJkMtTa
	fidKPTYkxwhzEbySkR3CGWaRSS8+fYOYmxWOscuJv1lwd0VRvzYlZv2JHFJJ5i3CLwaE6L6+EJq
X-Received: by 2002:a5d:59ab:0:b0:385:ed20:3be2 with SMTP id ffacd0b85a97d-38a223fd422mr53893625f8f.48.1736197012919;
        Mon, 06 Jan 2025 12:56:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHrZOAG2IIaJebkjwZyeFOdqION8za8ShH7IDTY5duWeITW3n+LENwAcQX/DL9MudLOsOwmYA==
X-Received: by 2002:a5d:59ab:0:b0:385:ed20:3be2 with SMTP id ffacd0b85a97d-38a223fd422mr53893615f8f.48.1736197012583;
        Mon, 06 Jan 2025 12:56:52 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8475d9sm48538562f8f.56.2025.01.06.12.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 12:56:52 -0800 (PST)
Date: Mon, 6 Jan 2025 21:56:51 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, david@fromorbit.com, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC] Directly mapped xattr data & fs-verity
Message-ID: <prijdbxigrvzr5xsjviohbkb3gjzrans6yqzygncqrwdacfhcu@lhc3vtgd6ecw>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20250106154212.GA27933@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106154212.GA27933@lst.de>

On 2025-01-06 16:42:12, Christoph Hellwig wrote:
> I've not looked in details through the entire series, but I still find
> all the churn for trying to force fsverity into xattrs very counter
> productive, or in fact wrong.

Have you checked
	[PATCH] xfs: direct mapped xattrs design documentation [1]?
It has more detailed argumentation of this approach.

[1]: https://lore.kernel.org/linux-xfs/20250106154212.GA27933@lst.de/T/#m412549e0f3b6671a3bb9f1cb1c0967d504c06ef4

> 
> xattrs are for relatively small variable sized items where each item
> has it's own name.

Probably, but now I'm not sure that this is what I see, xattrs have
the whole dabtree to address all the attributes and there's
infrastructure to have quite a lot of pretty huge attributes.

Taking 1T file we will have about 1908 4k merkle tree blocks ~8Mb,
in comparison to file size, I see it as a pretty small set of
metadata.

> fsverity has been designed to be stored beyond
> i_size inside the file.

I think the only requirement coming from fs-verity in this regard is
that Merkle blocks are stored in Pages. This allows for PG_Checked
optimization. Otherwise, I think it doesn't really care where the
data comes from or where it is.

> We're creating a lot of overhead for trying
> to map fsverity to an underlying storage concept that does not fit it
> will.  As fsverity protected files can't be written to there is no
> chance of confusing fsverity blocks with post-EOF preallocation.

Yes, that's one of the arguments in the design doc, we can possibly
use it for mutable files in future. Not sure how feasible it is with
post-EOF approach.

Regarding code overhead, I don't think it's that much. iomap
interface could be used by any filesystem to read tree from post
eof/anywhere else via ->iomap_begin. The directly mapped attribute
data is a change of leaf format. Then, the fs-verity patchset
itself isn't that huge. But yeah, this's probably more changes than
post i_size.

> 
> So please try to implement it just using the normal post-i_size blocks
> and everything will become a lot simpler and cleaner even if the concept
> of metadata beyond EOF might sound revolting (it still does to me to
> some extent)
> 

I don't really see the advantage or much difference of storing
fs-verity post-i_size. Dedicating post-i_size space to fs-verity
dosn't seem to be much different from changing xattr format to align
with fs blocks, to me.

-- 
- Andrey

