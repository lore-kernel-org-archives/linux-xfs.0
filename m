Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C0F8A7F3F
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 12:16:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 93F4D304066
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:09 -0800 (PST)
Received: from mail-gg0-f201.google.com (mail-gg0-f201.google.com
	[209.85.161.201]) by cuda.sgi.com with ESMTP id
	LaoJRVtHUF47RF8A (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 10:16:08 -0800 (PST)
Received: by mail-gg0-f201.google.com with SMTP id k5so1285ggd.0
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:16:08 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v3 06/12] xfstests: fix generic/127 to call _cleanup() only
	once
Date: Wed, 18 Dec 2013 10:15:57 -0800
Message-Id: <1387390563-27064-6-git-send-email-jayr@google.com>
In-Reply-To: <1387390563-27064-1-git-send-email-jayr@google.com>
References: <1387390563-27064-1-git-send-email-jayr@google.com>
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

v3: same as v1

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
