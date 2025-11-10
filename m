Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFDC32C94C
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 21:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762810420; cv=none; b=d/PUZeiR/CVbJcOkzW8KfBdhFiHsjGL4vN3h3HOS/WZmI4+NlUPdS7s6AbkCXgCDIhF1Nlg+/23aVFXrrLprt8AwhTvgq08cCCDR3y6ChnCz58RDvKDIJ4xZBzyqYqY/nyi/KudMGrVdIxNWL3i8r5BED5c9AGbaQ/EXT2VLK0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762810420; c=relaxed/simple;
	bh=zCkKKVg19c5cxq77+q3GwYQQR79PB9nvGpzFEBpyE/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZzlKRoNUszA+2maNyKaC9RHhB0bHkds9mthdnJuzati/DwR+DRMBEOZgJkRb9Yt9qguyzBv5qb73xu7eIhFr5i7E9FZE5GxJZjg3nihiC8hoegxqexw9MaACcHnvYEuQpiulv0xJnzeIXz3cQCjZB8yWkufKir4pfR4rPj6csg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kZhaUjga; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kZhaUjga"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-bb7799edea8so951568a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1762810418; x=1763415218; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SvM9ffGyDnNBYQvg+LznWRsq+EE4XVPlNR8iz1yg4y0=;
        b=kZhaUjgaREGTNavqnFP3TwTIUdylvNBvPrZODXT7zqCDrk0o5xk7DxPu7enRZ5BF/q
         uocMBVkwes/avytgIsvZR3/Re+xvgwqg+YSg6v1JYM1y9VpxOohdWbMqQBsZh08rjHrz
         x5QBdMoF/5Dz6g0UPJE4dult8cAcTUGD/Fe8YyWvGKeQMquLHYzpOMysv8f/1TDGPpWq
         iaixTALdNU9fe9CV0HshGmxSeCkSUVJyNG2NNlP3qxR2d1dgj+MqXIwungtZluYndI9z
         OYXOm+FwnkMlJ5pE+Q64sVkShfs1L7Yi3rvf7H0+wDS2TnSVHUEGJYeDXzppapqCwEle
         2eGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762810418; x=1763415218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SvM9ffGyDnNBYQvg+LznWRsq+EE4XVPlNR8iz1yg4y0=;
        b=jN4UFdASX92PebLZ9AqESWJ08wTcZJwi64bqWB4efNOFWvNS0CdScnSPbHDJukvUzK
         K0aSNDJkhaFCMtUpE8ffxbP3C/AmdJOa945Nw1AZnWddeZeLRv46jVSyhNyLMOZSi++V
         WZJdV+zcIAEmRv4IJBXHjVabwjveTR06HX0alOOFPxrfGW1c6OA+E25hV0X1tz13NigC
         mTrk2XLrWOERT7sVy05qzZybmssF2FCx6kksXivBJRSfPvikQaVsOgw8aRj22IXW2i7D
         FThfqgoDW84leH4n76PUYY2KBFHRWlP1PgLBD6vOhlUOy9DBV40R/xfog+pMdbS0rElj
         ktHw==
X-Forwarded-Encrypted: i=1; AJvYcCX0m2kWYGMw5uLC6CI6aAq3OL45CoFw6rqk0XRhO6T7UdwhHUjmHAJel2tL7vKAOh0FHO5mOXUpG2c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzErsaiLQ+opw8b0bnTdF/NzVGJ3IngrsvfAMNc+vSXACuEuOy
	rV0MrQgwyl4u2IvfErnAtH/sn/LIX/76HWK0+bhJYu72837YJPtdB6ilgEE4RPypfkY=
X-Gm-Gg: ASbGnctn7xj0tRGQgsMonAKNRvF0R8XONpx6yEaknaJL+ggw69ERdY/rJciYv7fvdXN
	rv0Jo9Vsl9+XjAkzFBokwpDFVsTi+LbP+/dG12XylBP0Hbrp5s24CgFiaqg5CYCwRF+wC9e+R0k
	61v0squYPd12Jb4yYXe3YbjY4nazWU6J2X0S72DcNkmY+8DlxnYk6R/XaOgJXubWp9VAIOBZ4d0
	fCHpPZBFOY6YyNUHKS/o6VBtNXr8d/Eg4v7W2AvRrb/8KiRDy+okoOFXM/1bCE6+VWkBf2qEzsc
	9AP+1drE64i0oPekH2cRNrZpSWC5psB6dJ5ksWZlT8LtaiM6pqbTJ0P4yg/DgXbV2eKtJinhQnr
	OA8IeyD5sxeX1B8Soi7IHpFBh+yguFHg1hhuZFQxZPOBYqOFbp+dISrUdndDu5ZzyMVzsa1Dm48
	91HwnBFD5V0oQyRKkXVdIXj5oRXehdFhyn8kfbnEPQC2p50hrhjAc=
X-Google-Smtp-Source: AGHT+IE9Gy3zLsAHXnLViJPwf3Ayy1iV4+M7p8/z+XXoIz8O+RbPg3Grxn6wKe3lT/+eSU+c3SDd4w==
X-Received: by 2002:a17:903:a90:b0:295:7f1f:a808 with SMTP id d9443c01a7336-297e56b8c0cmr118357695ad.38.1762810417526;
        Mon, 10 Nov 2025 13:33:37 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-297e2484bfbsm92087665ad.26.2025.11.10.13.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 13:33:37 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vIZW2-0000000961M-2l4D;
	Tue, 11 Nov 2025 08:33:34 +1100
