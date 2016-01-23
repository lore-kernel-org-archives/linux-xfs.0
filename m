Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E14027F37
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2016 07:13:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C49A28F804B
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2016 05:13:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MoHDDSvEJW6v5Q0B (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 23 Jan 2016 05:13:22 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 2AAC33B712
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2016 13:13:22 +0000 (UTC)
Date: Sat, 23 Jan 2016 08:13:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't overflow quota ID when initializing dqblk
Message-ID: <20160123131318.GA2795@bfoster.bfoster>
References: <56A01BB4.1050409@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56A01BB4.1050409@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 20, 2016 at 05:43:48PM -0600, Eric Sandeen wrote:
> Quota IDs are unsigned, and so we can pass in values up
> to 2^32-1.  But if we try to initialize a block containing
> values over MAX_INT, curid will overflow and assert.
> 
> curid holds a quota ID, so give it the proper
> xfs_dqid_t type (and remove the now-impossible ASSERT).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 83ce4aa..5d92bb5 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -232,7 +232,8 @@ xfs_qm_init_dquot_blk(
>  {
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	xfs_dqblk_t	*d;
> -	int		curid, i;
> +	xfs_dqid_t	curid;
> +	int		i;
>  
>  	ASSERT(tp);
>  	ASSERT(xfs_buf_islocked(bp));
> @@ -243,7 +244,6 @@ xfs_qm_init_dquot_blk(
>  	 * ID of the first dquot in the block - id's are zero based.
>  	 */
>  	curid = id - (id % q->qi_dqperchunk);
> -	ASSERT(curid >= 0);
>  	memset(d, 0, BBTOB(q->qi_dqchunklen));
>  	for (i = 0; i < q->qi_dqperchunk; i++, d++, curid++) {
>  		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
