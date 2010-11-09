Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9Bvmef152418 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 05:57:48 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CE134CD418
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 03:59:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	YK7FFxLfbZQeAqrI for <xfs@oss.sgi.com>;
	Tue, 09 Nov 2010 03:59:14 -0800 (PST)
Date: Tue, 9 Nov 2010 22:59:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add test for renaming over non-empty directories
Message-ID: <20101109115911.GL2715@dastard>
References: <20101028115224.GA1429@infradead.org>
	<20101109113459.GB21237@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109113459.GB21237@infradead.org>
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

On Tue, Nov 09, 2010 at 06:34:59AM -0500, Christoph Hellwig wrote:
> ping?
> 
> On Thu, Oct 28, 2010 at 07:52:24AM -0400, Christoph Hellwig wrote:
> > Per Posix renames over non-empty directories should fail, but hfsplus used to
> > allow this (and corrupt the filesystem while doing so).
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>

looks OK to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
