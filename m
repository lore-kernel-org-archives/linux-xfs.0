Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6K7ZaGC007316 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 02:35:37 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8403B15F9C8D
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 00:38:35 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	QeqwldYqOUWEbnTy for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 00:38:35 -0700 (PDT)
Date: Tue, 20 Jul 2010 17:38:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: remove obsolete osyncisosync mount option
Message-ID: <20100720073832.GH32635@dastard>
References: <20100718203848.927859114@bombadil.infradead.org>
	<20100718203926.229290039@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100718203926.229290039@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Jul 18, 2010 at 04:38:51PM -0400, Christoph Hellwig wrote:
> Since Linux 2.6.33 the kernel has support for real O_SYNC, which made
> the osyncisosync option a no-op.  Warn the users about this and remove
> the mount flag for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, but I think these messages:
> 
> @@ -366,9 +363,11 @@ xfs_parseargs(
>  			cmn_err(CE_WARN,
>  	"XFS: ihashsize no longer used, option is deprecated.");
>  		} else if (!strcmp(this_char, "osyncisdsync")) {
> -			/* no-op, this is now the default */
>  			cmn_err(CE_WARN,
> -	"XFS: osyncisdsync is now the default, option is deprecated.");
> +	"XFS: the osyncisdsync option is deprecated as has no effect.");
> +		} else if (!strcmp(this_char, "osyncisosync")) {
> +			cmn_err(CE_WARN,
> +	"XFS: the osyncisosync option is deprecated as has no effect.");
>  		} else if (!strcmp(this_char, "irixsgid")) {
>  			cmn_err(CE_WARN,
>  	"XFS: irixsgid is now a sysctl(2) variable, option is deprecated.");

Look better as:

	"XFS: osyncisdsync has no effect, option is deprecated."
	"XFS: osyncisosync has no effect, option is deprecated."

so they are consistent with the other deprecated option output.
I've made this change to the patch i have in my tree....

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
