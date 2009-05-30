Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4U3DVLt109339 for <xfs@oss.sgi.com>; Fri, 29 May 2009 22:13:31 -0500
Received: from alopias.GreenKey.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDE91102D788
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 20:19:54 -0700 (PDT)
Received: from alopias.GreenKey.net (alopias.GreenKey.net [209.209.60.60]) by
	cuda.sgi.com with ESMTP id l3AvsaOyJzMJbUjx for
	<xfs@oss.sgi.com>; Fri, 29 May 2009 20:19:54 -0700 (PDT)
Date: Fri, 29 May 2009 20:13:43 -0700 (PDT)
From: Curtis Doty <Curtis@GreenKey.net>
Subject: xfs full when not
MIME-Version: 1.0
Message-Id: <20090530031344.E7A146F0B9@alopias.GreenKey.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS <xfs@oss.sgi.com>

I had a lone 795G xfs "fill up" prematurely at 89% blocks and 28% inodes. 
It was built/running under 32-bit OS, and I rebuilt OS 64-bit but the 
problem persisted.

Just for fun, I moved off and back on about 50K files with old ctimes from 
early in the fs life. This actually kinda worked. But I was only able to 
populate and addtional 10K new files before it hit the roof again.

An xfs_repair produced no change in behavior.

meta-data=/dev/cciss/c1d0p3      isize=2048   agcount=33, agsize=6509200 blks
          =                       sectsz=512   attr=1
data     =                       bsize=4096   blocks=208294773, imaxpct=50
          =                       sunit=16     swidth=16 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=8192, version=1
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0

As you can see, it was setup with 2K inodes. The imaxpct was originally 
at 25% but I raised it and the problem still occurs at 50%.

I can't even get it to reproduce the behavior Eric reported previously: 
http://oss.sgi.com/archives/xfs/2005-02/msg00325.html

../C

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
