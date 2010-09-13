Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8D4bwph048154 for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 23:37:58 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75F09DC5002
	for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 21:50:22 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id i5aAhKMibVQLa9fj for
	<xfs@oss.sgi.com>; Sun, 12 Sep 2010 21:50:22 -0700 (PDT)
Message-ID: <4C8DAAD0.9050505@sandeen.net>
Date: Sun, 12 Sep 2010 23:38:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix 108 and enable it by default
References: <20100912171204.GA7225@infradead.org>
In-Reply-To: <20100912171204.GA7225@infradead.org>
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
> Apply the prjquota check to the scratch device so that it doesn't fail,
> and add the test to the auto and quick groups now that it works.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ah, after arekm's patch... makes sense.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfstests-dev/108
> ===================================================================
> --- xfstests-dev.orig/108	2010-09-12 17:04:58.000000000 +0000
> +++ xfstests-dev/108	2010-09-12 17:05:23.000000000 +0000
> @@ -86,8 +86,8 @@ test_accounting()
>  }
>  
>  export MOUNT_OPTIONS="-opquota"
> -_require_prjquota
>  _qmount
> +_require_prjquota $SCRATCH_DEV
>  
>  # real QA test starts here
>  rm -f $tmp.projects $seq.full
> Index: xfstests-dev/group
> ===================================================================
> --- xfstests-dev.orig/group	2010-09-12 17:05:43.000000000 +0000
> +++ xfstests-dev/group	2010-09-12 17:06:32.000000000 +0000
> @@ -218,7 +218,7 @@ deprecated
>  105 acl auto quick
>  106 quota
>  107 quota
> -108 quota
> +108 quota auto quick
>  109 metadata auto
>  110 repair auto
>  111 ioctl
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
