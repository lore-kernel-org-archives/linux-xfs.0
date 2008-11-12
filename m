Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 05:34:43 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mACDYXqs018010
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 05:34:33 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1ABB51B7E212
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 05:34:32 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id DCI0xv3S8ijtwXwI for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 05:34:32 -0800 (PST)
Message-ID: <491ADB68.9010502@sandeen.net>
Date: Wed, 12 Nov 2008 07:34:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix buffer overflow in lstat64.c
References: <490F7A7F.9010102@sandeen.net> <20081112095702.GA2496@infradead.org>
In-Reply-To: <20081112095702.GA2496@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Nov 03, 2008 at 04:26:07PM -0600, Eric Sandeen wrote:
>> lstat64.c was putting an 11-byte string into a 10-byte buffer.
> 
> What about somthing like this instead?

That's too easy! :)

Sure, that makes good sense.

-Eric

> 
> Index: xfs-cmds/xfstests/src/lstat64.c
> ===================================================================
> --- xfs-cmds.orig/xfstests/src/lstat64.c	2008-11-12 10:55:16.000000000 +0100
> +++ xfs-cmds/xfstests/src/lstat64.c	2008-11-12 10:55:50.000000000 +0100
> @@ -57,7 +57,6 @@ int
>  main(int argc, char **argv)
>  {
>  	struct stat64	sbuf;
> -	char		mode[10];
>  	int		i, c;
>  	int		terse_flag = 0;
>  
> @@ -78,6 +77,7 @@ main(int argc, char **argv)
>  	time(&timebuf);
>  
>  	for (i = optind; i < argc; i++) {
> +		char *mode = "----------";
>  
>  		if( lstat64(argv[i], &sbuf) < 0) {
>  			perror(argv[i]);
> @@ -92,7 +92,6 @@ main(int argc, char **argv)
>  			printf("  Size: %-10llu", (unsigned long long)sbuf.st_size);
>  		}
>  
> -		strcpy(mode,"----------");
>  		if (sbuf.st_mode & (S_IEXEC>>6))
>  			mode[9] = 'x';
>  		if (sbuf.st_mode & (S_IWRITE>>6))
> 
