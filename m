Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB99NCq8011518 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 03:23:12 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2482822E0
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2008 01:23:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id S4046OTVFxTWqfZI for
	<xfs@oss.sgi.com>; Tue, 09 Dec 2008 01:23:12 -0800 (PST)
Date: Tue, 9 Dec 2008 04:22:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Fwd: [PATCH] Fix race in xfs_write() between direct and
	buffered I/O with DMAPI]
Message-ID: <20081209092240.GA23915@infradead.org>
References: <493779B1.3010703@sgi.com> <20081208225125.GA15647@infradead.org>
	<493DFDBD.7060909@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <493DFDBD.7060909@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 09, 2008 at 04:10:21PM +1100, Lachlan McIlroy wrote:
> Thanks for looking at this Christoph.
> 
> I'm not sure what you mean by duplicating the checks.  I assume you
> mean this check:
> 
> 		if (!need_i_mutex && (mapping->nrpages || pos > xip->i_size)) {
> 			xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
> 			iolock = XFS_IOLOCK_EXCL;
> 			need_i_mutex = 1;
> 			mutex_lock(&inode->i_mutex);
> 			xfs_ilock(xip, XFS_ILOCK_EXCL|iolock);
> 			goto start;
> 		}

Yes.

> This check is there because the default case for direct I/O is to
> acquire the iolock in shared mode.  If we have work to do which
> requires the iolock to be held exclusive then drop the lock and get
> it again.  Since we dropped the lock then restart.
> 
> In the dmapi post-write event it doesn't matter if we have the
> iolock shared or exclusive - it will be dropped regardless so I
> don't see how checking the state of the iolock will allow us to
> avoid a restart.

All very true, but it doesn't matter :)  When you do the goto start
after the dmapi post event you will run through the above check anyway,
and take the lock exclusive even if you don't need it.  By doing
the check right after the dmapi even you only run through the sequence
of checks leading to the above one guaranteed once, instead of
potentially twice (in addition to the initial once or twice before the
dmapi event).  Alternatively you could also have a flag that sais don't
bother with taking the lock exclusive that gets set after the dmapi
nospace even code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
