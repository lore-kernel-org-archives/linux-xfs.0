Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 43EF07F60
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:40:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30D64304066
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 07:40:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aYCRe58BXQkz8vXS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 07:40:26 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v3 04/11] xfsprogs: Add ifdef dirent checks where it was
	missing
Date: Mon,  3 Aug 2015 16:39:42 +0200
Message-Id: <1438612789-17486-5-git-send-email-jtulak@redhat.com>
In-Reply-To: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
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
 io/readdir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io/readdir.c b/io/readdir.c
index 20b8898..ed8f04d 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -104,12 +104,16 @@ read_directory(
 		if (!dirent)
 			break;
 
+#ifdef _DIRENT_HAVE_D_RECLEN
 		*total += dirent->d_reclen;
+#endif
 		count++;
 
 		if (dump) {
 			dump_dirent(offset, dirent);
+#ifdef _DIRENT_HAVE_D_OFF
 			offset = dirent->d_off;
+#endif
 		}
 	}
 
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
