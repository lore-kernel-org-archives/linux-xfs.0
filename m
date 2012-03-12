Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CGEUDL105186 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 11:14:31 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FybAG08nZEbRUNLO (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 09:14:29 -0700 (PDT)
Date: Mon, 12 Mar 2012 12:14:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 3.2.9 and locking problem
Message-ID: <20120312161425.GA23815@infradead.org>
References: <201203092028.47177.arekm@maven.pl> <20120312005325.GX5091@dastard>
	<201203121443.59217.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201203121443.59217.arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

In the 3.2 version xfs_sync_flags does a double unlock of the ilock -
change the last argument of xfs_trans_ijoin from XFS_ILOCK_EXCL to 0
will fix this.  The 3.0 version doesn't have this bug.

And btw, the additions to the on-disk format are gross - this stuff
broke before and will break again when we add new features.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
