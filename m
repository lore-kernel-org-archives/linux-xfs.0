Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 577887F37
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2015 10:11:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3BAA58F804B
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2015 08:11:07 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id 06rk4SH5gdtIEETf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Apr 2015 08:11:05 -0700 (PDT)
Date: Sat, 25 Apr 2015 16:11:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 5/6] xfs: move non-inline symlinks to the pagecache
Message-ID: <20150425151103.GF889@ZenIV.linux.org.uk>
References: <1429816064-10033-1-git-send-email-hch@lst.de>
	<1429816064-10033-6-git-send-email-hch@lst.de>
	<20150423222942.GK15810@dastard> <20150425141612.GA4153@lst.de>
	<20150425145728.GE889@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150425145728.GE889@ZenIV.linux.org.uk>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Apr 25, 2015 at 03:57:28PM +0100, Al Viro wrote:
> > i_link member to the union of i_pipe, i_bdev and i_cdev.  That we
> > we can cache a link acquired by any way for direct use in the VFS.
> > 
> > This has a few use cases:  inline links can be set up directly
> > when reading the inode, and we never need to call into ->follow_link.
> > 
> > Formats like the XFS v5 symlinks can be read in once by whatever
> > way we want, and following accesses can be done RCU safe and
> > without calling into the filesystem.
> > 
> > Note that caching the symlink in a kmalloc'ed buffer might be
> > more efficient than the pagecache for most cases anyway.
> 
> Hmm...  When would you free the sucker?

FWIW, I'm not particularly opposed to doing that, but we'd better be careful
about not losing ->follow_link() itself.  Reason: we use its presence to
tell symlinks from non-symlinks.  OTOH, something like

	/* have already decided it's a symlink */
	if (inode->i_link)
		return inode->i_link;
	res = inode->i_op->follow_link(...);
with ->follow_link() instance returning ERR_PTR(-EIO) would work.  Such
sucker could live in fs/libfs.c just fine, with rule being "if you use it
for ->follow_link(), you'd better set ->i_link"...

Note, BTW, that there are symlinks where we _do_ have "traverse a string"
for semantics, and it's even kmalloc'ed, but we very much do not want it
to be cached.  Consider /proc/self, for example.  Different processes should
see different link bodies there, without any serialization between them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
