Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Feb 2008 09:57:49 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1QHvcmP012319
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2008 09:57:40 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBE4161B888
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2008 09:58:05 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Rp0dbsHa4GLrOE3c for <xfs@oss.sgi.com>; Tue, 26 Feb 2008 09:58:05 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1QHvwF3013396
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2008 18:57:59 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1QHvweL013394
	for xfs@oss.sgi.com; Tue, 26 Feb 2008 18:57:58 +0100
Date: Tue, 26 Feb 2008 18:57:58 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill t_sema member of struct xfs_trans
Message-ID: <20080226175758.GA13162@lst.de>
References: <20080207082724.GA14119@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207082724.GA14119@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Feb 07, 2008 at 09:27:24AM +0100, Christoph Hellwig wrote:
> It's completely unused so we might aswell kill it.  Note that there is
> another t_sema in struct xlog_ticket, which is used and actually an sv_t
> despite the name.  That one is left untouched by this patch.

Ping?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
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
---end quoted text---
