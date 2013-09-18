Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C73747F50
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 22:36:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A48198F8074
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 20:36:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HhAxZSZS3b4YwgsH for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 20:36:47 -0700 (PDT)
Date: Wed, 18 Sep 2013 13:36:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/55] libxfs: sync dir2 kernel differences
Message-ID: <20130918033645.GN19103@dastard>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-11-git-send-email-david@fromorbit.com>
	<523871C2.5010704@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <523871C2.5010704@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Sep 17, 2013 at 10:14:10AM -0500, Eric Sandeen wrote:
> On 9/4/13 5:05 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  libxfs/xfs_dir2.c      | 45 +++++++++++++++++++++++++++++++++++++++++++++
> >  libxfs/xfs_dir2_data.c | 20 ++++++++++----------
> >  libxfs/xfs_dir2_leaf.c |  4 ++--
> >  libxfs/xfs_dir2_node.c | 26 ++++++++++++--------------
> >  4 files changed, 69 insertions(+), 26 deletions(-)
> > 
> > diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
> > index 6a4027f..830fe3e 100644
> > --- a/libxfs/xfs_dir2.c
> > +++ b/libxfs/xfs_dir2.c
> > @@ -392,6 +392,51 @@ xfs_dir_replace(
> >  }
> >  
> >  /*
> > + * See if this entry can be added to the directory without allocating space.
> > + * First checks that the caller couldn't reserve enough space (resblks = 0).
> > + */
> > +int
> > +xfs_dir_canenter(
> 
> Retroactive, post-merge question.  :)  This function isn't used in userspace,
> AFAICT.  What's the intended libxfs philosophy - keep files as identical to
> kernelspace as possible, used code or not, or remove things which aren't used
> in userspace?

A bit of history here. Going back to when the GPL'd version of
xfscmds was created, the intention was that libxfs would be a
minimal, cut down version of the kernel code that only had the exact
functionality that the userspace tools required. That lasted while
Nathan was the maintainer - most of the changes were being made by
SGI, and were being made to both Irix and GPL'd code bases and so
there was significant amounts of code shuffling internally and so a
minimal implementation made sense.

With the demise of Irix, there was much less code shuffling going
on, and all development work moved over to Linux, leading to the
situation where there was only one kernel code base to maintain, and
one userspace to maintain.

When Nathan left, regular updates to the libxfs code pretty much
stopped - there weren't a lot of people that grokked the libxfs
codebase and so it was mostly left alone. There was a major update
for ~2.9.13 with all the xfs repair work that was done back in 2008
done by Barry Naujok, and since then there's only been sporadic,
massive kernel code syncs that have involved diffs > +/-10000 lines
that are impossible to review.

So, come the CRC work, another major sync was needed, and I decided
to make such sycnhronisation work easy in a way that Christoph had
mentioned a few times over the past couple of years. That is, libxfs
basically becomes a shared copy of the code with minimal differences
and we separate all the kernel code out into kernel-only and
shared-libxfs code.

That's where we are now - with almost all the libxfs code synced in
user and kernel space.

Yes, this means that there are some dead functions in userspace, but
it means that it is trivial to spot differences between the user and
kernel code, and that is far more important from a maintenance
perspective that having a bit of dead code lying around.

Once this started to fall into place, I started finding lots of
little differences that needed fixing that were hidden by the
verbosity of previous sync efforts. Indeed, this command points out
interesting little things like:

$ for f in `ls libxfs |grep xfs_ |grep -v trace`; do diff -u
libxfs/$f ../kern/xfsdev/fs/xfs/$f; done |less
....
@@ -612,6 +635,7 @@
        xfs_trans_log_buf(tp, bp, 0, size - 1);
 
        bp->b_ops = blk1->bp->b_ops;
+       xfs_trans_buf_copy_type(bp, blk1->bp);
        blk1->bp = bp;
        blk1->blkno = blkno;
 
Which indicate that some bug fixes from teh kernel code haven't been
brought across.

There's still more work to do - xfs-rtalloc.c still needs splitting,
and xfs_btree.c has some readahead differences that need to be
sorted, but overall the idea is that libxfs and the include/xfs_*h
files are as close to identical to the kernel code as possible....

The other advantage of this is that patches made to the kernel apply
with a minimum of massaging to userspace, which makes keeping the
userspace code up to data a lot easier.

I've mentioned it before - I'd like to end up with a fs/xfs/libxfs/
directory in the kernel that is essentially identical in all ways to
the userspace libxfs, so all we need to do is copy files to keep
them in sync. We're not there yet, but it's definitely getting
closer to being a reality. If we get to this stage, then getting
userspace support up and running for new features will not require
any kernel patch ftuzing at all - just copy the files, and start
working on tool support...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
