Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B39E17FA8
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 04:25:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E7F0AC001
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 02:25:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ga6KZBcP5Fzx8w7p (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 02:25:23 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v4 04/11] xfsprogs: Add ifdef dirent checks where it was
	missing
Date: Tue,  4 Aug 2015 11:25:14 +0200
Message-Id: <1438680314-23950-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1438612789-17486-5-git-send-email-jtulak@redhat.com>
References: <1438612789-17486-5-git-send-email-jtulak@redhat.com>
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

Add check for _DIRENT_HAVED_RECLEN/_OFF to read_directory().
In dump_dirent() these checks already are used, but they were
missing in read_directory.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 io/readdir.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/io/readdir.c b/io/readdir.c
index 20b8898..ddd62c9 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -104,12 +104,24 @@ read_directory(
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
+			/* Some platforms don't have dirent->d_off, but because it is
+			 * used only for dumping the value, it should be safe to only
+			 * set it to zero in such case.
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
