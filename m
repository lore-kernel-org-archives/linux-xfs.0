Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC8037F4E
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 03:06:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D84F304032
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 01:06:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id zbaklzkXDSn5CARL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 01:06:28 -0800 (PST)
Date: Mon, 4 Nov 2013 01:06:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/30] db: verify and calculate dquot CRCs
Message-ID: <20131104090627.GB23564@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-22-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-22-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 30, 2013 at 03:31:12PM +1100, Dave Chinner wrote:
> When we set the current Io cursor to point at a dquot block, verify
> that the dquot CRC is intact. And prior to writing such an IO
> cursor, calculate the dquot CRC.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  db/io.c | 5 ++++-
>  db/io.h | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/db/io.c b/db/io.c
> index 8ddb5e5..7281148 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -464,7 +464,9 @@ write_cur(void)
>  
>  	if (iocur_top->ino_buf)
>  		libxfs_dinode_calc_crc(mp, iocur_top->data);
> -
> +	if (iocur_top->dquot_buf)
> +		xfs_update_cksum(iocur_top->data, sizeof(struct xfs_dqblk),
> +				 XFS_DQUOT_CRC_OFF);

The patch looks good to get going, but it seems we'd be better off going
through an ops vector here in some form..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
