Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UAIs35199328 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 04:18:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7535019D91E
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 02:19:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tq1JrBJL7VUGZEV0 for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 02:19:51 -0800 (PST)
Date: Sat, 30 Jan 2010 05:19:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: routine to create scratch of certain size
Message-ID: <20100130101951.GA32695@infradead.org>
References: <4B621D89.8070800@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B621D89.8070800@sandeen.net>
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

On Thu, Jan 28, 2010 at 05:28:09PM -0600, Eric Sandeen wrote:
> This is needed for later enospc tests to be generic
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> diff --git a/common.rc b/common.rc
> index 97513cc..cf2662a 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -237,6 +237,27 @@ _scratch_mkfs_options()
>      echo $SCRATCH_OPTIONS $MKFS_OPTIONS $* $SCRATCH_DEV
>  }
>  
> +# arg 1 is size in bytes, arg 2 is (optional) blocksize
> +_scratch_mkfs_sized()
> +{
> +    fssz=$1
> +    bsz=$2
> +    [ -z "$bsz" ] && bsz=4096
> +    let blocks=$fssz/$bsz
> +
> +    case $FSTYP in
> +    xfs)
> +        _scratch_mkfs_xfs -d size=$fssz -b size=$bsz 2>&1 >>$here/$seq.full
> +    ;;
> +    ext2|ext3|ext4)
> +        /sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS -b $bsz $SCRATCH_DEV $blocks  2>&1>>$here/$seq.full
> +    ;;
> +    *)
> +    _notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
> +    ;;
> +    esac
> +}

Looks good, the only questions is why you're using $MKFS_OPTIONS for
extN, but not for xfs?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
