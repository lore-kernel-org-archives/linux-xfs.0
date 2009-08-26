Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QHkXDB027248 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 12:46:43 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 736218F80B5
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 10:47:26 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [PATCH] xfs_showargs() reports group *and* project quotas enabled
Date: Wed, 26 Aug 2009 12:46:12 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABD9@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABD0@cf--amer001e--3.americas.sgi.com>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

If you enable group or project quotas on an XFS file system, then the
mount table presented through /proc/self/mounts erroneously shows
that both options are in effect for the file system.  The root of
the problem is some bad logic in the xfs_showargs() function, which
is used to format the file system type-specific options in effect
for a file system.

The problem originated in this GIT commit:
    Move platform specific mount option parse out of core XFS code
    Date: 11/22/07
    Author: Dave Chinner
    SHA1 ID: a67d7c5f5d25d0b13a4dfb182697135b014fa478

For XFS quotas, project and group quota management are mutually
exclusive--only one can be in effect at a time.  There are two
parts to managing quotas:  aggregating usage information; and
enforcing limits.  It is possible to have a quota in effect
(aggregating usage) but not enforced.

These features are recorded on an XFS mount point using these flags:
    XFS_PQUOTA_ACCT - Project quotas are aggregated
    XFS_GQUOTA_ACCT - Group quotas are aggregated
    XFS_OQUOTA_ENFD - Project/group quotas are enforced

The code in error is in fs/xfs/linux-2.6/xfs_super.c:

        if (mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
                seq_puts(m, "," MNTOPT_PRJQUOTA);
        else if (mp->m_qflags & XFS_PQUOTA_ACCT)
                seq_puts(m, "," MNTOPT_PQUOTANOENF);

        if (mp->m_qflags & (XFS_GQUOTA_ACCT|XFS_OQUOTA_ENFD))
                seq_puts(m, "," MNTOPT_GRPQUOTA);
        else if (mp->m_qflags & XFS_GQUOTA_ACCT)
                seq_puts(m, "," MNTOPT_GQUOTANOENF);

The problem is that XFS_OQUOTA_ENFD will be set in mp->m_qflags
if either group or project quotas are enforced, and as a result
both MNTOPT_PRJQUOTA and MNTOPT_GRPQUOTA will be shown as mount
options.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_super.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -579,15 +579,19 @@ xfs_showargs(
 	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
 		seq_puts(m, "," MNTOPT_UQUOTANOENF);
 
-	if (mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
-		seq_puts(m, "," MNTOPT_PRJQUOTA);
-	else if (mp->m_qflags & XFS_PQUOTA_ACCT)
-		seq_puts(m, "," MNTOPT_PQUOTANOENF);
+	/* Either project or group quotas can be active, not both */
 
-	if (mp->m_qflags & (XFS_GQUOTA_ACCT|XFS_OQUOTA_ENFD))
-		seq_puts(m, "," MNTOPT_GRPQUOTA);
-	else if (mp->m_qflags & XFS_GQUOTA_ACCT)
-		seq_puts(m, "," MNTOPT_GQUOTANOENF);
+	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_OQUOTA_ENFD)
+			seq_puts(m, "," MNTOPT_PRJQUOTA);
+		else
+			seq_puts(m, "," MNTOPT_PQUOTANOENF);
+	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_OQUOTA_ENFD)
+			seq_puts(m, "," MNTOPT_GRPQUOTA);
+		else
+			seq_puts(m, "," MNTOPT_GQUOTANOENF);
+	}
 
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, "," MNTOPT_NOQUOTA);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
