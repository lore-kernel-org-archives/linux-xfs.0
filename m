Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18B7B7F6A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 13:07:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 02E5F8F8065
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 11:07:22 -0800 (PST)
Received: from zimbra13.linbit.com (zimbra13.linbit.com [212.69.166.240]) by
	cuda.sgi.com with ESMTP id GaNeeWvQvHrgsaFR for
	<xfs@oss.sgi.com>; Thu, 12 Dec 2013 11:07:21 -0800 (PST)
Date: Thu, 12 Dec 2013 20:07:20 +0100 (CET)
From: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Message-ID: <389888733.69110.1386875240679.JavaMail.zimbra@linbit.com>
In-Reply-To: <20131211104527.223923019@bombadil.infradead.org>
References: <20131211104243.148113893@bombadil.infradead.org>
	<20131211104527.223923019@bombadil.infradead.org>
Subject: Re: [PATCH 05/18] fs: make posix_acl_chmod more useful
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

> +int
> +posix_acl_chmod(struct inode *inode)
> +{
> +	struct posix_acl *acl;
> +	int ret = 0;
> +
> +	if (S_ISLNK(inode->i_mode) || !inode->i_op->set_acl)
> +		return -EOPNOTSUPP;

Symlinks never have get_acl callbacks, so I would remove the S_ISLNK() check here.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
