Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07E9A7F61
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 13:50:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9E398F8064
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 11:50:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qTIYvOMtiEvubeqF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2015 11:50:57 -0700 (PDT)
Date: Mon, 8 Jun 2015 14:50:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4 V3] xfsprogs: zero out clean log in xfs_metadump
Message-ID: <20150608185054.GB18211@bfoster.bfoster>
References: <5568B7CE.9030709@redhat.com> <5568BB5C.4080400@sandeen.net>
	<5575AF7A.8050306@sandeen.net> <5575E30D.80800@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5575E30D.80800@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Mon, Jun 08, 2015 at 01:46:37PM -0500, Eric Sandeen wrote:
> When doing an obfuscated xfs_metadump, if the log is clean, zero
> it out for 2 reasons:
> 
>  * It'll make the image more compressible
>  * It'll eliminate an un-obfuscated metadata source
> 
> If the log isn't clean, and the user expected obfuscation, warn
> that metadata in the log will not be obfuscated.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: If not obfuscating, copy log as-is
> V3: Remove pointless "obfuscate" checks after goto
> 

Looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/db/metadump.c b/db/metadump.c
> index bea4e00..bdc48a0 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include <libxfs.h>
> +#include <libxlog.h>
>  #include "bmap.h"
>  #include "command.h"
>  #include "metadump.h"
> @@ -2169,6 +2170,8 @@ copy_sb_inodes(void)
>  static int
>  copy_log(void)
>  {
> +	int dirty;
> +
>  	if (show_progress)
>  		print_progress("Copying log");
>  
> @@ -2180,6 +2183,34 @@ copy_log(void)
>  		print_warning("cannot read log");
>  		return !stop_on_read_error;
>  	}
> +
> +	/* If not obfuscating, just copy the log as it is */
> +	if (!obfuscate)
> +		goto done;
> +
> +	dirty = xlog_is_dirty(mp, &x, 0);
> +
> +	switch (dirty) {
> +	case 0:
> +		/* clear out a clean log */
> +		if (show_progress)
> +			print_progress("Zeroing clean log");
> +		memset(iocur_top->data, 0,
> +			mp->m_sb.sb_logblocks * mp->m_sb.sb_blocksize);
> +		break;
> +	case 1:
> +		/* keep the dirty log */
> +		print_warning(
> +_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
> +		break;
> +	case -1:
> +		/* log detection error */
> +		print_warning(
> +_("Could not discern log; image will contain unobfuscated metadata in log."));
> +		break;
> +	}
> +
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
