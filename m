Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Oct 2008 21:31:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9B4VCm1029910
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2008 21:31:12 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6EF013EAB6B
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2008 21:32:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id iNoOF68Tp6OEBgxS for <xfs@oss.sgi.com>; Fri, 10 Oct 2008 21:32:53 -0700 (PDT)
Message-ID: <48F02C74.8080902@sandeen.net>
Date: Fri, 10 Oct 2008 23:32:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db: don't put null inode
References: <48F02BB0.2030107@sandeen.net>
In-Reply-To: <48F02BB0.2030107@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: John Willis <John.Willis@Distant-earth.com>

Ugh subject should be xfs_db of course :/

Eric Sandeen wrote:
> John Willis pointed this out:
> 
> $ sudo xfs_db -x /dev/evms/RAID5-SATA-1 
> cache_node_purge: refcount was 1, not zero (node=0x80dd660)
> xfs_db: cannot read root inode (22)
> cache_node_purge: refcount was 1, not zero (node=0x80e0008)
> xfs_db: cannot read realtime bitmap inode (22)
> Segmentation fault
> 
> it dies when pthread code gets a null ptr, like this:
> 
> (gdb) bt
> #0  0x0000003ef1c08309 in pthread_mutex_lock () from /lib64/libpthread.so.0
> #1  0x000000000044f5af in cache_node_put (cache=0x25a2030, node=0x0) at cache.c:368
> #2  0x000000000041ff7e in libxfs_mount (mp=0x0, sb=<value optimized out>, dev=<value optimized out>, logdev=<value optimized out>, 
>     rtdev=<value optimized out>, flags=1) at init.c:680
> #3  0x0000000000416157 in init (argc=2, argv=0x7fffd9e19798) at init.c:125
> #4  0x000000000041635a in main (argc=48, argv=0x7fffd9e19798) at init.c:153
> (gdb) 
> 
> when reading the root inode fails, and we try to libxfs_iput it anyway.
> 
> The following seems to fix it ...
> 
> -Eric
> 
> Index: xfsprogs/libxfs/init.c
> ===================================================================
> --- xfsprogs.orig/libxfs/init.c
> +++ xfsprogs/libxfs/init.c
> @@ -677,7 +677,8 @@ libxfs_mount(
>  		ASSERT(mp->m_rootip != NULL);
>  	}
>  	if ((flags & LIBXFS_MOUNT_ROOTINOS) && rtmount_inodes(mp)) {
> -		libxfs_iput(mp->m_rootip, 0);
> +		if (mp->m_rootip)
> +			libxfs_iput(mp->m_rootip, 0);
>  		return NULL;
>  	}
>  
> 
> 
