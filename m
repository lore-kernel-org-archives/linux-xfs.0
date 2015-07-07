Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 287AC7F50
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 19:10:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 060688F8052
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 17:09:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VZo3hCCag4h5uRVT for <xfs@oss.sgi.com>;
	Mon, 06 Jul 2015 17:09:53 -0700 (PDT)
Date: Tue, 7 Jul 2015 10:09:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Message-ID: <20150707000911.GT7943@dastard>
References: <20150629222651.GG7943@dastard>
	<F1A27B6A9FB048488A388EC4D9FD71F7@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F1A27B6A9FB048488A388EC4D9FD71F7@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Danny Shavit <danny@zadarastorage.com>, bfoster@redhat.com, Yair Hershko <yair@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, xfs@oss.sgi.com

On Mon, Jul 06, 2015 at 08:47:56PM +0200, Alex Lyakas wrote:
> Hi Dave, Brian,
> 
> [Compendium reply, trimmed and re-ordered]
> >I suppose that might never trigger due to the sync mount
> >option. What's the reason for using that one?
> 
> >I'm afraid to ask why, but that is likely your problem - synchronous
> >out of order writes from the NFS client will fragment the file
> >badly because it defeats both delayed allocation and speculative
> >preallocation because there is nothing to trigger the "don't remove
> >speculatieve prealloc on file close" heuristic used to avoid
> >fragmentation caused by out of order NFS writes....
> The main reason for using "sync" mount option is to avoid data loss
> in the case of crash.
> I did some experiments without this mount option, and indeed I see
> that same NFS workload results in lower fragmentation, especially
> for large files. However, since we do not consider at the moment
> removing the "sync" mount option, I did not debug further why it
> happens.

The NFS protocol handles server side data loss in the event of a
server crash. i.e. the client side commit is an "fsync" to the
server, and until the server responds with a success to the client
commit RPC the client side will continue to retry sending the data
to the server.

For the persepctive of metadata (i.e. directory entries) the use of
the "dirsync" mount option is sufficient for HA failover servers to
work correctly as it ensures that directory structure changes are always
committed to disk before the RPC response is sent back to the
client.

i.e. the "sync" mount option doesn't actually improve data integrity
of an NFS server when you look at the end-to-end NFS protocol
handling of async write data....

> >NFS is likely resulting in out of order writes....
> Yes, Dave, this appeared to be our issue.

Ok, no big surprise that fragmentation is happening...

> However, Dave, I am still not comfortable with XFS insisting on
> continuous space for the data fork in kmem_alloc. Consider, for
> example,  Brian's script. Nothing stops the user from doing that.
> Another example could be strided 4k NFS writes coming out of order.
> For these cases, speculative preallocation will not help, as we will
> receive a highly fragmented file with holes.

Except that users and applications don't tend to do this because
other filesystem barf on such fragmented files long before XFS does.
Hence, in general, application and users take steps to avoid this
sort of braindead allocation.  And then, of course, there is
xfs_fsr...

We had this discussion ~10 years ago when this code was originally
written and it was decided that the complexity of implementing a
fully generic, scalable solution was not worth the effort as files
with massive numbers of extents cause other performance problems
long before memory allocation should be an issue.

That said, there is now generic infrastructure that makes the
complexity less of a problem, and I do have some patches that I've
been working on in the background to move to a generic structure.
Other filesystems like ext4, btrfs and f2fs have moved to extremely
fine-grained extent trees, but they have been causing all sorts of
interesting scalablity and memory reclaim problems so I don't think
we want to go that way.

However, the problem we actually need to solve is not having a
fine-grained extent tree, but that of demand paging of in-memory
extent lists so that we don't need to keep millions of extents in
memory at a time.  That's where we need to go with this, and I have
some early, incomplete patches that move towards a btree based
structure for doing this....

> Another example, Dave, can you please look at the stack trace in
> [1]. (It doesn't make much sense, but this is what we got). Could
> something like this happen:
> - VFS tells XFS to unlink an inode
> - XFS tries to reallocate the extents fork via xfs_inactive path
> - there is no continuous memory, so kernel (somehow) wants to evict
> the same inode, but cannot lock it due to XFS already holding the
> lock???

Simply not possible. Memory reclaim can't evict an inode that has an
active reference count.  Also, unlinked inodes never get evicted
from memory reclaim - the final inode reference release will do the
reclaim, and that always occurs in a process context of some
kind....

> [454509.864025]  [<ffffffffa075e303>] ? xfs_fs_evict_inode+0x93/0x100 [xfs]
> [454509.864025]  [<ffffffff811b5530>] ? evict+0xc0/0x1d0
> [454509.864025]  [<ffffffff811b5e62>] ? iput_final+0xe2/0x170
> [454509.864025]  [<ffffffff811b5f2e>] ? iput+0x3e/0x50
> [454509.864025]  [<ffffffff811b0e88>] ? dentry_unlink_inode+0xd8/0x110
> [454509.864025]  [<ffffffff811b0f7e>] ? d_delete+0xbe/0xd0
> [454509.864025]  [<ffffffff811a663e>] ? vfs_unlink.part.27+0xde/0xf0
> [454509.864025]  [<ffffffff811a847c>] ? vfs_unlink+0x3c/0x60
> [454509.864025]  [<ffffffffa01e90c3>] ? nfsd_unlink+0x183/0x230 [nfsd]
> [454509.864025]  [<ffffffffa01f871d>] ? nfsd4_remove+0x6d/0x130 [nfsd]

As you can see here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
