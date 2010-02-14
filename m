Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1ELhjlm260431 for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 15:43:45 -0600
Date: Sun, 14 Feb 2010 16:45:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: clean up dmapi Makefile
Message-ID: <20100214214500.GB21311@infradead.org>
References: <201002122145.o1CLjMRf028235@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201002122145.o1CLjMRf028235@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

> Index: b/Makefile
> ===================================================================
> --- a/Makefile
> +++ b/Makefile
> @@ -99,3 +99,7 @@ install-dev install-lib:
>  realclean distclean: clean
>  	rm -f $(LDIRT) $(CONFIGURE)
>  	rm -rf autom4te.cache Logs
> +ifeq ($(HAVE_DMAPI), true)
> +	rm -f $(DMAPI_MAKEFILE)
> +endif

Why not just remove it uncondtionally?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
