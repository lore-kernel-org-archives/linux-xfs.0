Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HBgkTX009082 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 05:42:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09C26F18C21
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:43:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IdPVypJdbdvHVRyK for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:43:44 -0800 (PST)
Date: Sun, 17 Jan 2010 06:43:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 131: kill locktest process in cleanup &
	better error msgs
Message-ID: <20100117114344.GC7813@infradead.org>
References: <4B51220F.7020703@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B51220F.7020703@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jan 15, 2010 at 08:18:55PM -0600, Eric Sandeen wrote:
> I occasionally get failures in 131 like:
> 
> gethostbyname: Success
> 
> 1) perror is the wrong thing for gethostbyname errors, so this
> is confusing

Indeed.

> 2) the locktest thread doesn't get killed, so the fs
> is busy and the next test fails when it can't unmount

Yeah, this was always causing problems for me when running xfstests on
a system without networking for some unknown reason.

> --- a/src/locktest.c
> +++ b/src/locktest.c
> @@ -44,6 +44,8 @@
>  #define PLATFORM_CLEANUP()  /*no-op*/
>  #define LL                  "ll"
>  
> +extern int h_errno;
> +
>  #define inet_aton(STRING, INADDRP) \
>      (((INADDRP)->s_addr = inet_addr(STRING)) == -1 ? 0 : 1)
>  
> @@ -937,7 +939,10 @@ main(int argc, char *argv[])
>          struct hostent  *servInfo;
>  
>          if ((servInfo = gethostbyname(host)) == NULL) {
> -            perror("gethostbyname");
> +	    printf("Couldn't get hostbyname for %s", host);
> +	    if (h_errno == HOST_NOT_FOUND)
> +		printf(": host not found");
> +	    printf("\n");

Might be worth using herror or hsterror, although the manpage marks them
as obsolete..


Anyway, good enough to put in, so:


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
