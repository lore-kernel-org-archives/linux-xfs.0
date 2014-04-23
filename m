Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0596C7F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 01:10:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EAEAE304051
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 23:10:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gGohZRlQnBbEBnAD for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 23:10:42 -0700 (PDT)
Date: Wed, 23 Apr 2014 16:10:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 14/20] xfsprogs/repair: phase 2 finobt scan
Message-ID: <20140423061039.GM15995@dastard>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
	<1397146270-42993-15-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397146270-42993-15-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 12:11:04PM -0400, Brian Foster wrote:
> If one exists, scan the free inode btree in phase 2 of xfs_repair.
> We use the same general infrastructure as for the inobt scan, but
> trigger finobt chunk scan logic in in scan_inobt() via the magic
> value.
> 
> The new scan_single_finobt_chunk() function is similar to the inobt
> equivalent with some finobt specific logic. We can expect that
> underlying inode chunk blocks are already marked used due to the
> previous inobt scan. We can also expect to find every record
> tracked by the finobt already accounted for in the in-core tree
> with equivalent (and internally consistent) inobt record data.
> 
> Spit out a warning on any divergences from the above and add the
> inodes referenced by the current finobt record to the appropriate
> in-core tree.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
.....
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> +		bno = be32_to_cpu(agi->agi_free_root);
> +		if (bno != 0 && verify_agbno(mp, agno, bno)) {
> +			magic = xfs_sb_version_hascrc(&mp->m_sb) ?
> +					XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
> +			scan_sbtree(bno, be32_to_cpu(agi->agi_free_level),
> +				    agno, 0, scan_inobt, 1, magic, agcnts,
> +				    &xfs_inobt_buf_ops);
> +		} else {
> +			do_warn(_("bad agbno %u for finobt root, agno %d\n"),
> +				be32_to_cpu(agi->agi_free_root), agno);
> +		}
> +	}
> +

This generates a new repair output in xfs/030, so the xfstests repair
filter will need to be updated.

--- tests/xfs/030.out   2014-01-20 16:57:33.000000000 +1100
+++ results//xfs/030.out.bad        2014-04-23 15:28:29.000000000 +1000
@@ -82,6 +82,7 @@
 bad length # 0 for agi 0, should be LENGTH
 reset bad agi for ag 0
 bad agbno AGBNO for inobt root, agno 0
+bad agbno AGBNO for finobt root, agno 0
 root inode chunk not found
 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
@@ -204,6 +205,7 @@
 bad length # -1 for agi 0, should be LENGTH
 reset bad agi for ag 0
 bad agbno AGBNO for inobt root, agno 0
+bad agbno AGBNO for finobt root, agno 0
 root inode chunk not found
 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
