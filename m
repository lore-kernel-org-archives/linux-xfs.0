Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 00:18:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5I7ISUS015915
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 00:18:29 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA13695; Wed, 18 Jun 2008 17:19:16 +1000
Message-ID: <4858B6F4.5010705@sgi.com>
Date: Wed, 18 Jun 2008 17:19:16 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix XFSQA 144
References: <20080614192248.GA24329@lst.de>
In-Reply-To: <20080614192248.GA24329@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Two really dumb bugs:
> 
>  - "foo & 0x3FFFFFFFFFFFF" doesn't cap at 1TB, but rather at more than
>    two magnitudes larger than that.  That gets us EFBIG with typical
>    32bit XFS setups.
>  - the command array can easily overflow and thus let the test fail
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, thanks for the fix.
Checking it in now.

> 
> 
> Index: xfstests/dmapi/src/suite2/src/test_fileattr.c
> ===================================================================
> RCS file: /cvs/xfs-cmds/xfstests/dmapi/src/suite2/src/test_fileattr.c,v
> retrieving revision 1.12
> diff -u -p -r1.12 test_fileattr.c
> --- xfstests/dmapi/src/suite2/src/test_fileattr.c	21 Sep 2007 04:15:06 -0000	1.12
> +++ xfstests/dmapi/src/suite2/src/test_fileattr.c	14 Jun 2008 19:12:43 -0000
> @@ -160,7 +160,7 @@ main(
>  	char		*ls_path;
>  	char		*pathname;
>  	char            test_file[100];
> -	char            command[100];
> +	char            command[200];
>  	int		num_files=50;
>  	dm_stat_t	*stat_arr;
>  	dm_stat_t	dmstat;
> @@ -244,7 +244,7 @@ main(
>  	  stat_arr[i].dt_uid=(uid_t)(rand()+rand()*0x10000);
>  	  stat_arr[i].dt_gid=(gid_t)(rand()+rand()*0x10000);
>  	  stat_arr[i].dt_mode=(mode_t)((rand()%4096)+32768);
> -          stat_arr[i].dt_size=((dm_off_t)(rand()+rand()*0x10000)) & 0x3FFFFFFFFFFFF; /* 1 TB max */
> +          stat_arr[i].dt_size=((dm_off_t)(rand()+rand()*0x10000)) & 0x1FFFFFFFFFFULL; /* 1 TB max */
>  	}	
>  
>  	/*-----------------------------------------------------*\
> 
