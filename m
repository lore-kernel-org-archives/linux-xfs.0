Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05CC57FA8
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 23:27:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8F7F304032
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 21:27:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wid0jPYpnG9GgxtA for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 21:27:13 -0700 (PDT)
Subject: Re: [PATCH] xfs_repair: release corrupt directory node buffer
References: <20150904042104.GD10397@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E91DA0.7000306@sandeen.net>
Date: Thu, 3 Sep 2015 23:27:12 -0500
MIME-Version: 1.0
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: xfs@oss.sgi.com

On 9/3/15 11:21 PM, Darrick J. Wong wrote:
> If repair encounters a dir node block that fails checksum or
> verification, free the buffer before the directory gets rebuilt.
> 
> Reported-by: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/dir2.c |    1 +
>  1 file changed, 1 insertion(+)
> 
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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
