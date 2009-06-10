Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AIsPMg107428 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 13:54:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6795D126F229
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 12:01:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vMuwDH2mreP2Cwb3 for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 12:01:58 -0700 (PDT)
Date: Wed, 10 Jun 2009 14:54:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests:  Skip dump _cleanup if filesystem is not xfs
Message-ID: <20090610185445.GB24615@infradead.org>
References: <4A2FF2CB.1060805@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A2FF2CB.1060805@sandeen.net>
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

On Wed, Jun 10, 2009 at 12:52:11PM -0500, Eric Sandeen wrote:
> Skip dump _cleanup if filesystem is not xfs
> 
> Many/most dump tests include common.dump before checking
> supported fs, and this means that even if the dump tests
> are skipped, the sleep & filesystem check in _cleanup
> gets run, which makes it take rather a long time to
> skip these tests for non-xfs filesystems.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> 
> diff --git a/common.dump b/common.dump
> index 94de07f..d5aadfc 100644
> --- a/common.dump
> +++ b/common.dump
> @@ -233,6 +233,12 @@ _wipe_fs()
>  #
>  _cleanup()
>  {
> +    # Some tests include this before checking _supported_fs xfs
> +    # and the sleeps & checks get annoying
> +    if [ "$FSTYP" != "xfs" ]; then
> +       return
> +    fi

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
