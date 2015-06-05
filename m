Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E2287F86
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2015 08:28:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A4D78F8033
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2015 06:28:57 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id oqFUAEmuGxgdNIBo (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 05 Jun 2015 06:28:55 -0700 (PDT)
From: Ales Novak <alnovak@suse.cz>
Subject: [PATCH] xfs: fix in the setting of logbsize
Date: Fri,  5 Jun 2015 15:28:45 +0200
Message-Id: <1433510925-11438-1-git-send-email-alnovak@suse.cz>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ales Novak <alnovak@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Logbsize should be integer multiple of log stripe unit size. If it's
not, various operations will lead to crashes, due to invalid buffer
sizes, i.e. we've seen crashes in the callpath xlog_sync->xlog_pack_data.

However, this rule is only mentioned in the documentation, while it
could be checked during the mount.

Signed-off-by: Ales Novak <alnovak@suse.cz>
---
 fs/xfs/xfs_super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8fcc4cc..1a3766d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1352,6 +1352,11 @@ xfs_finish_flags(
 			xfs_warn(mp,
 		"logbuf size must be greater than or equal to log stripe size");
 			return -EINVAL;
+		} else if (mp->m_logbsize > 0 && mp->m_sb.sb_logsunit > 0 &&
+			   mp->m_logbsize % mp->m_sb.sb_logsunit) {
+			xfs_warn(mp,
+		"logbuf size must be integer multiple of log stripe size");
+			return -EINVAL;
 		}
 	} else {
 		/* Fail a mount if the logbuf is larger than 32K */
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
