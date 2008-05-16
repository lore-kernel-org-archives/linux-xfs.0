Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 03:34:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4GAYMG7012240
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 03:34:23 -0700
Received: from mail.arkeia.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B04AC17CB9B
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 03:35:08 -0700 (PDT)
Received: from mail.arkeia.com (mail2.fr.arkeia.com [62.240.235.218]) by cuda.sgi.com with ESMTP id Q3FDicKwY8BZ68Il for <xfs@oss.sgi.com>; Fri, 16 May 2008 03:35:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.arkeia.com (Postfix) with ESMTP id 9AC2C4BCBD7
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 12:35:07 +0200 (CEST)
Received: from mail.arkeia.com ([127.0.0.1])
	by localhost (mail.arkeia.com [127.0.0.1]) (amavisd-new, port 42001)
	with ESMTP id M8ALKuAU1Fxd for <xfs@oss.sgi.com>;
	Fri, 16 May 2008 12:35:01 +0200 (CEST)
Received: from [10.1.14.5] (hubert.bat2.fr.arkeia.com [10.1.14.5])
	by mail.arkeia.com (Postfix) with ESMTP id DFE6C4BCBCC
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 12:35:01 +0200 (CEST)
Message-ID: <482D6388.7040602@free.fr>
Date: Fri, 16 May 2008 12:35:52 +0200
From: Hubert Verstraete <hubskml@free.fr>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS tuning on software RAID5 partitionable array; error
 in xfsprogs 2.9.8
References: <47D90614.9040206@free.fr> <18408.36753.223347.129420@notabene.brown> <47E92EE2.1080108@free.fr> <20080326065232.GA21970@percy.comedia.it> <47EA71BF.8050800@tmr.com> <47EA8CF4.7080201@free.fr> <47EA99AD.9060400@free.fr>
In-Reply-To: <47EA99AD.9060400@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello

First, thank you for including the patch in xfsprogs-2.9.8.
I have just reviewed the new source code; unfortunately, I found out a 
change from the original patch that could generate a segmentation fault.

The line 89 in libdisk/md.c is: "free(dfile2);" but it should have 
remained "if (dfile2) free(dfile2);" because dfile2 is null in case 
mkfs.xfs is run on an MD device.

Regards,
Hubert Verstraete

Hubert Verstraete wrote:
> Hi XFS list,
>
> please find attached a patch for libdisk/mkfs.xfs which tunes XFS on 
> software partitionable RAID arrays, also called mdp.
>
> Hubert Verstraete
>
> ------------------------------------------------------------------------
> 
> diff -u -r xfsprogs-2.8.11/libdisk/md.c xfsprogs-2.8.11-mdp/libdisk/md.c
> --- xfsprogs-2.8.11/libdisk/md.c	2006-06-26 07:01:15.000000000 +0200
> +++ xfsprogs-2.8.11-mdp/libdisk/md.c	2008-03-26 20:12:38.000000000 +0100
> @@ -24,8 +24,12 @@
>  	dev_t		dev)
>  {
>  	if (major(dev) == MD_MAJOR)
> -		return 1;
> -	return get_driver_block_major("md", major(dev));
> +		return MD_IS_MD;
> +	if (get_driver_block_major("md", major(dev)))
> +		return MD_IS_MD;
> +	if (get_driver_block_major("mdp", major(dev)))
> +		return MD_IS_MDP;
> +	return 0;
>  }
>  
>  int
> @@ -37,12 +41,32 @@
>  	int		*sectalign,
>  	struct stat64	*sb)
>  {
> -	if (mnt_is_md_subvol(sb->st_rdev)) {
> +	char *pc, *dfile2 = NULL;
> +	int is_md;
> +
> +	if ((is_md = mnt_is_md_subvol(sb->st_rdev))) {
>  		struct md_array_info	md;
>  		int			fd;
>  
> +		if (is_md == MD_IS_MDP) {
> +			if (!(pc = strrchr(dfile, 'd'))
> +			|| !(pc = strchr(pc, 'p'))) {
> +				fprintf(stderr,
> +					_("Error getting MD array device from %s\n"),
> +					dfile);
> +				exit(1);
> +			}
> +			dfile2 = (char *) malloc(pc - dfile + 1);
> +			if (dfile2 == NULL) {
> +				fprintf(stderr,
> +					_("Couldn't malloc device string\n"));
> +				exit(1);
> +			}
> +			strncpy(dfile2, dfile, pc - dfile);
> +			dfile2[pc - dfile + 1] = '\0';
> +		}
>  		/* Open device */
> -		fd = open(dfile, O_RDONLY);
> +		fd = open(dfile2 ? dfile2 : dfile, O_RDONLY);
>  		if (fd == -1)
>  			return 0;
>  
> @@ -50,10 +74,11 @@
>  		if (ioctl(fd, GET_ARRAY_INFO, &md)) {
>  			fprintf(stderr,
>  				_("Error getting MD array info from %s\n"),
> -				dfile);
> +				dfile2 ? dfile2 : dfile);
>  			exit(1);
>  		}
>  		close(fd);
> +		if (dfile2) free(dfile2);
>  
>  		/*
>  		 * Ignore levels we don't want aligned (e.g. linear)
> diff -u -r xfsprogs-2.8.11/libdisk/md.h xfsprogs-2.8.11-mdp/libdisk/md.h
> --- xfsprogs-2.8.11/libdisk/md.h	2006-06-26 07:01:15.000000000 +0200
> +++ xfsprogs-2.8.11-mdp/libdisk/md.h	2008-03-26 20:12:10.000000000 +0100
> @@ -20,6 +20,9 @@
>  #define MD_MAJOR		9 /* we also check at runtime */
>  #endif
>  
> +#define MD_IS_MD		1
> +#define MD_IS_MDP		2
> +
>  #define GET_ARRAY_INFO          _IOR (MD_MAJOR, 0x11, struct md_array_info)
>
>  #define MD_SB_CLEAN		0
