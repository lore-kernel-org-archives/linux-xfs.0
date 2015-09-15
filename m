Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 86FA57F54
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 04:59:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B7DEAC001
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id d2B5QSxHTDij3GOr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:42 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 5AAE2C0B2007
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 09:59:42 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 04/14] xfsprogs: prefix XATTR_LIST_MAX with XFS_
Date: Tue, 15 Sep 2015 11:59:14 +0200
Message-Id: <1442311164-12921-5-git-send-email-jtulak@redhat.com>
In-Reply-To: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

WILL CHANGE THE COMMIT MESSAGE.

All right, I make the renaming with define - though I'm not sure
that with the ifdef for OS X and SIZE_MAX moved to a standalone patch
we need it - shouldn't be this change rather dropped?

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/xfs.h      | 2 ++
 libhandle/handle.c | 4 ++--
 libhandle/jdm.c    | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/xfs.h b/include/xfs.h
index bc94068..8ee0106 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -53,6 +53,8 @@
 # define ASSERT(EX)	((void) 0)
 #endif
 
+#define XFS_XATTR_LIST_MAX XATTR_LIST_MAX
+
 /*
  * sparse kernel source annotations
  */
diff --git a/libhandle/handle.c b/libhandle/handle.c
index b1c0c10..7207186 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -397,8 +397,8 @@ attr_list_by_handle(
 	alhreq.buffer = buf;
 	alhreq.buflen = bufsize;
 	/* prevent needless EINVAL from the kernel */
-	if (alhreq.buflen > XATTR_LIST_MAX)
-		alhreq.buflen = XATTR_LIST_MAX;
+	if (alhreq.buflen > XFS_XATTR_LIST_MAX)
+		alhreq.buflen = XFS_XATTR_LIST_MAX;
 
 	error = xfsctl(path, fd, XFS_IOC_ATTRLIST_BY_HANDLE, &alhreq);
 
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index d804423..e52f5d8 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -168,8 +168,8 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 	int rval;
 
 	/* prevent needless EINVAL from the kernel */
-	if (bufsz > XATTR_LIST_MAX)
-		bufsz = XATTR_LIST_MAX;
+	if (bufsz > XFS_XATTR_LIST_MAX)
+		bufsz = XFS_XATTR_LIST_MAX;
 
 	jdm_fill_filehandle( &filehandle, fshandlep, statp );
 	rval = attr_list_by_handle (( void * )&filehandle,
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
