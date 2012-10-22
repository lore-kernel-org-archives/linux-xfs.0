Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9MKMZeG137285 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 15:22:35 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vUG6fqHR0CBa3sB1 for
	<xfs@oss.sgi.com>; Mon, 22 Oct 2012 13:24:18 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9MKOHlG004122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 16:24:18 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q9MKOG0x002778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 16:24:17 -0400
Message-ID: <5085AB70.2060904@redhat.com>
Date: Mon, 22 Oct 2012 15:24:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsdump: Revert dump version bump for 32bit projid fix
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
To: xfs-oss <xfs@oss.sgi.com>

commit 1e309da7a4f7e2a2f456bf6b7cea4c5f1181cd36 fixed xfsdump to
properly save & restore the top 16 bits of a 32-bit projid, which
otherwise was being dropped (and restored as 0) in older xfsdump.

The original thought was to bump the dump version, so that we know
whether the dump (may) have the top 16 bits filled in.  In practice
this would prevent older restores from restoring newer dumps, and
losing the top 16 bits contained in these newer dumps.

However, in hindsight this appears to be of limited value.  I
propose that the dump version change is unuseful/unwanted for a
couple reasons:

* There is no actual dump *format* change; the structure size
  is the same, and the top 16 bits were properly zeroed before; old
  restores will read these fixed dumps without problems and without
  restoring garbage.  IOW, they will behave exactly as buggily as
  they did before.  And worst case, if a dump containing the top 16
  bits is mangled by an old restore, this can be easily remedied by
  simply re-restoring with updated userspace.

* We have no reliable method to know whether 32 bit project IDs are
  in use; the feature flag was not added to the GEOM call at the time
  of implementation.  Therefore we cannot reliably bump to V4 only
  for projid32bit filesystems, and we cannot restrict V4 restores
  only to projid32bit filesystems.  So the dump version is not
  useful for feature cross-checking purposes.

I spoke with wkendall via email, and although he may not have given
it the most scrutiny (having moved on from xfsdump-land), he also
felt that a version dump may not be warranted.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/global.c b/common/global.c
index 1793ff4..8e49d8b 100644
--- a/common/global.c
+++ b/common/global.c
@@ -281,7 +281,6 @@ global_version_check( u_int32_t version )
 		case GLOBAL_HDR_VERSION_1:
 		case GLOBAL_HDR_VERSION_2:
 		case GLOBAL_HDR_VERSION_3:
-		case GLOBAL_HDR_VERSION_4:
 			return BOOL_TRUE;
 		default:
 			return BOOL_FALSE;
diff --git a/common/global.h b/common/global.h
index 5138ed8..6556a68 100644
--- a/common/global.h
+++ b/common/global.h
@@ -28,15 +28,13 @@
 #define GLOBAL_HDR_VERSION_1	1
 #define GLOBAL_HDR_VERSION_2	2
 #define GLOBAL_HDR_VERSION_3	3
-#define GLOBAL_HDR_VERSION_4	4
-	/* version 4 adds 32-bit projid (projid_hi)
-	 * version 3 uses the full 32-bit inode generation number in direnthdr_t.
+	/* version 3 uses the full 32-bit inode generation number in direnthdr_t.
 	 * version 2 adds encoding of holes and a change to on-tape inventory format.
 	 * version 1 adds extended file attribute dumping.
 	 * version 0 xfsrestore can't handle media produced
 	 * by version 1 xfsdump. 
 	 */
-#define GLOBAL_HDR_VERSION	GLOBAL_HDR_VERSION_4
+#define GLOBAL_HDR_VERSION	GLOBAL_HDR_VERSION_3
 
 #define GLOBAL_HDR_STRING_SZ	0x100
 #define GLOBAL_HDR_TIME_SZ	4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
