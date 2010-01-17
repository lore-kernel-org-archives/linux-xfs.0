Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HBeXiQ008960 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 05:40:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AF741C57647
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:41:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nq6mUdmCqDrAu75v for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:41:32 -0800 (PST)
Date: Sun, 17 Jan 2010 06:41:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 073: unmount source image in cleanup
Message-ID: <20100117114131.GB7813@infradead.org>
References: <4B510B41.3070904@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B510B41.3070904@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jan 15, 2010 at 06:41:37PM -0600, Eric Sandeen wrote:
> Test 073 is currently failing w/ xfs_repair problems, and when
> it does, the whole series stops because the test dir still has
> a loopback mounted filesystem on it, and it can't unmount.
> 
> Fix that.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> diff --git a/073 b/073
> index 0ef9287..756c1c8 100755
> --- a/073
> +++ b/073
> @@ -44,6 +44,7 @@ _cleanup()
>  	umount $SCRATCH_MNT 2>/dev/null
>  	umount -d $imgs.loop 2>/dev/null
>  	[ -d $imgs.loop ] && rmdir $imgs.loop
> +	umount -d $imgs.source_dir 2>/dev/null
>  	[ -d $imgs.source_dir ] && rm -rf $imgs.source_dir
>  	rm -f $imgs.* $tmp.* /var/tmp/xfs_copy.log.*

Yes, we should always unmount everything in the cleanup handler.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
