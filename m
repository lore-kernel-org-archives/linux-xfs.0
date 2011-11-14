Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEKKqDV237424 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 14:20:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76BD9105DD5A
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 12:20:50 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	a4B8MO8EUUWphkFq for <xfs@oss.sgi.com>;
	Mon, 14 Nov 2011 12:20:50 -0800 (PST)
Date: Mon, 14 Nov 2011 15:20:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Occasional memory fault in inode_has_perm() while running
	xfstest 234
Message-ID: <20111114202044.GA306@infradead.org>
References: <1320961003.2201.27.camel@chandra-lucid.austin.ibm.com>
	<20111114102755.GA31043@infradead.org>
	<CACLa4psaXKWT0uQBdQFTkT6bzqLED1dZna5RhBK3-oZ=6LjDRw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACLa4psaXKWT0uQBdQFTkT6bzqLED1dZna5RhBK3-oZ=6LjDRw@mail.gmail.com>
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
To: Eric Paris <eparis@parisplace.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-security-module@vger.kernel.org, Chandra Seetharaman <sekharan@us.ibm.com>, XFS Mailing List <xfs@oss.sgi.com>

On Mon, Nov 14, 2011 at 10:13:11AM -0500, Eric Paris wrote:
> The only way this can happen is if the filesystem is creating inodes
> and not calling security_inode_alloc() (which should be done in
> inode_init_always)
> 
> I can only guess (and believe me it is a complete wild guess after
> looking at grep for 5 seconds) it has something to do with the XFS
> __releases() function which does some weirdness in the case of a
> failed call to inode_init_always().

Do you mean xfs_iget_cache_hit?

> The only other option is an FS somehow still uses an inode after
> __destroy_inode(), but I'd assume that would land you in other
> troubles.  In either case, I'm hard pressed to blame SELinux/LSM,
> since the VFS does appear to be hooked in the right places
> (inode_init_alwasys and __destroy_inode) to set and unset
> inode->i_security....

XFS inodes have a longer life time than VFS inodes they still
hang around after ->destroy_inode, and if we manage to reuse them
we'll call inode_init_always on them manually.  The error handling
there is nasty - basically we try to move it back into the state
before we tried to reuse it, return an error to userspace and then
expect the inode to either get reclaimed, or that we have enough
memory next time someone tries to reuse it.  Note that the only
way for it to fail is if security_inode_alloc fails, so on normal
non-LSM systems it won't ever fail.

I can't really see an issue with i_security lifetimes from a quick
look over the code, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
