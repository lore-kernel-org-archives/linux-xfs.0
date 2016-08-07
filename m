Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0201B7CA4
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:24:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B8B9B8F8039
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:24:38 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id Uur7patVciFhuI7l (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:24:35 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 0A2CD2097C
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:24:32 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTC33gwhz1048
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:24:31 +0200 (CEST)
Resent-Message-ID: <20160813172334.GB3830@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <bd011b1c8a9f0f17626d36c8c9868355dc6182a9.1471107858.git.felix.janda@posteo.de>
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
References: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sun, 7 Aug 2016 07:21:20 +0200
Subject: [PATCHv2 xfsprogs 01/14] configure: use AC_SYS_LARGEFILE
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

The autoconf macro AC_SYS_LARGEFILE defines _FILE_OFFSET_BITS=64
where necessary to ensure that off_t and all interfaces using off_t
are 64bit, even on 32bit systems.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 configure.ac | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/configure.ac b/configure.ac
index 1bb5fef..8fa96a5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -107,6 +107,8 @@ AC_PACKAGE_UTILITIES(xfsprogs)
 AC_MULTILIB($enable_lib64)
 AC_RT($enable_librt)
 
+AC_SYS_LARGEFILE
+
 AC_PACKAGE_NEED_UUID_H
 AC_PACKAGE_NEED_UUIDCOMPARE
 
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
