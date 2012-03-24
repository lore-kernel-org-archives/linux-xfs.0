Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2ODg7M1028418 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 08:42:07 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YWHxFZ2RoEm000Z3 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 06:42:06 -0700 (PDT)
Date: Sat, 24 Mar 2012 09:42:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfs: add lots of attribute trace points
Message-ID: <20120324134206.GB25674@infradead.org>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1332393313-1955-9-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 22, 2012 at 04:15:13PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good mostly good, minor comments below:

>  	/*
> -	 * Copy the attribute name and value into the new space.
> -	 *

Why does this get removed?

>  
>  #define DEFINE_DIR2_EVENT(name) \
> -DEFINE_EVENT(xfs_dir2_class, name, \
> +DEFINE_EVENT(xfs_da_class, name, \
>  	TP_PROTO(struct xfs_da_args *args), \
>  	TP_ARGS(args))


> +#define DEFINE_ATTR_EVENT(name) \
> +DEFINE_EVENT(xfs_da_class, name, \
> +	TP_PROTO(struct xfs_da_args *args), \
> +	TP_ARGS(args))

> +#define DEFINE_DA_EVENT(name) \
> +DEFINE_EVENT(xfs_da_class, name, \
> +	TP_PROTO(struct xfs_da_args *args), \
> +	TP_ARGS(args))

We should use the DEFINE_DA_EVENT macro for all of these tracepoints,
instead of having two duplicates of it.

Also all the tracepoints should print of which fork we operate on,
which is useful at least for the ones in common code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
