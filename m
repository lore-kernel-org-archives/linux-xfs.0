Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F451F5847
	for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 18:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763578535; cv=none; b=OYthb/bwkQ0GK9DbUbbVUnhLt5F0KPB/4wPF8GNLZUESfbpBL7jOD52tuxpXDpbpGglRUD4KqHqvJAsoIQ1AsSA59oLlFqw+Xs0C7j/gIj6JDXw4wnjTIamG6WdZ8GBD2gJE5G9e7oFgi3mEu8egJMjRSGBrZPl3pbSLVbjlQ2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763578535; c=relaxed/simple;
	bh=9v0djC3j4UdC0t5of+7eTF62EBu112vbh4SXSgoEENs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tV/ZdfcXo8cAynSunM+vDss7byMkEx6hhWaUY3ocbY1MGHqVVsr6u4mxAr7j5uOXIZp5161+AtoK2M8LuFN0KzniMJMKYjRiMcX/YwGx36u/4RSg9zdGBKXKoe/6ApROOKBRg19uubv55h5VAVxeRuMXZWYCv1MPTPk18Avl3sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f2y5Z6L+; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2y5Z6L+"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-298145fe27eso1090475ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 10:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763578525; x=1764183325; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=edQ3lAhPLjZZSk1oSVWuvnsvYz+DEp4d1vNMqDu5ED0=;
        b=f2y5Z6L+kLyXRojnbWggFSxJmrU6qFh1ngJsga7teH3sIzPOFpaUXpg6my3r1GrT+h
         QYedur5evNIqg2Q9FC+BucBax8qGGC+tHKqaePdntEt5rJICcdXWHGhIrdrw0Vxinfib
         UsZHYviIGIR/jalPnc6lFmmDRfn4Yw7RtANSccMlOUE/0p1zcjft94WLO3gasEFpcdKz
         spVFOXGglIrBITjPBrnX9qvOy2nNRcj3CYc8O8TZIt0uRAKuyzkKif2w0pCadaLeotbp
         DkWZ2V6FjT75381Hw4nTQ4KBgbE/C74XdsZLiziZ3oW5p6GxO6Hi55X4tvcwpkq+vTd9
         h/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763578525; x=1764183325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=edQ3lAhPLjZZSk1oSVWuvnsvYz+DEp4d1vNMqDu5ED0=;
        b=tpfpegUpDgOgrVVqtIkC3DGPyw5ybSB3SloU152AunIWZ/YT8po2digSJuU+ktmKUp
         jCA3MFFMUXiCb9JtcJLKBHnsoTF/Wb5xH+UTmU8tAcPJK5jQ90sUIHHAM0Gu6T4pQdNy
         ApebBh58uWZXf2Xwy/n5sSsJ8VbvhV7/cnK9VvMeaKGQcWrqViHE+oGPsI0Fz2VfBxhG
         1bmGtwnJaJThseuHzbypV9wJZlc4LRNy+Jfarn/afrwsIO/j9Blv8wvA67oKaDjfXDVu
         HDNpcQDBmji64fcxwkexMP4iaGoYqv4kXqjTz0FBkOP91DAhC1vEpOHGsi/8tnrP0Vj8
         GY7A==
X-Forwarded-Encrypted: i=1; AJvYcCUrbdL3TH8VpOf60PED0rvH38gfsjHowhVvBdeQblt9EHIjE5r3iYPWgIKJ8Ymw+Rhec9rZx0579jg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrxjQEYTb7dD7OLY1H5ei3r4od0xbRuQhjOrzBZ83nx8Hd76VW
	mqCmGrfm8xVl0y1hCSmw4owyuFuikGb7+5ZAV7tzXSL1I0SsD5vNJk5/
X-Gm-Gg: ASbGncucMOeW6o2BjnOxgoXqztrpsf9TbkUT361p6oNMauSR/hzFeEEeyKZBTGUJ2LS
	DEqzwcI2avYenHNsBwoTxlV4mWf4Vhf3rlOIiJZnpreAMKuPATk1qXIeGmwdE1HEKRcFaookKTU
	NuAwjJ1FctTuPBVe+tRu28uyO6LqRvWyJW4znU7++a1tlMseTZxjrJhJym6wbJej3HI52atJAp7
	7QhOBfSSkQ4R8jUJerpZQsrRVIver+ahInnIu2tmDy5lrZ9pp7RkGH1C/mCSW56BKAq205OU3N+
	HCgJzpWpNyqr1RVRc7C2btYVj+bFO10WdYhJ4MGqQeuONazYioe7J87Bwh9M+jnQBHZ/1Drc7Wm
	isIRLXnh6jXnqUPJMsSaCWKyLk6hMWo7qycffU48UweHZ3QEPS8AJA5UE7PCrsF6iWlH9ADkhA4
	9zWPrXDKRdqQpZlQ9/zznOMib53bx1bVQwGmiNldkbMFc=
X-Google-Smtp-Source: AGHT+IGBQeqSMvGoivhKypewRSEuuSGzQM6EQybj3ad+ID5hnktZP2Z/3EF+i6z/IdXkB6hPA0OLmA==
X-Received: by 2002:a05:7022:1e11:b0:119:e56b:c754 with SMTP id a92af1059eb24-11c9387cf19mr128055c88.25.1763578524596;
        Wed, 19 Nov 2025 10:55:24 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e3e945sm323775c88.6.2025.11.19.10.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 10:55:23 -0800 (PST)
Date: Wed, 19 Nov 2025 10:55:21 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Cc: Biju Das <biju.das.jz@bp.renesas.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"urezki@gmail.com" <urezki@gmail.com>
Subject: Re: [PATCH v3 0/4] make vmalloc gfp flags usage more apparent
Message-ID: <aR4SmclGax8584IJ@fedora>
References: <TY3PR01MB11346E8536B69E11A9A9DAB0886D6A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <aRyn7Ibaqa5rlHHx@fedora>
 <aRzPqYfXc6mtR1U9@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRzPqYfXc6mtR1U9@casper.infradead.org>

On Tue, Nov 18, 2025 at 07:57:29PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 18, 2025 at 09:07:56AM -0800, Vishal Moola (Oracle) wrote:
> > On Tue, Nov 18, 2025 at 04:14:01PM +0000, Biju Das wrote:
> > > Hi All,
> > > 
> > > I get below warning with today's next. Can you please suggest how to fix this warning?
> > 
> > Thanks Biju. This has been fixed and will be in whenever Andrews tree
> > gets merged again.
> 
> I see:
> 
> Unexpected gfp: 0x1000000 (__GFP_NOLOCKDEP). Fixing up to gfp: 0x2dc0 (GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN). Fix your code!
> 
> I suspect __GFP_NOLOCKDEP should also be permitted by vmalloc.

As far as I can tell, theres only 1 caller of this.
Christoph started using vmalloc for this xfs call in commit
e2874632a621 ("xfs: use vmalloc instead of vm_map_area for buffer backing memory").

Looks like xfs uses the flag to prevent false positives. Do
we want to continue this? If so, I'll send a patch adding the flag to
the whitelist.
