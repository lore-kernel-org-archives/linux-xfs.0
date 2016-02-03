Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC6C829DF5
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 02:31:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DDC73304043
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 00:31:25 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	W9Yco8tWrbhgOTuu for <xfs@oss.sgi.com>;
	Wed, 03 Feb 2016 00:30:54 -0800 (PST)
Date: Wed, 3 Feb 2016 19:30:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Request for information on bloated writes using Swift
Message-ID: <20160203083016.GD459@dastard>
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
	<56B16A3C.1030207@sandeen.net>
	<CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
	<20160203063705.GB459@dastard>
	<CAFHL4X0m8Ov+zJxteUJJxzEHVXpJsfe=9mtapRmWkhT6VRkDxg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFHL4X0m8Ov+zJxteUJJxzEHVXpJsfe=9mtapRmWkhT6VRkDxg@mail.gmail.com>
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
To: Dilip Simha <nmdilipsimha@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Feb 02, 2016 at 11:09:15PM -0800, Dilip Simha wrote:
> Hi Dave,
> 
> On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wrote:
> > > Hi Eric,
> > >
> > > Thank you for your quick reply.
> > >
> > > Using xfs_io as per your suggestion, I am able to reproduce the issue.
> > > However, I need to falloc for 256K and write for 257K to see this issue.
> > >
> > > # xfs_io -f -c "falloc 0 256k" -c "pwrite 0 257k" /srv/node/r1/t1.txt
> > > # stat /srv/node/r1/t4.txt | grep Blocks
> > >   Size: 263168     Blocks: 1536       IO Block: 4096   regular file
> >
> > Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.
> >
> > When you writing *past the preallocated area* and do delayed
> > allocation, the speculative preallocation beyond EOF is double the
> > size of the extent at EOF. i.e. 512k, leading to 768k being
> > allocated to the file (1536 blocks, exactly).
> >
> 
> Thank you for the details.
> This is exactly where I am a bit perplexed. Since the reclamation logic
> skips inodes that have the XFS_DIFLAG_PREALLOC flag set, why did the
> allocation logic allot more blocks on such an inode?

To store the data you wrote outside the preallocated region, of
course.

> My understanding is that the fallocate caller only requested for 256K worth
> of blocks to be available sequentially if possible.

fallocate only guarantees the blocks are allocated - it does not
guarantee anything about the layout of the blocks.

> On any subsequent write beyond the EOF, the caller is completely
> unaware of the underlying file-system storing that data adjacent
> to the first 256K data.  Since XFS is speculatively allocating
> additional space (512K) adjacent to the first 256K data, I would
> expect XFS to either treat these two allocations distinctly and
> NOT mark XFS_DIFLAG_PREALLOC on the additional 512K data(minus the
> actually used additional data=1K), OR remove XFS_DIFLAG_PREALLOC
> flag on the entire inode.

Oh, if only it were that simple. It's way more complex than I have
time to explain here.

Fundamentally, XFS_DIFLAG_PREALLOC is used to indicate that
persistent preallocation has been done on the file, and so if that
has happened we need to turn off optimistic removal of blocks
anywhere in the file because we can't tell what blocks had
persistent preallocation done on them after the fact.  That's the
way it's been since unwritten extents were added to XFS back in
1998, and I don't really see the need for it to change right now.

If an application wants to mix fallocate and delayed allocatin
writes to the same file in the same IO, then that's an application
bug. It's going to cause bad IO patterns and file fragmentation and
have other side effects (as you've noticed), and there's nothing the
filesystem can do about it. fallocate() requires expertise to use in
a beneficial manner - most developers do not have the required
expertise (and don't have enough expertise to realise this) and so
usually make things worse rather than better by using fallocate.

> Also, is there any way I can check for this flag?
> The FLAGS, as observed from xfs_bmap doesn't show any flags set to it. Am I
> not looking at the right flags?

xfs_io -c stat <file>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
