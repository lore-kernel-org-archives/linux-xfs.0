Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CEC1D7F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 06:52:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AAC2A8F8071
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 04:52:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wTvUccOJR9WQnNF6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 04:52:38 -0700 (PDT)
Date: Fri, 20 Mar 2015 07:52:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] libxfs: don't write uninitialized heap contents into
	new directory blocks
Message-ID: <20150320115232.GA19057@laptop.bfoster>
References: <20150319235520.GG24608@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150319235520.GG24608@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 19, 2015 at 04:55:20PM -0700, Darrick J. Wong wrote:
> Clear the contents of the xfs buffer when we're initializing it to avoid
> writing random heap contents (and CRC thereof) to disk.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/rdwr.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 7d73477..35fb366 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -411,6 +411,7 @@ __initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
>  			strerror(errno));
>  		exit(1);
>  	}
> +	memset(bp->b_addr, 0, bytes);
>  #ifdef XFS_BUF_TRACING
>  	list_head_init(&bp->b_lock_list);
>  #endif
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
