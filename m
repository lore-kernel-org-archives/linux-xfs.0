Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5EA8LAB036220 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 05:08:21 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BBAF12AD31A
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 03:14:23 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id BqOLHgkGuZIkIRZ1 for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 03:14:23 -0700 (PDT)
Date: Mon, 14 Jun 2010 12:10:36 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] quota: don't disable accounting with quotaoff
Message-ID: <20100614101035.GD3903@quack.suse.cz>
References: <4C12B40A.2070405@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C12B40A.2070405@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

  Hi,

On Fri 11-06-10 17:09:14, Eric Sandeen wrote:
> The quotaon(8) man page says:
> 
> NOTES ON XFS FILESYSTEMS
> ...
>        To turn off quota limit enforcement on any XFS filesys-
>        tem, first make sure that quota accounting and enforce-
>        ment  are  both turned on using repquota -v filesystem.
>        Then, use  quotaoff  -v  filesystem  to  disable  limit
>        enforcement.   This may be done while the filesystem is
>        mounted.
> 
>        Turning on quota limit enforcement on an XFS filesystem
>        is  achieved  using quotaon -v filesystem.  This may be
>        done while the filesystem is mounted
> 
> however, quotaoff turns off both enforcement -and- accounting,
> and then quotaon fails.
> 
> If the manpage describes the intended behavior, then I think the
> following patch is needed.
  Yes, I think this behavior makes more sence. Applied.

								Honza
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> --- quota-tools/quotaon_xfs.c	2010-01-05 10:39:54.000000000 -0500
> +++ quota-tools-mine/quotaon_xfs.c	2010-06-11 17:45:12.000000000 -0400
> @@ -208,10 +208,9 @@
>  	}
>  #endif /* XFS_ROOTHACK */
>  
> -	if (xarg == NULL) {	/* both acct & enfd on/off */
> -		xopts |= (type == USRQUOTA) ?
> -			(XFS_QUOTA_UDQ_ACCT | XFS_QUOTA_UDQ_ENFD) :
> -			(XFS_QUOTA_GDQ_ACCT | XFS_QUOTA_GDQ_ENFD);
> +	if (xarg == NULL) {	/* only enfd on/off */
> +		xopts |= (type == USRQUOTA) ? XFS_QUOTA_UDQ_ENFD :
> +			XFS_QUOTA_GDQ_ENFD;
>  		err = xfs_onoff((char *)dev, type, flags, roothack, xopts);
>  	}
>  	else if (strcmp(xarg, "account") == 0) {
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
