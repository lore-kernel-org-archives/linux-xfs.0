Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QMdDV2146175 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 17:39:14 -0500
Subject: Re: [PATCH 3/3] xfs: optimize the negative xattr caching
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110726150729.GC18000@infradead.org>
References: <20110726150633.GA17400@infradead.org>
	<20110726150729.GC18000@infradead.org>
Date: Tue, 26 Jul 2011 17:39:11 -0500
Message-ID: <1311719951.11557.15.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, 2011-07-26 at 11:07 -0400, Christoph Hellwig wrote:
> Since the addition of file capabilities every write needs to read xattrs to
> check if we have any capabilities to clear.  In Linux 3.0 Andi Kleen added
> a flag to cache the fact that we do not have any attributes on an inode.
> Make sure to already mark a file as not having any attributes when reading
> it from disk in case it doesn't even have an attribute fork.  Based on an
> earlier patch from Andi Kleen.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
