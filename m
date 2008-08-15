Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Aug 2008 15:39:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7FMdTAA024607
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2008 15:39:30 -0700
Date: Fri, 15 Aug 2008 18:40:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] Prevent direct I/O from mapping extents beyond eof
Message-ID: <20080815224047.GA15914@infradead.org>
References: <48A50152.8020104@sgi.com> <20080815220958.GB13770@infradead.org> <20080815152756.61aab5a7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815152756.61aab5a7.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, lachlan@sgi.com, xfs-dev@sgi.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Fri, Aug 15, 2008 at 03:27:56PM -0700, Andrew Morton wrote:
> Oh gee, I forget, and so many people have done drivebys on that code...
> 
> We _could_ add additional i_size checking into direct-io.c but bear in
> mind that it would be best-effort unreliable stuff.  The code will
> still be tripped up by concurrent extends and concurrent truncates.
> 
> So we'll still end up calling the fs for blocks outside i_size, only
> less commonly.  I think.

Yeah, guess we should put in this patch then.
