Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D32F7F5D
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 00:40:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8DAC18F804B
	for <xfs@oss.sgi.com>; Sun, 22 Dec 2013 22:40:22 -0800 (PST)
Received: from oproxy9-pub.mail.unifiedlayer.com
	(oproxy9-pub.mail.unifiedlayer.com [69.89.24.6]) by
	cuda.sgi.com with SMTP id 5gUtCtUPJxA1vQI2 for
	<xfs@oss.sgi.com>; Sun, 22 Dec 2013 22:40:21 -0800 (PST)
Message-ID: <1387780809.3991.21.camel@slavad-ubuntu>
Subject: Re: [PATCH 21/21] hfsplus: remove can_set_xattr
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Date: Mon, 23 Dec 2013 10:40:09 +0400
In-Reply-To: <20131222192818.GA32565@infradead.org>
References: <20131220131635.650823732@bombadil.infradead.org>
	<20131220132524.900291394@bombadil.infradead.org>
	<636E01BC-12FD-452B-8B1C-320B6EADAEFD@dubeyko.com>
	<20131222192818.GA32565@infradead.org>
Mime-Version: 1.0
Reply-To: slava@dubeyko.com
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
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Sun, 2013-12-22 at 11:28 -0800, Christoph Hellwig wrote:

> 
> > > -	if (!strncmp(name, XATTR_MAC_OSX_PREFIX, XATTR_MAC_OSX_PREFIX_LEN)) {
> > > -		/*
> > > -		 * This makes sure that we aren't trying to set an
> > > -		 * attribute in a different namespace by prefixing it
> > > -		 * with "osx."
> > > -		 */
> > > -		if (is_known_namespace(name + XATTR_MAC_OSX_PREFIX_LEN))
> > > -			return -EOPNOTSUPP;
> > 
> > I think that this check is important. It forbids such combinations as "osx.system.*" or
> > "osx.trusted.*", for example. Because "osx.*" is virtual namespace for xattrs that
> > it can be under Mac OS X. If you want to set xattr from "system.*" namespace, for example,
> > then you need to use another handler. And such namespace should be without
> > addition of "osx." prefix.
> 
> Right, and we keep exactly the check, just in a different place.
> 

Maybe I missed something, but I can see that this check is removed only.
Could you point out the code in your patch that it checks and forbids
such combination as "osx.security.*", "osx.trusted.*" and so on?

I can see that is_known_namespace() is called for
hfsplus_xattr_osx_handler only. But this method doesn't contain
above-mentioned check. Moreover, hfsplus_xattr_user_handler,
hfsplus_xattr_trusted_handler, hfsplus_xattr_security_handler will be
without is_know_namespace() check. What about it?

> > The __hfsplus_setxattr() is common method for all handlers. So, removing
> > this call means that we don't check validity of namespace. I don't think
> > that such modification is a right way.
> 
> The generic code already checks for the validity of the namespace for
> you. xattr_resolve_name in fs/xattr.c makes sure only attributes for a
> namespace that the filesystem registered can be set or modified.
> 

But generic code doesn't check such names combination that it is treated
as wrong for concrete file systems. For example, "osx.security.*" is
wrong for the case of HFS+. Because it will works
hfsplus_xattr_osx_handler instead of hfsplus_xattr_security_handler.

> > > @@ -841,10 +761,6 @@ int hfsplus_removexattr(struct dentry *dentry, const char *name)
> > > 	if (!HFSPLUS_SB(inode->i_sb)->attr_tree)
> > > 		return -EOPNOTSUPP;
> > > 
> > > -	err = can_set_xattr(inode, name, NULL, 0);
> > 
> > Ditto. Moreover, it is used namely hfsplus_removexattr() and not
> > __hfsplus_setxattr() for removing xattrs in hfsplus driver. So, removing
> > this check is not good way.
> 
> Oh, I just noticed that hfsplus does not use the xattr handlers for
> removing, while it does for getting and setting xattrs.  That's a really
> bad a confusing design, and we'll indeed need to fix that as well.
> 

Why bad design? Do you mean that using .removexattr callback is bad
idea?

So, if it needs to use xattr handler only for removing then it needs to
make some refactoring of using __hfsplus_setxattr() and
hfsplus_removexattr() or merging these two functions into one. And I
think that merging is better idea.

Thanks,
Vyacheslav Dubeyko.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
