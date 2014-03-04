Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F7DA7F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 09:05:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 56B78304048
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 07:05:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id B47uXcKoaJMCKyCY for
	<xfs@oss.sgi.com>; Tue, 04 Mar 2014 07:05:15 -0800 (PST)
Date: Tue, 4 Mar 2014 10:05:11 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfstests: fix error msg in aio-dio-subblock-eof-read.c
Message-ID: <20140304150511.GB51235@bfoster.bfoster>
References: <53156389.4060405@redhat.com>
 <5315681C.5070704@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5315681C.5070704@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 03, 2014 at 11:43:56PM -0600, Eric Sandeen wrote:
> io_getevents returns the number of events; printing its
> return as "bytes read" is ... wrong.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: print as signed so we can easily see errors returned
> 

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/src/aio-dio-regress/aio-dio-subblock-eof-read.c b/src/aio-dio-regress/aio-dio-subblock-eof-read.c
> index a48841d..8f74cec 100644
> --- a/src/aio-dio-regress/aio-dio-subblock-eof-read.c
> +++ b/src/aio-dio-regress/aio-dio-subblock-eof-read.c
> @@ -105,8 +107,8 @@ main(int argc, char **argv)
>  	 *  are broken, we may very well see a result of 4k.
>  	 */
>  	if (ie.res != FILE_SIZE)
> -		fail("AIO read of last block in file returned %d bytes, "
> -		     "expected %d\n", ret, FILE_SIZE);
> +		fail("AIO read of last block in file returned %ld bytes, "
> +		     "expected %d\n", ie.res, FILE_SIZE);
>  
>  	printf("AIO read of last block in file succeeded.\n");
>  	return 0;
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
