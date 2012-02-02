Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12GGW93061707 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 10:16:32 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	kwgL44j8OgepYyYM (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 08:16:31 -0800 (PST)
Message-Id: <20120202161409.303465214@bombadil.infradead.org>
Date: Thu, 02 Feb 2012 11:14:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] include reservations in quota reporting
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jack@suse.cz

This series makes sure quota reporting through quotactl, or in case of
project quotas, statfs includes quota reservation in addition to the
on-disk values.  This fixes xfstests 270, which has been failing on XFS
since it was added, and makes the Q_XQUOTASYNC quotactl command that
xfs_quota uses to flush delalloc space redundant.

Jan, the last patch touches common quota code, but it's only relevant
to XFS - I'd like to put it in through the XFS tree if possible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
