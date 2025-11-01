Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592BC3F9FB
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 16:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762014177; cv=none; b=b2TNQO/gAPWKmcOcVRShd93UEJT+E9oodTe4qLA8vhMGHNRzHg7U6tmDt2rQQOQRsNcAS5sDrhZpAqHTyIgzIMUKpWqUrcR73eF39TOUs0UEXnwVVfKqXuT6skfcqYfjxOCGP0QwNEwOI+vLQv5U78ZVfXdCAjOyY8Xdr3SUwEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762014177; c=relaxed/simple;
	bh=e6mlkJR9aMFC9ANHE6QjA198w/jqNaOS+rF/2oxxq1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0T0T78Di0aIvyPtoA2eCJVuSvWGoFWmmwpeiEMG+t9XYzgeqKkWFdTpsGubQzqWDGCokCeyyFZrZR8tr6T3UNdbvMaxEi9cpzvR3/KWxnm2kw5caAqILjQdygeuqto1pa8BEBDJYwFhdNcnicfWb96VB2KO1AX8MnZi2UDYb90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dphqOCRr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BWaUzqEX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dphqOCRr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BWaUzqEX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762014174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QLqxICTjnbrsU3SYP49qwWUOxqba/4I+LS+XC/NNGv4=;
	b=dphqOCRrVgbqwd7bLxR5UAmYSF8QPQgacQ6fLNtmZusdUmKkYJNxmatE9TZR0W2Ue1phY0
	z9fKtuFzNAYrdkTHEQIFDTmmc34dREe6lximSG2ck8MU2gD5N4C7Xtu2BhkV5mJhLt361B
	nmqj9FmrVETOQaPNbnalvBuddEdHAnw=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-wLJVUUMjMGKuFYG3YS9Hrg-1; Sat, 01 Nov 2025 12:22:52 -0400
X-MC-Unique: wLJVUUMjMGKuFYG3YS9Hrg-1
X-Mimecast-MFC-AGG-ID: wLJVUUMjMGKuFYG3YS9Hrg_1762014172
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso3066140b3a.2
        for <linux-xfs@vger.kernel.org>; Sat, 01 Nov 2025 09:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762014171; x=1762618971; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QLqxICTjnbrsU3SYP49qwWUOxqba/4I+LS+XC/NNGv4=;
        b=BWaUzqEX/otwJymDhE8Vb3cvODodERZD9P6W0IdebUvDZLwD0YG8Zij++YnWMzuRAO
         vyW/xZteE6ezi9JqZpekho1uDGhYYftwrlG1BxEgtMGLnPtPMS85LY5ubKwyImcbOQOC
         XUUy4XBu9gMdaRajU2zKgIQ0LLK5k8IsNLwial3YcSsOpbVzxA8yUlpbETa90utD20Dh
         L9C+XMmsP+7KJhOj8fBSzhwuHPlW3q8DgTpfRFPaWpwBd0RwvFdmSWvx51GOfoaKE+v7
         OZj+yyto8PY6LoXE7z8Ej/1nWVvlHzWYD0JcUVJsc18xVMFzhbXODAT25i+feyPSu0UI
         AGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762014171; x=1762618971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QLqxICTjnbrsU3SYP49qwWUOxqba/4I+LS+XC/NNGv4=;
        b=OQczpSaqDrH/yUJfuPvCsVUd4SVBHgUqGWnLYVI3E3HQobevohd962JzrkaIl3DPMv
         y+aMM01f9HhzCcKW5prNL3sY8SKHLKTbkGF3i8erQifQpZoEDBfValcrWcUCxu0mOAB9
         26NVcDVvaLFclC/RtX40Vv5kOSg3iAOYEW0WyBbvE0Ebfvs8h8uLYY7RjsLZLjqZ2XIv
         T7q6kGHH4x2OYFcDjs0ylLgTjKsW7DXK31vyeCJ7MLVzjubbSCwVvdw+1UndflLZgNl2
         dcMi9+Mde9YSdEDgeKfwOYtKLkEpXodLuV7hCeVgl+j9kbA/8l7nUnkz8IZETXBivwY9
         lCjw==
X-Forwarded-Encrypted: i=1; AJvYcCXlJlRglf/2UCOdduuxeWH39iciRPaG4hnL4ucGsdUFgppYK3RkDZUjUf7auXNSJBHUv03AjpFyEWE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzw2iBgbEnq5hPf8PcNOMsGjr4Tmj7WalIPHltWgMcz2wCsBdx
	AoOBRoaIIwHBoLJRypXJWeZkzBUl7ZhuMzyMH0wxcxSqGLXPbntF+xKr9adK+eFFZvPY8cplStM
	A81f1sAYPRy7JVJKBN5JP2NTrNQb8YT+bNxU1KkfcjIEdqoCq8QGC7DgRXR8iLg==
