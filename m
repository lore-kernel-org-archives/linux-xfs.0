Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Oct 2006 03:51:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9AApKaG004851
	for <xfs@oss.sgi.com>; Tue, 10 Oct 2006 03:51:21 -0700
Date: Tue, 10 Oct 2006 10:19:04 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Directories > 2GB
Message-ID: <20061010091904.GA395@infradead.org>
References: <20061004165655.GD22010@schatzie.adilger.int> <452AC4BE.6090905@xfs.org> <20061010015512.GQ11034@melbourne.sgi.com> <452B0240.60203@xfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <452B0240.60203@xfs.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Steve Lord <lord@xfs.org>
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Oct 09, 2006 at 09:15:28PM -0500, Steve Lord wrote:
> Hi Dave,
> 
> My recollection is that it used to default to on, it was disabled
> because it needs to map the buffer into a single contiguous chunk
> of kernel memory. This was placing a lot of pressure on the memory
> remapping code, so we made it not default to on as reworking the
> code to deal with non contig memory was looking like a major
> effort.

Exactly.  The code works but tends to go OOM pretty fast at least
when the dir blocksize code is bigger than the page size.  I should
give the code a spin on my ppc box with 64k pages if it works better
there.
