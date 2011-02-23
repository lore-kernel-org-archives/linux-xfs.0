Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1N0mnTN008096 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 18:48:49 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D740D2DEE2E
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 16:51:33 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ksyq2ndYyAyBJ5Gm for <xfs@oss.sgi.com>;
	Tue, 22 Feb 2011 16:51:33 -0800 (PST)
Date: Wed, 23 Feb 2011 11:51:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: more sensible inode refcounting for ialloc
Message-ID: <20110223005131.GJ3166@dastard>
References: <20110213132642.GB18279@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110213132642.GB18279@infradead.org>
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

On Sun, Feb 13, 2011 at 08:26:42AM -0500, Christoph Hellwig wrote:
> Currently we return iodes from xfs_ialloc with just a single reference held.
> But we need two references, as one is dropped during transaction commit and
> the second needs to be transfered to the VFS.  Change xfs_ialloc to use
> xfs_iget plus xfs_trans_ijoin_ref to grab two references to the inode,
> and remove the now superflous IHOLD calls from all callers.  This also
> greatly simplifies the error handling in xfs_create and also allow to remove
> xfs_trans_iget as no other callers are left.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice. Good to get rid of the lock flags count hack xfs_trans_iget()
used.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
