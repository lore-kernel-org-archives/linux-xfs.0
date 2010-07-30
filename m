Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o590JtAd031899 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 19:19:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B58B61665ED4
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 00:57:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Rzjhi0Zks2YNgEK3 for
	<xfs@oss.sgi.com>; Fri, 30 Jul 2010 00:57:49 -0700 (PDT)
Date: Fri, 30 Jul 2010 03:57:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100730075746.GA20444@infradead.org>
References: <20100726034545.GE655@dastard>
	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
	<20100726060604.GF7362@dastard>
	<F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>
	<20100726102036.GH7362@dastard>
	<0EC8FE5D-212C-4030-9D59-FDF38DF4E9EE@ucsc.edu>
	<D6C570D6-FEC7-4E3C-AAC2-13275721370A@ucsc.edu>
	<20100729230147.GN655@dastard>
	<04349CE2-CF8B-463C-8B06-5E4E59E869B2@ucsc.edu>
	<20100730091554.2c9ca1ec@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100730091554.2c9ca1ec@galadriel.home>
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
Cc: Eli Morris <ermorris@ucsc.edu>, xfs@oss.sgi.com

On Fri, Jul 30, 2010 at 09:15:54AM +0200, Emmanuel Florac wrote:
> > Is that something I could do now, or only when the filesystem is
> > created? If I mount it with '-o inode64', can I mount it without that
> > later, or once I write to the filesystem like that, can I not go back
> > to mounting it in 32 bit mode? 
> 
> You use inode64 at mount, however there is no return. Once you have
> used a filesystem with "inode64", you must use it always.

Recent enough kernel work fine with filesystems that inode64 was used
on even if it's not specified anymore.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
