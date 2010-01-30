Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UKjp9M236494 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 14:45:51 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22B4F136662D
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 12:46:56 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id JOWHC8FK5PwdP4CT for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 12:46:56 -0800 (PST)
Message-ID: <4B649AC0.2040105@sandeen.net>
Date: Sat, 30 Jan 2010 14:46:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs.xfs: fix fd validity check in get_topology
References: <20100130195226.GA15379@infradead.org>
In-Reply-To: <20100130195226.GA15379@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Only negatie return values from open mean we failed to open the device.
> Without this check we do not print the usage message when no device is
> specified.  This leads to a weird failure in xfstests 122.

and unhelpful help for any user... argh :(

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.ent>

> 
> Index: xfsprogs-dev/mkfs/xfs_mkfs.c
> ===================================================================
> --- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2010-01-30 20:44:03.505255109 +0100
> +++ xfsprogs-dev/mkfs/xfs_mkfs.c	2010-01-30 20:44:20.579255807 +0100
> @@ -455,7 +455,7 @@ static void get_topology(libxfs_init_t *
>  				&ft->dsunit, &ft->dswidth, &ft->sectoralign);
>  		fd = open(dfile, O_RDONLY);
>  		/* If this fails we just fall back to BBSIZE */
> -		if (fd) {
> +		if (fd >= 0) {
>  			platform_findsizes(dfile, fd, &dummy, &bsz);
>  			close(fd);
>  		}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
