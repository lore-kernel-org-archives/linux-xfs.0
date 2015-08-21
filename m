Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B121D7F6F
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 16:15:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A26F2304039
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 14:15:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iyurrHfDagktsTic (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 14:15:50 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 22CF18E676
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 21:15:50 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7LLFmiE017551
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 17:15:49 -0400
Message-ID: <55D79504.6040305@redhat.com>
Date: Fri, 21 Aug 2015 16:15:48 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: collapse allocsize and biosize mount option handling
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
To: xfs-oss <xfs@oss.sgi.com>

The allocsize and biosize mount options are handled identically,
other than allocsize accepting suffixes.  suffix_kstrtoint handles
bare numbers just fine too, so these can be collapsed.

(In other news, though, maybe biosize needs to be deprecated?
XFS_IOC_SETBIOSIZE and XFS_IOC_GETBIOSIZE are deprecated, and
"biosize" was removed from Documentation/ back in 2005 ...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1fb1656..4bd6c0d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -261,16 +261,8 @@ xfs_parseargs(
 			mp->m_rtname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
 			if (!mp->m_rtname)
 				return -ENOMEM;
-		} else if (!strcmp(this_char, MNTOPT_BIOSIZE)) {
-			if (!value || !*value) {
-				xfs_warn(mp, "%s option requires an argument",
-					this_char);
-				return -EINVAL;
-			}
-			if (kstrtoint(value, 10, &iosize))
-				return -EINVAL;
-			iosizelog = ffs(iosize) - 1;
-		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
+		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE) ||
+			   !strcmp(this_char, MNTOPT_BIOSIZE)) {
 			if (!value || !*value) {
 				xfs_warn(mp, "%s option requires an argument",
 					this_char);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
