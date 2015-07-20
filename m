Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E16397F55
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 07:57:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC4C68F8033
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 05:57:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cbb4cg46HGNA9tY8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 05:57:09 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2 2/4] xfsprogs: Don't Make .po files with gettext disabled
Date: Mon, 20 Jul 2015 14:56:56 +0200
Message-Id: <1437397018-12864-3-git-send-email-jtulak@redhat.com>
In-Reply-To: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
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

"po" target is added only if gettext binary is found.
Without this patch, Make tried to build the target even
with --enable-gettext=no configure option, which led
to a failing build.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 6d6803b..3da4d5d 100644
--- a/Makefile
+++ b/Makefile
@@ -46,7 +46,11 @@ HDR_SUBDIRS = include libxfs
 DLIB_SUBDIRS = libxlog libxcmd libhandle libdisk
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc po debian
+		mdrestore repair rtcp m4 man doc debian
+
+ifneq ("$(XGETTEXT)","")
+TOOL_SUBDIRS += po
+endif
 
 # include is listed last so it is processed last in clean rules.
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
