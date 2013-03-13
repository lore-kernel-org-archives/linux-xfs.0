Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47BF57F50
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 08:57:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2BB098F8049
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 06:57:44 -0700 (PDT)
Received: from bp-05.lab.msp.redhat.com (nat-pool-rdu.redhat.com
	[66.187.233.202]) by cuda.sgi.com with ESMTP id
	fAKo8CMtLzDJtBp5 for <xfs@oss.sgi.com>;
	Wed, 13 Mar 2013 06:57:43 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3] xfstests: add 274 to the prealloc group
Date: Wed, 13 Mar 2013 09:57:01 -0500
Message-Id: <1363186623-1378-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>

test 274 does preallocation tests but is not in the prealloc group.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 group |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/group b/group
index c3c4161..8096968 100644
--- a/group
+++ b/group
@@ -397,7 +397,7 @@ stress
 271 auto rw quick
 272 auto enospc rw
 273 auto rw
-274 auto rw
+274 auto rw prealloc
 275 auto rw
 276 auto rw metadata
 277 auto ioctl quick metadata
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
