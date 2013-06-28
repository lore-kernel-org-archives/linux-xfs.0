Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 72FEF7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:26:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58D4C30406B
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 08:26:00 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id UkCJ1Lmtu03kyD91
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 08:25:59 -0700 (PDT)
Date: Fri, 28 Jun 2013 10:25:52 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
Message-ID: <20130628152552.GB26841@sergelap>
References: <20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130626173017.5100327a@oracle.com>
	<20130626224410.GB28426@dastard> <20130627130205.GA4003@sergelap>
	<20130628015401.GG32195@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130628015401.GG32195@dastard>
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
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Brian Foster <bfoster@redhat.com>, Dwight Engen <dwight.engen@oracle.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, xfs@oss.sgi.com

Quoting Dave Chinner (david@fromorbit.com):
> On Thu, Jun 27, 2013 at 08:02:05AM -0500, Serge Hallyn wrote:
> > Quoting Dave Chinner (david@fromorbit.com):
> > > On Wed, Jun 26, 2013 at 05:30:17PM -0400, Dwight Engen wrote:
> > > > On Wed, 26 Jun 2013 12:09:24 +1000
> > > > Dave Chinner <david@fromorbit.com> wrote:
> > > > > > We do need to decide on the di_uid that comes back from bulkstat.
> > > > > > Right now it is returning on disk (== init_user_ns) uids. It looks
> > > > > > to me like xfsrestore is using the normal vfs routines (chown,
> > 
> > I might not be helpful here, (as despite having used xfs for years
> > I've not used these features) but feel like I should try based on
> > what I see in the manpages.  Here is my understanding:
> > 
> > Assume you're a task in a child userns, where you have host uids
> > 100000-110000 mapped to container uids 0-10000,
> > 
> > 1. bulkstat is an xfs_ioctl command, right?  It should return the mapped
> > uids (0-10000).
> > 
> > 2. xfsdump should store the uids as seen in the caller's namespace.  If
> > xfsdump is done from the container, the dump should show uids 0-10000.
> 
> So when run from within a namespace, it should filter and return
> only inodes that match the uids/gids mapped into the namespace?

I would think they should all be returned, with uid/gid being -1.

> That can be done, it's just a rather inefficient use of bulkstat
> (which is primarily there for efficiency reasons).
> 
> Here's a corner case. Say I download a tarball from somewhere that
> has uids/gids inside it, and when I untar it it creates uids/gids
> outside the namespaces mapped range of [0-10000]. What happens then?

The chown will fail, so they should belong to the fsuid/fsguid of the
calling task.

> What uids do we end up on disk, and how do we ensure that the
> bulkstat filter still returns those inodes?
> 
> > 3. xfsrestore should use be run from the desired namespace.  If you did
> > xfsdump from the host ns, you should then xfsrestore from the host ns.
> > Then inside the container those uids (100000-110000) will be mapped
> > to your uids (0-10000).
> > 
> > 4. If you xfsdump in this container, then xfsrestore in another
> > container where you have 200000-210000 mapped to 0-10000, the dump
> > image will have uids 0-10000.  The restored image will have container
> > uids 0-10000, while on the underlying host media it will be uids
> > 200000-210000.
> > 
> > 5. If you xfsdump in this container then xfsrestore on the host, then
> > the host uids 0-10000 will be used on the underlying media.  The
> > container would be unable to read this files as the uids do not map
> > into the container.
> 
> Yes, that follows from 1+2. We'll need some documentation in
> the dump/restore man pages for this, and I'd suggest that the
> namespace documentation/man pages get this sort of treatment, too.

There is a user_namespaces(7) man page which Michael Kerrisk had been
working on with Eric back in March.  I don't see it at
http://man7.org/linux/man-pages/dir_section_7.html
though, so it may still be in development or in a staging tree.

-serge

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
