Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A1737F5D
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 17:55:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 502EB30407E
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 15:55:33 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id Gf1RqtYmmCeusYJy (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 15:55:28 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] generic/022: update expected output after the test was
	renamed
Date: Sat, 12 Apr 2014 18:55:16 -0400
Message-Id: <1397343317-14669-3-git-send-email-tytso@mit.edu>
In-Reply-To: <1397343317-14669-1-git-send-email-tytso@mit.edu>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
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
Cc: Lukas Czerner <lczerner@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>

After generic/022 was renamed by commit 21723cdb, the wrong test
number was put into generic/022.out.  Fix this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Lukas Czerner <lczerner@redhat.com>
---
 tests/generic/022.out | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/022.out b/tests/generic/022.out
index 96c2d33..fbffa59 100644
--- a/tests/generic/022.out
+++ b/tests/generic/022.out
@@ -1,4 +1,4 @@
-QA output created by 009
+QA output created by 022
 	1. into a hole
 f4f35d60b3cc18aaa6d8d92f0cd3708a
 	2. into allocated space
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
