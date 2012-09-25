Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8PFdHT1072451 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 10:39:17 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	Tu3yMridPTHAgK2F (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 08:40:34 -0700 (PDT)
Received: by obbun3 with SMTP id un3so2406131obb.26
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 08:40:34 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Sep 2012 11:40:33 -0400
Message-ID: <CAH4wwdG4j_53UYUtU-h3uwaqMOwDz+EsvXLojWKgCx5i7Ftndw@mail.gmail.com>
Subject: xfs_repair: enabling lazy sb counters
From: Peter Watkins <treestem@gmail.com>
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

Hello,

Has anyone noticed that phase1 updates the lazy count flag in the
superblock, and then writes out the sb before the traversal in phase5
counts btree blocks consumed and sets agf_btreeblks?

Seems like if xfs_repair is interrupted or crashes at the wrong time,
you'd have enabled lazy count but not set agf_btreeblks, which would
trigger the corruption check in xfs_alloc.c:xfs_read_agf().

If you just re-run xfs_repair to enable lazy counts, it would stop
early saying they're already enabled. You'd have to disable them, and
then enable again to get a consistent state.

Second, is it possible to enable lazy counts without doing the full
repair traversal, i.e. a cheap and easy way to set agf_btreeblks if
the fs is already consistent? On some systems, the whole repair
enchilada can take a long time!

Lazy counts are a great feature, and I'd like to enable them on some
older systems.

-Peter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
