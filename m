Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C93C57F37
	for <xfs@oss.sgi.com>; Sun, 14 Jun 2015 19:14:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43DE9AC001
	for <xfs@oss.sgi.com>; Sun, 14 Jun 2015 17:14:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3sqsa9ED9fNbgG2Z for <xfs@oss.sgi.com>;
	Sun, 14 Jun 2015 17:14:20 -0700 (PDT)
Date: Mon, 15 Jun 2015 10:13:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Script to cross-apply libxfs changes
Message-ID: <20150615001306.GF20262@dastard>
References: <55563463.1030107@redhat.com>
 <20150615000115.GE20262@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150615000115.GE20262@dastard>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 15, 2015 at 10:01:15AM +1000, Dave Chinner wrote:
> On Fri, May 15, 2015 at 01:01:07PM -0500, Eric Sandeen wrote:
> > I'm terrible at bash, so don't laugh.  But this more or less works for me ...
> > 
> > This script takes either a patch name or a commit ID in the current
> > tree, and massages that change into a libxfs patch for the other tree;
> > i.e. it applies a kernel libxfs patch to xfsprogs, or vice versa.
> > It'll create a guilt patch if it looks like a guilt dir, or just smack
> > it in with "patch" if not.
> > 
> > It can surely be improved, but it's a start.
> > 
> > Example below, and script at the end.  Requires filterdiff.
> > 
> > [root@bp-05 xfsprogs]# git log
> > commit 9681b791929795cd7dc6c7a79c3a69354f34e0b0
> > ...
> > [root@bp-05 xfsprogs]# libxfs-apply /mnt/test2/git/linux-xfs/ 9681b791929795cd7dc6c7a79c3a69354f34e0b0
> > Filtered patch for /mnt/test2/git/linux-xfs/ contains:
> > a/fs/xfs/libxfs/xfs_alloc.c
> > a/fs/xfs/libxfs/xfs_alloc_btree.c
> > a/fs/xfs/libxfs/xfs_attr_leaf.c
> > a/fs/xfs/libxfs/xfs_attr_remote.c
> > a/fs/xfs/libxfs/xfs_bmap_btree.c
> > a/fs/xfs/libxfs/xfs_btree.c
> > a/fs/xfs/libxfs/xfs_da_btree.c
> > a/fs/xfs/libxfs/xfs_dir2_block.c
> > a/fs/xfs/libxfs/xfs_dir2_data.c
> > a/fs/xfs/libxfs/xfs_dir2_leaf.c
> > a/fs/xfs/libxfs/xfs_dir2_node.c
> > a/fs/xfs/libxfs/xfs_dquot_buf.c
> > a/fs/xfs/libxfs/xfs_format.h
> > a/fs/xfs/libxfs/xfs_ialloc.c
> > a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > a/fs/xfs/libxfs/xfs_inode_buf.c
> > a/fs/xfs/libxfs/xfs_sb.c
> > a/fs/xfs/libxfs/xfs_symlink_remote.c
> > /mnt/test2/git/linux-xfs/ looks like a guilt directory.
> > Top patch is: percpu-2
> > Create new Guilt patch? (Enter patch name or return to skip) new-uuid
> > Applying patch..new-uuid
> > Patch applied.
> > Patch was applied in /mnt/test2/git/linux-xfs/; check for rejects, guilt push -f, etc
> > [root@bp-05 xfsprogs]#
> 
> Eric, can you add a sign-off on this? I'll add it to the xfsprogs
> repo under a tools/ directory and write some docco for it. No point
> in having someone write a script like this and then ignoring it...

Ok, I'm also going to modify it. It currently needs to be run in the
source repository, rather than in the destination repository. It's
not obvious, because the CLI interface is:

	"$prog <destination repo> <source repo commit id>"

I think it makes more sense to run from the destination repo, and
specify "source repo" "source repo commit id" as the paramters.

I'll also look to supporting a range of commit id's so that a series
can be pulled in with a single command....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
