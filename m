Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 221DA7F89
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 10:52:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B446EAC009
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 08:51:59 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 3aznvsZCZPDH2XNX (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 08:51:56 -0800 (PST)
Date: Wed, 18 Feb 2015 08:51:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Cluster-devel] [PATCH 3/8] xfs: Convert to using ->get_state
	callback
Message-ID: <20150218165154.GA29465@infradead.org>
References: <1424267274-11836-1-git-send-email-jack@suse.cz>
	<1424267274-11836-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424267274-11836-4-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, xfs@oss.sgi.com

> +static void
> +xfs_qm_fill_state(
> +	struct qc_type_state *tstate,
> +	struct xfs_mount *mp,
> +	struct xfs_inode *ip,
> +	xfs_ino_t ino)

> +/*
> + * Return quota status information, such as enforcements, quota file inode
> + * numbers etc.
> + */
> +static int
> +xfs_fs_get_quota_state(
> +	struct super_block *sb,
> +	struct qc_state *state)

We usually tab-align the arguments in XFS prototypes.


Otherwise this patch looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
