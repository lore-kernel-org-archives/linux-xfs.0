Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n84N8AQ4248898 for <xfs@oss.sgi.com>; Fri, 4 Sep 2009 18:08:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA72A15DFCE2
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2009 16:09:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DA75Dzvgw6cHJE6X for
	<xfs@oss.sgi.com>; Fri, 04 Sep 2009 16:09:05 -0700 (PDT)
Date: Fri, 4 Sep 2009 19:09:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: mark some functions as noreturn
Message-ID: <20090904230904.GA25934@infradead.org>
References: <4AA19639.6090208@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AA19639.6090208@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Fri, Sep 04, 2009 at 05:35:37PM -0500, Eric Sandeen wrote:
> Static checkers are a lot less noisy if they know certain
> functions are noreturn.
> 
> Making this change removed about 50 errors from "clang" output.
> (http://clang-analyzer.llvm.org) output.

Not pretty but useful,


Reviewed-by: Christoph Hellwig <hch@lst.de>

> -void	do_abort(char const *, ...);		/* abort, internal error */
> -void	do_error(char const *, ...);		/* abort, system error */
> -void	do_warn(char const *, ...);		/* issue warning */
> -void	do_log(char const *, ...);		/* issue log message */
> +/* abort, internal error */
> +void  __attribute__((noreturn)) do_abort(char const *, ...);
> +/* abort, system error */
> +void  __attribute__((noreturn)) do_error(char const *, ...);
> +/* issue warning */
> +void do_warn(char const *, ...);
> +/* issue log message */
> +void do_log(char const *, ...);

It would be good to add the proper printflike attributes to these to
also get vararg typechecking.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
