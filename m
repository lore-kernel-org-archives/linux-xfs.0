Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AF96ON097524 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 10:09:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49DAB126D8E6
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 08:16:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zhgGOuS6jYNi1OJS for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 08:16:38 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MEPQc-0002ks-Dh
	for xfs@oss.sgi.com; Wed, 10 Jun 2009 15:09:26 +0000
Date: Wed, 10 Jun 2009 11:09:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: pull request: sync changes + misc other bits for 2.6.31
Message-ID: <20090610150926.GA9512@infradead.org>
References: <20090608154405.GA28165@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090608154405.GA28165@infradead.org>
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
To: xfs@oss.sgi.com

On Mon, Jun 08, 2009 at 11:44:05AM -0400, Christoph Hellwig wrote:
> Hi Felix,
> 
> please pull git://git.kernel.org/pub/scm/fs/xfs/xfs.git for the
> following changes:
> 
> 
> Christoph Hellwig (8):
>       xfs: update max log size
>       xfs: validate quota log items during log recovery
>       xfs: kill xfs_qmops
>       xfs: split inode flushing from xfs_sync_inodes_ag
>       xfs: use generic inode iterator in xfs_qm_dqrele_all_inodes
>       xfs: split xfs_sync_inodes
>       xfs: remove SYNC_IOWAIT
>       xfs: remove SYNC_BDFLUSH

I've also added

	xfs: use generic Posix ACL code

As Al Viro is urgently waiting for that bit to hit mainline.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
