Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 10D697F77
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 13:08:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 930DBAC005
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 11:07:56 -0800 (PST)
Received: from zimbra13.linbit.com (zimbra13.linbit.com [212.69.166.240]) by
	cuda.sgi.com with ESMTP id opQlwMGfuTT9d0cC for
	<xfs@oss.sgi.com>; Thu, 12 Dec 2013 11:07:55 -0800 (PST)
Date: Thu, 12 Dec 2013 20:07:54 +0100 (CET)
From: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Message-ID: <1342716144.69126.1386875274180.JavaMail.zimbra@linbit.com>
In-Reply-To: <20131211104527.044064384@bombadil.infradead.org>
References: <20131211104243.148113893@bombadil.infradead.org>
	<20131211104527.044064384@bombadil.infradead.org>
Subject: Re: [PATCH 04/18] fs: add generic xattr_acl handlers
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

Christoph,

> +static int
> +posix_acl_xattr_set(struct dentry *dentry, const char *name,
> +		const void *value, size_t size, int flags, int type)
> +{
> +	struct inode *inode = dentry->d_inode;
> +	struct posix_acl *acl = NULL;
> +	int ret;
> +
> +	if (!IS_POSIXACL(inode))
> +		return -EOPNOTSUPP;
> +	if (S_ISLNK(inode->i_mode) || !inode->i_op->set_acl)
> +		return -EOPNOTSUPP;

Sama here, I would remove the S_ISLNK() check.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
