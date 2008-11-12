Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 01:59:35 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC9xR6n001375
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:59:27 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B6B2154A896
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:59:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id MPCz9F6GzZn4fc8U for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:59:27 -0800 (PST)
Date: Wed, 12 Nov 2008 04:58:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfstests: fix nr of args in open calls
Message-ID: <20081112095856.GB2496@infradead.org>
References: <49036961.8070100@sandeen.net> <4903E7F7.9010608@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4903E7F7.9010608@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Folks can we please get this in?  This is breaking the xfstests build on
any modern distro.

On Sat, Oct 25, 2008 at 10:45:59PM -0500, Eric Sandeen wrote:
> Fix a few problematic open calls which strict checking catches;
> in most cases just missing a mode with O_CREAT.
> 
> Removed the #ifdef CRAY instance around one, per hch's request.
> 
> Somebody else can remove the rest, when motivated.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> Index: xfstests/ltp/iogen.c
> ===================================================================
> --- xfstests.orig/ltp/iogen.c
> +++ xfstests/ltp/iogen.c
> @@ -1060,7 +1060,7 @@ int 	nbytes;
>  
>      Oflags |= O_CREAT | O_WRONLY;
>  
> -    if ((fd = open(path, Oflags, 0666, Ocbits, Ocblks)) == -1) {
> +    if ((fd = open(path, Oflags, 0666)) == -1) {
>  	fprintf(stderr, "iogen%s:  Could not create/open file %s: %s (%d)\n",
>  		TagName, path, SYSERR, errno);
>  	return -1;
> Index: xfstests/src/multi_open_unlink.c
> ===================================================================
> --- xfstests.orig/src/multi_open_unlink.c
> +++ xfstests/src/multi_open_unlink.c
> @@ -92,7 +92,7 @@ main(int argc, char *argv[])
>  			return 1;
>  		}
>  
> -		fd = open(path, O_RDWR|O_CREAT|O_EXCL);
> +		fd = open(path, O_RDWR|O_CREAT|O_EXCL, 0666);
>  		if (fd == -1) {
>  			fprintf(stderr, "%s: failed to create \"%s\": %s\n", prog, path, strerror(errno));
>  			return 1;
> Index: xfstests/src/enospc_unlink.c
> ===================================================================
> --- xfstests.orig/src/enospc_unlink.c
> +++ xfstests/src/enospc_unlink.c
> @@ -40,7 +40,7 @@ int main(int argc, char **argv)
>  	memset(ptr, 0xffffffff, sz);
>  
>  	for (i = 0; i < count; i++) {
> -		fd = open(argv[1], O_CREAT|O_WRONLY);
> +		fd = open(argv[1], O_CREAT|O_WRONLY, 0666);
>  		if (fd < 0) {
>  			perror(argv[1]);
>  			exit(1);
> Index: xfstests/src/dmiperf.c
> ===================================================================
> --- xfstests.orig/src/dmiperf.c
> +++ xfstests/src/dmiperf.c
> @@ -203,7 +203,7 @@ mkfile(char *name, char *attr)
>  	ssize_t		wrote, wsize;
>  	off64_t		bytes = fsize;
>  
> -	if ((fd = open(name, O_WRONLY | O_CREAT | O_EXCL | O_DIRECT)) < 0) {
> +	if ((fd = open(name, O_WRONLY | O_CREAT | O_EXCL | O_DIRECT, 0666)) < 0) {
>  		perror("open");
>  		exit(1);
>  	}
> 
> 
---end quoted text---
