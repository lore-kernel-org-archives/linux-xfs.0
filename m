Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A1F4C7F37
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 20:34:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E2218F8050
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 18:34:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QAebinnh7GNhY8sV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 18:34:13 -0800 (PST)
From: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2] xfs: send warning of project quota to userspace via netlink
Date: Thu, 26 Nov 2015 11:34:07 +0900
Message-Id: <1448505248-25481-1-git-send-email-yamato@redhat.com>
In-Reply-To: <20151125185419.GA18719@bfoster.bfoster>
References: <20151125185419.GA18719@bfoster.bfoster>
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
Cc: yamato@redhat.com

Linux's quota subsystem has an ability to handle
project quota. This commit just utilizes the ability
from xfs side.

dbus-monitor and quota_nld shipped as part of quota-tools can
be used for testing.

The testing environment and condition:

    # cat /etc/projects
    10:/root/Q/a
    # grep Q /proc/mounts
    /dev/loop0 /root/Q xfs rw,relatime,attr2,inode64,prjquota 0 0
    # ls -l /dev/loop0
    brw-rw---- 1 root disk 7, 0 Nov 26 10:46 /dev/loop0

3 terminals are used for each commands: dd, quota_nld, and dbus-monitor.

Start quota_nld with terminal 1:

	[1]# quota_nld -F

Start dbus-monitor with terminal 2:

        [2]# dbus-monitor --system

Start dd to generate a large file for hitting the quota limit:

        [3]# dd if=/dev/sda of=/root/Q/a/X

At the terminal 1, you will see warning messages like:

   quota_nld: Failed to open tty /dev/tty1 of user 0 to report warning.

Let's ignore them.  These meaningless messages
are suppressed by a patch available at
https://sourceforge.net/p/linuxquota/patches/43/.

At the terminal 2, you will see following traffic about disk quota
(newlines are inserted):

    signal time=1448502680.741715 sender=:1.35 -> \
	   destination=(null destination) serial=4 path=/; \
	   interface=com.system.quota.warning; member=warning
       uint32 2
       uint64 10
       uint32 6
       uint32 7
       uint32 0
       uint64 0
    signal time=1448502680.742518 sender=:1.35 -> \
	   destination=(null destination) serial=5 path=/; \
	   interface=com.system.quota.warning; member=warning
       uint32 2
       uint64 10
       uint32 4
       uint32 7
       uint32 0
       uint64 0

The 1st "2" means the type of quota: project quota.
The 2nd "10" means the project id.
The 3rd "4" and "6" mean "Block hardlimit reached" and
"Block softlimit reached".
The 4th "7" means the major number of loop0.
The 5th "0" means the minor number of loop0.

Changes in v2:

	a couple aesthetic things suggested by Brian Foster <bfoster@redhat.com>.
	* rename local vairable for aligning the parameter names,
	* move a short line to the end of its previous line.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 fs/xfs/xfs_trans_dquot.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ce78534..9951701 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -572,12 +572,16 @@ xfs_quota_warn(
 	struct xfs_dquot	*dqp,
 	int			type)
 {
-	/* no warnings for project quotas - we just return ENOSPC later */
+	enum quota_type qtype;
+
 	if (dqp->dq_flags & XFS_DQ_PROJ)
-		return;
-	quota_send_warning(make_kqid(&init_user_ns,
-				     (dqp->dq_flags & XFS_DQ_USER) ?
-				     USRQUOTA : GRPQUOTA,
+		qtype = PRJQUOTA;
+	else if (dqp->dq_flags & XFS_DQ_USER)
+		qtype = USRQUOTA;
+	else
+		qtype = GRPQUOTA;
+
+	quota_send_warning(make_kqid(&init_user_ns, qtype,
 				     be32_to_cpu(dqp->q_core.d_id)),
 			   mp->m_super->s_dev, type);
 }
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
