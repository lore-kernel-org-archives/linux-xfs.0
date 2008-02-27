Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Feb 2008 23:09:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1R79gib011646
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2008 23:09:47 -0800
Message-ID: <47C50CC0.1080802@sgi.com>
Date: Wed, 27 Feb 2008 18:09:52 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] kill t_sema member of struct xfs_trans
References: <20080207082724.GA14119@lst.de> <20080226175758.GA13162@lst.de> <20080227005546.GA77525841@sgi.com>
In-Reply-To: <20080227005546.GA77525841@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Niv Sardi wrote:
> * Christoph Hellwig <hch@lst.de> [2008-02-26 18:57:58 +0100]:
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_trans.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_trans.h	2008-02-05 08:48:40.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_trans.h	2008-02-05 08:48:45.000000000 +0100
> @@ -341,7 +341,6 @@ typedef struct xfs_trans {
>  	unsigned int		t_rtx_res;	/* # of rt extents resvd */
>  	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
>  	xfs_log_ticket_t	t_ticket;	/* log mgr ticket */
> -	sema_t			t_sema;		/* sema for commit completion */
>  	xfs_lsn_t		t_lsn;		/* log seq num of start of
>  						 * transaction. */
>  	xfs_lsn_t		t_commit_lsn;	/* log seq num of end of

>> On Thu, Feb 07, 2008 at 09:27:24AM +0100, Christoph Hellwig wrote:
>>> It's completely unused so we might aswell kill it.  Note that there is
>>> another t_sema in struct xlog_ticket, which is used and actually an sv_t
>>> despite the name.  That one is left untouched by this patch.
>> Ping?
> 
> This seems to be already applied in our dev tree, I'm trying to track down how/when/by-who, appart from that I'm all for pushing it.
> 
> Cheers,

Niv, it still seems to be in our dev tree for me:

 > p_cat -farm xfs_trans.h | grep -C 3 t_sema
doucette  |1.22 |                            |	unsigned int		t_rtx_res;	/* # of rt extents resvd */
cattelan  |1.118|2.4.x-xfs:slinx:144573a     |	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
ajs       |1.13 |                            |	xfs_log_ticket_t	t_ticket;	/* log mgr ticket */
ajs       |1.11 |                            |	sema_t			t_sema;		/* sema for commit completion */
lord      |1.114|2.4.x-xfs:slinx:129778a     |	xfs_lsn_t		t_lsn;		/* log seq num of start of
lord      |1.114|2.4.x-xfs:slinx:129778a     |						 * transaction. */
cattelan  |1.118|2.4.x-xfs:slinx:144573a     |	xfs_lsn_t		t_commit_lsn;	/* log seq num of end of

--Tim
