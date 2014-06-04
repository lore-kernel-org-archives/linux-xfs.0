Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E24D7F50
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 04:48:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 66FE930406B
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 02:48:33 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id shaHUmzUc4d3CycG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jun 2014 02:48:23 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 36DF8AC7A
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 09:48:22 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Fix rounding in xfs_alloc_fix_len()
Date: Wed,  4 Jun 2014 11:48:13 +0200
Message-Id: <1401875293-16227-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

Rounding in xfs_alloc_fix_len() is wrong. As the comment states, the
result should be a number of a form (k*prod+mod) however due to sign
mistake the result is different. As a result allocations on raid arrays
could be misaligned in some cases.

This also seems to fix occasional assertion failure:
	XFS_WANT_CORRUPTED_GOTO(rlen <= flen, error0)
in xfs_alloc_ag_vextent_size().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_alloc.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index c1cf6a336a72..6a0281b16451 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -257,14 +257,12 @@ xfs_alloc_fix_len(
 	k = rlen % args->prod;
 	if (k == args->mod)
 		return;
-	if (k > args->mod) {
-		if ((int)(rlen = rlen - k - args->mod) < (int)args->minlen)
-			return;
-	} else {
-		if ((int)(rlen = rlen - args->prod - (args->mod - k)) <
-		    (int)args->minlen)
-			return;
-	}
+	if (k > args->mod)
+		rlen = rlen - (k - args->mod);
+	else
+		rlen = rlen - args->prod + (args->mod - k);
+	if ((int)rlen < (int)args->minlen)
+		return;
 	ASSERT(rlen >= args->minlen);
 	ASSERT(rlen <= args->maxlen);
 	args->len = rlen;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
