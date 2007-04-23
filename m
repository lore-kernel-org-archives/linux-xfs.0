Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 14:49:33 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NLnTfB014530
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 14:49:31 -0700
Date: Mon, 23 Apr 2007 22:26:06 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix "quota -n" command in xfs_quota.
Message-ID: <20070423212606.GE13572@infradead.org>
References: <200704190837.AA05238@TNESG9305.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704190837.AA05238@TNESG9305.tnes.nec.co.jp>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <utako@tnes.nec.co.jp>
Cc: xfs@oss.sgi.com

On Thu, Apr 19, 2007 at 05:37:11PM +0900, Utako Kusaka wrote:
> Hi,
> 
> "quota -n" command in xfs_quota don't work when specifying the project id.
> This patch fixes it.
> 
> Example:
> # ./xfs_quota -x -c 'quota -p -n 42' ~utako/mpnt
> Disk quotas for Project logfiles (42)
> Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted on
> /dev/sda6                   52          0          0   00 [--------] /home/utako/mpnt

Looks good to me, but the even the original code could be a little bit cleaner:

> --- xfsprogs-2.8.20/quota/quota.orig	2007-04-18 10:36:38.000000000 +0900
> +++ xfsprogs-2.8.20/quota/quota.c	2007-04-18 11:09:10.000000000 +0900
> @@ -312,7 +312,7 @@ getprojectname(
>  	static char	buffer[32];
>  	fs_project_t	*p;
>  
> -	if ((p = getprprid(prid)))
> +	if (!numeric && (p = getprprid(prid)))
>  		return p->pr_name;
>  	snprintf(buffer, sizeof(buffer), "#%u", (unsigned int)prid);
>  	return &buffer[0];

	if (!numeric) {
		fs_project_t *p = getprprid(prid);
		if (p)
			return p->pr_name;
	}

	snprintf(buffer, sizeof(buffer), "#%u", (unsigned int)prid);
	return &buffer[0];

		
