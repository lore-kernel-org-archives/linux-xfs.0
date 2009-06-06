Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5659s6U088127 for <xfs@oss.sgi.com>; Sat, 6 Jun 2009 00:09:54 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 665652D81C0
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 22:10:12 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id kINJbCMyinVaDi4k for
	<xfs@oss.sgi.com>; Fri, 05 Jun 2009 22:10:12 -0700 (PDT)
Message-ID: <4A29FA34.5020809@sandeen.net>
Date: Sat, 06 Jun 2009 00:10:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Segmentation fault during xfs_repair
References: <20090605222236.GA39825@magus.portal.sigil.org>
	<4A29F415.5020203@sandeen.net>
In-Reply-To: <4A29F415.5020203@sandeen.net>
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
To: Richard Kolkovich <richard@intrameta.com>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:

> I'll have to ponder what repair should do in this case ... and I'll see
> if there's something we can do in xfs_db to just whack out this problem
> and let repair continue for now.
>
> -Eric
>
>   
This should get you over that hump I think:


--- xfsprogs-3.0.1.orig/repair/dir2.c	2009-06-06 00:01:10.711081870 -0500
+++ xfsprogs-3.0.1/repair/dir2.c	2009-06-06 00:05:52.993365954 -0500
@@ -353,6 +353,14 @@
 			}
 		}
 
+		if (i >= XFS_DA_NODE_MAXDEPTH) {
+			do_warn(_("bad header depth for directory inode %llu\n"),
+				da_cursor->ino);
+			da_brelse(bp);
+			i = -1;
+			goto error_out;
+		}
+
 		da_cursor->level[i].hashval =
 					be32_to_cpu(node->btree[0].hashval);
 		da_cursor->level[i].bp = bp;


but I have to say, that is one fried filesystem you've got there....

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
