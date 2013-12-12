Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C18EC7F6A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 13:06:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1758304053
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 11:06:13 -0800 (PST)
Received: from zimbra13.linbit.com (zimbra13.linbit.com [212.69.166.240]) by
	cuda.sgi.com with ESMTP id Jdd4lYwafV7lvchL for
	<xfs@oss.sgi.com>; Thu, 12 Dec 2013 11:06:11 -0800 (PST)
Date: Thu, 12 Dec 2013 20:06:09 +0100 (CET)
From: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Message-ID: <1724169901.69108.1386875169382.JavaMail.zimbra@linbit.com>
In-Reply-To: <20131211104526.648135334@bombadil.infradead.org>
References: <20131211104243.148113893@bombadil.infradead.org>
	<20131211104526.648135334@bombadil.infradead.org>
Subject: Re: [PATCH 02/18] fs: add get_acl helper
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

> +struct posix_acl *get_acl(struct inode *inode, int type)
> +{
> +	struct posix_acl *acl;
> +
> +	acl = get_cached_acl(inode, type);
> +	if (acl != ACL_NOT_CACHED)
> +		return acl;
> +
> +	if (!IS_POSIXACL(inode))
> +		return NULL;
> +
> +	/*
> +	 * A filesystem can force a ACL callback by just never filling the
> +	 * ACL cache. But normally you'd fill the cache either at inode
> +	 * instantiation time, or on the first ->get_acl call.
> +	 *
> +	 * If the filesystem doesn't have a get_acl() function at all, we'll
> +	 * just create the negative cache entry.
> +	 */
> +	if (!inode->i_op->get_acl) {
> +		set_cached_acl(inode, type, NULL);
> +		return ERR_PTR(-EAGAIN);

The function should return NULL here.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
