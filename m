Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1100 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752400AbdIAWHm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 18:07:42 -0400
Date: Sat, 2 Sep 2017 08:07:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix unused variable warning in xfs_buf_item_unlock()
Message-ID: <20170901220739.GB10621@dastard>
References: <20170831160458.24886-1-bfoster@redhat.com>
 <20170831164107.GL3775@magnolia>
 <20170831215209.GQ10621@dastard>
 <20170901102420.GA28241@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170901102420.GA28241@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Sep 01, 2017 at 06:24:20AM -0400, Brian Foster wrote:
> On Fri, Sep 01, 2017 at 07:52:09AM +1000, Dave Chinner wrote:
> > On Thu, Aug 31, 2017 at 09:41:07AM -0700, Darrick J. Wong wrote:
> > > On Thu, Aug 31, 2017 at 12:04:58PM -0400, Brian Foster wrote:
> > > > The ordered variable generates an unused warning on !DEBUG builds.
> > > > Separate the initialization of the associated variables from the
> > > > declarations to quiet gcc.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > And merged before everyone in different timezones has had a chance
> > to comment. :(
> > 
> > I just built the latest for-next with CONFIG_XFS_DEBUG=n and there's
> > three set-but-unused warnings, one of which is introduced by this
> > patch.
> > 
> > fs/xfs/libxfs/xfs_inode_fork.c: In function ¿xfs_iext_realloc_indirect¿:
> > fs/xfs/libxfs/xfs_inode_fork.c:1503:7: error: variable ¿size¿ set but not used [-Werror=unused-but-set-variable]
> >   int  size;  /* current indirection array size */
> >        ^~~~
> > 
> > fs/xfs/xfs_buf_item.c: In function ¿xfs_buf_item_unlock¿:
> > fs/xfs/xfs_buf_item.c:573:9: error: variable ¿ordered¿ set but not used [-Werror=unused-but-set-variable]
> >   bool   ordered;
> >          ^~~~~~~
> > 
> > fs/xfs/xfs_log_recover.c: In function ¿xlog_recover_process_intents¿:
> > fs/xfs/xfs_log_recover.c:4830:13: error: variable ¿last_lsn¿ set but not used [-Werror=unused-but-set-variable]
> >   xfs_lsn_t  last_lsn;
> >              ^~~~~~~~
> > 
> > Yeah, maintainer habits die hard; I'm still patching fs/xfs/Makefile
> > in my build trees with this:
> > 
> > -ccflags-y += -I$(src)                  # needed for trace events
> > +ccflags-y += -I$(src) -Werror -Wunused-but-set-variable
> > 
> > Which catches stupid problems like this that will the userspace
> > libxfs build will trip over when the next merge occurs.
> > 
> 
> Note that the associated bli code is not shared with userspace, fwiw. We
> should probably fix the warnings regardless...
> 
> Hmm, I don't see that option enabled in xfsprogs. Is the issue then that
> it is more of a default behavior and the kernel disables it somewhere?

Yup, it's default gcc behaviour since early 5.x, IIRC, and the
kernel build disables a bunch of different warnings including this
one.

> After poking around a bit, that appears to be the case. We can run 'make
> W=1' to generate these (and more) in the kernel build.

Oh, yeah, but we don't want to do that by default because the kernel
headers throw huge numbers of warnings (e.g. signed v unsigned char)
that won't ever get fixed.  There's been heat and light expended on
LKML over fixing these warnings in the past, but the only outcome of
those discussion was to add the "-W1" option to allow people who
cared to see all the warnings that don't indicate a problem and
so won't get fixed....

Hence I started adding my own flags for XFS builds so I would avoid
adding code to the kernel that would throw userspace warnings.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
