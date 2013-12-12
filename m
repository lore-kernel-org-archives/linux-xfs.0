Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BA4ED7F3F
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 15:04:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B060304067
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 13:04:52 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id fTIO0fKIZRYhOFJk (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 13:04:51 -0800 (PST)
Date: Thu, 12 Dec 2013 13:04:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/18] fs: add get_acl helper
Message-ID: <20131212210439.GA27686@infradead.org>
References: <20131211104243.148113893@bombadil.infradead.org>
	<20131211104526.648135334@bombadil.infradead.org>
	<1724169901.69108.1386875169382.JavaMail.zimbra@linbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1724169901.69108.1386875169382.JavaMail.zimbra@linbit.com>
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
To: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Cc: cluster-devel@redhat.com, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig <hch@infradead.org>, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Thu, Dec 12, 2013 at 08:06:09PM +0100, Andreas Gruenbacher wrote:
> > +	/*
> > +	 * A filesystem can force a ACL callback by just never filling the
> > +	 * ACL cache. But normally you'd fill the cache either at inode
> > +	 * instantiation time, or on the first ->get_acl call.
> > +	 *
> > +	 * If the filesystem doesn't have a get_acl() function at all, we'll
> > +	 * just create the negative cache entry.
> > +	 */
> > +	if (!inode->i_op->get_acl) {
> > +		set_cached_acl(inode, type, NULL);
> > +		return ERR_PTR(-EAGAIN);
> 
> The function should return NULL here.

Indeed.  EAGAIN is the convention check_acl() in fs/namei.c uses,
but it will return that automatically if we just return NULL here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
