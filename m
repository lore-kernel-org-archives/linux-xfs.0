Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8D83FjC114553 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 03:03:15 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dnSBOjRMnsD7O14L (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Sep 2012 01:04:21 -0700 (PDT)
Date: Thu, 13 Sep 2012 04:04:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for August 2012
Message-ID: <20120913080420.GA9775@infradead.org>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

After the release of Linux 3.5 in July, August saw the big XFS merge for
the Linux 3.6 merge window.  In the meantime the XFS tree has seen low
activity, with refined support for SEEK_HOLE/SEEK_DATA that takes unwritten
extents into account as the main feature.  A couple of fixes also went in
and mostly got back ported to mainline for Linux 3.5 as well.

The mailing list had a lot of traffic about interesting updates that didn't
make it into the tree yet, with the most interesting being: remount support
for the inode64 option, a patch series allowing to trim back large
preallocations when the filesystem is out of space, and a large rewrite
of the XFS-internal sync code.

On the user land side xfs_db saw a fix for a very long standing bug go into
the tree and xfstests saw a few fixes.  The mailing list list saw various other
interesting updates including a German translation for the xfsdump messages,
32-bit project ID support in xfsdump, a lot of xfstests updates including a
patch to use the upstream util-linux version of fstrim in xfstests, support
for tmpfs in xfstests, various ext3 and btrfs updates, but none of them
made it into the git tree.  There also was a lot of discussion of older
patch to reorganize the xfstests source tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
