Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p87EH4AX164963 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 09:17:04 -0500
Received: from e31.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2663141F70
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 07:17:03 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id M8qecGPC3NU6GvFc for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2011 07:17:03 -0700 (PDT)
Received: from /spool/local by us.ibm.com with XMail ESMTP
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 7 Sep 2011 08:14:30 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p87EDvFg165222 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 08:13:59 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p878DtoC027872
	for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 02:13:56 -0600
Subject: Re: [PATCH] xfs: fix possible overflow in xfs_ioc_trim()
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1315233205-27093-1-git-send-email-lczerner@redhat.com>
References: <1315233205-27093-1-git-send-email-lczerner@redhat.com>
Date: Wed, 07 Sep 2011 09:13:53 -0500
Message-ID: <1315404833.3195.10.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, 2011-09-05 at 16:33 +0200, Lukas Czerner wrote:
> In xfs_ioc_trim it is possible that start+len might overflow. Fix it by
> decrementing the len so that start+len equals to the file system size in
> the worst case.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/xfs/xfs_discard.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 244e797..0fab107 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -146,6 +146,7 @@ xfs_ioc_trim(
>  	unsigned int		granularity = q->limits.discard_granularity;
>  	struct fstrim_range	range;
>  	xfs_fsblock_t		start, len, minlen;
> +	xfs_fsblock_t		max_blks =  XFS_MAX_DBLOCKS(&(mp->m_sb));
>  	xfs_agnumber_t		start_agno, end_agno, agno;
>  	__uint64_t		blocks_trimmed = 0;
>  	int			error, last_error = 0;
> @@ -171,7 +172,8 @@ xfs_ioc_trim(
>  	start_agno = XFS_FSB_TO_AGNO(mp, start);
>  	if (start_agno >= mp->m_sb.sb_agcount)
>  		return -XFS_ERROR(EINVAL);
> -
> +	if (len > max_blks)

just wondering....

shouldn't this be ((start + len) > max_blks) ?

> +		len = max_blks - start;
>  	end_agno = XFS_FSB_TO_AGNO(mp, start + len);
>  	if (end_agno >= mp->m_sb.sb_agcount)
>  		end_agno = mp->m_sb.sb_agcount - 1;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
