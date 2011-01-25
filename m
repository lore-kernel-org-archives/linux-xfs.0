Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P8p62q224577 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 02:51:06 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 590EE1DC15C8
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 00:53:28 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jlgjMB7Lr3Pp07FS for <xfs@oss.sgi.com>;
	Tue, 25 Jan 2011 00:53:28 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PheeI-0003xf-Uw
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:53:14 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Phebw-0007gS-No
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:50:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: prevent extsize alignment from exceeding maximum
	extent size
Date: Tue, 25 Jan 2011 19:50:41 +1100
Message-Id: <1295945444-29488-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1295945444-29488-1-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When doing delayed allocation, if the allocation size is for a
maximally sized extent, extent size alignment can push it over this
limit. This results in an assert failure in xfs_bmbt_set_allf() as
the extent length is too large to find in the extent record.

Fix this by ensuring that we allow for space that extent size
alignment requires (up to 2 * (extsize -1) blocks as we have to
handle both head and tail alignment) when limiting the maximum size
of the extent.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 74861c6..3e5a91a 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4487,6 +4487,16 @@ xfs_bmapi(
 				/* Figure out the extent size, adjust alen */
 				extsz = xfs_get_extsz_hint(ip);
 				if (extsz) {
+					/*
+					 * make sure we don't exceed a single
+					 * extent length when we align the
+					 * extent by reducing length we are
+					 * going to allocate by the maximum
+					 * amount extent size aligment may
+					 * require.
+					 */
+					alen = XFS_FILBLKS_MIN( len,
+						   MAXEXTLEN - (2 * extsz - 1));
 					error = xfs_bmap_extsize_align(mp,
 							&got, &prev, extsz,
 							rt, eof,
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
