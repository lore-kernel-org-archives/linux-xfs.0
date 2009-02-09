Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n192CIOq211248 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 20:12:19 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBA6BFC61B
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 18:11:39 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	M7QDjArFTxgM7tnB for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2009 18:11:39 -0800 (PST)
Date: Mon, 9 Feb 2009 13:11:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_db: fix wrong sibling pointers offset for the bmbt attr block
Message-ID: <20090209021136.GC8830@disturbed>
References: <20090208211515.GB22118@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090208211515.GB22118@infradead.org>
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

On Sun, Feb 08, 2009 at 04:15:15PM -0500, Christoph Hellwig wrote:
> The attr bmbt should use long, not short pointers.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/db/btblock.c
> ===================================================================
> --- xfsprogs-dev.orig/db/btblock.c	2009-02-08 22:13:05.225944103 +0100
> +++ xfsprogs-dev/db/btblock.c	2009-02-08 22:13:14.143944165 +0100
> @@ -227,8 +227,8 @@ const field_t	bmapbtd_flds[] = {
>  	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
>  	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
>  	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
> -	{ "leftsib", FLDT_DFSBNO, OI(OFF(u.s.bb_leftsib)), C1, 0, TYP_BMAPBTD },
> -	{ "rightsib", FLDT_DFSBNO, OI(OFF(u.s.bb_rightsib)), C1, 0, TYP_BMAPBTD },
> +	{ "leftsib", FLDT_DFSBNO, OI(OFF(u.l.bb_leftsib)), C1, 0, TYP_BMAPBTD },
> +	{ "rightsib", FLDT_DFSBNO, OI(OFF(u.l.bb_rightsib)), C1, 0, TYP_BMAPBTD },
>  	{ "recs", FLDT_BMAPBTDREC, btblock_rec_offset, btblock_rec_count,
>  	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
>  	{ "keys", FLDT_BMAPBTDKEY, btblock_key_offset, btblock_key_count,

Reviewed-by: Dave Chinner <david@fromorbit.com>


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
