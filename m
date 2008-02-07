Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Feb 2008 00:27:52 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m178RkF5008353
	for <xfs@oss.sgi.com>; Thu, 7 Feb 2008 00:27:47 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D629811E08CB
	for <xfs@oss.sgi.com>; Thu,  7 Feb 2008 00:27:34 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id iPrfVZFgn3nve9d3 for <xfs@oss.sgi.com>; Thu, 07 Feb 2008 00:27:34 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m178RPF3014229
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 7 Feb 2008 09:27:25 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m178ROsa014227
	for xfs@oss.sgi.com; Thu, 7 Feb 2008 09:27:24 +0100
Date: Thu, 7 Feb 2008 09:27:24 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill t_sema member of struct xfs_trans
Message-ID: <20080207082724.GA14119@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

It's completely unused so we might aswell kill it.  Note that there is
another t_sema in struct xlog_ticket, which is used and actually an sv_t
despite the name.  That one is left untouched by this patch.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_trans.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_trans.h	2008-02-05 08:48:40.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_trans.h	2008-02-05 08:48:45.000000000 +0100
@@ -341,7 +341,6 @@ typedef struct xfs_trans {
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
 	xfs_log_ticket_t	t_ticket;	/* log mgr ticket */
-	sema_t			t_sema;		/* sema for commit completion */
 	xfs_lsn_t		t_lsn;		/* log seq num of start of
 						 * transaction. */
 	xfs_lsn_t		t_commit_lsn;	/* log seq num of end of
