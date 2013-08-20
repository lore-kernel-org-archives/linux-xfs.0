Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6F257FF2
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 18:19:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F341AC001
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 16:19:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dBzYbAbIW2BjeBtn for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 16:19:07 -0700 (PDT)
Date: Wed, 21 Aug 2013 09:19:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
Message-ID: <20130820231903.GN6023@dastard>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com> <5212AA1D.3000809@sandeen.net>
	<52137D3D.8060205@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52137D3D.8060205@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Aug 20, 2013 at 09:29:17AM -0500, Mark Tinguely wrote:
> On 08/19/13 18:28, Eric Sandeen wrote:
> >On 8/19/13 3:19 PM, Mark Tinguely wrote:
> >
> ><an attachment that doesn't show up on reply, moving d_type support to v4 superblocks ;)>
> >
> >Thanks, Mark!
> >
> >Has you been able to test this at all?
> 
> There is no test for this feature. Yes I did my version of testing.
> First adding each type of inode type and verifying it. Then fsstress
> testing using the same seed for sb v4+feature, v4 plain, v5+feature.
> The resulting directory and checked with xfs_db. fsstress was chosen

You would have had to have modified xfs_db to do this - can you send
the patches out for review?

> because how it manipulate directory items.

But fsstress doesn't build large directories, so I don't think
you've done anywhere near enough testing to say that you'd done
anything more than smoke tested it.

Indeed, in testing the dirent code on v5 superblocks, Michael Semon
triggered a corner case failure in the v5 directory code that I
haven't ever triggered in all my testin.

Run this on a v5 filesystem:

# seq 200000 | xargs touch

And watch it fail when splitting a leaf in a node format directory.
It's taken several months of testing to uncover this problem, and it
is almost certain to be a bug that causes directory corruption.
fsstress doesn't get anywhere near the per-directory file count
necessary to exercise these sorts of directory operations.

The moral of the story: the XFS directory code is *very hard to
validate*.

This is an clear demonstration of why I want to be extremely
conservative in bringing this feature to v4 filesystems. The risk of
there being an undiscovered corruption bug in the dtype code, or it
exposes a pre-existing corruption bug in the directory code is
still significant.

> >I do still owe a promised xfstest - but for that, we'll need at least mkfs
> >&  xfs_repair support.
> >
> 
> Dave made changes so that xfs_repair will run (find the correct
> directory items) but the feature verification and repairs has not
> been done, so technically this is an incomplete feature.

The patches I sent won't support a new v4 superblock feature bit, so
you had had to write code to do that. Can you post your userspace
patches at well?

> >* XFS_IOC_FSGEOM support so that xfs_info can report the difference
> >* xfs_repair needs to know that it's a valid feature on V4
> 
> okay, it will run xfs_repair to the same level as v5. AND ...As
> pointed out, there is no xfs_repair support to verify/correct the
> feature in v5 and therefore v4 - (again it is the same directory
> code). As is, this feature is incomplete. That could keep the kernel
> portion from moving forward.

That's not what XFS_IOC_FSGEOM is for. Adding the feature bit to the
XFS_IOC_FSGEOM ioctl is to allow us to find out if the user has
enabled the feature via xfs_info....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
