Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 863C17F4E
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 09:48:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6AA90304048
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 07:48:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id d9t5e4nP4MeAhDsn for
	<xfs@oss.sgi.com>; Wed, 07 May 2014 07:48:32 -0700 (PDT)
Date: Wed, 7 May 2014 10:48:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140507144822.GA4061@bfoster.bfoster>
References: <20140506071855.F152E7FBC@oss.sgi.com>
	<20140506075905.GA5421@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506075905.GA5421@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, May 06, 2014 at 05:59:05PM +1000, Dave Chinner wrote:
> On Tue, May 06, 2014 at 02:18:55AM -0500, xfs@oss.sgi.com wrote:
> > This is an automated email from the git hooks/post-receive script. It was
> > generated because a ref change was pushed to the repository containing
> > the project "XFS development tree".
> > 
> > The branch, xfs-libxfs-in-kernel-RFC has been created
> >         at  6579dd808ddf0ddc10e59e715dc8f2eb09705203 (commit)
> 
> No doubt you are all wondering what this is by now. :)
> 
> I spent a couple of hours doing what I'd been talking about for a
> while now - converting the xfs kernel source tree to have a libxfs
> abstraction. It's based on the current for-next branch, so it's
> completely up-to-date.
> 
> The commits in this series move all the files used by userspace to:
> 
> 	- fs/xfs/libxfs for .c and private.h files
> 	- fs/xfs/libxfs/include for public .h files
> 
> It converts all the libxfs includes to makes the userspace libxfs
> includes (just a single #include) for both internal (libxfs_int.h)
> and external (libxfs.h). These will not be shared with userspace;
> userspace will provide it's own just like it does now.
> 
> The core idea around this code layout is that we can now extract all
> the changes to the libxfs code in the kernel in a simple manner
> (commit by commit or as a single aggregate patch), and apply it to
> the userspace libxfs code with the right pathname filter to the
> patch command. That's all a sync will require in future, and should
> make it scriptable and easy for anyone to do. It means, ideally,
> that we can do libxfs updates at the same time we do kernel updates
> with almost no effort.
> 
> There's still a few little messy corners, but I'm seriously tempted
> just to merge this into for-next right now because it's all good. :)"
> 
> [ Seriously, it removes almost a thousand #include lines from the
> kernel code, requires almost no extra infrastructure in the kernel,
> already has passed several full xfstests runs and will make our life
> so much easier. ]
> 
> Things that need to be done:
> 
> 	- xfs_dir2_priv.h is included in places that it shouldn't
> 	  be. Whatever those callers need from that header file
> 	  should be moved to xfs_dir2.h and into libxfs proper.
> 	- the Makefiles still have a little bit of messy include
> 	  rules (i.e. -I$(src) -I$(src)/libxfs/include) bit I can
> 	  live with that I think.
> 	- some of the libxfs header files have a dependency on
> 	  xfs_mount.h for things like inode cluster and directory
> 	  block sizes. These need to be untangled, but it's not a
> 	  critical issue right now.
> 	- xfs_vnode.h needs to die.
> 	- the kernel only header files that include libxfs header
> 	  files can now drop those includes.
> 
> Overall, though, this was surprisingly easy to do. All of the recent
> header file consolidation and cleanup that we've done made this
> pretty much a case of git mv of all the files and little bit of
> infrastructure, and not much else...
> 
> I suspect the next thing that needs to be done is consolidate libxfs
> and libxlog in userspace, and split the log recovery code in the
> kernel and put the shared part into fs/xfs/libxfs.....
> 
> I've put it up as a git branch rather than patches, because nobody
> wants me posting a patchset with a diffstat like this:
> 
> $ git diff --stat for-next..
> ....
> 164 files changed, 47250 insertions(+), 48036 deletions(-)
> 
> However, when you tell git to be smart about renames (i.e file
> movement is ignored), the actual diffstat looks like this:
> 
> $ git diff --stat --summary -C -M for-next..
> ....
> 108 files changed, 291 insertions(+), 1077 deletions(-)
> 
> If you want to look at it, pull from this branch:
> 
> git://oss.sgi.com/xfs/xfs xfs-libxfs-in-kernel-RFC
> 
> And check it out. The head is here:
> 
> 6579dd8 libxfs: provide extern include file
> 

It looks like a nice cleanup to me from the perspective of maintaining
synchronization between kernel and userspace. I suppose it gets more
interesting if we want to consider libxfs as something potentially
externally consumable, particularly whether we have broken things out at
the right interfaces. This certainly gets the ball rolling in that
direction. I have no major objections given that this mostly looks like
a mechanical code restructure.

Note that the Makefile structure between the core and libxfs/ subdir
appears to be busted for module compiles. It attempts to create a
libxfs.ko and doesn't appear to create any real link dependency between
the logical modules:

...
WARNING: "__tracepoint_xfs_dir2_sf_create" [fs/xfs/libxfs/libxfs.ko]
undefined!
WARNING: "__tracepoint_xfs_da_root_join" [fs/xfs/libxfs/libxfs.ko]
undefined!
WARNING: "xfs_trans_mod_sb" [fs/xfs/libxfs/libxfs.ko] undefined!
WARNING: "xfs_extent_busy_insert" [fs/xfs/libxfs/libxfs.ko] undefined!
WARNING: "__tracepoint_xfs_dir2_sf_addname" [fs/xfs/libxfs/libxfs.ko]
undefined!
  CC      fs/xfs/xfs.mod.o
  CC      fs/xfs/libxfs/libxfs.mod.o
  LD [M]  fs/xfs/xfs.ko
  LD [M]  fs/xfs/libxfs/libxfs.ko

I played with it a bit but didn't get anywhere without just pulling the
source file dependency up into fs/xfs/Makefile. :/

Brian

> New Commits:
> 
> Dave Chinner (5):
>       [20c53cb] xfs: create libxfs infrastructure
>       [22b8ea8] libxfs: move header files
>       [612480c] libxfs: move source files
>       [5e51adf] libxfs: consolidate internal include files
>       [6579dd8] libxfs: provide extern include file
> 
> Comments, flames, suggestions and beer all welcome :)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com



> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
