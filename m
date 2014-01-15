Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 507A429DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 11:31:35 -0600 (CST)
From: Shaun Gosse <sgosse@sgi.com>
Subject: RE: [PATCH] Add a warning about non-ASCII filenames in ASCII-CI mode
Date: Wed, 15 Jan 2014 17:31:34 +0000
Message-ID: <8D3FA7645C1CFC4E9E783D22B4C708644AA855@P-EXMB2-DC21.corp.sgi.com>
References: <1389806582-26815-1-git-send-email-zach@kotlarek.com>
	<1389806582-26815-2-git-send-email-zach@kotlarek.com>
In-Reply-To: <1389806582-26815-2-git-send-email-zach@kotlarek.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Zachary Kotlarek <zach@kotlarek.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Looks good.

Reviewed-by: Shaun Gosse <sgosse@sgi.com>

Thanks again,
-Shaun

-----Original Message-----
From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf Of Zachary Kotlarek
Sent: Wednesday, January 15, 2014 11:23 AM
To: xfs@oss.sgi.com
Cc: Zachary Kotlarek
Subject: [PATCH] Add a warning about non-ASCII filenames in ASCII-CI mode

---
 man/man8/mkfs.xfs.8 |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8 index 8184e10..e1c5cf7 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -513,9 +513,11 @@ any power of 2 size from the filesystem block size up to 65536.
 .IP
 The
 .B version=ci
-option enables ASCII only case-insensitive filename lookup and version
+option enables ASCII-only case-insensitive filename lookup and version
 2 directories. Filenames are case-preserving, that is, the names -are stored in directories using the case they were created with.
+are stored in directories using the case they were created with. In 
+this mode non-ASCII file and directory names are not supported and are 
+likely to become inaccessible if used.
 .IP
 Note: Version 1 directories are not supported.
 .TP
--
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
