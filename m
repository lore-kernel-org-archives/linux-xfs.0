Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LGmZtY087732 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 11:48:36 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C954B1211EB0
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 09:51:36 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id nFHFUahYi2EOSq6S for <xfs@oss.sgi.com>;
	Wed, 21 Jul 2010 09:51:36 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] Add test for correct $SCRATCH_MNT into _require_scratch
Date: Wed, 21 Jul 2010 18:50:52 +0200
Message-Id: <1279731052-30631-3-git-send-email-jack@suse.cz>
In-Reply-To: <1279731052-30631-1-git-send-email-jack@suse.cz>
References: <1279731052-30631-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>

---
 common.rc |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index 6bf1e12..72997f9 100644
--- a/common.rc
+++ b/common.rc
@@ -703,6 +703,10 @@ _require_scratch()
 		 then
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
+		if [ ! -d "$SCRATCH_MNT" ]
+		then
+		     _notrun "this test requires a valid \$SCRATCH_MNT"
+		fi
 		 ;;
     esac
 
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
