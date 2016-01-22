Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B87777F55
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:07:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57C88AC001
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 20:07:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0CzJktgl96cgxzeq for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 20:07:26 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/7] xfs: don't overflow quota ID when initializing dqblk
Date: Thu, 21 Jan 2016 22:07:21 -0600
Message-Id: <1453435644-32261-5-git-send-email-sandeen@redhat.com>
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

Quota IDs are unsigned, and so we can pass in values up
to 2^32-1.  But if we try to initialize a block containing
values over MAX_INT, curid will overflow and assert.

curid holds a quota ID, so give it the proper
xfs_dqid_t type (and remove the now-impossible ASSERT).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_dquot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9c44d38..c9c7c2d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -232,7 +232,8 @@ xfs_qm_init_dquot_blk(
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	xfs_dqblk_t	*d;
-	int		curid, i;
+	xfs_dqid_t	curid;
+	int		i;
 
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
@@ -243,7 +244,6 @@ xfs_qm_init_dquot_blk(
 	 * ID of the first dquot in the block - id's are zero based.
 	 */
 	curid = id - (id % q->qi_dqperchunk);
-	ASSERT(curid >= 0);
 	memset(d, 0, BBTOB(q->qi_dqchunklen));
 	for (i = 0; i < q->qi_dqperchunk; i++, d++, curid++) {
 		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
