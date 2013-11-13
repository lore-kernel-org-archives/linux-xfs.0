Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F6C67F52
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 06:59:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 542DC304039
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 04:59:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rjjCf2v6lKWqGEL6 for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 04:59:28 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADCxQFU009117
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:59:27 -0500
Received: from orion.maiolino.org (ovpn-113-139.phx2.redhat.com [10.3.113.139])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rADCxNAw003454
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:59:26 -0500
Date: Wed, 13 Nov 2013 10:59:22 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH RFC] xfsprogs: suggest "-d" option for repair of RO mount
Message-ID: <20131113125921.GC24615@orion.maiolino.org>
References: <528261AD.50501@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528261AD.50501@redhat.com>
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

Hm, even in single user with a RO root filesystem, changing filesystem
on-disk filesystem structures without have them replied in memory looks
dangerous to me, you will keep data consistency since the fs is RO, but how
about memory? You might have a discrepancy between memory and disk metadata
contents causing in-memory only problems?


On Tue, Nov 12, 2013 at 11:13:17AM -0600, Eric Sandeen wrote:
> How dangerous is dangerous?
> 
> We could offer the suggestion of a "-d" repair, if we're
> in single-user mode with the root fs mounted readonly.
> 
> This change suggests -d to repair any RO mounted fs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/init.c b/repair/init.c
> index c3f380b..a7a7613 100644
> --- a/repair/init.c
> +++ b/repair/init.c
> @@ -97,8 +97,17 @@ xfs_init(libxfs_init_t *args)
>  	else
>  		args->isreadonly = LIBXFS_EXCLUSIVELY;
>  
> -	if (!libxfs_init(args))
> +	if (!libxfs_init(args)) {
> +		/* would -d be an option? */
> +		if (!no_modify && !dangerously) {
> +			args->isreadonly = (LIBXFS_ISINACTIVE |
> +					    LIBXFS_DANGEROUSLY);
> +			if (libxfs_init(args))
> +				fprintf(stderr,
> +_("Unmount or use -d to repair a read-only mounted filesystem\n"));
> +		}
>  		do_error(_("couldn't initialize XFS library\n"));
> +	}
>  
>  	ts_create();
>  	increase_rlimit();
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
