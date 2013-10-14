Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 28E057F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 16:07:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C849DAC009
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 14:07:06 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	U4hePuZzpW9B7rjc for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 14:07:04 -0700 (PDT)
Date: Tue, 15 Oct 2013 08:07:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: remove incorrect l_sectBBsize assignment in
	xfs_repair
Message-ID: <20131014210701.GH5663@dastard>
References: <5252F0D4.8090209@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5252F0D4.8090209@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 07, 2013 at 12:35:16PM -0500, Eric Sandeen wrote:
> Commit e0607266 xfsprogs: add crc format support to repair
> 
> added a 2nd assignment to l_sectBBsize:
> 
> 	log.l_sectBBsize = 1 << mp->m_sb.sb_logsectlog;
> 
> which is incorrect; sb_logsectlog is log2 of the sector size,
> in bytes; l_sectBBsize is the size of the log sector in
> 512-byte units.

Yes, that is wrong. It looks like a hunk of code I didn't cleanup
properly when I did some patch reordering and rebasing. IIRC, the
above patch was written before I realised that all of xfsprogs
failed to handle log sector sizes != 512 bytes properly, and that
the log CRC code required that to work correctly. Hence a generic
fix to the problem was added in commit:

999f0b9 xfsprogs: updata libxlog to current kernel code

Which fixed repair, db and logprint. That is where this code:

> Just remove the incorrect assignment; it was already properly
> assigned about 12 lines prior:
> 
>         log.l_sectBBsize  = BTOBB(x.lbsize);
> 
> and things work again.

came from.

Basically, I didn't clean all the random fix fragments out of the
repair patch, and so I broke log secotr size != 512 byte cases for
repair again....

> Reporteed-by: Markus Trippelsdorf <markus@trippelsdorf.de>

Reported-by the reportee. ;)

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/phase2.c b/repair/phase2.c
> index a62854e..2817fed 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -64,7 +64,6 @@ zero_log(xfs_mount_t *mp)
>  		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
>  	}
>  	log.l_sectbb_mask = (1 << log.l_sectbb_log) - 1;
> -	log.l_sectBBsize = 1 << mp->m_sb.sb_logsectlog;
>  
>  	if ((error = xlog_find_tail(&log, &head_blk, &tail_blk))) {
>  		do_warn(_("zero_log: cannot find log head/tail "

Looks good,

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
