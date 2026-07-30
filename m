Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BEF43E06E;
	Thu, 30 Jul 2026 17:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785432135; cv=none; b=GI1zXpFtvvKDNJSbFAwbKuJL+vELMBR0IXuuR9sDDC56YLjfvZc38gysNwoL3aqlmwZOXyQ5YYVEqm25OrIqcYAGf5NgMV5t6bpCUPQDIgJZci7XQGJ3IC3x+IULtzNcXIW1gmEWaet02ktMCiaAkyvMXILnauGoGHGRuqdRh6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785432135; c=relaxed/simple;
	bh=jDNmc4meTOC48+Q3IEDbk4+gRBVJ/ShbSj+dJRJ29s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQoegVxB2J+d99cJnOH63js5nXFeg7amzGiyBF29+/fMdv3AEntajgTUgmmJysU9XiT/9in+ZNnlSUDvMRGb1yn6SejjZMMl1xh/m/fohoWoDrOkly+K7OcQB1bkjNVvKtPOwKWBJUcjN+IFXhKiZxOVIXGSRb3+i7F3/SWpt7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSX2F6X8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSX2F6X8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 98B301F000E9;
	Thu, 30 Jul 2026 17:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785432133;
	bh=McAgD6bGrXTjy6SCU9zZMCKhjy/fGK+hqvLguqeEyXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oSX2F6X8bCppWdG2XhvH4DC2YBCkQa5JqzZ0jpGA5M8YlAdYHmk9gPn8foNtgPQiA
	 l81DnkCN0xz2AKvZ1TGMykgQovUloJiQ7i580uaaKQdpVl/JKRMoprfN38uoUSjeJa
	 06zW3eCL3PRoIR0+v/4ndHolhVnlXyoU4g7cNR52qrT6pu4fVMHsesUQpNqpaAMZ32
	 S3rx2n+FauNF3WNeXLgNaSDTOSecAvPnIwBLunnsWKDwZ/t9hwv0opAUEl6Swdz6MC
	 TWM3yjySvoWbXtuF4ufClpIJ270VKPdTLnTY9S1onvxIIuFUGTyZw/e9RvQHVIoZ+a
	 YNAvv5Bnh9o9Q==
Date: Thu, 30 Jul 2026 10:22:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
Message-ID: <20260730172211.GF3556460@frogsfrogsfrogs>
References: <20260717125538.508925-1-joshi.k@samsung.com>
 <CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com>
 <20260717125538.508925-2-joshi.k@samsung.com>
 <20260721030338.GU7380@frogsfrogsfrogs>
 <71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com>

On Thu, Jul 30, 2026 at 08:22:51PM +0530, Kanchan Joshi wrote:
> On 7/21/2026 8:33 AM, Darrick J. Wong wrote:
> > On Fri, Jul 17, 2026 at 06:25:33PM +0530, Kanchan Joshi wrote:
> >> From: Anuj Gupta<anuj20.g@samsung.com>
> >>
> >> Wire up the userspace interface for write stream management via four
> >> ioctls:
> >>
> >>    FS_IOC_WRITE_STREAM_GET_MAX  query the max streams supported
> >>    FS_IOC_WRITE_STREAM_OPEN     open a stream id, returns a stream fd
> >>    FS_IOC_WRITE_STREAM_SET      attach the stream fd to an open file
> >>    FS_IOC_WRITE_STREAM_GET      query the stream id value set on a file
> >>
> >> Application should query the available streams by using
> >> FS_IOC_WRITE_STREAM_GET_MAX. If returned value is N, valid stream id for
> >> the file are 1 to N.
> >>
> >> Application calls FS_IOC_WRITE_STREAM_OPEN to get fd for a stream-id.
> >> By default, kernel picks an available stream-id and returns the fd for
> >> it. The flag FS_WRITE_STREAM_OPEN_EXACT can be used to request a
> >> specific stream_id. This is useful if application cares about keeping a
> >> stable stream-id-to-spatial-isolation-bucket mapping across restarts.
> > Hmm.  If FS_IOC_WRITE_STREAM_OPEN returns an fd that represents an open
> > stream id, then why does STREAM_SET below take a pointer to a signed
> > s32? 
> 
> Not a pointer, that s32 is to pass the stream fd.

