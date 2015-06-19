Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E04F87F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:04:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0EEF8F8035
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:04:27 -0700 (PDT)
Received: from smtp-out4.electric.net ([192.162.216.182]) by cuda.sgi.com with
	ESMTP id AkiboV28a0nTZWfj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 08:04:25 -0700 (PDT)
Received: from 1Z5xqC-0004ux-UT by out4c.electric.net with emc1-ok (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5xqC-0004wH-VG
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 08:04:24 -0700
Received: from [192.171.162.48] (helo=lismore.npm.ac.uk)
	by out4c.electric.net with esmtp (Exim 4.84)
	(envelope-from <mggr@pml.ac.uk>) id 1Z5xqC-0004ux-UT
	for xfs@oss.sgi.com; Fri, 19 Jun 2015 08:04:24 -0700
Received: from lismore.npm.ac.uk (localhost.localdomain [127.0.0.1])
	by localhost (Email Security Appliance) with SMTP id
	30EA88D726B_5842F78B
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 15:04:24 +0000 (GMT)
Received: from Harris.npm.ac.uk (harris.npm.ac.uk [192.171.162.107])
	by lismore.npm.ac.uk (Sophos Email Appliance) with ESMTP id
	EDF808D7267_5842F77F
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 15:04:23 +0000 (GMT)
From: Mike Grant <mggr@pml.ac.uk>
Subject: [PATCH v2 3/3] xfs_repair: include any realloc'ed buffers in final
	putbuf
Date: Fri, 19 Jun 2015 16:04:01 +0100
Message-ID: <1434726241-11606-4-git-send-email-mggr@pml.ac.uk>
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

The realloc code included in commit 95dff16b1 potentially introduces
extra buffers to bplist.  These should be dealt with at the end of the
longform_dir2_entry_check function.  This replaces the originally estimated
number of entries (freetab->naents) with the actual number finally allocated
(num_bps).

Note: this has not been tested on a suitable filesystem image but
appears correct..

Signed-off-by: Mike Grant <mggr@pml.ac.uk>
---
 repair/phase6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index e24cf62..7f7d9b0 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2409,14 +2409,14 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 out_fix:
 	if (!no_modify && (fixit || dotdot_update)) {
 		dir_hash_dup_names(hashtab);
-		for (i = 0; i < freetab->naents; i++)
+		for (i = 0; i < num_bps; i++)
 			if (bplist[i])
 				libxfs_putbuf(bplist[i]);
 		longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);
 		*num_illegal = 0;
 		*need_dot = 0;
 	} else {
-		for (i = 0; i < freetab->naents; i++)
+		for (i = 0; i < num_bps; i++)
 			if (bplist[i])
 				libxfs_putbuf(bplist[i]);
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
