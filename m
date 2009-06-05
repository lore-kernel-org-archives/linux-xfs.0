Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n55JFehw060998 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 14:15:40 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE8F98BBFEA
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 12:22:43 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id HpVdlX5nJSiQ8T3m for <xfs@oss.sgi.com>;
	Fri, 05 Jun 2009 12:22:43 -0700 (PDT)
Message-ID: <4A296EDA.9020802@sandeen.net>
Date: Fri, 05 Jun 2009 14:15:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 6/7] xfs: use generic inode iterator
	in	xfs_qm_dqrele_all_inodes
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171559.029154000@bombadil.infradead.org>
In-Reply-To: <20090514171559.029154000@bombadil.infradead.org>
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

Christoph Hellwig wrote:

> Use xfs_inode_ag_iterator instead of opencoding the inode walk in the
> quota code.  Mark xfs_inode_ag_iterator and xfs_sync_inode_valid non-static
> to allow using them from the quota code.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2009-05-13 14:52:54.087659167 +0200
> +++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2009-05-13 14:57:36.531661369 +0200

...

> +	error = xfs_sync_inode_valid(ip, pag);
> +	if (error)
> +		return 0;

Does this need the same error propagation treatment as 5/7 ?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
