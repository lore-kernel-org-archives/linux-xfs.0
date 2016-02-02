Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 81AEA7CB1
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 05:17:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1FB19AC002
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 03:17:47 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id H0rnzNFRzUOIDLr5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 03:17:42 -0800 (PST)
Date: Tue, 2 Feb 2016 12:17:40 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160202111740.GA28777@lst.de>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
	<20160129141232.GA43184@bfoster.bfoster>
	<20160201215407.GI20038@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160201215407.GI20038@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Feb 01, 2016 at 01:54:07PM -0800, Darrick J. Wong wrote:
> Also: I've noticed that if I write 8MB file to a file backed by a failing
> device, xfs_end_io_direct_write() gets called with size == 8MB even if the
> writes failed.  If the write was to an unwritten extent, the extent will be
> converted to a regular extent even though the blocks contain old file contents
> and other garbage, which can subsequently be read off the disk.
> 
> For CoW I'd only want to remap the blocks if the write totally succeeds.  If a
> disk error happens, the EIO code gets passed back to userspace, and it seems
> logical to me that the file contents should remain unchanged.
> 
> To that end, I'm changing dio_iodone_t to pass an error code, and I think I
> want to change XFS to avoid doing unwritten extent conversions when the write
> fails.  Does that make sense?

I have some of these patches prepared already, I'm just too busy keeping
up with all your changes.  I'll rebase and post this ASAP!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