Oh, but that third argument to ioctl() /is/ supposed to be a pointer to
some data.  From ioctl(2):

"The third argument is an untyped pointer to memory.  It's traditionally
char  *argp (from the days before void * was valid C), and will be so
named for this discussion."

You can also see this reflected in the discussion of the R/W/WR variants
of _IO:
https://docs.kernel.org/driver-api/ioctl.html

"[data_type] may be a pointer to data to be passed into the kernel
(_IOW), out of the kernel (_IOR), or both (_IOWR)"

Granted your kernel code can treat that argp as an integer and not a
__user pointer if it wants to, but that goes against most ioctl
implementations.  Further, subsystems that marshal ioctl information for
passing through to another layer (e.g. fuse) assume that the third
argument is a pointer and that it can copy sizeof(data_type) bytes at
that address in and out of the kernel as part of marshalling.

> > And why does STREAM_GET take a pointer to a u32?
> 
> This also is a scalar value and not a pointer. The returned stream-id is 
> a u32.
> 
> > IOWs it'd be much easier to distinguish these things if the ioctls took
> > pointers to structs instead of u32/s32 pointers directly.
> 
> Maybe IOCTL naming is the source of confusion, because we introduced 
> stream-fds alongside stream-ids. More on this below.
> > Also it's a little weird that STREAM_SET associates an open file with a
> > stream fd, but STREAM_GET returns the stream*id* (not the fd)
> > associated with an open file.
> 
> The confusion stems from keeping symmetric names for different 
> operations. Let me explain the intent and propose revised names below.
> 
> Christoph's idea was to use FD for a write-stream so that it remains 
> exclusive to the application and unrelated applications don't collide.
> 
> So, in this version, write-stream ids are implemented as independent 
> resource:
> - To set a file's write-stream ID to X, the app must first obtain the fd 
> for stream X.
> - That stream/fd will be unavailable if some other application has 
> already opened it.
> - If applications gets the stream fd, it can use that to set stream id 
> for multiple files.
> - It can close the stream-fd and that does not change anything for the 
> file resource (i.e, its inode continue to carry the stream-id value that 
> was set).
> 
> Christoph - does this match?
> 
> Here are the revised names (suggestions?):
> 
> 1. FS_IOC_QUERY_MAX_WRITE_STREAM_IDS		_IOR('f', 135, __u32)
> 
> Returns (in __u32) number of supported stream-ids.
> 
> 2. FS_IOC_OPEN_WRITE_STREAM_ID			_IOWR('f', 136, struct 
> fs_write_stream_open)
> 
> Open the specific write-stream id (or any available one via a flag) and 
> return its FD. This gives right to use that stream-id.
> 
> And the following manage setting/clearing/querying write-stream on the file:
> 
> 3. FS_IOC_SET_FILE_WRITE_STREAM_BY_FD		_IOW('f', 137, __s32)
> 
> Sets a file's write-stream value (in inode) to whatever the stream fd 
> (passed as __s32) carries. So one never sets scalar values into a file 
> directly.
> 
> 4. FS_IOC_QUERY_FILE_WRITE_STREAM_ID		_IOR('f', 138, __u32)
> 
> Queries the write-stream value (__u32) currently assigned to the file 
> (its inode).
> 
> 5. FS_IOC_CLEAR_FILE_WRITE_STREAM_ID		_IO('f', 139)
> 
> To clear (zeroing) the write-stream value on the file's inode.
> 
> 
> > Can you extract the stream id from the fd that FS_IOC_WRITE_STREAM_OPEN
> > returns?
> 
> Can be done by implementing the ioctl handler for that stream fd, but 
> did not feel the need of it. Do you see the utility? If yes, name can 
> potentially be FS_IOC_QUERY_WRITE_STREAM_ID_FROM_FD.

Why not reuse FS_IOC_QUERY_FILE_WRITE_STREAM_ID?

--D
