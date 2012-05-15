Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FI5f0i203142 for <xfs@oss.sgi.com>; Tue, 15 May 2012 13:05:42 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ukuCxMc9bat5q4kS (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 May 2012 11:05:40 -0700 (PDT)
Date: Tue, 15 May 2012 20:05:21 +0200
From: Jan Kara <jack@suse.cz>
Subject: Test 274 in xfstests
Message-ID: <20120515180521.GE26579@quack.suse.cz>
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
To: wu.bo@cn.fujitsu.com
Cc: xfs@oss.sgi.com

  Hello,

  test 274 fails e.g. for ext3 because it does not support fallocate(). So
I would think the best way to fix the is to add to the test
  _require_xfs_io_falloc()
so that the test is run only for filesystems which do support fallocate.
But with that is connected one slightly related question - why does the
test use fallocate(1) binary instead of "xfs_io falloc" command which is
more common in xfstests?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
