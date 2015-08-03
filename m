Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6351D7F58
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 11:18:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E284FAC004
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:18:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id i1tZ23fbqr7GWDDa for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 09:18:03 -0700 (PDT)
Message-ID: <55BF9439.8010003@sandeen.net>
Date: Mon, 03 Aug 2015 09:18:01 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] xfs: growfs not aware of sb_meta_uuid
References: <1438587625-31437-1-git-send-email-david@fromorbit.com>
	<1438587625-31437-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1438587625-31437-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 8/3/15 12:40 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Adding this simple change to xfstests:common/rc::_scratch_mkfs_xfs:
> 
> +       if [ $mkfs_status -eq 0 ]; then
> +               xfs_admin -U generate $SCRATCH_DEV > /dev/null
> +       fi
> 
> triggers all sorts of errors in xfstests. xfs/104 is an example,
> where growfs fails with a UUID mismatch corruption detected by
> xfs_agf_write_verify() when trying to write the first new AG
> headers.
> 
> Fix this problem by making sure we copy the sb_meta_uuid into new
> metadata written by growfs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ok, at least this one has a plausible story; I did have this
in my tree, and must have somehow (re?)sent outdated patches. :(
Yeah, it was in all the series I sent up until the last re-send,
damn.

I'll re-check those prior patches against what we end up with,
to make sure everything is in sync.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_fsops.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 9b3438a..ee3aaa0a 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -250,7 +250,7 @@ xfs_growfs_data_private(
>  		agf->agf_freeblks = cpu_to_be32(tmpsize);
>  		agf->agf_longest = cpu_to_be32(tmpsize);
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
> -			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
>  
>  		error = xfs_bwrite(bp);
>  		xfs_buf_relse(bp);
> @@ -273,7 +273,7 @@ xfs_growfs_data_private(
>  		if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  			agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
>  			agfl->agfl_seqno = cpu_to_be32(agno);
> -			uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
>  		}
>  
>  		agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
> @@ -309,7 +309,7 @@ xfs_growfs_data_private(
>  		agi->agi_newino = cpu_to_be32(NULLAGINO);
>  		agi->agi_dirino = cpu_to_be32(NULLAGINO);
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
> -			uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
>  		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
>  			agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
>  			agi->agi_free_level = cpu_to_be32(1);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
