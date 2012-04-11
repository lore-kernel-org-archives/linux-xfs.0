Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3BJxMac105768 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 14:59:23 -0500
Date: Wed, 11 Apr 2012 15:59:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't fill statvfs with project quota for a
	directory if it was not enabled.
Message-ID: <20120411195915.GA28816@infradead.org>
References: <4F77DFDB.1040802@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F77DFDB.1040802@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

Sorry for taking so long to get back to this, but conferences and work
kept me really busy the last two weeks.

> -	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
> -	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
> -			      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
> -		xfs_qm_statvfs(ip, statp);

I thjink the correct fix here is to replace the || between the inode
flag and quota flag check with and && - we want both the above
conditions to be true.  Can you respin the patch by doing that and make
sure it still passes the test case?  I'd like to send it of to -stable
ASAP.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
