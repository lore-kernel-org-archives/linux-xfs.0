Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:17:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKHGY0028281
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:17:17 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D446147F9B8
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:17:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id RfRjO1D35ehdn4ZG for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:17:15 -0700 (PDT)
Date: Sat, 25 Oct 2008 16:17:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix nr of args in open calls
Message-ID: <20081025201715.GA28002@infradead.org>
References: <49036961.8070100@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49036961.8070100@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Oct 25, 2008 at 01:45:53PM -0500, Eric Sandeen wrote:
> --- xfstests.orig/ltp/iogen.c
> +++ xfstests/ltp/iogen.c
> @@ -1060,7 +1060,11 @@ int 	nbytes;
>  
>      Oflags |= O_CREAT | O_WRONLY;
>  
> +#ifdef CRAY
>      if ((fd = open(path, Oflags, 0666, Ocbits, Ocblks)) == -1) {
> +#else
> +    if ((fd = open(path, Oflags, 0666)) == -1) {
> +#endif

Do we really need that ifdef cray here?
