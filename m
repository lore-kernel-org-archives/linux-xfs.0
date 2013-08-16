Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E31FD7CBE
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 12:45:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD91D8F8087
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 10:44:59 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.140]) by
	cuda.sgi.com with ESMTP id RNX4Y71vy91yPXNz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Aug 2013 10:44:58 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] xfstests: btrfs/009 never shrinked or removed $seqres.full
Date: Fri, 16 Aug 2013 19:44:54 +0200
Message-Id: <1376675094-21522-1-git-send-email-sbehrens@giantdisaster.de>
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
Cc: linux-btrfs@vger.kernel.org

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 tests/btrfs/009 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/btrfs/009 b/tests/btrfs/009
index d46744c..08aa508 100755
--- a/tests/btrfs/009
+++ b/tests/btrfs/009
@@ -47,6 +47,8 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 
+rm -f $seqres.full
+
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
 
-- 
1.8.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
