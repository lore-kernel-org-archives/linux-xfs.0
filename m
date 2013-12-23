Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C62317F54
	for <xfs@oss.sgi.com>; Sun, 22 Dec 2013 19:42:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BCD56304051
	for <xfs@oss.sgi.com>; Sun, 22 Dec 2013 17:42:33 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DAga8f1zHRt8WXBH for <xfs@oss.sgi.com>;
	Sun, 22 Dec 2013 17:42:28 -0800 (PST)
Date: Mon, 23 Dec 2013 12:42:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] directory quota survey on xfs
Message-ID: <20131223014222.GC3220@dastard>
References: <20131222095929.GA11444@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131222095929.GA11444@gmail.com>
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
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Dmitry Monakhov <dmonakhov@openvz.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Sun, Dec 22, 2013 at 05:59:29PM +0800, Zheng Liu wrote:
> Hi all,
> 
> As discussed with ext4 folks, I will try to make ext4 file system support
> directory quota (a.k.a., project id in xfs).

Firstly, project quotas are not directory quotas.  Project groups
are simply an aggregation of unrelated inodes with a specific
identifier (i.e. the project ID). Files accessable only to
individual users can shared project ID and hence be accounted to the
same quota, and hence accounting is independent of uid/gid.

By themselves, project quotas cannot be used to implement direct
subtree quotas - thay requires help from a special inode flag that
is used on directory inodes: XFS_DIFLAG_PROJINHERIT

This flag indicates that the directory and all inodes created in the
directory inherit the project ID of the directory. Hence the act of
creating a file in a XFS_DIFLAG_PROJINHERIT marked directory
associates the new file with s a specific project group. New
directories also get marked with XFS_DIFLAG_PROJINHERIT so the
behaviour is propagated down the directory tree.

Now, there is nothing to stop us from having files outside the
inheritance subtree from also having the same project ID, and hence
be accounted to the same project group. Indeed, you can have
multiple sub-trees that all use the same project ID and hence are
accounted together. e.g. a project has subdirs in various
directories:

	/documentation/project_A
	/src/project_A
	/build/project_A
	/test/project_A
	.....
	/home/bill/project_A
	/home/barry/project_A
	/home/benito/project_A
	/home/beryl/project_A
	.....

All of these directories can be set up with the same project ID
and XFS_DIFLAG_PROJINHERIT flag, and hence all be accounted to the
same project quota, despite being separate, disconnected subtrees.

IOWs, project groups are an accounting mechanism associated with the
inode's project ID, while XFS_DIFLAG_PROJINHERIT is a policy used
to direct how project IDs are applied.

> For keeping consistency
> with xfs's implementation, I did some tests on xfs, and I summarized the
> result as following.  This will help us understand what we can do and
> what we can't do.  Please correct me if I miss doing some tests or mis-
> understand something.
> 
> I just do some tests about rename/hardlink because they are the key
> issue from our discussion.
> 
> + unaccounted dir
> x accounted dir
> 
> rename(mv)
> ==========
> 
> + -> +: ok
> 
> + -> x: ok
> 
> I use strace(1) to lookup which syscall is used, and I found that xfs
> will return EXDEV when mv(1) tries to use rename(2) to move a dir from
> a unaccounted dir to a accounted dir.  Then mv uses creat(2)/read(2)/
> write(2) syscalls to move this dir.

That's purely an implementation detail, designed to simplify the
change of project ID for an inode.  By forcing the new inode to be
created from scratch under the destination's project ID, we don't
have to care about whether rename needs to allocate or free source
directory metadata, what anonymous metadata was accounted to the
source project ID as the srouce file and directory was modified,
etc. It's as simple as this:

        /*
         * If we are using project inheritance, we only allow renames
         * into our tree when the project IDs are the same; else the
         * tree quota mechanism would be circumvented.
         */
        if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
                     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
                error = XFS_ERROR(EXDEV);
                goto error_return;
        }

It also documents the policy for accounting directory tree quotas:
that quota is accounted for when moving *into* an accounted
directory tree, not when moving out of a directory tree.

> x -> +: wrong (design by feature?) 
> 
> If we move a dir from a accounted dir to a unaccounted dir, the quota is
> still accounted.  It seems that xfs don't remove project id from this
> dir and its subdirs/files on this case.

That's the way the directory tree policy was designed: it's designed
to allow project quotas to account for individual files as well as
subtrees. Remember: projects are not confined to a single subtree
and directory tree accounting is done when moving *into* a
controlled tree, not the other way around.

> x -> x: ok
> 
> Xfs returns EXDEV error when mv(1) uses rename(2) to move a dir from a
> accounted dir to another accounted dir (These dirs have different
> project ids).  Then mv(1) uses creat(1)/read(1)/write(1) syscalls to
> move this dir.
> 
> summary:
> rename        +        x
> +             ok       ok (EXDEV)
> x             wrong    ok (EXDEV)
> 
> hardlink(ln)
> ========
> 
> + -> +: ok
> 
> + -> x: error
> 
> Xfs also returns EXDEV error to forbid this operation.  So that means
> that we don't allow users to do a hardlink for a file from a unaccount
> dir to a accounted dir.

Of course - who do you account new changes to? It's the same problem
as linking across directory trees with different project IDs....

> 
> x -> +: ok
> 
> This operation can be executed and no any error is reported.  After that
> the quota doesn't be changed.  When both of two hardlinks are removed,
> the quota will be discharged.

Consistent with the rename case - checking is done based on the
destination directory - you can link out to an uncontrolled
destination as the inode is still accounted to the project ID, but
you can't link into a controlled destination with a different
project ID. The check is identical to the one I quoted for rename
above.

> As always, any comment or idea are welcome.

I'd suggest that you implement project quotas, not directory quotas.
They are way more flexible than pure directory quotas, but with only
a few lines of code and a special directory flag they can be used to
implement directory subtree quotas....

I'd also strongly suggest that you use the XFS userspace quota API
for managing project quotas, so that we can use the same management
tools and tests to verify that they behave the same. Please don't
invent a new version of the quota API to implement this - everything
you need ifor managing project/directory quotas is already there in
xfs_quota.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
