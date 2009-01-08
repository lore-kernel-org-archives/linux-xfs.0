Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08MnRUG015765 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 16:49:27 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFE8F71EAB
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 14:49:25 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	uIB7FAeWxRE36OtY for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 14:49:25 -0800 (PST)
Date: Fri, 9 Jan 2009 09:43:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: truncate readdir offsets to signed 32 bit values
Message-ID: <20090108224350.GJ9448@disturbed>
References: <20090108184222.244013000@bombadil.infradead.org>
	<20090108184430.165424000@bombadil.infradead.org>
	<20090108190000.GA8440@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090108190000.GA8440@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Thu, Jan 08, 2009 at 02:00:00PM -0500, Christoph Hellwig wrote:
> On Thu, Jan 08, 2009 at 01:42:24PM -0500, Christoph Hellwig wrote:
> > John Stanley reported EOVERFLOW errors in readdir from his self-build
> > glibc.  I traced this down to glibc enabling d_off overflow checks
> > in one of the about five million different getdents implementations.
> > 
> > In 2.6.28 Dave Woodhouse moved our readdir double buffering required
> > for NFS4 readdirplus into nfsd and at that point we lost the capping
> > of the directory offsets to 32 bit signed values.  Johns glibc used
> > getdents64 to even implement readdir for normal 32 bit offset dirents,
> > and failed with EOVERFLOW only if this happens on the first dirent in
> > a getdents call.  I managed to come up with a testcase that uses
> > raw getdents and does the EOVERFLOW check manually.  We always hit
> > it with our last entry due to the special end of directory marker.
> > 
> > The patch below is a dumb version of just putting back the masking,
> > to make sure we have the same behavior as in 2.6.27 and earlier.
> > 
> > I will work on a better and cleaner fix for 2.6.30.
> > 
> > Reported-by: John Stanley <jpsinthemix@verizon.net>
> > Tested-by: John Stanley <jpsinthemix@verizon.net>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> As arkem noticed I should not have sent out some half-mangled version
> but the first crude patch.  Here it is:

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
