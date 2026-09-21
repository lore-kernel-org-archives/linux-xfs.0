Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AD547DF94;
	Mon, 21 Sep 2026 23:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790033015; cv=none; b=N+ws8jv1Ephtnlet/YKMfBw0QVtAOh+B+OpgKCNGnAqVR8+OjL0qFhOMxg1ZcQ05N92JTJeEYECszXG89YUGmY8JyJebdptBejFR7gRx1Mdu7w2btXHlNZ74+fP3HPqhUTARomMTbzl/LZzzawfGdKkRiLQZEXGJEmvfTb8thtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790033015; c=relaxed/simple;
	bh=SMF3JTCy12tMkh7LP9QsPNpLnwOfmZrlhdz3vWkH4HU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLcTB1Mejgt1OIr7Vqk0E5+mWgfwSOfl/lmy+zQCXCXv3Z8Z4UmsO3Cl7cztdUhDEavMGO+Nv2JI9W7fV6hNrCRK1/WOM5lFC68wT8/ko4aFXXKfO7zmESUzQleABV8SzYYNmsPCZn/9qqEwxlRZwGwW8ZI9waSO+2KAjI9qd/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VsOq4jUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VsOq4jUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E8F1F000FF;
	Mon, 21 Sep 2026 23:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790033013;
	bh=Mi8Whz8fBeA3TakUMBe/3d5D0jQRsBe/GVENydPqRxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VsOq4jUJcbukzkixpIPpN6J6et3/8yD0xicFSkalFapwRsPh+YemxJqNXdy4DvfAj
	 oo0yGBmnOVyNtT/blMloMMZija1QjrRLwAo9znr2mIE2s3szPFFTwTEuvT4TsTyRV1
	 C8ugLpJ5m8lYQ9OHbiLmlAOuovineqU7W9Ev4banNcwezizuZT2hhRj1WKwmtgCUMs
	 Vc+qijkOT7n4lTD5mkA3TjKgEy4Y4u433tz1wjqb/NC4A1wOeAqHdgltYDLBMwC6Rl
	 rye5D0r7NV0115Ib7kIJwTXZIpXY6fPZfuKLZTa7CnEhi+KpYtnVyRpnB/X3rvdbgF
	 pQYgNyhrcjb8A==
Date: Tue, 22 Sep 2026 09:23:23 +1000
From: Dave Chinner <dgc@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, cem@kernel.org,
	jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com
Subject: Re: [PATCH v5 0/8] xfs write streams
Message-ID: <arG8a7Vcy6_qZi0e@dread>
References: <CGME20260921093229epcas5p387ee10f88335ddc5fc930ca919769a60@epcas5p3.samsung.com>
 <20260921093147.59935-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921093147.59935-1-joshi.k@samsung.com>

On Mon, Sep 21, 2026 at 03:01:39PM +0530, Kanchan Joshi wrote:
> This series introduces a generic interface [2,3] for write stream management on
> files.
> It enables spatial isolation (at sw and hw level) and concurrency improvments [1]
> in xfs by
> (a) steering each write stream to its own set of allocation groups (patch #5)
>     and realtime groups (patch #6).
> (b) connecting xfs write streams to block write streams (FDP capable NVMe).
> 
> Write streams allow the abstraction provider (fs, block, raid etc.) to
> leverage application's intent (file relationships/lifecycle).
> - application: reserves a stream and sets it on the files it wants
>   placed together.
> - xfs: maps streams to AGs/RGs; allocates without interleaving; gains
>   higher concurrency due to reduced lock contention.
> - hardware: maps streams to underlying allocation unit; reduces device
>   internal write amplification, improved life, predictable QoS.
> 
> Also
> - A stream is handed out using an fd. The filesystem is free to map streams
>   onto its own geometry, and the reservation/fd machinery is generic
>  (fs/write_streams.c) so other filesystems can reuse it.
> 
> - Since high-level write stream (in xfs) and logical placement can work
>   without the low-level write streams (in block device), series has a general
>   value beyond the hardware that provides spatial isolation. Patches 1-7 are
>   software only and work on any block device; patch 8 aligns the stream
>   count to the hardware streams when the device has them.

So, how would I set up a stream that directs all writes to AG 1, and
returns ENOSPC to write operations if that AG is full?

What about having several streams, each pointing at a different,
known AG that the application directly controls (i.e. a known 1:1
mapping between stream_fd and agno)?

This is functionality that we could use in xfs_fsr to get rid of all
the historic tmpdir/tmpfile heuristics that allow it to "control"
locality of the data placement of files that it defragments. We also
need such control of data placement to empty AGs for shrink
operations. Yes, this only occurred to me a couple of days ago, but
now that I've made the connection between write streams and fs
allocation policy direction, it seems like a natural fit.

FWIW, that also means that, for XFS, write streams need to be
applicable to directories, so that directory block allocation also
gets placed according to the stream ID, and that new inodes in that
directory are created in the same AG as the stream ID points to.
This directly allows us to rebuild directories using FICLONE/UNSHARE
tricks and have all the indoes, data and metadata placed in the AG
we desire (i.e. necessary functionality for online shrink).

So:

> [2]
> ### Application interface
> 
> Three new ioctls:
>       FS_IOC_WRITE_STREAM_GET_MAX  number of streams the filesystem offers
>       FS_IOC_WRITE_STREAM_ALLOC    reserve a stream, returns an fd
>       FS_IOC_WRITE_STREAM_SET      set or clear a stream on a file

How does this interface enable such usage of write streams to direct
purely filesystem level allocation policy requirements? I don't see
how I can use this API to direct where in the filesystem to map the
stream to. I can see that there is a 'set' command, but all it has
is a flags field. There's nothing passed to the ALLOC command to
allow the application to indicate to the filesystem where it wants
the new stream to point to.

IOWs, it appears taht there is no way to provide the FS with any
sort of direction as to how the stream should be set up. If we want
a FS specific stream (e.g. an AG) then we don't want it mapped to a
hardware stream, and we don't want it mapped to some random set of
AGs (like this patchset implements). The only real reason for
filesystem level write streams is to expose allocation locality
control to applications, so it seems kinda silly to have an API that
prevents any real application level control...

Indeed, how do we ask for a fs-level write stream instead of a
hardware-level write stream? They are different things, and have
different use cases (obviously!) so there definitely needs to be
some level of though put into this. And, FWIW, the write stream id
will probably need to be a u32 if we are going to support FS level
write streams, as we can have more than 65536 AGs in a
filesystem....

> - Usage model: application needs to get a handle (fd) for a write stream
>   before being able to use it. This avoids multi-application conflicts.

Why can't multiple applications use the same write stream locality
mapping independently? If the application wants an exclusive write
stream (i.e. exclusive access to a set of AGs in the filesystem),
then surely that's a flag for the ALLOC API, right?

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
