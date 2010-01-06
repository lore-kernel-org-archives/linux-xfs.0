Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06I8kgX101382 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 12:08:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5334ED82F3
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 10:09:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hCE0XxyXlFk94DMR for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2010 10:09:38 -0800 (PST)
Date: Wed, 6 Jan 2010 13:09:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: NFS export broke with change from ext3 to xfs
Message-ID: <20100106180938.GB9613@infradead.org>
References: <1262652500.24160.27.camel@oxygen.netxsys.com>
	<20100105174332.GA14496@infradead.org>
	<20100105213714.5b9b2a11@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100105213714.5b9b2a11@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 05, 2010 at 09:37:14PM +0100, Emmanuel Florac wrote:
> Le Tue, 5 Jan 2010 12:43:32 -0500 vous ?criviez:
> 
> > Remove the inode64 mount option or move every export to a separate
> > filesystem.  The NFS code can't cope with 64 bit inode numbers when
> > exporting a subtree of a filesystem.  You'd see the same issue with
> > e.g. ocfs2 or gfs2.
> 
> Does the kernel architecture (32 or 64 bits) have any influence there?

Unfortunately not.  But if you specify a uuid in the /etc/exports
file it should use a different filesystem handle format that has space
for 8 byte inode numbers.  I'm not entirely sure how nfsutils selects
them - it's been a while since I dealt with that code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
