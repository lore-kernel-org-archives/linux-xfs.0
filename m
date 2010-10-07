Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o97MLrcU230254 for <xfs@oss.sgi.com>; Thu, 7 Oct 2010 17:21:53 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25447304064
	for <xfs@oss.sgi.com>; Thu,  7 Oct 2010 15:22:56 -0700 (PDT)
Received: from [128.162.232.176] (eagdhcp-232-176.americas.sgi.com
	[128.162.232.176])
	by estes.americas.sgi.com (Postfix) with ESMTP id 0B0B970017C5
	for <xfs@oss.sgi.com>; Thu,  7 Oct 2010 17:22:56 -0500 (CDT)
Message-ID: <4CAE483F.1020608@sgi.com>
Date: Thu, 07 Oct 2010 17:22:55 -0500
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Fix some file permission.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I notice that some of the test script do not have execute
permission. To be consistent I changed the permissions to be 755.
Can someone verify that this is valid.

Thanks.

Signed-off-by: Alain Renaud <arenaud@sgi.com>
---
  0 files changed, 0 insertions(+), 0 deletions(-)
  mode change 100644 => 100755 215
  mode change 100644 => 100755 220
  mode change 100644 => 100755 221
  mode change 100644 => 100755 222
  mode change 100644 => 100755 224
  mode change 100644 => 100755 225
  mode change 100644 => 100755 227
  mode change 100644 => 100755 229
  mode change 100644 => 100755 236
  mode change 100644 => 100755 237
  mode change 100644 => 100755 239
  mode change 100644 => 100755 242
  mode change 100644 => 100755 244

diff --git a/215 b/215
old mode 100644
new mode 100755
diff --git a/220 b/220
old mode 100644
new mode 100755
diff --git a/221 b/221
old mode 100644
new mode 100755
diff --git a/222 b/222
old mode 100644
new mode 100755
diff --git a/224 b/224
old mode 100644
new mode 100755
diff --git a/225 b/225
old mode 100644
new mode 100755
diff --git a/227 b/227
old mode 100644
new mode 100755
diff --git a/229 b/229
old mode 100644
new mode 100755
diff --git a/236 b/236
old mode 100644
new mode 100755
diff --git a/237 b/237
old mode 100644
new mode 100755
diff --git a/239 b/239
old mode 100644
new mode 100755
diff --git a/242 b/242
old mode 100644
new mode 100755
diff --git a/244 b/244
old mode 100644
new mode 100755
-- 
1.6.0.2

-- 
===============================================
Alain Renaud     - Cluster File System Engineer
arenaud@sgi.com  - SGI
===============================================

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
