Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 076AF7F78
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 04:21:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88BD1AC009
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 02:21:55 -0700 (PDT)
Received: from smtp-out4.electric.net ([192.162.216.184]) by cuda.sgi.com with
	ESMTP id C2g0E7hXpQns1YXA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 02:21:53 -0700 (PDT)
Received: from 1Z5sUh-0002MY-VO by out4d.electric.net with emc1-ok (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5sUi-0002Ot-T5
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 02:21:52 -0700
Received: from [192.171.162.48] (helo=lismore.npm.ac.uk)
	by out4d.electric.net with esmtp (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5sUh-0002MY-VO
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 02:21:51 -0700
Received: from lismore.npm.ac.uk (localhost.localdomain [127.0.0.1])
	by localhost (Email Security Appliance) with SMTP id
	72B818D6C73_583DF2FB
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 09:21:51 +0000 (GMT)
Received: from Harris.npm.ac.uk (harris.npm.ac.uk [192.171.162.107])
	by lismore.npm.ac.uk (Sophos Email Appliance) with ESMTP id
	260278D689E_583DF2FF
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 09:21:51 +0000 (GMT)
From: Mike Grant <mggr@pml.ac.uk>
Subject: [PATCH 2/2] xfs_repair: clear new memory after realloc
Date: Fri, 19 Jun 2015 10:21:36 +0100
Message-ID: <1434705696-21705-3-git-send-email-mggr@pml.ac.uk>
In-Reply-To: <1434705696-21705-1-git-send-email-mggr@pml.ac.uk>
References: <1434705696-21705-1-git-send-email-mggr@pml.ac.uk>
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
 repair/phase6.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/repair/phase6.c b/repair/phase6.c
index 0d66f9c..4dd7551 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2326,6 +2326,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		db = xfs_dir2_da_to_db(mp, da_bno);
 		if (db >= num_bps) {
 			/* more data blocks than expected */
+			int num_bps_prev = num_bps;
 			num_bps = db + 1;
 			bplist = realloc(bplist, num_bps *
 				sizeof(struct xfs_buf*));
@@ -2334,6 +2335,10 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 					_("realloc failed in %s (%zu bytes)\n"),
 					__func__,
 					num_bps * sizeof(struct xfs_buf*));
+			/* clear new memory as previous bplist was calloc'ed */
+			memset((void *) bplist + num_bps_prev
+				* sizeof(struct xfs_buf*), 0, (num_bps -
+				num_bps_prev) * sizeof(struct xfs_buf*));
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
