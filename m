Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2I8QPp0207175 for <xfs@oss.sgi.com>; Sun, 18 Mar 2012 03:26:25 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	c0qrwBkH4JXwG37A (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 18 Mar 2012 01:26:21 -0700 (PDT)
Date: Sun, 18 Mar 2012 04:26:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for February 2012
Message-ID: <20120318082619.GA28069@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

February has been been busy with development for Linux 3.3, although only
little new code made it to the development tree yet, mostly a refactor
of the log grant code.  Patch traffic on the mailing list included a rewrite
of disk quota caching, yielding dramatic performance improvements for systems
with lots of quotas, a series to make all inode updates and thus all live
metadata updates transactional.  Last but not least a version versions to
fix a long standing bug in support of the real time subvolume was posted,
showing that even this long deprecated feature still has a user base.

On the userspace side development has been quite, with just two fixes to
xfs_io committed to xfsprogs, while waiting for the long overdue 3.1.8
release.  Xfsdump has been entirely quite this month, again waiting for
a release, and xfstests saw only two commits either, although there are
still lots of outstanding patches on the list that haven't been reviewed
and/or applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
