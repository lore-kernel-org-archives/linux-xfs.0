Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 379547F7B
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 04:21:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3CFBAC00B
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 02:21:55 -0700 (PDT)
Received: from smtp-out6.electric.net ([192.162.217.193]) by cuda.sgi.com with
	ESMTP id c6kOfQaK8nKRiZDw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 02:21:49 -0700 (PDT)
Received: from 1Z5sUe-0008F8-Uh by out6a.electric.net with emc1-ok (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5sUe-0008Gv-VU
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 02:21:48 -0700
Received: from [192.171.162.48] (helo=lismore.npm.ac.uk)
	by out6a.electric.net with esmtp (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5sUe-0008F8-Uh
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 02:21:48 -0700
Received: from lismore.npm.ac.uk (localhost.localdomain [127.0.0.1])
	by localhost (Email Security Appliance) with SMTP id
	4A9A48D6D66_583DF2CB
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 09:21:48 +0000 (GMT)
Received: from Harris.npm.ac.uk (harris.npm.ac.uk [192.171.162.107])
	by lismore.npm.ac.uk (Sophos Email Appliance) with ESMTP id
	106438D6D56_583DF2CF
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 09:21:48 +0000 (GMT)
From: Mike Grant <mggr@pml.ac.uk>
Subject: [PATCH 1/2] xfs_repair: reformat lines to fit within 80 characters
Date: Fri, 19 Jun 2015 10:21:35 +0100
Message-ID: <1434705696-21705-2-git-send-email-mggr@pml.ac.uk>
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

Signed-off-by: Mike Grant <mggr@pml.ac.uk>
---
 repair/phase6.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 105bce4..0d66f9c 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2327,9 +2327,11 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		if (db >= num_bps) {
 			/* more data blocks than expected */
 			num_bps = db + 1;
-			bplist = realloc(bplist, num_bps * sizeof(struct xfs_buf*));
+			bplist = realloc(bplist, num_bps *
+				sizeof(struct xfs_buf*));
 			if (!bplist)
-				do_error(_("realloc failed in %s (%zu bytes)\n"),
+				do_error(
+					_("realloc failed in %s (%zu bytes)\n"),
 					__func__,
 					num_bps * sizeof(struct xfs_buf*));
 		}
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
