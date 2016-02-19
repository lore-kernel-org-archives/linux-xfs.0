Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B4697CAA
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 14:25:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31470304039
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 12:25:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id maNisJO2wGkECRC6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Feb 2016 12:25:15 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 9FA2328A4D
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 20:25:14 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u1JKPDEH016164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 15:25:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_db: Fix dquot command docs
Message-ID: <56C77A29.7070806@redhat.com>
Date: Fri, 19 Feb 2016 14:25:13 -0600
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

The dquot command in xfs_db takes quota type as well as an ID.
Fix the usage & man page to reflect this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/dquot.c b/db/dquot.c
index 3adde3b..c4d0bff 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -33,9 +33,11 @@
 static int	dquot_f(int argc, char **argv);
 static void	dquot_help(void);
 
-static const cmdinfo_t	dquot_cmd =
-	{ "dquot", NULL, dquot_f, 1, 2, 1, N_("[projid|gid|uid]"),
-	  N_("set current address to project, group or user quota block"), dquot_help };
+static const cmdinfo_t	dquot_cmd = {
+	"dquot", NULL, dquot_f, 1, 2, 1, N_("[-g|-p|-u] id"),
+N_("set current address to a group, project or user quota block for given ID"),
+	dquot_help,
+};
 
 const field_t	dqblk_hfld[] = {
 	{ "", FLDT_DQBLK, OI(0), C1, 0, TYP_NONE },
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 5745b22..6f0c424 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -444,8 +444,8 @@ If no value is given for
 .IR flagbits ,
 print the current debug option bits. These are for the use of the implementor.
 .TP
-.BI "dquot [" projectid_or_userid ]
-Set current address to a project or user quota block.
+.BI "dquot [" \-g | \-p | \-u ] " id"
+Set current address to a group, project or user quota block for the given ID. Defaults to user quota.
 .TP
 .BI "echo [" arg "] ..."
 Echo the arguments to the output.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
