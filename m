Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E424E7F54
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 14:06:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A58818F804B
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 12:06:20 -0800 (PST)
Received: from fieldses.org (li207-46.members.linode.com [173.255.197.46]) by
	cuda.sgi.com with ESMTP id ERpfIjIMg0nGOeXy for
	<xfs@oss.sgi.com>; Thu, 22 Jan 2015 12:06:19 -0800 (PST)
Date: Thu, 22 Jan 2015 15:06:18 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: a simple and scalable pNFS block layout server V2
Message-ID: <20150122200618.GI898@fieldses.org>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
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
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Thu, Jan 22, 2015 at 12:09:46PM +0100, Christoph Hellwig wrote:
> This series adds support for the pNFS operations in NFS v4.1, as well
> as a block layout driver that can export block based filesystems that
> implement a few additional export operations.  Support for XFS is
> provided in this series, but other filesystems could be added easily.
> 
> The core pNFS code of course owns its heritage to the existing Linux
> pNFS server prototype, but except for a few bits and pieces in the
> XDR path nothing is left from it.
> 
> The design of this new pNFS server is fairly different from the old
> one - while the old one implemented very little semantics in nfsd
> and left almost everything to filesystems my implementation implements
> as much as possible in common nfsd code, then dispatches to a layout
> driver that still is part of nfsd and only then calls into the
> filesystem, thus keeping it free from intimate pNFS knowledge.
> 
> This version of the code has been rebased to the locks-for-3.20
> tree which adds a new lock context structure to the inode.

By the way, Jeff, do you consider the lock changes are ready?  Would you
mind if I pulled or cherry-picked them into the nfsd tree just to
simplify merging this stuff for 3.20?  (Assuming it's going to be
ready.)

--b.

> For now
> we still (ab)use the lease list like in the last version.  Adding
> a pNFS-specific list would duplicate a lot of code without much
> benefit.  But during this research I came up with way to associate
> a nfs4_file with a struct file at open time which should allow
> to greatly simplify the pNFS and delegation code.  So stay tuned
> for some patches in this area!
> 
> For now this also doesn't take errata 3901 for rfc 5661 into account
> yet and sticks to the verified errata.  The changes in 3901 seem
> useful in the longer run one verified and will be implemented
> eventually. Note that the only existing pNFS block client (Linux)
> would not benefit from the longer layout lifetimes anyway.
> 
> More details are document in the individual patch descriptions and
> code comments.
> 
> This code is also available from:
> 
> 	git://git.infradead.org/users/hch/pnfs.git pnfsd-for-3.20-2
> 
> Changes since V1:
> 	- rebased to the locks-for-3.20 tree
> 	- fixed a memory leak in the nfsd4_encode_getdeviceinfo error path
> 	- removed the always one lg_roc field
> 	- added a nopnfs export option
> 	- use a synchronous transaction in layoutget to simplify recovery
> 	- various XFS fixes pointed out by Dave
> 	- various documentation typo fixes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
