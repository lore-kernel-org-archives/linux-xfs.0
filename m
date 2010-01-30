Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UApVqn201870 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 04:51:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03936136599A
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 02:52:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FN0OzQnhu2CHNGFN for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 02:52:37 -0800 (PST)
Date: Sat, 30 Jan 2010 05:52:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: 223 - test file alignment on stripe geometry
Message-ID: <20100130105236.GA18286@infradead.org>
References: <4B621529.20708@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B621529.20708@sandeen.net>
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
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

> +# real QA test starts here
> +_supported_fs xfs ext4

I'd make this generic and just do the notrun in scratch_mkfs_geom for
non-supported filesystems.

> +scratch_mkfs_geom()
> +{

And I'd throw this one into common.rc.

> +=== Testing size 1073745920 falloc on 128k stripe ===
> +SCRATCH_MNT/file-1073745920-falloc: well-aligned
> diff --git a/common.rc b/common.rc
> index 6424871..97513cc 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -292,7 +292,7 @@ _scratch_mkfs()
>          $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
>  	;;
>      *)
> -	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
> +	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV

Hmm, doesn't this change break other testcase?  Anyway needs some
rationale in the changelog.

> index 0000000..fa005b2
> --- /dev/null
> +++ b/src/fibmap.c

This is a bit misnamed as it's not a generic fibmap tool but rather
a specific tool comparing the bmap to the sunit alignment.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
