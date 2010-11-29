Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATEslwY176665 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 08:54:47 -0600
Date: Mon, 29 Nov 2010 09:56:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 4/9] xfsrestore: mmap dirent names for faster lookups
Message-ID: <20101129145627.GB22839@infradead.org>
References: <20101119183837.GA9505@sgi.com>
	<20101123134818.GA31206@infradead.org> <4CF3B875.3020701@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CF3B875.3020701@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 08:28:05AM -0600, Bill Kendall wrote:
> There are several modules in xfsrestore which map files. None of them
> currently contain a destructor/cleanup function for unmapping the files.
> It would be a good change to make though.

If keeping it mapped later it's fine with me.  So ACK from me for the
whole series.

Alex, maybe it's time to push out another xfsdump release after this?
There's quite a few changes that have accumulated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
