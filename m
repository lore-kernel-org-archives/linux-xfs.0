Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52B02EC563
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 20:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762806506; cv=none; b=u83xEU/Ld0DoQv1bRujWSbtPm9zLleAUEwKwZKFEsGfFXGc058pOwmSNZH4H0TLLy0TvFfIFAiimVJ4NOcRy8RQQ0vDwmvXc6XTf8SKFnlQoRsBl2fwl8TXUBC4mDykLdvBZh50SeZeEvdH1pbeV7yiOlNYvy4dtmE6UJBORj2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762806506; c=relaxed/simple;
	bh=U2KPE+a4Gjk2w8tXO3gOnH3+aIIjVM+sZqVcF9kbiaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GOR0SfC2lAFIqPSIEF8CtK4l4fHxrc4OlxXjIH7qm9odMjC/QbxjrARUL1LNm5So9f6sAtcgBhn4FQaQ+lUkeIc3osJb1ifeeYLlrg8ZWieknm70iMPTRnlt8cgCpNFZqEpji65RtVPrci1frZgggjVG+9+SngdgjuK4x2NDu6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0DXESfE9; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0DXESfE9"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b0246b27b2so3668448b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 12:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1762806504; x=1763411304; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/v36x1hAUlyKd1IieWoklJ8pc6DivsQnj+M0ePT6nI=;
        b=0DXESfE9IgF6uIMHPBfVhT9MYO+Z/zPM9nYObFd6wb7gLGzb8ZLekHfT8BI8+vA7yr
         46cdVNBO0kTI6DdJU+k9wLHyk4DAs/A0p0sxjXuZVUKzWFRE65xSPsLNVit5H/n2Ddhv
         hoCX0C2cYzbicMfZeFYjvnmox4Qqqdv92C/xmaX+O51kOAQEG6QSHAuFVFUN0EeSntOL
         JfN6WXtzX0r1BFI1UJu4rFi/8UgfbGM8v5vvUnyj54k2hjuqxysPmvxvpNp7ecCLJVi4
         wKE6B1+n9ehk7mhdrtPJPJnp9/bNyi+D+oYRiQ1GClslcmi2tBKXH6BLNmeiE650kITd
         rFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762806504; x=1763411304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q/v36x1hAUlyKd1IieWoklJ8pc6DivsQnj+M0ePT6nI=;
        b=lCWe9pUGuqTjWktjd3erYgLGGCdRNgApYIPHR/bTnhf6gQab2BFw0JmOS6szp5uyqZ
         lxXJIxS16oasdhuNhYV1xllv6Q8e8AcPEUVmKW7ECGod+8hoYYwu5vuy3J4ShIVN9K3E
         glPNE54oVuY+Dv1Qk73mtSGpkyAN9VQ6EUi8CxtF8ylS3AMGYLRSTSayFmdrCh0weXuZ
         vbZ8Unvsmh1T28VKWlopNyALFq5oMgDZWHC+qUq3L3WX5DWH6lLNnecBueAuSqnOqU/R
         WmpgtoXmBjKvC72jvy5gVOmjLcmDnW4jFLc21ZWPxAqJQ4+XPIkwGB6chaa5rJjgCm/2
         U/xg==
X-Forwarded-Encrypted: i=1; AJvYcCW6T9OotVLb+2U4Lcbj3kXFcv9r0gMYezfeWWf7kfOYyjE0llyAC8Petn0ovCrr8YLIALA5qRROfZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVWbuaLLzyy5O1Dv1v04jvN1DCHU4CrMuiu3IYw844gUwULRLg
	dxgjM5Se+8/2zdmeb5rBlM+0D3cQwm3JyudKiXw4hOt2Vy7BwgmbwHVHWNbSoMUHLpg=
X-Gm-Gg: ASbGncuJK8+DBOoVLvNZzA3jdWL0J+pCkWZ8VX1hiVjtxGxNcXAslS4qeTpkuYK/N0r
	56FqlcUP4/+GfhvgFC2yxFWuB29R74nir9Pzi3u/1dTYEJAIiLopHJ5TVv7zHMlhTyR0g49ABmr
	4oqMs7jsu2MvGxLwodV6OVTtncJ8pwKMbPyuIQaF9sFz2XYthC2M4guO1l3kWrhVjNh+NL9M2Qa
	BK0uu4NJxbCVxzngAUkkW34F8VrHWQAbDpCdq3nM9QczyWBZ98Fk/QdRCRdY9Kfj563scAC7fR9
	+E1PE/9BwZwApvZjD/eDfkJzNtJvtKX0aBoA4ui62ZiXnAxthguocuBxsnIu0hMwbznMMcSmSOS
	6r6uW3PLQPTAkVCu+kzoVyqbZfMB5Iwmw1QoWJUatKpZZJ7/YSDOfiljUYdK0esqD8B005fMKeZ
	aLEGLJYtFAtqo14StfgDWh36H14ywad9nUAGyAG1SlAXinGqgi1jHGTTn/kygopw==
X-Google-Smtp-Source: AGHT+IH39E62oY2rb1DPACln6LUbVJT652sq3AEwuo4V3SoBL2oWZyT4qZRjdpQUUFk3spj6hUT/4Q==
X-Received: by 2002:a05:6a20:6a1d:b0:340:fce2:a15c with SMTP id adf61e73a8af0-353a0ba080amr10349273637.9.1762806504055;
        Mon, 10 Nov 2025 12:28:24 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c953d0a6sm12689594b3a.12.2025.11.10.12.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 12:28:23 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vIYUu-000000094pP-2u7e;
	Tue, 11 Nov 2025 07:28:20 +1100
