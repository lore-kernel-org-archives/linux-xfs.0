Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A53E329E13
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 08:07:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28141AC00B
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 06:07:18 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.141]) by
	cuda.sgi.com with ESMTP id 57HkQO9TmsMEtebx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Aug 2013 06:07:17 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] xfstests: update _filter_size() for Btrfs
Date: Fri, 23 Aug 2013 15:07:12 +0200
Message-Id: <1377263233-8903-3-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
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

From: root <root@qvarne.iata>

The btrfs-progs tools changed the output:
- 100GiB instead of 100GB

xfstest btrfs/006 is one that failed due to this change.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 common/filter | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/filter b/common/filter
index dbb1674..ee738ca 100644
--- a/common/filter
+++ b/common/filter
@@ -262,7 +262,7 @@ _filter_uuid()
 # Filter out sizes like 6.14MB etc
 _filter_size()
 {
-	sed -e "s/[0-9\.]\+\s\?[b|k|m|g|t][b]\?/<SIZE>/ig"
+	sed -e "s/[0-9\.]\+\s\?[b|k|m|g|t][i]\?[b]\?/<SIZE>/ig"
 }
 
 # Convert string read from stdin like 128K to bytes and print it to stdout
-- 
1.8.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
