Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n068MF0D030715 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 02:22:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D105649AF
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 00:22:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rSncQGvyXB49xRmE for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2009 00:22:14 -0800 (PST)
Date: Tue, 6 Jan 2009 03:22:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] define xfs_ino_t as unsigned long long
Message-ID: <20090106082214.GA635@infradead.org>
References: <20090105193129.GA19909@infradead.org>
	<20090106011414.GB9448@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090106011414.GB9448@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jan 06, 2009 at 12:14:14PM +1100, Dave Chinner wrote:
> On Mon, Jan 05, 2009 at 02:31:29PM -0500, Christoph Hellwig wrote:
> > That way we can avoid ugly casts when printining it (like the ones
> > that show up on powerpc with Linus' current tree).
> 
> Is that because ppc uses int-l64.h instead of int-64ll.h and so __64 gets
> defined to an unsigned long on that platform?

Yes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
