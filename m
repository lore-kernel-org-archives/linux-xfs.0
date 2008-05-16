Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 03:40:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4GAeYCt012915
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 03:40:38 -0700
Date: Fri, 16 May 2008 06:41:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix inode list allocation size in writeback.
Message-ID: <20080516104121.GA28064@infradead.org>
References: <20080516100657.GV103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516100657.GV103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 16, 2008 at 08:06:57PM +1000, David Chinner wrote:
> We only need to allocate space for the number of inodes in
> the cluster when writing back inodes, not every byte in the
> inode cluster. This reduces the amount of memory needing to
> be allocated to 256 bytes instead of 64k.
> 
> Somebody pass me the brown paper bag, please.

Looks good, and I'll happily pass on my brown paper bag :)
