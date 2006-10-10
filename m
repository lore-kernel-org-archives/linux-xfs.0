Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Oct 2006 16:32:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9ANWJaG017607
	for <xfs@oss.sgi.com>; Tue, 10 Oct 2006 16:32:21 -0700
Date: Wed, 11 Oct 2006 09:31:24 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Directories > 2GB
Message-ID: <20061010233124.GX11034@melbourne.sgi.com>
References: <20061004165655.GD22010@schatzie.adilger.int> <452AC4BE.6090905@xfs.org> <20061010015512.GQ11034@melbourne.sgi.com> <452B0240.60203@xfs.org> <20061010091904.GA395@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061010091904.GA395@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Steve Lord <lord@xfs.org>, David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Oct 10, 2006 at 10:19:04AM +0100, Christoph Hellwig wrote:
> On Mon, Oct 09, 2006 at 09:15:28PM -0500, Steve Lord wrote:
> > Hi Dave,
> > 
> > My recollection is that it used to default to on, it was disabled
> > because it needs to map the buffer into a single contiguous chunk
> > of kernel memory. This was placing a lot of pressure on the memory
> > remapping code, so we made it not default to on as reworking the
> > code to deal with non contig memory was looking like a major
> > effort.
> 
> Exactly.  The code works but tends to go OOM pretty fast at least
> when the dir blocksize code is bigger than the page size.  I should
> give the code a spin on my ppc box with 64k pages if it works better
> there.

The pagebuf code doesn't use high-order allocations anymore; it uses
scatter lists and remapping to allow physically discontiguous pages
in a multi-page buffer. That is, the pages are sourced via
find_or_create_page() from the address space of the backing device,
and then mapped via vmap() to provide a virtually contigous mapping
of the multi-page buffer.

So I don't think this problem exists anymore...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
