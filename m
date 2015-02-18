Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4693F29DF7
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 11:11:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 26587304032
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 09:11:45 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id X5Y8eHv6DGCdHqOf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 09:11:44 -0800 (PST)
Date: Wed, 18 Feb 2015 18:11:38 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [Cluster-devel] [PATCH 3/8] xfs: Convert to using ->get_state
	callback
Message-ID: <20150218171138.GA11951@quack.suse.cz>
References: <1424267274-11836-1-git-send-email-jack@suse.cz>
	<1424267274-11836-4-git-send-email-jack@suse.cz>
	<20150218165154.GA29465@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150218165154.GA29465@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed 18-02-15 08:51:54, Christoph Hellwig wrote:
> > +static void
> > +xfs_qm_fill_state(
> > +	struct qc_type_state *tstate,
> > +	struct xfs_mount *mp,
> > +	struct xfs_inode *ip,
> > +	xfs_ino_t ino)
> 
> > +/*
> > + * Return quota status information, such as enforcements, quota file inode
> > + * numbers etc.
> > + */
> > +static int
> > +xfs_fs_get_quota_state(
> > +	struct super_block *sb,
> > +	struct qc_state *state)
> 
> We usually tab-align the arguments in XFS prototypes.
  OK, fixed.

> Otherwise this patch looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
  Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
