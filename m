Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B10577FC1
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 04:48:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 822FC8F8039
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 02:48:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hm49mpCm5fGrkyNf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 02:48:23 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v5 04/11] xfsprogs: Add ifdef dirent checks where it was
	missing
Date: Wed,  5 Aug 2015 11:48:15 +0200
Message-Id: <1438768095-389-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1438680314-23950-1-git-send-email-jtulak@redhat.com>
References: <1438680314-23950-1-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

CHANGED: text width fix

Add check for _DIRENT_HAVED_RECLEN/_OFF to read_directory().
In dump_dirent() these checks already are used, but they were
missing in read_directory.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 io/readdir.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/io/readdir.c b/io/readdir.c
index 7b0edbc..151b72e 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -103,12 +103,24 @@ read_directory(
 		if (!dirent)
 			break;
 
+#ifdef _DIRENT_HAVE_D_RECLEN
 		*total += dirent->d_reclen;
+#else
+		*total += dirent->d_namlen + sizeof(*dirent);
+#endif
 		count++;
 
 		if (dump) {
 			dump_dirent(offset, dirent);
+#ifdef _DIRENT_HAVE_D_OFF
 			offset = dirent->d_off;
+#else
+			/* Some platforms don't have dirent->d_off, but because
+			 * it is used only for dumping the value, it should be
+			 * safe to only set it to zero in such case.
+			 */
+			offset = 0;
+#endif
 		}
 	}
 
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
