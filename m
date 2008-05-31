Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 31 May 2008 01:04:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4V844QZ008199
	for <xfs@oss.sgi.com>; Sat, 31 May 2008 01:04:04 -0700
Date: Sat, 31 May 2008 04:04:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: fix up xfs_repair I/O size for filesystems with >=
	16KB filesystem blocksize
Message-ID: <20080531080456.GA23803@infradead.org>
References: <op.ubwjeftu3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ubwjeftu3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, May 29, 2008 at 04:09:41PM +1000, Barry Naujok wrote:
> For 4KB block size filesystems (the default), inode chunks are read and 
> written
> in 8KB "clusters". With a 16KB block size (possible on ia64 boxes), the 
> inode
> chunks are read/written in 16KB I/Os (matches the filesystem block size).
>
> This patch fixes up the I/Os for filesystems with a blocksize greater than 
> 8KB.

Looks good.
