Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D66FD7F96
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 15:08:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA0428F8033
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 13:08:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xALUbt3KvFSmgCQc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2015 13:08:33 -0700 (PDT)
Date: Fri, 9 Oct 2015 16:08:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] xfs_metadump: Fix unaligned accesses
Message-ID: <20151009200831.GI27982@bfoster.bfoster>
References: <56181A17.9080503@sandeen.net>
 <56181B1C.6030508@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56181B1C.6030508@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Oct 09, 2015 at 02:53:00PM -0500, Eric Sandeen wrote:
> This fixes some unaligned accesses spotted by libubsan in
> xfs_metadump.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/metadump.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index af96e12..39f893d 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1872,8 +1872,8 @@ scanfunc_bmap(
>  		xfs_agnumber_t	ag;
>  		xfs_agblock_t	bno;
>  
> -		ag = XFS_FSB_TO_AGNO(mp, be64_to_cpu(pp[i]));
> -		bno = XFS_FSB_TO_AGBNO(mp, be64_to_cpu(pp[i]));
> +		ag = XFS_FSB_TO_AGNO(mp, get_unaligned_be64(&pp[i]));
> +		bno = XFS_FSB_TO_AGBNO(mp, get_unaligned_be64(&pp[i]));
>  
>  		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
>  				ag > mp->m_sb.sb_agcount) {
> @@ -1938,8 +1938,8 @@ process_btinode(
>  		xfs_agnumber_t	ag;
>  		xfs_agblock_t	bno;
>  
> -		ag = XFS_FSB_TO_AGNO(mp, be64_to_cpu(pp[i]));
> -		bno = XFS_FSB_TO_AGBNO(mp, be64_to_cpu(pp[i]));
> +		ag = XFS_FSB_TO_AGNO(mp, get_unaligned_be64(&pp[i]));
> +		bno = XFS_FSB_TO_AGBNO(mp, get_unaligned_be64(&pp[i]));
>  
>  		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
>  				ag > mp->m_sb.sb_agcount) {
> -- 
> 2.6.1
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
