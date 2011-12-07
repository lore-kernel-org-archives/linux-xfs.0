Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB7GMpNa101077 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 10:22:51 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4986B16EC62A
	for <xfs@oss.sgi.com>; Wed,  7 Dec 2011 08:22:44 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id EqZdNcDkXd3oxFPc for <xfs@oss.sgi.com>;
	Wed, 07 Dec 2011 08:22:44 -0800 (PST)
Message-Id: <20111207161218.969833891@clark.kroah.org>
Date: Wed, 07 Dec 2011 08:11:53 -0800
From: Greg KH <gregkh@suse.de>
Subject: [051/104] xfs: use doalloc flag in xfs_qm_dqattach_one()
In-Reply-To: <20111207161246.GA10995@kroah.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, greg@kroah.com
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, bpm@sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>

commit db3e74b582915d66e10b0c73a62763418f54c340 upstream.

The doalloc arg in xfs_qm_dqattach_one() is a flag that indicates
whether a new area to handle quota information will be allocated
if needed. Originally, it was passed to xfs_qm_dqget(), but has
been removed by the following commit (probably by mistake):

	commit 8e9b6e7fa4544ea8a0e030c8987b918509c8ff47
	Author: Christoph Hellwig <hch@lst.de>
	Date:   Sun Feb 8 21:51:42 2009 +0100

	xfs: remove the unused XFS_QMOPT_DQLOCK flag

As the result, xfs_qm_dqget() called from xfs_qm_dqattach_one()
never allocates the new area even if it is needed.

This patch gives the doalloc arg to xfs_qm_dqget() in
xfs_qm_dqattach_one() to fix this problem.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_qm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -674,7 +674,8 @@ xfs_qm_dqattach_one(
 	 * disk and we didn't ask it to allocate;
 	 * ESRCH if quotas got turned off suddenly.
 	 */
-	error = xfs_qm_dqget(ip->i_mount, ip, id, type, XFS_QMOPT_DOWARN, &dqp);
+	error = xfs_qm_dqget(ip->i_mount, ip, id, type,
+			     doalloc | XFS_QMOPT_DOWARN, &dqp);
 	if (error)
 		return error;
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
