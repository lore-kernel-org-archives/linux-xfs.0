Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D69C47F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 07:36:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 58B518F80BE
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 05:36:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 536TaK9kh8kwLboW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 05:36:55 -0800 (PST)
Date: Tue, 24 Feb 2015 08:36:52 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: superblock buffers need to be sector sized
Message-ID: <20150224133652.GB45528@bfoster.bfoster>
References: <1424761944-2034-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424761944-2034-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 24, 2015 at 06:12:24PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In secondary_sb_wack() we zero the unused portion of both the
> on-disk superblock and the in-memory copy that we have. When
> the device sector size is 4k, this causes xfs_repair to crash like
> so:
> 
> # xfs_repair /dev/ram1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> bad magic number
> bad on-disk superblock 3 - bad magic number
> primary/secondary superblock 3 conflict - AG superblock geometry info conflicts with filesystem geometry
> zeroing unused portion of secondary superblock (AG #3)
> #
> 
> The stack trace is indicative:
> 
> #0  memset ()
> #1  0x000000000040404b in secondary_sb_wack
> #2  verify_set_agheader
> #3  0x0000000000427b4b in scan_ag
> #4  0x000000000042a2ca in worker_thread
> #5  0x00007ffff77ba0a4 in start_thread
> #6  0x00007ffff74efc2d in clone
> 
> Which points at memset overrunning the in memory buffer, as it is
> only 512 bytes in length.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

The patch subject line should probably say 'xfsprogs:' or 'repair:,'
otherwise this looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index ce8d7f5..12aa782 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -1485,7 +1485,7 @@ scan_ag(
>  	int		status;
>  	char		*objname = NULL;
>  
> -	sb = (struct xfs_sb *)calloc(BBSIZE, 1);
> +	sb = (struct xfs_sb *)calloc(BBTOB(XFS_FSS_TO_BB(mp, 1)), 1);
>  	if (!sb) {
>  		do_error(_("can't allocate memory for superblock\n"));
>  		return;
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
