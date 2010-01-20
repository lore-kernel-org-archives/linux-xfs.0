Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K8VHrW254270 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 02:31:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6F96177C8A
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 00:32:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8PvraYaG0hJMIVpT for
	<xfs@oss.sgi.com>; Wed, 20 Jan 2010 00:32:17 -0800 (PST)
Date: Wed, 20 Jan 2010 03:32:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfstests: fix printf format warnings in looptest.c
Message-ID: <20100120083217.GF6721@infradead.org>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
	<1263958688-435-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263958688-435-7-git-send-email-david@fromorbit.com>
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

On Wed, Jan 20, 2010 at 02:38:06PM +1100, Dave Chinner wrote:
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  src/looptest.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/src/looptest.c b/src/looptest.c
> index d951f2b..3d99f38 100755
> --- a/src/looptest.c
> +++ b/src/looptest.c
> @@ -202,7 +202,7 @@ main(int argc, char *argv[])
>          
>          if ((flags & FLAG_OPENCLOSE) && (flags & FLAG_SEQUENTIAL)) {
>              if (flags & FLAG_VERBOSE)
> -                printf("seek %" LL "d\n", seek_to);
> +                printf("seek %" LL "d\n", (long long)seek_to);
>              if (SEEK(f, seek_to, FILE_BEGIN) < 0)
>  	        PERROR("SEEK", GET_LAST_ERROR);
>  	    seek_to += bufsize;

Ok.


Reviewed-by: Christoph Hellwig <hch@lst.de>

What an ugly code in this file, urggg.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
