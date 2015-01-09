Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E7127F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 07:49:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3347AC003
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 05:48:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Bfib5iIQwaGmw0Dm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 05:48:54 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t09Dmrpt029053
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 9 Jan 2015 08:48:54 -0500
Received: from sh-el6.eng.rdu2.redhat.com (sh-el6.eng.rdu2.redhat.com
	[10.10.160.69])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t09DmqbH007851
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 9 Jan 2015 08:48:53 -0500
Date: Fri, 9 Jan 2015 08:48:51 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: remove deprecated sysctls
Message-ID: <20150109134851.GE28570@sh-el6.eng.rdu2.redhat.com>
References: <1420667006-7377-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420667006-7377-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

Looks good to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Thu, Jan 08, 2015 at 08:43:26AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfsbufd_centisecs and age_buffer_centisecs were due for removal in
> 3.14. We forgot to do that - it's now well past time to remove these
> deprecated, unused sysctls.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  Documentation/filesystems/xfs.txt | 17 +++++++----------
>  fs/xfs/xfs_sysctl.c               | 18 ------------------
>  2 files changed, 7 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 5be51fd..7077103 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -348,16 +348,13 @@ The following sysctls are available for the XFS filesystem:
>  Deprecated Sysctls
>  ==================
>  
> -  fs.xfs.xfsbufd_centisecs	(Min: 50  Default: 100	Max: 3000)
> -	Dirty metadata is now tracked by the log subsystem and
> -	flushing is driven by log space and idling demands. The
> -	xfsbufd no longer exists, so this syctl does nothing.
> +None at present.
>  
> -	Due for removal in 3.14.
>  
> -  fs.xfs.age_buffer_centisecs	(Min: 100  Default: 1500  Max: 720000)
> -	Dirty metadata is now tracked by the log subsystem and
> -	flushing is driven by log space and idling demands. The
> -	xfsbufd no longer exists, so this syctl does nothing.
> +Removed Sysctls
> +===============
>  
> -	Due for removal in 3.14.
> +  Name				Removed
> +  ----				-------
> +  fs.xfs.xfsbufd_centisec	v3.20
> +  fs.xfs.age_buffer_centisecs	v3.20
> diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
> index 1743b9f..a0c8067 100644
> --- a/fs/xfs/xfs_sysctl.c
> +++ b/fs/xfs/xfs_sysctl.c
> @@ -149,24 +149,6 @@ static struct ctl_table xfs_table[] = {
>  		.extra2		= &xfs_params.inherit_noatim.max
>  	},
>  	{
> -		.procname	= "xfsbufd_centisecs",
> -		.data		= &xfs_params.xfs_buf_timer.val,
> -		.maxlen		= sizeof(int),
> -		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_minmax,
> -		.extra1		= &xfs_params.xfs_buf_timer.min,
> -		.extra2		= &xfs_params.xfs_buf_timer.max
> -	},
> -	{
> -		.procname	= "age_buffer_centisecs",
> -		.data		= &xfs_params.xfs_buf_age.val,
> -		.maxlen		= sizeof(int),
> -		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_minmax,
> -		.extra1		= &xfs_params.xfs_buf_age.min,
> -		.extra2		= &xfs_params.xfs_buf_age.max
> -	},
> -	{
>  		.procname	= "inherit_nosymlinks",
>  		.data		= &xfs_params.inherit_nosym.val,
>  		.maxlen		= sizeof(int),
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
