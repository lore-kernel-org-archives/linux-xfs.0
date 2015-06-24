Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 848F27F6B
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 08:00:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 661CA8F8050
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 06:00:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4Rl9ftmxQowPM8WM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2015 06:00:46 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 5DA73B8BD6
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 13:00:46 +0000 (UTC)
Date: Wed, 24 Jun 2015 09:00:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_metadump: don't zero log if not obfuscating
Message-ID: <20150624130044.GB1888@bfoster.bfoster>
References: <55880F60.9030800@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55880F60.9030800@redhat.com>
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

On Mon, Jun 22, 2015 at 08:36:32AM -0500, Eric Sandeen wrote:
> The earlier commit:
> 
> ec693e1 metadump: zero out clean log
> 
> ignored the "obfuscate" state, but there's no reason to
> zero out the log if we're not obfuscating; all the other
> metadata is in the clear, so we may as well keep it around
> in the log as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> (this is for the progs-misc-fixes-1 branch)
> 
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index eb5e9da..bdc48a0 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2184,6 +2184,10 @@ copy_log(void)
>  		return !stop_on_read_error;
>  	}
>  
> +	/* If not obfuscating, just copy the log as it is */
> +	if (!obfuscate)
> +		goto done;
> +
>  	dirty = xlog_is_dirty(mp, &x, 0);
>  
>  	switch (dirty) {
> @@ -2196,18 +2200,17 @@ copy_log(void)
>  		break;
>  	case 1:
>  		/* keep the dirty log */
> -		if (obfuscate)
> -			print_warning(
> +		print_warning(
>  _("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
>  		break;
>  	case -1:
>  		/* log detection error */
> -		if (obfuscate)
> -			print_warning(
> +		print_warning(
>  _("Could not discern log; image will contain unobfuscated metadata in log."));
>  		break;
>  	}
>  
> +done:
>  	return !write_buf(iocur_top);
>  }
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
