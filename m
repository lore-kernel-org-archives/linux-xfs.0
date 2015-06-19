Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A4FB7F75
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:04:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EFA10304043
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:04:21 -0700 (PDT)
Received: from smtp-out4.electric.net ([192.162.216.183]) by cuda.sgi.com with
	ESMTP id vGOPXHuKEXVvKFge (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 08:04:19 -0700 (PDT)
Received: from 1Z5xq5-0005j6-VI by out4a.electric.net with emc1-ok (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5xq6-0005k1-T8
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 08:04:18 -0700
Received: from [192.171.162.48] (helo=lismore.npm.ac.uk)
	by out4a.electric.net with esmtp (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5xq5-0005j6-VI
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 08:04:17 -0700
Received: from lismore.npm.ac.uk (localhost.localdomain [127.0.0.1])
	by localhost (Email Security Appliance) with SMTP id
	6E0188D7272_5842F71B
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 15:04:17 +0000 (GMT)
Received: from Harris.npm.ac.uk (harris.npm.ac.uk [192.171.162.107])
	by lismore.npm.ac.uk (Sophos Email Appliance) with ESMTP id
	0FA048D7267_5842F71F
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 15:04:17 +0000 (GMT)
From: Mike Grant <mggr@pml.ac.uk>
Subject: [PATCH v2 2/3] xfs_repair: clear new memory after realloc
Date: Fri, 19 Jun 2015 16:04:00 +0100
Message-ID: <1434726241-11606-3-git-send-email-mggr@pml.ac.uk>
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

longform_dir2_entry_check in phase6.c has a calloc'ed array of xfs_buf
pointers (bplist).  It reallocs this array if there turns out to be more
blocks than expected.  However, realloc doesn't zero the new memory like
calloc.  In unusual circumstances*, things may then blow up later due to
random data populating the new part of the array.

This patch zeros the new part of the array.

* (bit speculative) as dir_read_buf zeros the element it's looking at, I
think this can only happen if the realloc adds several members and one
of the first is corrupt.  In my case, the realloc went from 35 to 37
members, meaning db must have been 36 without being 35.  A read error
then caused it to goto out_fix. The crash then occurred in the
libxfs_putbuf when looping through the bplist structure, checking it for
NULL pointers (and presumably tripping over the non-zeroed data at
position 35?)

Signed-off-by: Mike Grant <mggr@pml.ac.uk>
---
 repair/phase6.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/repair/phase6.c b/repair/phase6.c
index 6520196..e24cf62 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2327,6 +2327,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		db = xfs_dir2_da_to_db(mp, da_bno);
 		if (db >= num_bps) {
 			/* more data blocks than expected */
+			int num_bps_prev = num_bps;
 			num_bps = db + 1;
 			bplist = realloc(bplist, num_bps * bpsz);
 			if (!bplist)
@@ -2334,6 +2335,9 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 					_("realloc failed in %s (%zu bytes)\n"),
 					__func__,
 					num_bps * bpsz);
+			/* clear new memory as previous bplist was calloc'ed */
+			memset((void *) bplist + num_bps_prev * bpsz, 0,
+				(num_bps - num_bps_prev) * bpsz);
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
