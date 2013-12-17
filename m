Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F3FD29DF8
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 16:18:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA05D8F8078
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:56 -0800 (PST)
Received: from mail-yh0-f74.google.com (mail-yh0-f74.google.com
	[209.85.213.74]) by cuda.sgi.com with ESMTP id BhUyCagpWE8U2Dvz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:56 -0800 (PST)
Received: by mail-yh0-f74.google.com with SMTP id a41so667102yho.5
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:55 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v2 06/12] xfstests: fix generic/127 to call _cleanup() only
	once
Date: Tue, 17 Dec 2013 14:18:36 -0800
Message-Id: <1387318722-3050-6-git-send-email-jayr@google.com>
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

The test is already trap-ing signal 0 (EXIT). umount prints error
message when target tmpfs is already unmounted.

Signed-off-by: Junho Ryu <jayr@google.com>
---

v2: same as v1

 tests/generic/127 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/generic/127 b/tests/generic/127
index 58ca91e..47bd1ca 100755
--- a/tests/generic/127
+++ b/tests/generic/127
@@ -117,5 +117,4 @@ _fsx_std_nommap
 _fsx_std_mmap
 
 status=0
-_cleanup
 exit
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
