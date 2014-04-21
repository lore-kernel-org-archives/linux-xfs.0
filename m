Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D19A329DF7
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 15:40:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B44EF8F804B
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:40:28 -0700 (PDT)
Received: from mail-yh0-f54.google.com (mail-yh0-f54.google.com
	[209.85.213.54]) by cuda.sgi.com with ESMTP id McmvcAwV5DTdlqZa
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:40:27 -0700 (PDT)
Received: by mail-yh0-f54.google.com with SMTP id f73so4016132yha.27
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:40:27 -0700 (PDT)
Date: Mon, 21 Apr 2014 16:40:23 -0400
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH 1/3] xfstests: add helper for zero range support check
Message-ID: <20140421204023.GB960@wallace>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org

Add a helper function to verify fallocate zero range support in a style
similar to _require_xfs_io_falloc_collapse(), etc.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 common/rc | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/common/rc b/common/rc
index acf419b..bcda96a 100644
--- a/common/rc
+++ b/common/rc
@@ -1375,6 +1375,13 @@ _require_xfs_io_falloc_collapse()
 	_require_xfs_io_command "fcollapse"
 }
 
+# check that xfs_io, kernel, and filesystem all support fallocate with zero
+# range
+_require_xfs_io_falloc_zero()
+{
+	_require_xfs_io_command "fzero"
+}
+
 # check that xfs_io, kernel and filesystem support fiemap
 _require_xfs_io_fiemap()
 {
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
