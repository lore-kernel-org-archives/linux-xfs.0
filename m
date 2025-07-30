Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C1778F4E
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753890145; cv=none; b=cDE/4ZAS5vQOSb7ruZ1cKmknoB1jVM6Wk93sl8aXhIIsmU/DCRAnFBfPlwVeMWa/THZiNAUz+8IETKuoiebk7E58zNumIvI9TK4zXTp+V4ssJ0b4AOvZV2d3fZcizJyTbxVhxdH1TyOUXnEJbpIfWC9XiMgX4hZG+EnIqngkcr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753890145; c=relaxed/simple;
	bh=iJgN5YVEDqKpkOaGo4RN/Jmggnqhu375DswQEmw5eNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8eZXcdef8YXZ7P3T4v2Oh4TJ5hqFjJDYq68NN7Av3ubJ9Nvh6Z3voLUXElvm5ELbbYQPzL64SmOzYMbePiMnyBBf5oGuQjDy4NZUGx0yEAHcYN86+ZwI52vVswy5QUItjGB4zYbJeXZ96N46lHfhTnG4TYbpigKI3HT7QAkoos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gbZ6NB1y; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gbZ6NB1y"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4563cfac2d2so69513975e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 08:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753890142; x=1754494942; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iJgN5YVEDqKpkOaGo4RN/Jmggnqhu375DswQEmw5eNo=;
        b=gbZ6NB1yItijvcMweKcRYPo44B5Jgl4REzAg6MZZCbvV9OrsH4Xkni9ndJL9nFQlKj
         fu4lBLC3awws6d2su35R0+mPW8CnmIiD8j5Pghv2/K+D1c1hhDt/jT1PIWDeRv82XjX+
         BwPuHN+RgE8jD9R8sEEqX9VkGvJIrHN3vjlr5lnfWWr7mPk1car3t7YPVyjpRjNqCk1e
         ea2OapyLeM349F9YDa4yaI8/fHvpQvS4brF5SxLrmIN+YB91MhFPrbStqY0Y5v2hZTEQ
         Kz2A4FCUhRmn9Pd0pUfEiTrUjm5AK46KWnU6rVMUTY8uKbYHMophAEDE8I/QJubG/XWa
         Xeew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753890142; x=1754494942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJgN5YVEDqKpkOaGo4RN/Jmggnqhu375DswQEmw5eNo=;
        b=J4+PcWiqSt0CbBJoXaSSI9lLs29b5JUiKhsz7XBVfMFqzpZrZy6h4pmeyaL/rzrMlE
         YYVvJHj4TP8s2n5/m/Y3nYOxtA0ST41B+aXJH/Pn++AqW711feGEFD5WHD3RcmtHl914
         Qj363S0bv7NB3+2xrZx30wPQH5txZn+iVrMNx2zQ3iVoUdEA/thM4Vhaf1yk0b4mpUX0
         Xh+r0bN3gTaq9Fk+RGGzWOXL2tpuVYvXdaS3NLVGLziM52AiOztP+g5+CC+d2lfCQ64W
         XdBQnI7Tl64nJfUmN6Q1ZKxGRBN9E6AMswqg0+yyezl0FI5v2ObSETaokCS0S1XX0dlo
         hy4Q==
X-Gm-Message-State: AOJu0YxFUyBbmvy61b3ctZ1Cm4VbGFMTfPibFp3ttgGXMfp+1dVRkVXU
	WhaJMciD+xOp46DwA03BQe3MsGtLnpD+MKC00zsPQASCkRaG4ILmENre
X-Gm-Gg: ASbGncunbKMCq5wmc+yh3KnIfM/NFxGsq3fsEqKYdw37/LUkE76SIgfAg2ccLnm7rTg
	5DQ1wt7uhgsWumMIOFXWLJo4UbwdWIFw0Xpsb5ov9pPfETqQ4PPPcRe5JinQSpZ2E8RvRmgQsUf
	ELWrfxf+NHIHRFYz9Relj40cZaR4BuT437/i0BFRu+Ofb8EnyhU8J0fcCOfwHRlaB8trFq5l5ER
	69tlTHK/aKOQ68rMKCSe8uG5VQ0cuuH/c+K2mwUiaGnBp94lMmdzbdnhywd29tXwd/R1CiTpuNW
	Erz97TICqeEQGR/MsmUwDlyUHiO2ma4BAxBqe0mUzTDzZkT77VPcPnoGSyLQiczMrZ50J73EDE9
	wQceHiC8KJLT9eR3j2Pw2YDxQTvgvTyUH+Dv9JQ2IGgw3r82vJQ7Q5sgcAcrPNHfuQ5jMVw==
X-Google-Smtp-Source: AGHT+IFypeUsBdfxtoMLe1aDSV4K6WCSwfkqXhEAbRNvOCu70CgsjWJ8BLqLovuivfteZXHP0hFTRA==
X-Received: by 2002:a05:600c:3145:b0:453:81a:2f3f with SMTP id 5b1f17b1804b1-45892bed97emr37933835e9.30.1753890141946;
        Wed, 30 Jul 2025 08:42:21 -0700 (PDT)
Received: from framework13 (93-44-110-195.ip96.fastwebnet.it. [93.44.110.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953cfeaesm35400975e9.16.2025.07.30.08.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 08:42:21 -0700 (PDT)
Date: Wed, 30 Jul 2025 17:42:19 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v11 1/1] proto: add ability to populate a filesystem from
 a directory
Message-ID: <6xaype7bpxgfsdnooc7qphwzigmk4mu2ov3kxcpoofkdz64vvh@2vn4xf5jam42>
References: <20250728152919.654513-2-luca.dimaio1@gmail.com>
 <20250728152919.654513-4-luca.dimaio1@gmail.com>
 <20250729214322.GH2672049@frogsfrogsfrogs>
 <bowzj7lobz6tv73swiauishctrryozcwqmqyeqck65o2qjyt5v@vufmu67nwlkc>
 <20250730150409.GG2672070@frogsfrogsfrogs>
 <an4uufrp4vk4bqs4zpvver7sodqn3i2gtx5rjp5336jlylmmhk@bchzcckwdlfr>
 <20250730152652.GS2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730152652.GS2672049@frogsfrogsfrogs>

On Wed, Jul 30, 2025 at 08:26:52AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 30, 2025 at 05:20:42PM +0200, Luca Di Maio wrote:
> > On Wed, Jul 30, 2025 at 08:04:09AM -0700, Darrick J. Wong wrote:
> > > On Wed, Jul 30, 2025 at 04:40:39PM +0200, Luca Di Maio wrote:
> > > > Thanks Darrick for the review!
> > > > Sorry again for this indentation mess, I'm going to basically align all
> > > > function arguments and all the top-function declarations
> > > > I was a bit confused because elsewhere in the code is not like that so
> > > > it's a bit difficult to infere
> > > >
> > > > Offtopic: maybe we could also introduce an editorconfig setup? so that
> > > > all various editors will be correctly set to see the tabs/spaces as
> > > > needed (https://editorconfig.org/)
> > >
> > > Hrmm, that /would/ be useful.
> > >
> >
> > Nice, will try to put something together for a future patch
>
> Either that or a indent/clang-format wrapper?

Yes that is what I was thinking, there should be the option to create
custom formatting rules, and stick with those, ideally with a pre-commit
hook

> The kernel has scripts/Lindent, maybe someone should try to write one
> for xfs style if I don't get to it first.

I'm unfamiliar with those, I'll try to check them in the next
days/weeks

L.
