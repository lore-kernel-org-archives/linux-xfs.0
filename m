Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K8Ud5e254220 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 02:30:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA8CA177C86
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 00:31:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FgzjMqq7gPGg63OC for
	<xfs@oss.sgi.com>; Wed, 20 Jan 2010 00:31:40 -0800 (PST)
Date: Wed, 20 Jan 2010 03:31:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] xfstests: fix compile warnings in iopat.c
Message-ID: <20100120083140.GE6721@infradead.org>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
	<1263958688-435-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263958688-435-6-git-send-email-david@fromorbit.com>
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

On Wed, Jan 20, 2010 at 02:38:05PM +1100, Dave Chinner wrote:
> Printf format warnings and return value warnings need fixing.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  src/iopat.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/src/iopat.c b/src/iopat.c
> index c06071f..f34de19 100644
> --- a/src/iopat.c
> +++ b/src/iopat.c
> @@ -47,12 +47,13 @@ int main(int argc, char **argv)
>     read(fd, &x, 1048576);
>     for (i = 0; i < 131072; i++) {
>        if (x[i] != i) {
> -         printf("error: %d %d %d\n",i,8*i,x[i]);
> +         printf("error: %d %d %lld\n", i ,8 * i, (long long)x[i]);
>  	 exit(1);

Instead of the casting we could also use the C99 macro for the uin64_t
format.  But either way good enough for the tests,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
