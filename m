Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10ABB7F37
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 18:22:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F3C7F304043
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 16:22:43 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id P2WFqFddLdl8aJy1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Mar 2015 16:22:42 -0700 (PDT)
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id t2INMfL9030960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 23:22:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t2INMfWX022819
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 23:22:41 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t2INMfU3023238
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 23:22:41 GMT
Date: Wed, 18 Mar 2015 16:22:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_repair: don't abort on bad directory leaf crc during
	leaf check
Message-ID: <20150318232239.GB24608@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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

longform_dir2_check_leaf() checks a directory leaf block to help
decide if we need to rebuild the directory.  If the verifier fails
with a CRC or corrupt structure error, rebuild the directory instead
of aborting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase6.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 1728609..c09b394 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1951,7 +1951,12 @@ longform_dir2_check_leaf(
 	da_bno = mp->m_dirleafblk;
 	error = dir_read_buf(ip, da_bno, -1, &bp, &xfs_dir3_leaf1_buf_ops,
 			     &fixit);
-	if (error) {
+	if (error == EFSBADCRC || error == EFSCORRUPTED || fixit) {
+		do_warn(
+	_("leaf block %u for directory inode %" PRIu64 " bad CRC\n"),
+			da_bno, ip->i_ino);
+		return 1;
+	} else if (error) {
 		do_error(
 	_("can't read block %u for directory inode %" PRIu64 ", error %d\n"),
 			da_bno, ip->i_ino, error);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
