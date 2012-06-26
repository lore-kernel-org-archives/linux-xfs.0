Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5QI97iU133864 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 13:09:08 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id V8c4t8Pjsd1zHtFb for
	<xfs@oss.sgi.com>; Tue, 26 Jun 2012 11:09:07 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5QI96l5011651
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 14:09:06 -0400
Received: from andromeda.usersys.redhat.com (vpn1-4-112.gru2.redhat.com
	[10.97.4.112])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q5QI93Gc005169
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 14:09:05 -0400
Date: Tue, 26 Jun 2012 15:09:02 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: synchronously write the superblock on unmount
Message-ID: <20120626180902.GA8842@andromeda.usersys.redhat.com>
References: <20120626160051.364635296@sgi.com>
	<20120626160102.898671754@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120626160102.898671754@sgi.com>
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
To: xfs@oss.sgi.com

Hi,

comments inlined below

> @@ -1571,19 +1569,16 @@ xfs_log_sbcount(xfs_mount_t *mp)
>  	 * counters on every modification.
>  	 */
>  	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
> -		return 0;
> +	return 0;
	^^^
I'd like to point this cosmetic thing about properly alignment of the
statement with its parent if condition.
>  
> ===================================================================
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -371,7 +371,9 @@ typedef struct xfs_mod_sb {
>  	int64_t		msb_delta;	/* Change to make to specified field */
>  } xfs_mod_sb_t;
>  
> -extern int	xfs_log_sbcount(xfs_mount_t *);
> +extern int
> +xfs_write_sbcount(
> +	struct xfs_mount *mp);
I would also write it in one single line, but this is just my point of view

Otherwise, looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
