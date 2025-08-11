Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1CF202C3A
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 18:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936311; cv=none; b=b8X5QqyBUOI3QJgM4p+BaQagh2lWlgWIfs2hXG+SOIVSRRrDZuZZGFoTAwEe47jbnuU3c4m3zhuptmGp57i8Novlr2flD/lmzUkFTNKb9xUoYNswj/UzQoejGxVQo5BHK4k2yNvosElbrmnvLDE5qcbE21qhsPDAhOxQolR3vpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936311; c=relaxed/simple;
	bh=278LB+F/JpYWyp3Scr9ING3NFA9Kzch6L8LJO3c2y5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fc0g1gWLBDPR06gB31UbXbreGfa29BMEuBY0Bncb385PpRtrJACBOGzGTRrwbvUNLRtI0wydCH1zT2oKQkRJCJRAgifloEaiks5n/jDQLbq7QRI59dHbgMLfUfLxJNIHQcfRibuL0fFzUKi79GqzDAQ5G6L5sxK/ZvDY1ankyFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EBBoVssR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EBBoVssR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754936308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lAD+rf/CTMK9ZczcWk4uX22kkA50cFqnLejY2P0NP4k=;
	b=EBBoVssRgs3PeV9HtZIBaUVlM8syNaeRd+ETtXA90XSkrFYMO50W90ewzcZjSPoXpku3LG
	ylp0dxskOnJmCMhkcRyi5i6/3WJ9QsBbQ/oI4rlb1NKu8dYbl0gpmaXefbq3K5aiCz8JQB
	lrGvBH3ey53iqbR0pXveKdmZEBGJolQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-K25-d3ChPO2IyMkFqdXaKw-1; Mon, 11 Aug 2025 14:18:27 -0400
X-MC-Unique: K25-d3ChPO2IyMkFqdXaKw-1
X-Mimecast-MFC-AGG-ID: K25-d3ChPO2IyMkFqdXaKw_1754936306
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a09c08999so8429215e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 11:18:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754936306; x=1755541106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAD+rf/CTMK9ZczcWk4uX22kkA50cFqnLejY2P0NP4k=;
        b=iQ566EzH7PJFwKxLCXl0b+NA7VslMtxC9in313C0qPTaC/cn6ZW7wG2RW8it6TgGTL
         mc//Jgidr2b2hCAdrrVH6/n0PGHHaiXiYRV6rDOipUPbdqneeRf5ll94O5GyzTKP4xv2
         LHgqCORlb4+jwlD0oJ1PJLUAZN5vxzWDVzEzxIG/FqtnH9JYNx24TMZmotSpJO1Vf3Ox
         xcPh5cEzGAoVAMOemnNmQwP9l/T9gOYPPDfsHD3jOZvmsSNFwC0H/7jeI9g5Jl7GY06N
         wwBiJjwSEzPIh6m+WlGZ58ISZFi2TGl4cLbXJib73h3BIJNhUvUlCF4ArC1xzaAWuvNy
         l4TA==
X-Forwarded-Encrypted: i=1; AJvYcCU282eHPGiGJciDtt8EX5leP3s1a2MA9/i04xuIyrCN7dzY7MG9RyFgpHCZQz74GoYTn5RXFFFQF9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwD3Y3eEHW4oKMaVQGjID9jG7bdhvLke0SNCdQdhW80MZnd8vjm
	6nm/MybNwS4KoIdalx2NqFq6NrFdTRTcgMVL3gZyTwzAEQYPEUh3r4i4Am7oyHezMjhIg5kYfPa
	sOkSfSaysXEIt0zGqwar5DN/okD5pszMIkoFgi9Q9HuyjQygOiXBYqPq240Pj
X-Gm-Gg: ASbGncv8VvX+GxSfa0mBd1eu6QLzRUqZR5Q8WOCUZCr6Mdi24Bzbu9kH7ZMD1stmS1s
	2HnLeE6Jb/A9VioMA5/PVZhRI10pjucuUaeh2ZL2wxwydDT1LWw505twbLgWdFdKjtHpEMPN8nw
	HWr5rc7p6dDo47yJH7BrW8BTg0MPdtrESGr9cmcfnMr3dYDYD8lOPIB+clBArONzqoazpN7Gp3L
	ZyAdxx88Hz7wXx21+yd9ZAMxus1ciJd86GE9XJaHeAOaT0dtvN/oP245NbGvBLjjAFmWjzIUznF
	Djndmj+37JbMJmVqmuhqQDem0FtCUlLjqTvWESMB+03z0cLwTg86SFoGFVg=
X-Received: by 2002:a05:600c:1c90:b0:456:2a9:f815 with SMTP id 5b1f17b1804b1-45a10b941ddmr7145945e9.4.1754936306149;
        Mon, 11 Aug 2025 11:18:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6y7tsIn2G/sy6tsYCOF6OgvujdY/Mg5JcoMXvxNskFgP3OG39fmK1x2ARU5f0kEII7yPZbg==
X-Received: by 2002:a05:600c:1c90:b0:456:2a9:f815 with SMTP id 5b1f17b1804b1-45a10b941ddmr7145785e9.4.1754936305759;
        Mon, 11 Aug 2025 11:18:25 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c453aeasm43024090f8f.40.2025.08.11.11.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 11:18:25 -0700 (PDT)
Date: Mon, 11 Aug 2025 20:18:24 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 2/3] generic: introduce test to test
 file_getattr/file_setattr syscalls
Message-ID: <ydu5kha77suh2sn4jmyh4xxj2eiw3g72qvf3b7hy2k5xoh33eu@2vconk3marrs>
References: <20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org>
 <20250808-xattrat-syscall-v1-2-6a09c4f37f10@kernel.org>
 <20250811175541.nbvwyy76zulslgnq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811175541.nbvwyy76zulslgnq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On 2025-08-12 01:55:41, Zorro Lang wrote:
> On Fri, Aug 08, 2025 at 09:31:57PM +0200, Andrey Albershteyn wrote:
> > Add a test to test basic functionality of file_getattr() and
> > file_setattr() syscalls. Most of the work is done in file_attr
> > utility.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  tests/generic/2000     | 113 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/2000.out |  37 ++++++++++++++++
> >  2 files changed, 150 insertions(+)
> > 
> > diff --git a/tests/generic/2000 b/tests/generic/2000
> > new file mode 100755
> > index 000000000000..b4410628c241
> > --- /dev/null
> > +++ b/tests/generic/2000
> > @@ -0,0 +1,113 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Red Hat Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 2000
> > +#
> > +# Test file_getattr/file_setattr syscalls
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto
> > +
> > +# Import common functions.
> > +# . ./common/filter
> > +
> > +_wants_kernel_commit xxxxxxxxxxx \
> > +	"fs: introduce file_getattr and file_setattr syscalls"
> 
> As this's a new feature test, I'm wondering if we should use a _require_
> function to check if current kernel and FSTYP supports file_set/getattr
> syscalls, and _notrun if it's not supported, rather than fail the test.

hmm, I don't see where _require_function is defined

Anyway, the _notrun makes more sense, I will look into what to check
for to skip this one if it's not supported

-- 
- Andrey

