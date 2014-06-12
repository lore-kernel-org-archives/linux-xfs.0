Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1919F7F3F
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 10:05:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA2F6304048
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 08:05:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KkCALa5JXAV4U5PR for
	<xfs@oss.sgi.com>; Thu, 12 Jun 2014 08:05:00 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5CF50EW008535
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 11:05:00 -0400
Date: Thu, 12 Jun 2014 11:00:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't send null bp to xfs_trans_brelse()
Message-ID: <20140612150000.GA3148@laptop.bfoster>
References: <53978301.3050105@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53978301.3050105@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 10, 2014 at 05:13:21PM -0500, Eric Sandeen wrote:
> In this case, if bp is null, error is set, and we send
> bp to xfs_trans_brelse, which will try to dereference it.
> 
> Test whether we actualy have a buffer before we try to
> free it.
> 
> Coverity spotted this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
> index 6cc5f67..41f7a42 100644
> --- a/fs/xfs/xfs_da_btree.c
> +++ b/fs/xfs/xfs_da_btree.c
> @@ -2571,7 +2571,8 @@ xfs_da_get_buf(
>  				    mapp, nmap, 0);
>  	error = bp ? bp->b_error : XFS_ERROR(EIO);
>  	if (error) {
> -		xfs_trans_brelse(trans, bp);
> +		if (bp)
> +			xfs_trans_brelse(trans, bp);
>  		goto out_free;
>  	}
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
