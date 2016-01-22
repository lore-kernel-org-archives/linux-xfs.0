Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E3627F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:07:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6CBAD304059
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 20:07:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5EBvY08jLJvELGk3 for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 20:07:26 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/7] quota: remove unused cmd argument from quota_quotaon()
Date: Thu, 21 Jan 2016 22:07:18 -0600
Message-Id: <1453435644-32261-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
References: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: jack@suse.cz

The cmd argument to quota_quotaon() via Q_QUOTAON quotactl
is not used, so remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/quota/quota.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 3746367..ea66670 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -79,7 +79,7 @@ unsigned int qtype_enforce_flag(int type)
 	return 0;
 }
 
-static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
+static int quota_quotaon(struct super_block *sb, int type, qid_t id,
 		         struct path *path)
 {
 	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_enable)
@@ -659,7 +659,7 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 
 	switch (cmd) {
 	case Q_QUOTAON:
-		return quota_quotaon(sb, type, cmd, id, path);
+		return quota_quotaon(sb, type, id, path);
 	case Q_QUOTAOFF:
 		return quota_quotaoff(sb, type);
 	case Q_GETFMT:
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