X-Gm-Gg: ASbGncvaCwl5137ki3t0JxMisY5F+5gUAf+dTGoyuV2j03xnqMbVuyNHwHmDM0ZPaWW
	iQHF8SQuOh/2AekrsKfm62p6/6r1jnmKlhxdKyrnt2M/P6xpL//Hk16cKLmTEr3p/jbItWJJ0zd
	dx0exYe/I1p1WaS6Prl1wfzvuytzBjDtU7Yv7UQhA8qyz9UZA1ZVc+kydDfGBp6l6gDq87oQd93
	ZaeFEshQib+AB+Hzxfeg2j3iVJP9GjAyWRpwvbIhwzhHHQAneImhMkbejCo5y2iOnGawSYeN206
	vTehGJm4StHG0FT91xQKgImhYu95lTTUZpO/OdRMmBnxWWeXUKo3MuVIu5yBVOxv5BBDjmRHaST
	6Kwxwv+G9yGQDwKG/j+OOQ3V6LRZp4/xDdjPw+FY=
X-Received: by 2002:a05:6a20:7484:b0:2b3:4f2a:d2e9 with SMTP id adf61e73a8af0-348c9d69c31mr8402836637.9.1762014171423;
        Sat, 01 Nov 2025 09:22:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEc8BOPj2pKyXNQKaATw/JLfCBSoicvuZ6AdRuvcaB7gDZzdncb9ymDM7Eh2jjEBIKMmUaZFw==
X-Received: by 2002:a05:6a20:7484:b0:2b3:4f2a:d2e9 with SMTP id adf61e73a8af0-348c9d69c31mr8402818637.9.1762014170980;
        Sat, 01 Nov 2025 09:22:50 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db681c01sm5637496b3a.55.2025.11.01.09.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 09:22:50 -0700 (PDT)
Date: Sun, 2 Nov 2025 00:22:45 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] generic/778: fix severe performance problems
Message-ID: <20251101161919.7sydm4rtfgkc2krg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
 <176107188833.4163693.9661686434641271120.stgit@frogsfrogsfrogs>
 <aPhbp5xf9DgX0If7@infradead.org>
 <20251022042731.GK3356773@frogsfrogsfrogs>
 <20251031174734.GD6178@frogsfrogsfrogs>
 <20251101093418.wxv6w6diisvflrrp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20251101154235.GX4015566@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251101154235.GX4015566@frogsfrogsfrogs>

On Sat, Nov 01, 2025 at 08:42:35AM -0700, Darrick J. Wong wrote:
> On Sat, Nov 01, 2025 at 05:34:18PM +0800, Zorro Lang wrote:
> > On Fri, Oct 31, 2025 at 10:47:34AM -0700, Darrick J. Wong wrote:
> > > On Tue, Oct 21, 2025 at 09:27:31PM -0700, Darrick J. Wong wrote:
> > > > On Tue, Oct 21, 2025 at 09:20:55PM -0700, Christoph Hellwig wrote:
> > > > > On Tue, Oct 21, 2025 at 11:41:33AM -0700, Darrick J. Wong wrote:
> > > > > > As a result, one loop through the test takes almost 4 minutes.  The test
> > > > > > loops 20 times, so it runs for 80 minutes(!!) which is a really long
> > > > > > time.
> > > > > 
> > > > > Heh.  I'm glade none of my usual test setups even supports atomics I
> > > > > guess :)
> > > > 
> > > > FWIW the failure was on a regular xfs, no hw atomics.  So in theory
> > > > you're affected, but only if you pulled the 20 Oct next branch.
> > > > 
> > > > > > So the first thing we do is observe that the giant slow loop is being
> > > > > > run as a single thread on an empty filesystem.  Most of the time the
> > > > > > allocator generates a mostly physically contiguous file.  We could
> > > > > > fallocate the whole file instead of fallocating one block every other
> > > > > > time through the loop.  This halves the setup time.
> > > > > > 
> > > > > > Next, we can also stuff the remaining pwrite commands into a bash array
> > > > > > and only invoke xfs_io once every 128x through the loop.  This amortizes
> > > > > > the xfs_io startup time, which reduces the test loop runtime to about 20
> > > > > > seconds.
> > > > > 
> > > > > Wouldn't it make sense to adopt src/punch-alternating.c to also be
> > > > > able to create unwritten extents instead of holes for the punched
> > > > > range and run all of this from a C program?
> > > > 
> > > > For the write sizes it comes up with I'm guessing that this test will
> > > > almost always be poking the software fallbacks so it probably doesn't
> > > > matter if the file is full of holes.
> > > 
> > > ...and now running this with 32k-fsblocks reveals that the
> > > atomic_write_loop code actually writes the wrong value into $tmp.aw and
> > > only runs the loop once, so the test fails because dry_run thinks the
> > > file size should be 0.
> > > 
> > > Also the cmds+=() line needs to insert its own -c or else you end up
> > > writing huge files to $here.  Ooops.
> > > 
> > > Will send a v2 once the brownpaperbag testing finishes.
> > 
> > Hi Darrick,
> > 
> > JFYI:) If you don't mind, as I haven't seen your v2, I'll try to merge this patchset
> > without this [09/11] at first. Then I can merge another patchset "[PATCH 0/3] generic/772:
> > split and fix" which bases on this patchset, and give them a test.
> 
> Sounds good!
> 
> The 778 changes are going to take a while longer because it keeps
> breaking down in weird ways on 64k fsblock filesystems.

Thanks for this detail, Darrick. I've pushed "ready to merge" patches into
patches-in-queue branch, feel free to check. This week we have many scattered
patches, I hope to take more time to give them enough test.

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > > > Otherwise this looks good:
> > > > > 
> > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Thanks!
> > > > 
> > > > --D
> > > > 
> > > 
> > 
> 

