Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0EA376BE8;
	Thu, 11 Jun 2026 10:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781172328; cv=none; b=sv4+7C2BZirDi/tIeLiHcyfcbQ+gez5Rmn/GzBtrdF+DPEjUecuIfc2HNSsv2YoaRahiSs9jN9zGVbTHhkDNw7Qh+ZvWoLYgYSXwPd+kajzj5Gn96YSb27ScmVJrUScJU4D9X0uC/3lYKR0bgKa1xZh4NuuB2wB6cV/N7/3teO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781172328; c=relaxed/simple;
	bh=slkSgqvlvaokGL2aQqREVszt5Yca5ISJw/S6ugNEyBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BRO94av/s3gwBE7Tki+pfCtp+iKjVjy5Y92Y5p7mOl9ci4LWhldYO2VNlN+fPFcdtIgv4k7ETMXQTYSwaeMxhV51c3uKcsDd0COGI646wHz2zM8YiKfUzfs3RL/9Q0WX8Xx/SXttlFF4vBQTj2pYgqsMz0Uv8QLGHWYR5Lj656E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PH6lPKSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PH6lPKSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505791F00893;
	Thu, 11 Jun 2026 10:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781172327;
	bh=G1wrc7bULXcsUx3is2pOZWD0oQ3p8AYlULlCrIY/zqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PH6lPKSuwE9w0QX3PbCxw3gca69PTX76fniZ7oOlqJp8H/rIbvZg/xKmzRFXZcBWx
	 MF+4eC68fSehCu2M9nVR+DZW98ucpnO1nKI3+W5czuC3N5pFdqoegRtfQojYqu1kpB
	 8S3lN8dmFQvwqxNyG0gCtZJwcbYJAuCr5E20KzIiPyQIBUkwoBuehWqrj1koYuoVUq
	 TYr4qDFogrD7FVS+VooUO2MBeTvcNxLFpx5huWkVfAHNEEJzcmRErca/E/kaLagrJo
	 vZUEIR2owfZ46jH7CW/N8nuoYO/o/gFP4xVaPR/raYhCsy5mXe6aHdGGvimhpt+r8o
	 xgvFYDnu8cN/g==
Date: Thu, 11 Jun 2026 12:05:22 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] iomap: enforce DIO alignment check in iomap
Message-ID: <aiqBvF93P4NjfaDR@nidhogg.toxiclabs.cc>
References: <20260610145218.141369-1-cem@kernel.org>
 <20260611055744.GA18538@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611055744.GA18538@lst.de>

On Thu, Jun 11, 2026 at 07:57:44AM +0200, Christoph Hellwig wrote:
> On Wed, Jun 10, 2026 at 04:52:11PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > The DIO alignment check has been lifted from iomap layer to rely on the
> > block layer to enforce proper alignment when issuing direct IO
> > operations. This though, depending on the IO size and buffer address
> > passed to the IO operation may lead to user-visible behavior change.
> > 
> > This has been caught initially by LTP test diotest4 running on
> > PPC architecture, where the test fails because a read() operation
> > with a supposedly misaligned buffer succeeds instead of an expected
> > -EINVAL.
> > This has no direct relationship with PPC, but seems to do with the
> > IO size crossing page borders or not.
> 
> I don't understand the problem here.  Why do we want to insist on a
> failure when we can support it?  I think the test is just broken.

The problem I see here from my POV is this changed the behavior expected
from the syscalls when the passed in buffer is misaligned as the read()
(in the test) succeeds when the passed in buffer does not match the
alignment requirements (see below).

I am pretty happy in declaring this a test bug, but I thought it would be
worth starting a discussion about the sudden/unexpected behavior change.
Not to mention now different filesystems will have different alignment
requirements which seems at least "weird" to me. I mean, now suddenly
iomap-based filesystems have a more relaxed alignment constraint than
for example btrfs.

> 
> > The problematic behavior is reproducible on x86 by reducing the IO size
> > to something < PAGE_SIZE, so the misaligned read()s will also be accepted
> > by the block layer.
> 
> What do you mean with misaligned here?  For a long time the kernel
> supports basically arbitrary low memory alignment for diret I/O,
> just bounded by the device capabilities (typical 4 byte alignment).

The test sends to read() a buffer misplaced by 1 byte (see below) which
doesn't match the system's alignment constraints at least from the user
passed buffer perspective.
I've been assuming it should match device's dma_alignment constraints.
The typical 4 byte alignment indeed is the requirement from my PPC
machine, but not for my x86:

> 
> The supported memory alignment is reported in the statx
> dio_mem_align.  What does that say compared to the alignment
> expectations in this test?

From my x86:
dio_mem_align: 512
dio_offset_align: 512

From PPC:
dio_mem_align: 4
dio_offset_align: 512

But this does not explain how the following call would succeed in either
case (below one taken from PPC):

openat(dirfd=AT_FDCWD, pathname="testdata-4.135256", flags=O_RDWR|O_DIRECT) = 3
_llseek(fd=3, offset=4096, result=[4096], whence=SEEK_SET) = 0
read(arg1=0x3, arg2=0x1003af80001, arg3=0x1000) = 0x1000

The passed in address 0x1003af80001 is one byte misaligned and shouldn't
(at least in theory) ever be accepted no? Or am I missing something
else?

