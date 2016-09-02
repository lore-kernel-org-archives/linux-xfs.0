Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 291A87CA7
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 21:28:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D7D9A8F8035
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 19:28:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZAEQNdS4gpdtFyRc for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2016 19:28:00 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: clean up AGFL index initialisation in growfs
Date: Fri,  2 Sep 2016 12:27:36 +1000
Message-Id: <1472783257-15941-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1472783257-15941-1-git-send-email-david@fromorbit.com>
References: <1472783257-15941-1-git-send-email-david@fromorbit.com>
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
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that we have a fixed size for the AGFL for v5 format filesysetms
across all platforms, we don't need the growfs workaround to avoid
using the last index in the AGFL. This effectively undoes commit
ad747e3 ("xfs: Don't wrap growfs AGFL indexes") and returns the
growfs code to it's prior behaviour.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 622ca71..e5ff65e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -251,8 +251,8 @@ xfs_growfs_data_private(
 			agf->agf_rmap_blocks = cpu_to_be32(1);
 		}
 
-		agf->agf_flfirst = cpu_to_be32(1);
-		agf->agf_fllast = 0;
+		agf->agf_flfirst = 0;
+		agf->agf_fllast = cpu_to_be32(xfs_agfl_size(mp) - 1);
 		agf->agf_flcount = 0;
 		tmpsize = agsize - mp->m_ag_prealloc_blocks;
 		agf->agf_freeblks = cpu_to_be32(tmpsize);
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
