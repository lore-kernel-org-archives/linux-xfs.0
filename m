Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0P51UC8094433 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 23:01:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4EE11BAB008
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 21:00:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 12tomqzFBPOGosyV for
	<xfs@oss.sgi.com>; Sat, 24 Jan 2009 21:00:47 -0800 (PST)
Date: Sun, 25 Jan 2009 00:00:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs spec file update
Message-ID: <20090125050046.GB3979@infradead.org>
References: <1232777667.13684.20.camel@verge.scott.net.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1232777667.13684.20.camel@verge.scott.net.au>
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

On Sat, Jan 24, 2009 at 05:14:27PM +1100, Nathan Scott wrote:
> Since binaries have moved between xfsprogs and xfsdump packages
> in version 3.0.0, we need to fix the dependencies in the rpm
> specfiles, else rpm will complain.
> 
> While in there, remove xfs-cmds Provides/Obsoletes lines, there
> is no way anyone is ever going to be requiring those anymore (no
> real-world upgrade path having such old skool SGI-released rpms).

Looks good to me, even without any real uptodate rpm knowledge..

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
