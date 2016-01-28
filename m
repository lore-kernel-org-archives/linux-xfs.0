Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1EE287CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 16:03:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3571AC001
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 14:02:58 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id hmZP4fFZFCQtTsGQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 14:02:56 -0800 (PST)
Date: Thu, 28 Jan 2016 23:02:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160128220255.GA28202@lst.de>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
	<20160128205333.GF20038@birch.djwong.org>
	<20160128211056.GA27287@lst.de>
	<20160128215853.GC6431@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160128215853.GC6431@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

On Thu, Jan 28, 2016 at 01:58:53PM -0800, Darrick J. Wong wrote:
> Aw, snap, I knew I'd forgotten something.  Yep, we'll need that... I think
> xfs_end_io_direct_write will have to sniff out the error status from "size"
> and either remap or discard the CoW allocations as appropriate.

I'd rather fix the direct I/O code to give us that information directly
(pun intended).  I'll add that to my short term todo list as it seems
useful for the existing code as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
