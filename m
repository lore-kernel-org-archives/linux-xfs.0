Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C4A667F72
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2015 03:38:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A32858F8035
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2015 01:38:13 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id UPo6BMDRN6pWZWhM (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Jan 2015 01:38:10 -0800 (PST)
Date: Mon, 19 Jan 2015 01:38:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/17] xfs: Convert to using ->get_state callback
Message-ID: <20150119093810.GA16484@infradead.org>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-13-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421412471-4747-13-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

> +static void xfs_qm_fill_state(struct qc_type_state *tstate,

Normal xfs style would be to keep the "static void " on a separate line,
as well as the arguments, e.g.

static void
xfs_qm_fill_state(
	struct qc_type_state	*tstate,

>
> +			      struct xfs_mount *mp,
> +			      struct xfs_inode *ip,
> +			      xfs_ino_t ino)

No need to pass mp, as it can be derived as ip->i_mount.

Btw, I think this code should move into xfs_quotaops.c now
that it ties into the Linux quota interface, and xfs_qm_scall_getstate
should be folded into xfs_fs_get_quota_state.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
