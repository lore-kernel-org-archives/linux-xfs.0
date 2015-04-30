Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C77AC7F37
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 19:53:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8863D8F8052
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 17:53:34 -0700 (PDT)
Received: from shells.gnugeneration.com (shells.gnugeneration.com
	[66.240.222.126]) by cuda.sgi.com with SMTP id hZFkqcjvGeS6iOhS
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 17:53:31 -0700 (PDT)
Date: Wed, 29 Apr 2015 19:53:30 -0500
From: xfs@pengaru.com
Subject: Re: question re: xfs inode to inode copy implementation
Message-ID: <20150430005330.GM8110@shells.gnugeneration.com>
References: <20150421010646.GX8110@shells.gnugeneration.com>
	<20150421042820.GA11601@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150421042820.GA11601@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: vito.caputo@coreos.com, xfs@pengaru.com, xfs <xfs@oss.sgi.com>

On Mon, Apr 20, 2015 at 09:28:20PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 20, 2015 at 08:06:46PM -0500, xfs@pengaru.com wrote:
> > Hello list,
> > 
> > I'm prototyping something like reflinks in xfs and was wondering if
> > anyone could give me some pointers on the best way to duplicate the
> 
> Heh, funny, I'm working on that too...
> 
> > blocks of the shared inode at the reflink inode, the copy which must
> > occur when breaking the link.
> 
> ...though I'm not sure what "the shared inode at the reflink inode" means.
> Are there somehow three inodes involved with reflinking one file to another?

There's just two inodes, the original file's inode and the inode created for
the reflink.

> 
> > It would be nice to do the transfer via the page cache after allocating
> > the space at the desintation inode, but it doesn't seem like I can use
> > any of the kernel helpers for copying the data via the address_space
> > structs since I don't have a struct file on hand for the copy source.
> > I'm doing this in xfs_file_open() so the only struct file I have is the
> > file being opened for writing - the destination of the copy.
> 
> So you're cloning the entire file's contents (i.e. breaking the reflink) as
> soon as the file is opened rw?

Correct.

> 
> > What I do have on hand is the shared inode and the destination inode
> > opened and ready to go, and the struct file for the destination.
> 
> The design I'm pursuing is different from yours, I think -- two files can use
> the regular bmbt to point to the same physical blocks, and there's a per-ag
> btree that tracks reference counts for physical extents.  What I'd like to do
> for the CoW operation is to clone the page (somehow), change the bmbt mapping
> to "delayed allocation", and let the dirty pages flush out like normal.
> 
> I haven't figured out /how/ to do this, mind you.  The rest of the bookkeeping
> parts are already written, though.
> 
> With reflink enabled, xfsrepair theoretically can solve multiply claimed blocks
> by simply adding the appropriate agblock:refcount entry to the refcount btree
> and it's done.
> 
> > My prototype already mostly works just using xfs_alloc_file_space() to
> > allocate the appropriate space in the destination inode, but I need to
> > get that allocated space populated from the shared inode's extents.
> 
> I think you're asking how to copy extent map entries from one file to another?

What I really wanted was something analogous to do_splice_direct() but for
operating on the inodes/address_space structs.  I ended up just hacking
something together which does the copy ad-hoc directly via the address_space
structs and calling xfs_get_blocks() on buffer heads of the destination pages,
without any readahead or other optimizations, at least it reads from and
populates the page caches.

It looks like what you guys are working on is a more granular/block-level COW
reflink implementation, which I assumed would be significantly more challenging
and well beyond my ability to hack up quickly for experimentation.

Below I'll summarize what I've hacked together.  It's probably inappropriate to
refer to this as a reflink, I've been referring to it as a COW-file in the
code.

A COW-file is a new inode which refers to another (shared) inode for its data
until the COW-file is opened for writing.  At that point it clones the shared
inode's data as its own.

Here's the mid-level details of the hack:

1. Add two members to the inode in the available padding:
 be32  nlink_cow:	Number of COW-file links to the inode
 be64  inumber_cow:	Number of backing inode if inode is a COW-file

2. Introduc a new ioctl for creating a COW-file: 
 #define XFS_IOC_CREATE_COWFILE_AT     _IOW ('X', 126, struct xfs_create_cowfile_at)

 typedef struct xfs_create_cowfile_at
 {
 	int	dfd;			/* parent directory	*/
 	char	name[MAXNAMELEN];	/* name to create	*/
 	umode_t	mode;			/* mode			*/
 } xfs_create_cowfile_at_t;

3. Derive a xfs_create_cowfile() from xfs_create() and xfs_link():
 xfs_create_cowfile(
	xfs_inode_t	*dp,		/* parent directory */
	xfs_inode_t	*sip,		/* shared inode (ioctl callee) */
	struct xfs_name	*name,		/* name of cowfile to create in dp */
	umode_t		mode,		/* mode */
	xfs_dev_t	rdev,
	xfs_inode_t	**ipp)		/* new inode */

 - ipp = allocate inode
 - ipp->i_mapping->host = sip
 - bump sip->nlink_cow
 - ipp->inumber_cow = sip->di_ino
 - create name in dp referencing ipp

 ipp starts out with the shared inode hosting i_mapping

4. Modify xfs_setup_inode() to be inumber_cow-aware, opening the shared inode
   when set, and assigning to i_mapping->host.

5. Modify xfs_file_open() S_ISREG && inumber_cow && FMODE_WRITE:
 - clear inumber_cow
 - restore i_mapping->host to the inode being opened
 - invalidate_inode_pages2(i_mapping)
 - allocate all needed space in this inode
 - copy size from shared inode to this inode
 - copy all pages from the previously shared inode to this one

6. Modify xfs_vn_getattr() to copy stat->size from the shared inode if
   inumer_cow is set.

7. Modify unlink paths to be nlink_cow-aware

8. To simplify things, inodes that have nlink_cow no longer can be opened for
   writing, they've become immutable backing stores of sorts for other inodes.


The one major question mark I see in this achieving correctness is the live
manipulation of i_mapping->host.  It seems to work in my casual testing on
x86_64, this actually all works surprisingly well considering it's a fast and
nasty hack.  I abuse invalidate_inode_pages2() as if a truncate has occurred,
forcing subsequent page accesses to fault and revisit i_mapping->host.

The goal here was to achieve something overlayfs-like but with inodes capable
of being chowned/chmodded without triggering the copy_up, operations likely
necessary for supporting user namespaces in containers.  Additionally,
overlayfs has some serious correctness issues WRT multiply-opened files
spanning the lower and upper layers due to one of the subsequent opens being a
writer.  Since my hack creates distinct inodes from the start, no such issue
exists.

However, one of the attractive things about overlayfs is the page cache sharing
which my XFS hack doesn't enable due to the distinct struct addres_space's and
i_mapping->host host exchanging.  I had hoped to explore something KSM-like
with maybe some hints from XFS for these shared inode pagess saying "hey these
are read-only pages in a shared inode, try deduplicate them!" but KSM is purely
in vma land so that seems like a lot of work to make happen.

In any case, thanks for the responses and any further input you guys have.
Obviously a more granular btrfs-like reflink is preferable, and I'd welcome it.
It just seemed like doing something overlayfs-like would be a whole lot easier
to get working in a relatively short time.

Cheers,
Vito Caputo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