Date: Tue, 11 Nov 2025 07:28:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	libc-alpha@sourceware.org
Subject: Re: [RFC] xfs: fake fallocate success for always CoW inodes
Message-ID: <aRJK5LqJnrT5KAyH@dread.disaster.area>
References: <20251106133530.12927-1-hans.holmberg@wdc.com>
 <lhuikfngtlv.fsf@oldenburg.str.redhat.com>
 <20251106135212.GA10477@lst.de>
 <aQyz1j7nqXPKTYPT@casper.infradead.org>
 <lhu4ir7gm1r.fsf@oldenburg.str.redhat.com>
 <20251106170501.GA25601@lst.de>
 <878qgg4sh1.fsf@mid.deneb.enyo.de>
 <aRESlvWf9VquNzx3@dread.disaster.area>
 <lhuseem1mpe.fsf@oldenburg.str.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lhuseem1mpe.fsf@oldenburg.str.redhat.com>

On Mon, Nov 10, 2025 at 06:27:41AM +0100, Florian Weimer wrote:
> * Dave Chinner:
> 
> > On Sat, Nov 08, 2025 at 01:30:18PM +0100, Florian Weimer wrote:
> >> * Christoph Hellwig:
> >> 
> >> > On Thu, Nov 06, 2025 at 05:31:28PM +0100, Florian Weimer wrote:
> >> >> It's been a few years, I think, and maybe we should drop the allocation
> >> >> logic from posix_fallocate in glibc?  Assuming that it's implemented
> >> >> everywhere it makes sense?
> >> >
> >> > I really think it should go away.  If it turns out we find cases where
> >> > it was useful we can try to implement a zeroing fallocate in the kernel
> >> > for the file system where people want it.
> >
> > This is what the shiny new FALLOC_FL_WRITE_ZEROS command is supposed
> > to provide. We don't have widepsread support in filesystems for it
> > yet, though.
> >
> >> > gfs2 for example currently
> >> > has such an implementation, and we could have somewhat generic library
> >> > version of it.
> >
> > Yup, seems like a iomap iter loop would be pretty trivial to
> > abstract from that...
> >
> >> Sorry, I remember now where this got stuck the last time.
> >> 
> >> This program:
> >> 
> >> #include <fcntl.h>
> >> #include <stddef.h>
> >> #include <stdio.h>
> >> #include <stdlib.h>
> >> #include <sys/mman.h>
> >> 
> >> int
> >> main(void)
> >> {
> >>   FILE *fp = tmpfile();
> >>   if (fp == NULL)
> >>     abort();
> >>   int fd = fileno(fp);
> >>   posix_fallocate(fd, 0, 1);
> >>   char *p = mmap(NULL, 1, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> >>   *p = 1;
> >> }
> >> 
> >> should not crash even if the file system does not support fallocate.
> >
> > I think that's buggy application code.
> >
> > Failing to check the return value of a library call that documents
> > EOPNOTSUPP as a valid error is a bug. IOWs, the above code *should*
> > SIGBUS on the mmap access, because it failed to verify that the file
> > extension operation actually worked.
> 
> Sorry, I made the example confusing.
> 
> How would the application deal with failure due to lack of fallocate
> support?  It would have to do a pwrite, like posix_fallocate does to
> today, or maybe ftruncate.  This is way I think removing the fallback
> from posix_fallocate completely is mostly pointless.
> 
> >> I hope we can agree on that.  I expect avoiding SIGBUS errors because
> >> of insufficient file size is a common use case for posix_fallocate.
> >> This use is not really an optimization, it's required to get mmap
> >> working properly.
> >> 
> >> If we can get an fallocate mode that we can use as a fallback to
> >> increase the file size with a zero flag argument, we can definitely
> >
> > The fallocate() API already support that, in two different ways:
> > FALLOC_FL_ZERO_RANGE and FALLOC_FL_WRITE_ZEROS.
> 
> Neither is appropriate for posix_fallocate because they are as
> destructive as the existing fallback.

You suggested we should consider "implement a zeroing fallocate",
and I've simply pointed out that it already exists. That is simply:

	fallocate(WRITE_ZEROES, old_eof, new_eof - old_eof)

You didn't say that you wanted something that isn't potentially
destructive when a buggy allocation allows multiple file extension
operations to be performed concurrently. 

> > You aren't going to get support for such new commands on existing
> > kernels, so userspace is still going to have to code the ftruncate()
> > fallback itself for the desired behaviour to be provided
> > consistently to applications.
> >
> > As such, I don't see any reason for the fallocate() syscall
> > providing some whacky "ftruncate() in all but name" mode.
> 
> Please reconsider.  If we start fixing this, we'll eventually be in a
> position where the glibc fallback code never runs.

Providing non-destructive, "truncate up only" file extension
semantics through fallocate() is exactly what
FALLOC_FL_ALLOCATE_RANGE provides.

Oh, wait, we started down this path because the "fake" success patch
didn't implement the correct ALLOCATE_RANGE semantics. i.e. the
proposed patch is buggy because it doesn't implement the externally
visible file size change semantics of a successful operation.

IOWs, there is no need for a new API here - just for filesystems to
correctly implement the file extension semantics of
FALLOC_FL_ALLOCATE_RANGE if they are going to return success without
having performed physical allocation.

IOWs, I have no problems with COW filesystems not doing
preallocation, but if they are going to return success they still
need to perform all the non-allocation parts of fallocate()
operations correctly.

Again, I don't see a need for a new API here to provide
non-destructive "truncate up only" semantics as we already have
those semantics built into the ALLOCATE_RANGE operation...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
