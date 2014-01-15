Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D27CD29DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 11:23:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D017D8F8033
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 09:23:11 -0800 (PST)
Received: from vera.uberzach.com (vera.uberzach.com [74.93.97.68]) by
	cuda.sgi.com with ESMTP id 0goSVQvFGt6oWWIW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jan 2014 09:23:10 -0800 (PST)
From: Zachary Kotlarek <zach@kotlarek.com>
Subject: [PATCH] Add a warning about non-ASCII filenames in ASCII-CI mode
Date: Wed, 15 Jan 2014 09:23:02 -0800
Message-Id: <1389806582-26815-2-git-send-email-zach@kotlarek.com>
In-Reply-To: <1389806582-26815-1-git-send-email-zach@kotlarek.com>
References: <1389806582-26815-1-git-send-email-zach@kotlarek.com>
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
Cc: Zachary Kotlarek <zach@kotlarek.com>

---
 man/man8/mkfs.xfs.8 |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 8184e10..e1c5cf7 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -513,9 +513,11 @@ any power of 2 size from the filesystem block size up to 65536.
 .IP
 The
 .B version=ci
-option enables ASCII only case-insensitive filename lookup and version
+option enables ASCII-only case-insensitive filename lookup and version
 2 directories. Filenames are case-preserving, that is, the names
-are stored in directories using the case they were created with.
+are stored in directories using the case they were created with. In this
+mode non-ASCII file and directory names are not supported and are likely
+to become inaccessible if used.
 .IP
 Note: Version 1 directories are not supported.
 .TP
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
