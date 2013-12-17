Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D32029E05
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 16:18:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64BE18F8071
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:56 -0800 (PST)
Received: from mail-ob0-f202.google.com (mail-ob0-f202.google.com
	[209.85.214.202]) by cuda.sgi.com with ESMTP id
	KWP6nKk2DjPNXFdl (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Dec 2013 14:18:55 -0800 (PST)
Received: by mail-ob0-f202.google.com with SMTP id gq1so1375567obb.1
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:55 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v2 05/12] xfstests: fix generic/225 to check fiemap support
Date: Tue, 17 Dec 2013 14:18:35 -0800
Message-Id: <1387318722-3050-5-git-send-email-jayr@google.com>
In-Reply-To: <1387318722-3050-1-git-send-email-jayr@google.com>
References: <1387318722-3050-1-git-send-email-jayr@google.com>
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
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

generic/225 runs fiemap.  Check fiemap support like other tests which
use fiemap.

Signed-off-by: Junho Ryu <jayr@google.com>
---

v2: renamed _require_xfs_io_fiemap to _require_fiemap

 tests/generic/225 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/225 b/tests/generic/225
index 73b125a..1fb1f94 100755
--- a/tests/generic/225
+++ b/tests/generic/225
@@ -44,6 +44,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 _require_scratch
+_require_fiemap
 
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount > /dev/null 2>&1
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
