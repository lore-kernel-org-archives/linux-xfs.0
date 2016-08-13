Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D9767CCD
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:25:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D4BDAC002
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:52 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id 6Fe0zB9uEwnSAPrR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:51 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 2B69A20449
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:50 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTDY4hcjz104J
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:49 +0200 (CEST)
Resent-Message-ID: <20160813172453.GH3858@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <7b393c92e885edd551cdd0c46b21807f653c8c1d.1471107858.git.felix.janda@posteo.de>
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
References: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 13 Aug 2016 18:17:41 +0200
Subject: [PATCHv2 xfsprogs 10/14] Makefile: disable fsr for Mac OS X
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

Since its kernel does not support XFS anyway this utility is not
useful, and with its removal the portability framework can be
simplified.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 7bdc670..84dc62c 100644
--- a/Makefile
+++ b/Makefile
@@ -45,9 +45,13 @@ HDR_SUBDIRS = include libxfs
 
 DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
-TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
+TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
 		mdrestore repair rtcp m4 man doc debian
 
+ifneq ("$(PKG_PLATFORM)","darwin")
+TOOL_SUBDIRS += fsr
+endif
+
 ifneq ("$(XGETTEXT)","")
 TOOL_SUBDIRS += po
 endif
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
