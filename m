Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C8FC7F8B
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:38:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3BA48304084
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:38:04 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id TQHsdFGj1qy7uEZg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:38:02 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 16/25] quota: Verify flags passed to Q_SETINFO
Date: Thu, 18 Dec 2014 16:37:30 +0100
Message-Id: <1418917059-23870-17-git-send-email-jack@suse.cz>
In-Reply-To: <1418917059-23870-1-git-send-email-jack@suse.cz>
References: <1418917059-23870-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

Currently flags passed via Q_SETINFO were just stored. This makes it
hard to add new flags since in theory userspace could be just setting /
clearing random flags. Since currently there is only one userspace
settable flag and that is somewhat obscure flags only for ancient v1
quota format, I'm reasonably sure noone operates these flags and
hopefully we are fine just adding the check that passed flags are sane.
If we indeed find some userspace program that gets broken by the strict
check, we can always remove it again.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a6b5795a4181..02d571cb010a 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2649,6 +2649,14 @@ int dquot_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
 		goto out;
 	}
 	mi = sb_dqopt(sb)->info + type;
+	if (ii->dqi_valid & IIF_FLAGS) {
+		if (ii->dqi_flags & ~DQF_SETINFO_MASK ||
+		    (ii->dqi_flags & DQF_ROOT_SQUASH &&
+		     mi->dqi_format->qf_fmt_id != QFMT_VFS_OLD)) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
 	spin_lock(&dq_data_lock);
 	if (ii->dqi_valid & IIF_BGRACE)
 		mi->dqi_bgrace = ii->dqi_bgrace;
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
