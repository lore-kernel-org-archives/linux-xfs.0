Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Feb 2007 21:32:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1G5WNm7019083
	for <xfs@oss.sgi.com>; Thu, 15 Feb 2007 21:32:25 -0800
Message-ID: <45D541CF.2070106@sgi.com>
Date: Fri, 16 Feb 2007 16:31:59 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix the grace time in xfs_quota
References: <200702150739.AA04964@TNESG9305.tnes.nec.co.jp>
In-Reply-To: <200702150739.AA04964@TNESG9305.tnes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <utako@tnes.nec.co.jp>
Cc: xfs@oss.sgi.com

Hi Utako,

I was unable to reproduce these results internally (sgi-xfsprogs-2.8.16-1sgi100b2chatz).
But I think your patch looks good, these really should be time_t's.

$ sudo /usr/sbin/xfs_quota -xc report /mnt/test
User quota on /mnt/test (/dev/sdb5)
                               Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
bin               168          0          0     00 [--------]
games             608          0          0     00 [--------]
root           125948          0          0     00  [0 days]
donaldd         15000      10240      20480     00 [00:00:11]

$ sudo /usr/sbin/xfs_quota -xc report /mnt/test
User quota on /mnt/test (/dev/sdb5)
                               Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
bin               168          0          0     00 [--------]
games             608          0          0     00 [--------]
root           125948          0          0     00  [0 days]
donaldd         15000      10240      20480     00  [0 days]

Thanks for the patch,
Donald

Utako Kusaka wrote:
...
> Example:
> xfs_quota> report
> User quota on /home/utako/mpnt (/dev/sda6)
>                                Blocks
> User ID          Used       Soft       Hard    Warn/Grace
> ---------- --------------------------------------------------
> root          3145728       1000       2000     00 [--none--]
> utako            1000       1000       2000     00 [00:00:4294967286]  <--
> 
> Group quota on /home/utako/mpnt (/dev/sda6)
>                                Blocks
> Group ID         Used       Soft       Hard    Warn/Grace
> ---------- --------------------------------------------------
> root          3145728          0          0     00 [--------]
> users            1000          0          0     00 [--------]

> Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
> ---
> 
> --- xfsprogs-2.8.18-orgn/quota/quota.h	2006-12-13 13:57:23.000000000 +0900
> +++ xfsprogs-2.8.18/quota/quota.h	2007-02-15 11:51:20.000000000 +0900
> @@ -49,7 +49,7 @@ enum {
>   */
>  extern char *type_to_string(uint __type);
>  extern char *form_to_string(uint __form);
> -extern char *time_to_string(__uint32_t __time, uint __flags);
> +extern char *time_to_string(time_t __time, uint __flags);
>  extern char *bbs_to_string(__uint64_t __v, char *__c, uint __size);
>  extern char *num_to_string(__uint64_t __v, char *__c, uint __size);
>  extern char *pct_to_string(__uint64_t __v, __uint64_t __t, char *__c, uint __s);
> 
> 
> --- xfsprogs-2.8.18-orgn/quota/util.c	2006-12-13 13:57:23.000000000 +0900
> +++ xfsprogs-2.8.18/quota/util.c	2007-02-15 11:51:51.000000000 +0900
> @@ -29,7 +29,7 @@
>  
>  char *
>  time_to_string(
> -	__uint32_t	origin,
> +	time_t		origin,
>  	uint		flags)
>  {
>  	static char	timestamp[32];
> 
> 
