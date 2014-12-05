Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 123B17F3F
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2014 14:30:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6A74304048
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2014 12:30:21 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MCCdybfGvb0V502I for <xfs@oss.sgi.com>;
	Fri, 05 Dec 2014 12:30:16 -0800 (PST)
Message-ID: <548215D6.5020804@sandeen.net>
Date: Fri, 05 Dec 2014 14:30:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: do not check symlink component lengths
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, Andy Grimm <agrimm@redhat.com>

As reported by Andy Grimm,

# ln -s $( python -c 'print "a" * 260' ) /mnt/foo

will succeed on xfs, but then xfs_repair will complain:

component of symlink in inode 131 too long
problem with symbolic link in inode 131
would have cleared inode 131

The kernel checks the total length of the symlink on both read
and write, but does not look at component paths.

Looking around the kernel, no other filesystem checks component
lengths, nor does the vfs.  And as Andy points out, the target
could even be on a different filesystem, with different limitations.

And having a "too-long" component doesn't even seem like something
likely to stem from disk corruption anyway, so I'm not sure why repair
should care.

Therefore I propose removing the component length checks from xfs_repair.

Andy Grimm <agrimm@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dinode.c b/repair/dinode.c
index 38a6562..73e4b9e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1333,7 +1333,7 @@ process_symlink(
 	xfs_dinode_t	*dino,
 	blkmap_t 	*blkmap)
 {
-	char			*symlink, *cptr;
+	char			*symlink;
 	char			data[MAXPATHLEN];
 
 	/*
@@ -1380,31 +1380,6 @@ _("found illegal null character in symlink inode %" PRIu64 "\n"),
 		return(1);
 	}
 
-	/*
-	 * check for any component being too long
-	 */
-	if (be64_to_cpu(dino->di_size) >= MAXNAMELEN)  {
-		cptr = strchr(symlink, '/');
-
-		while (cptr != NULL)  {
-			if (cptr - symlink >= MAXNAMELEN)  {
-				do_warn(
-_("component of symlink in inode %" PRIu64 " too long\n"),
-					lino);
-				return(1);
-			}
-			symlink = cptr + 1;
-			cptr = strchr(symlink, '/');
-		}
-
-		if (strlen(symlink) >= MAXNAMELEN)  {
-			do_warn(
-_("component of symlink in inode %" PRIu64 " too long\n"),
-				lino);
-			return(1);
-		}
-	}
-
 	return(0);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
