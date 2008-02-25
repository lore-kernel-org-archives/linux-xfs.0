Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 20:22:55 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1P4MmY0027502
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 20:22:51 -0800
Received: from mail.sceen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43B41EA702F
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 20:23:15 -0800 (PST)
Received: from mail.sceen.net (sceen.net [213.41.243.68]) by cuda.sgi.com with ESMTP id tq5KCVySiFunW1HP for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 20:23:15 -0800 (PST)
From: Niv Sardi <xaiki@cxhome.ath.cx>
Subject: Re: [REVIEW] fix mkfs.xfs agcount between 64 and 128MB
References: <op.t61916fp3jf8g2@pc-bnaujok.melbourne.sgi.com>
Date: Mon, 25 Feb 2008 15:21:25 +1100
In-Reply-To: <op.t61916fp3jf8g2@pc-bnaujok.melbourne.sgi.com> (Barry Naujok's
	message of "Mon, 25 Feb 2008 14:45:32 +1100")
Message-ID: <ncc8x19y8ca.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--=-=-=


What's wrong with this:

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=mkfs.diff

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index e15d667..13884f9 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -422,7 +422,7 @@ calc_default_ag_geometry(
 		count = 1;
 		goto done;
 	} else if (dblocks < MEGABYTES(128, blocklog)) {
-		blocks = MEGABYTES(16, blocklog);
+		blocks = MEGABYTES(32, blocklog);
 		goto done;
 	}
 

--=-=-=


-- 
Niv Sardi

--=-=-=--
