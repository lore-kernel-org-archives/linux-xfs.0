Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 749E77F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:04:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4BED98F8035
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:04:18 -0700 (PDT)
Received: from smtp-out6.electric.net ([192.162.217.192]) by cuda.sgi.com with
	ESMTP id uemFQPDJxLN9GOue (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 08:04:16 -0700 (PDT)
Received: from 1Z5xq3-0001Yq-UX by out6a.electric.net with emc1-ok (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5xq3-0001aj-VN
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 08:04:15 -0700
Received: from [192.171.162.48] (helo=lismore.npm.ac.uk)
	by out6a.electric.net with esmtp (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5xq3-0001Yq-UX
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 08:04:15 -0700
Received: from lismore.npm.ac.uk (localhost.localdomain [127.0.0.1])
	by localhost (Email Security Appliance) with SMTP id
	45B708D726B_5842F6FB
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 15:04:15 +0000 (GMT)
Received: from Harris.npm.ac.uk (harris.npm.ac.uk [192.171.162.107])
	by lismore.npm.ac.uk (Sophos Email Appliance) with ESMTP id
	2F4D58D7127_5842F6EF
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 15:04:14 +0000 (GMT)
From: Mike Grant <mggr@pml.ac.uk>
Subject: [PATCH v2 1/3] xfs_repair: reformat lines to fit within 80 characters
Date: Fri, 19 Jun 2015 16:03:59 +0100
Message-ID: <1434726241-11606-2-git-send-email-mggr@pml.ac.uk>
In-Reply-To: <1434726241-11606-1-git-send-email-mggr@pml.ac.uk>
References: <1434726241-11606-1-git-send-email-mggr@pml.ac.uk>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Mike Grant <mggr@pml.ac.uk>

Also introduces a const to improve readability

Signed-off-by: Mike Grant <mggr@pml.ac.uk>
---
 repair/phase6.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 105bce4..6520196 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2267,6 +2267,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			dir_hash_tab_t	*hashtab)
 {
 	struct xfs_buf		**bplist;
+	const size_t 		bpsz = sizeof(struct xfs_buf*);
 	xfs_dablk_t		da_bno;
 	freetab_t		*freetab;
 	int			num_bps;
@@ -2293,10 +2294,10 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		freetab->ents[i].s = 0;
 	}
 	num_bps = freetab->naents;
-	bplist = calloc(num_bps, sizeof(struct xfs_buf*));
+	bplist = calloc(num_bps, bpsz);
 	if (!bplist)
 		do_error(_("calloc failed in %s (%zu bytes)\n"),
-			__func__, num_bps * sizeof(struct xfs_buf*));
+			__func__, num_bps * bpsz);
 
 	/* is this a block, leaf, or node directory? */
 	libxfs_dir2_isblock(NULL, ip, &isblock);
@@ -2327,11 +2328,12 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		if (db >= num_bps) {
 			/* more data blocks than expected */
 			num_bps = db + 1;
-			bplist = realloc(bplist, num_bps * sizeof(struct xfs_buf*));
+			bplist = realloc(bplist, num_bps * bpsz);
 			if (!bplist)
-				do_error(_("realloc failed in %s (%zu bytes)\n"),
+				do_error(
+					_("realloc failed in %s (%zu bytes)\n"),
 					__func__,
-					num_bps * sizeof(struct xfs_buf*));
+					num_bps * bpsz);
 		}
 
 		if (isblock)
-- 
2.1.0

(apologies for the following junk forcibly appended by my company)


Please visit our new website at www.pml.ac.uk and follow us on Twitter  @PlymouthMarine

Winner of the Environment & Conservation category, the Charity Awards 2014.

Plymouth Marine Laboratory (PML) is a company limited by guarantee registered in England & Wales, company number 4178503. Registered Charity No. 1091222. Registered Office: Prospect Place, The Hoe, Plymouth  PL1 3DH, UK. 

This message is private and confidential. If you have received this message in error, please notify the sender and remove it from your system. You are reminded that e-mail communications are not secure and may contain viruses; PML accepts no liability for any loss or damage which may be caused by viruses.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
