Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A1D5E29E01
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:02:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39E7BAC001
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:02:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UaFEVvAbZdfyzEPQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:02:54 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 10/11] xfsprogs: add dummy mntent for OS X
Date: Wed, 26 Aug 2015 14:02:34 +0200
Message-Id: <1440590555-20463-10-git-send-email-jtulak@redhat.com>
In-Reply-To: <1440590555-20463-1-git-send-email-jtulak@redhat.com>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
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

Because these calls are used only by xfs_fsr, which can't
work on OS X unless a way how to mount XFS is found,
there is not use in implementing these calls.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index c8fcb3c..d47c96c 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -244,6 +244,41 @@ struct statvfs64
 	int __f_spare[6];
 };
 
+struct mntent
+{
+	char *mnt_fsname;		/* Device or server for filesystem.  */
+	char *mnt_dir;		/* Directory mounted on.  */
+	char *mnt_type;		/* Type of filesystem: ufs, nfs, etc.  */
+	char *mnt_opts;		/* Comma-separated options for fs.  */
+	int mnt_freq;		/* Dump frequency (in days).  */
+	int mnt_passno;		/* Pass number for `fsck'.  */
+};
+
+static inline FILE *setmntent(const char *filename, const char *type)
+{
+	return NULL;
+}
+
+static inline int endmntent(FILE *fp)
+{
+	return 0;
+}
+
+static inline struct mntent *getmntent(FILE *fp)
+{
+	return NULL;
+}
+
+static inline int addmntent(FILE *fp, const struct mntent *mnt)
+{
+	return 0;
+}
+
+static inline char *hasmntopt(const struct mntent *mnt, const char *opt)
+{
+	return NULL;
+}
+
 static inline int statvfs64 (const char *__restrict __file,
 							 struct statfs *__restrict __buf)
 {
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