Date: Tue, 11 Nov 2025 08:33:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Florian Weimer <fw@deneb.enyo.de>, Florian Weimer <fweimer@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	libc-alpha@sourceware.org
Subject: Re: [RFC] xfs: fake fallocate success for always CoW inodes
Message-ID: <aRJaLn72i4yh1mkp@dread.disaster.area>
References: <20251106133530.12927-1-hans.holmberg@wdc.com>
 <lhuikfngtlv.fsf@oldenburg.str.redhat.com>
 <20251106135212.GA10477@lst.de>
 <aQyz1j7nqXPKTYPT@casper.infradead.org>
 <lhu4ir7gm1r.fsf@oldenburg.str.redhat.com>
 <20251106170501.GA25601@lst.de>
 <878qgg4sh1.fsf@mid.deneb.enyo.de>
 <aRESlvWf9VquNzx3@dread.disaster.area>
 <20251110093701.GB22674@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110093701.GB22674@lst.de>

On Mon, Nov 10, 2025 at 10:37:01AM +0100, Christoph Hellwig wrote:
> On Mon, Nov 10, 2025 at 09:15:50AM +1100, Dave Chinner wrote:
> > On Sat, Nov 08, 2025 at 01:30:18PM +0100, Florian Weimer wrote:
> > > * Christoph Hellwig:
> > > 
> > > > On Thu, Nov 06, 2025 at 05:31:28PM +0100, Florian Weimer wrote:
> > > >> It's been a few years, I think, and maybe we should drop the allocation
> > > >> logic from posix_fallocate in glibc?  Assuming that it's implemented
> > > >> everywhere it makes sense?
> > > >
> > > > I really think it should go away.  If it turns out we find cases where
> > > > it was useful we can try to implement a zeroing fallocate in the kernel
> > > > for the file system where people want it.
> > 
> > This is what the shiny new FALLOC_FL_WRITE_ZEROS command is supposed
> > to provide. We don't have widepsread support in filesystems for it
> > yet, though.
> 
> Not really.  FALLOC_FL_WRITE_ZEROS does hardware-offloaded zeroing.

That is not required functionality - it is an implementation
optimisation.

WRITE_ZEROES requires that the subsequent write must not need to
perform filesystem metadata updates to guarantee data integrity.
How the filesystem implements that is up to the filesystem....

> I.e., it does the same think as the just write zeroes thing as the
> current glibc fallback and is just as bad for the same reasons.

No, it is not like the current glibc posix_fallocate() fallback.
That is a compatibility slow-path, not an IO path performance
optimisation.

i.e. WRITE_ZEROES is for applications that overwrite in place and
are very sensitive to IO latency.  The zeroing is done
in a context that is not performance sensitive, and it results in
much lower long tail latencies in the performance sensitive IO
paths.

WRITE_ZEROES is a more efficient way of running
FALLOC_FL_ALLOC_RANGE and then writing zeroes to convert the range
from unwritten to written extents because it allows ithe kernel to
use hardware offloads if they are available.

Applications that need pure overwrite behaviour are not going to be
using COW files or storage that requires always-COW IO paths in the
filesystems (e.g. on zoned storage hardware).

Hence we just don't care that:

> It
> also is something that doesn't make any sense to support in a write
> out of place file system.

... COW files cannot support WRITE_ZEROES functionality because
optimisations for overwrite-in-place aren't valid for COW-based
IO...

> > Failing to check the return value of a library call that documents
> > EOPNOTSUPP as a valid error is a bug. IOWs, the above code *should*
> > SIGBUS on the mmap access, because it failed to verify that the file
> > extension operation actually worked.
> > 
> > I mean, if this was "ftruncate(1); mmap(); *p =1" and ftruncate()
> > failed and so SIGBUS was delivered, there would be no doubt that
> > this is an application bug. Why is should we treat errors returned
> > by fallocate() and/or posix_fallocate() any different here?
> 
> I think what Florian wants (although I might be misunderstanding him)
> is an interface that will increase the file size up to the passed in
> size, but never reduce it and lose data.

Ah, that's not a "zeroing fallocate()" like was suggested. These are
the existing FALLOC_FL_ALLOCATE_RANGE file extension semantics.

AFAICT, this is exactly what the proposed patch implements - it
short circuits the bit we can't guarantee (ENOSPC prevention via
preallocation) but retains all the other aspects (non-destructive
truncate up) when it returns success.

I don't see how a glibc posix_fallocate() fallback that does a
non-desctructive truncate up though some new interface is any better
than just having the filesystem implement ALLOCATE_RANGE without the
ENOSPC guarantees in the first place?

> > > If we can get an fallocate mode that we can use as a fallback to
> > > increase the file size with a zero flag argument, we can definitely
> > 
> > The fallocate() API already support that, in two different ways:
> > FALLOC_FL_ZERO_RANGE and FALLOC_FL_WRITE_ZEROS. 
> 
> They are both quite different as they both zero the entire passed in
> range, even if it already contains data, which is completely different
> from the posix_fallocate or fallocate FALLOC_FL_ALLOCATE_RANGE semantics
> that leave any existing data intact.

Yes. However:

	fallocate(fd, FALLOC_FL_WRITE_ZEROES, old_eof, new_eof - old_eof);

is exactly the "zeroing truncate up" operation that was being
suggested. It will not overwrite any existing data, except if the
application is racing other file extension operations with this one.
In which case, the application is buggy, not the fallocate() code.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
