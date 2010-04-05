Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35JcZAY014725 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 14:38:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2755BFA497A
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 12:40:24 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id MAz7CN88Ns2NNU4e for
	<xfs@oss.sgi.com>; Mon, 05 Apr 2010 12:40:24 -0700 (PDT)
Message-ID: <4BBA3CA7.8000206@sandeen.net>
Date: Mon, 05 Apr 2010 14:40:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: don't use -s option to repquota
References: <20100405190428.GA3807@infradead.org>
In-Reply-To: <20100405190428.GA3807@infradead.org>
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
Cc: Theodore Tso <tytso@mit.edu>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> The -s option to repquota used to be a no-op, but actually changes
> output to different units in quota tools 4.0.  Remove it from the
> repquota invocation in test 219.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks, Ted was hitting this too.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfstests-dev/219
> ===================================================================
> --- xfstests-dev.orig/219	2010-04-05 18:55:09.000000000 +0000
> +++ xfstests-dev/219	2010-04-05 18:55:16.000000000 +0000
> @@ -85,7 +85,7 @@ test_accounting()
>  		$here/src/lstat64 $file | head -3 | filter_scratch
>  	done
>  
> -	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
> +	repquota -$type -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
>  	awk '/^#/ { if (seen[$1]) next; seen[$1]++; } { print; }'
>  }
>  
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
