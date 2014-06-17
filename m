Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A80E529E01
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 10:05:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8F68D8F8074
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 08:05:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YGISD8C6cuyANVLd for
	<xfs@oss.sgi.com>; Tue, 17 Jun 2014 08:05:01 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5HF50FP021106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 11:05:01 -0400
Date: Tue, 17 Jun 2014 11:04:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] libxfs: don't send null bp to xfs_trans_brelse()
Message-ID: <20140617150458.GC8905@bfoster.bfoster>
References: <1402960461-27881-1-git-send-email-sandeen@redhat.com>
	<1402960461-27881-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402960461-27881-2-git-send-email-sandeen@redhat.com>
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

On Mon, Jun 16, 2014 at 06:14:20PM -0500, Eric Sandeen wrote:
> In this case, if bp is null, error is set, and we send
> bp to xfs_trans_brelse, which will try to dereference it.
> 
> Test whether we actualy have a buffer before we try to
> free it.
> 
> Same fix as was sent for kernelspace.
> 
> Coverity spotted this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/xfs_da_btree.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
> index b70454e..b731b54 100644
> --- a/libxfs/xfs_da_btree.c
> +++ b/libxfs/xfs_da_btree.c
> @@ -2582,7 +2582,8 @@ xfs_da_get_buf(
>  				    mapp, nmap, 0);
>  	error = bp ? bp->b_error : XFS_ERROR(EIO);
>  	if (error) {
> -		xfs_trans_brelse(trans, bp);
> +		if (bp)
> +			xfs_trans_brelse(trans, bp);
>  		goto out_free;
>  	}
>  
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
