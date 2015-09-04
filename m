Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 421CA7F3F
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 07:59:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC41BAC001
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 05:59:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id A8XCVwj5Xqq1EN5g (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2015 05:59:42 -0700 (PDT)
Date: Fri, 4 Sep 2015 14:59:38 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_repair: release corrupt directory node buffer
Message-ID: <20150904125938.GA2821@zion.maiolino>
References: <20150904042104.GD10397@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150904042104.GD10397@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, xfs@oss.sgi.com

On Thu, Sep 03, 2015 at 09:21:04PM -0700, Darrick J. Wong wrote:
> If repair encounters a dir node block that fails checksum or
> verification, free the buffer before the directory gets rebuilt.
> 
> Reported-by: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/dir2.c |    1 +
>  1 file changed, 1 insertion(+)
> 
Makes sense.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> diff --git a/repair/dir2.c b/repair/dir2.c
> index a5646f8..54c49eb 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -200,6 +200,7 @@ _("bad dir magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
>  		}
>  		/* corrupt node; rebuild the dir. */
>  		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
> +			libxfs_putbuf(bp);
>  			do_warn(
>  _("corrupt tree block %u for directory inode %" PRIu64 "\n"),
>  				bno, da_cursor->ino);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
