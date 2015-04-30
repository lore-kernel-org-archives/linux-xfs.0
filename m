Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC9907F37
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2015 01:26:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA136304039
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 23:26:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nwkddydb3uaVTSFo for <xfs@oss.sgi.com>;
	Wed, 29 Apr 2015 23:26:39 -0700 (PDT)
Date: Thu, 30 Apr 2015 16:26:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question re: xfs inode to inode copy implementation
Message-ID: <20150430062614.GA15810@dastard>
References: <20150421010646.GX8110@shells.gnugeneration.com>
	<20150421042820.GA11601@birch.djwong.org>
	<20150430005330.GM8110@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150430005330.GM8110@shells.gnugeneration.com>
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
To: xfs@pengaru.com
Cc: vito.caputo@coreos.com, xfs <xfs@oss.sgi.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Apr 29, 2015 at 07:53:30PM -0500, xfs@pengaru.com wrote:
> On Mon, Apr 20, 2015 at 09:28:20PM -0700, Darrick J. Wong wrote:
> > On Mon, Apr 20, 2015 at 08:06:46PM -0500, xfs@pengaru.com wrote:
> > > My prototype already mostly works just using xfs_alloc_file_space() to
> > > allocate the appropriate space in the destination inode, but I need to
> > > get that allocated space populated from the shared inode's extents.
> > 
> > I think you're asking how to copy extent map entries from one file to another?
> 
> What I really wanted was something analogous to do_splice_direct() but for
> operating on the inodes/address_space structs.  I ended up just hacking
> something together which does the copy ad-hoc directly via the address_space
> structs and calling xfs_get_blocks() on buffer heads of the destination pages,
> without any readahead or other optimizations, at least it reads from and
> populates the page caches.
> 
> It looks like what you guys are working on is a more granular/block-level COW
> reflink implementation, which I assumed would be significantly more challenging
> and well beyond my ability to hack up quickly for experimentation.
> 
> Below I'll summarize what I've hacked together.  It's probably inappropriate to
> refer to this as a reflink, I've been referring to it as a COW-file in the
> code.

It's the same thing, just using a different COW mechanism to break
the reflink.

> A COW-file is a new inode which refers to another (shared) inode for its data
> until the COW-file is opened for writing.  At that point it clones the shared
> inode's data as its own.
> 
> Here's the mid-level details of the hack:
> 
> 1. Add two members to the inode in the available padding:
>  be32  nlink_cow:	Number of COW-file links to the inode
>  be64  inumber_cow:	Number of backing inode if inode is a COW-file

FYI, inode number alone is not enough to uniquely identify an inode.
Needs the ino/gen pair as inode numbers can be reused.

> 2. Introduc a new ioctl for creating a COW-file: 
>  #define XFS_IOC_CREATE_COWFILE_AT     _IOW ('X', 126, struct xfs_create_cowfile_at)
> 
>  typedef struct xfs_create_cowfile_at
>  {
>  	int	dfd;			/* parent directory	*/
>  	char	name[MAXNAMELEN];	/* name to create	*/
>  	umode_t	mode;			/* mode			*/
>  } xfs_create_cowfile_at_t;

Let's not create yet another incompatible reflink API. Please use
OCFS2_IOC_REFLINK as the API and pull the ioctl and infrastructure
within fs/ocfs2/refcounttree.c up to the VFS, add a ->reflink method
to the operations structure and then hook ocfs2 and the new XFS code
up to that interface.  We don't want to duplicate all that code
unnecessarily in an incompatible fashion.

> 3. Derive a xfs_create_cowfile() from xfs_create() and xfs_link():
>  xfs_create_cowfile(
> 	xfs_inode_t	*dp,		/* parent directory */
> 	xfs_inode_t	*sip,		/* shared inode (ioctl callee) */
> 	struct xfs_name	*name,		/* name of cowfile to create in dp */
> 	umode_t		mode,		/* mode */
> 	xfs_dev_t	rdev,
> 	xfs_inode_t	**ipp)		/* new inode */
> 
>  - ipp = allocate inode
>  - ipp->i_mapping->host = sip
>  - bump sip->nlink_cow
>  - ipp->inumber_cow = sip->di_ino
>  - create name in dp referencing ipp
> 
>  ipp starts out with the shared inode hosting i_mapping

That's kinda messy. I'd like to leave sharing page cache completely
out of the picture first, and get all the inode and extent
manipulations correct first. most important is all the inode life
cycle and unlink/unshare operations sorted, especially w.r.t.
locking and transactions.

