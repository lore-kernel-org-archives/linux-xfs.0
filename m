Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6BH90A212166 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 05:17:09 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A6AB29E14F
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 03:17:07 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wfpkxNYvt02etG8N for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 03:17:07 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RXt1D-0001lu-72
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 22:17:03 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RXt1C-0004CI-Gm
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 22:17:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfstests: test 110 sometimes fails to unmount scratch dev
Date: Tue,  6 Dec 2011 22:16:58 +1100
Message-Id: <1323170219-16080-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1323170219-16080-1-git-send-email-david@fromorbit.com>
References: <1323170219-16080-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

It runs a bunch of rm processes inteh background, tehn immediately
calls _check_scratch_fs without waiting for them to complete, hence
the unmount can fail with abusy filesystem error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 110 |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/110 b/110
index cf5f663..aad5835 100755
--- a/110
+++ b/110
@@ -79,6 +79,7 @@ do
     rm $SCRATCH_MNT/test/${STR1}${STR2}${STR3}${I} &
     let I=$I+1
 done
+wait
 
 _check_scratch_fs
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
