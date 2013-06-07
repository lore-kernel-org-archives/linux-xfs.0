Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79AA77F78
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 682618F8059
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:53 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Jn7leicjd06Cw8K9 for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:52 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVy-0003vj-VP
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:47 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVs-0001LS-Sb
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 26/48] xfsprogs: disable xfs_check for CRC enabled filesystems
Date: Fri,  7 Jun 2013 10:25:49 +1000
Message-Id: <1370564771-4929-27-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Until xfs_db has full metadata CRC support, xfs_check will not be
able to fully verify filesystems in this format. Don't even
bother trying right now, and to make it simple to test full xfsprogs
installs with xfstests, just silently succeed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/check.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/db/check.c b/db/check.c
index 5b7498f..dadfa97 100644
--- a/db/check.c
+++ b/db/check.c
@@ -788,6 +788,20 @@ blockget_f(
 		dbprintf(_("already have block usage information\n"));
 		return 0;
 	}
+
+	/*
+	 * XXX: check does not support CRC enabled filesystems. Return
+	 * immediately, silently, with success but  without doing anything here
+	 * initially so that xfstests can run without modification on metadata
+	 * enabled filesystems.
+	 *
+	 * XXX: ultimately we need to dump an error message here that xfstests
+	 * filters out, or we need to actually do the work to make check support
+	 * crc enabled filesystems.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return 0;
+
 	if (!init(argc, argv)) {
 		if (serious_error)
 			exitcode = 3;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