Once we have that sanely under control, page cache sharing is a
matter of reflecting the shared extents in the page cache via
multiple page references (i.e. one for each mapping tree the page is
inserted into) rather than playing games trying to share mappings.

> 4. Modify xfs_setup_inode() to be inumber_cow-aware, opening the shared inode
>    when set, and assigning to i_mapping->host.

So you've added an xfs_iget() call to xfs_setup_inode() if the inode
is a reflink inode? How does the locking work?

> 5. Modify xfs_file_open() S_ISREG && inumber_cow && FMODE_WRITE:
>  - clear inumber_cow
>  - restore i_mapping->host to the inode being opened
>  - invalidate_inode_pages2(i_mapping)
>  - allocate all needed space in this inode
>  - copy size from shared inode to this inode
>  - copy all pages from the previously shared inode to this one

So the copy is done on open(O_WR) of the file. files get opened in
write mode for more than just writing date to them. e.g. fchmod,
writing new attributes, etc. We don't want a data cow if this is the
first operation that is done to the inode after the reflink is
made...

> 6. Modify xfs_vn_getattr() to copy stat->size from the shared inode if
>    inumer_cow is set.

Why wouldn't you just put the size in the COW inode?

> 7. Modify unlink paths to be nlink_cow-aware

What happens when parent is unlinked? It stays on the unlinked list?
Or do we know have the possibility that unlink can have two inodes
to free in xfs-inactive()?  What's the implication for transaction
reservations? What's the locking order?

reflink doesn't have this "readonly parent" wart. If the parent is
modified, it breaks it's side of the reflink via COW. Simple,
symmetric handling of the problem - it doesn't matter who writes to
what, the unmodified inodes do not see any change.

> 8. To simplify things, inodes that have nlink_cow no longer can be opened for
>    writing, they've become immutable backing stores of sorts for other inodes.

So, someone marks a file as COW, and that makes it read only? What
happens if there is already an open fd with write permissions when
the COW ioctl is called? So, where does the immutable state of the
inode get enforced? What's preventing it from being unlinked?

> The one major question mark I see in this achieving correctness is the live
> manipulation of i_mapping->host.  It seems to work in my casual testing on
> x86_64, this actually all works surprisingly well considering it's a fast and
> nasty hack.  I abuse invalidate_inode_pages2() as if a truncate has occurred,
> forcing subsequent page accesses to fault and revisit i_mapping->host.

I don't think you can't change mapping->host, as there is no one
lock that protects access to it.

> The goal here was to achieve something overlayfs-like but with inodes capable
> of being chowned/chmodded without triggering the copy_up, operations likely
> necessary for supporting user namespaces in containers.

Yup, reflink gives us this.

> Additionally,
> overlayfs has some serious correctness issues WRT multiply-opened files
> spanning the lower and upper layers due to one of the subsequent opens being a
> writer.  Since my hack creates distinct inodes from the start, no such issue
> exists.

Right, but it's not something that overlayfs can use unconditionally
(reflink or your COW file) because overlayfs can have upper and
lower directories on different filesystems.  And, as has also been
pointed out, it doesn't work on lower filesystems that are
read-only.

As such, I'm not sure that overlayfs will ever support this change
of behaviour as it restricts overlayfs to a single writeable
filesystem. I know, most people only need overlayfs on a single
writeable filesystem, but....

> However, one of the attractive things about overlayfs is the page cache sharing
> which my XFS hack doesn't enable due to the distinct struct addres_space's and
> i_mapping->host host exchanging.  I had hoped to explore something KSM-like
> with maybe some hints from XFS for these shared inode pagess saying "hey these
> are read-only pages in a shared inode, try deduplicate them!" but KSM is purely
> in vma land so that seems like a lot of work to make happen.

As I mentioned before, page cache sharing needs to reflect shared
blocks on disk. Playing games with KSM or mappings isn't a viable
solution.

> In any case, thanks for the responses and any further input you guys have.
> Obviously a more granular btrfs-like reflink is preferable, and I'd welcome it.
> It just seemed like doing something overlayfs-like would be a whole lot easier
> to get working in a relatively short time.

Overlayfs is creating more problems than it is solving. Hacking
random one-off functionality into filesystems is not the way to fix
overlayfs problems. Let's do reflink properly, then we can modify
overlayfs to be able to use reflink when all it's working
directories are on the same filesystem.  The we can add page cache
sharing to reflink files, and all of a sudden, the overlayfs page
cache sharing problem is solved. Not to mention it is solved for all
the other people that want reflink files for their applications,
too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
