Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F24237F4E
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:57:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D24618F8040
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:57:24 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id S8NfZfg7yVCODgpA for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:57:22 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 7/9] xfsdump: free allocated persistent paths
Date: Wed, 12 Nov 2014 12:57:16 -0600
Message-Id: <1415818638-32700-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

"perspath" gets allocated by open_pathalloc, and haphazardly
freed at best; almost never on errors, often not on success.

While we're in there, fix a few leaked fd's as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 restore/content.c |    2 ++
 restore/inomap.c  |   11 +++++++++++
 restore/tree.c    |    9 +++++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index cfcf94d..c99aed7 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -1342,6 +1342,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 		      "could not open/create persistent state file %s: %s\n"),
 		      perspath,
 		      strerror( errno ));
+		free(perspath);
 		return BOOL_FALSE;
 	}
 
@@ -1356,6 +1357,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
 		      "could not map persistent state file hdr %s: %s\n"),
 		      perspath,
 		      strerror( errno ));
+		free(perspath);
 		return BOOL_FALSE;
 	}
 
diff --git a/restore/inomap.c b/restore/inomap.c
index 562492e..1976017 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -217,6 +217,7 @@ inomap_restore_pers( drive_t *drivep,
 		      "could not open %s: %s\n"),
 		      perspath,
 		      strerror( errno ));
+		free(perspath);
 		return RV_ERROR;
 	}
 
@@ -233,6 +234,8 @@ inomap_restore_pers( drive_t *drivep,
 		      "unable to map %s: %s\n"),
 		      perspath,
 		      strerror( errno ));
+		close(fd);
+		free(perspath);
 		return RV_ERROR;
 	}
 
@@ -363,6 +366,7 @@ inomap_sync_pers( char *hkdir )
 	perspath = open_pathalloc( hkdir, PERS_NAME, 0 );
 	pers_fd = open( perspath, O_RDWR );
 	if ( pers_fd < 0 ) {
+		free(perspath);
 		return BOOL_TRUE;
 	}
 
@@ -377,6 +381,8 @@ inomap_sync_pers( char *hkdir )
 		      "unable to map %s hdr: %s\n"),
 		      perspath,
 		      strerror( errno ));
+		close(pers_fd);
+		free(perspath);
 		return BOOL_FALSE;
 	}
 
@@ -398,9 +404,14 @@ inomap_sync_pers( char *hkdir )
 		      "unable to map %s: %s\n"),
 		      perspath,
 		      strerror( errno ));
+		close(pers_fd);
+		free(perspath);
 		return BOOL_FALSE;
 	}
 
+	close(pers_fd);
+	free(perspath);
+
 	/* correct the next pointers
 	 */
 	for ( hnkp = roothnkp
diff --git a/restore/tree.c b/restore/tree.c
index 21d3880..011fa44 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -420,6 +420,7 @@ tree_init( char *hkdir,
 		      "could not open %s: %s\n"),
 		      perspath,
 		      strerror( errno ));
+		free(perspath);
 		return BOOL_FALSE;
 	}
 
@@ -435,6 +436,7 @@ tree_init( char *hkdir,
 		      "unable to map %s: %s\n"),
 		      perspath,
 		      strerror( errno ));
+		free(perspath);
 		return BOOL_FALSE;
 	}
 
@@ -443,9 +445,12 @@ tree_init( char *hkdir,
 	 */
 	ok = hash_init( vmsz / HASHSZ_PERVM, dircnt, nondircnt, perspath );
 	if ( ! ok ) {
+		free(perspath);
 		return BOOL_FALSE;
 	}
 
+	free(perspath);
+
 	/* initialize the node abstraction. let it's use of backing store
 	 * begin immediately after the hash abstraction. give it the remainder
 	 * of vm.
@@ -595,6 +600,7 @@ tree_sync( char *hkdir,
 		      "could not open %s: %s\n"),
 		      perspath,
 		      strerror( errno ));
+		free(perspath);
 		return BOOL_FALSE;
 	}
 
@@ -610,6 +616,7 @@ tree_sync( char *hkdir,
 		      "unable to map %s: %s\n"),
 		      perspath,
 		      strerror( errno ));
+		free(perspath);
 		return BOOL_FALSE;
 	}
 
@@ -632,9 +639,11 @@ tree_sync( char *hkdir,
 	 */
 	ok = hash_sync( perspath );
 	if ( ! ok ) {
+		free(perspath);
 		return BOOL_FALSE;
 	}
 
+	free(perspath);
 	/* synchronize with the node abstraction.
 	 */
 	ASSERT( persp->p_hashsz <= ( size64_t )( OFF64MAX - ( off64_t )PERSSZ));
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
