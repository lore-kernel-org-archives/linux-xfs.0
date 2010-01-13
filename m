Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DM7Jp3194192 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:07:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA8D11C4D09D
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:08:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ool9CTbPYYRWTOok for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:08:15 -0800 (PST)
Date: Wed, 13 Jan 2010 17:08:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: Make the compile output cleaner V2
Message-ID: <20100113220814.GA17310@infradead.org>
References: <1263377007-4500-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263377007-4500-1-git-send-email-david@fromorbit.com>
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

On Wed, Jan 13, 2010 at 09:03:27PM +1100, Dave Chinner wrote:
> -LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
> +DISTDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
>  	built .census install.* install-dev.* *.gz autom4te.cache/* libtool \
>  	include/builddefs include/platform_defs.h

>  distclean: clean
> -	rm -f $(LDIRT)
> +	$(Q)rm -f $(DISTDIRT)

What does this have to do with the rest?

Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

Any chance you could also port it to xfsdump?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
