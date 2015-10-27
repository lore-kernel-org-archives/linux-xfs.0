Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 302817F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 15:18:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AB416AC001
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 13:18:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	kTZoEgeRxL0POm1A for <xfs@oss.sgi.com>;
	Tue, 27 Oct 2015 13:18:27 -0700 (PDT)
Date: Wed, 28 Oct 2015 07:18:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
Message-ID: <20151027201825.GO8773@dastard>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
	<20151024152254.GA22232@bfoster.bfoster>
	<20151026213228.GI8773@dastard>
	<CAHc6FU68MYTGWKM5S14_dQBqXeebd2GwQcKj4RztLvPWL2eksA@mail.gmail.com>
	<20151027053045.GL8773@dastard>
	<CAHc6FU4ZgJDKphScucvDfEWPFFu4dGfDVund9Wrah=X-vxnz3w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU4ZgJDKphScucvDfEWPFFu4dGfDVund9Wrah=X-vxnz3w@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Oct 27, 2015 at 11:56:46AM +0100, Andreas Gruenbacher wrote:
> On Tue, Oct 27, 2015 at 6:30 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Oct 27, 2015 at 12:52:10AM +0100, Andreas Gruenbacher wrote:
> >> On Mon, Oct 26, 2015 at 10:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > Really, I'm struggling to understand what the problem is with XFS
> >> > doing translation to it's own special xattr names for ACLs
> >> > underneath the posix layer.
> >>
> >> Right now, setting one of the SGI_ACL attributes leads to stale i_acl
> >> / i_default_acl fields and in the case of SGI_ACL_FILE, possibly to
> >> outdated permissions in i_mode. You would get different information
> >> from getfacl than what's stored on disk.
> >
> > That's because we're not marking the cached acl as stale when
> > setting the acl directly...
> >
> >> > Yes, there's a caching issue when someone directly manipulates
> >> > the underlying xattr,
> >>
> >> "Directly manipulating" could be doing a setxattr of an attribute that
> >> was previously retrieved by getxattr, like restoring a backup.
> >
> > Sure, that's what xfsdump/restore effectively does.
> >
> >> > but you need root to shoot yourself in the foot that way, and that is easily
> >> > solveable.
> >>
> >> What do you mean, it's easily solvable?
> >
> > forget_all_cached_acls()
> 
> Brian has already suggested that in this thread. Still leaves the
> i_mode permission bits stale and is broken wrt. uid/gid namespaces.

But for xfsrestore we don't want to do that because it's already
set the mode correctly. Indeed, we order operations in xfs_restore
to prevent the kernel from fucking with the inode modes and capabilities
and giving use the incorrect result once the backup is complete. e.g.:

struct stream_context {
        bstat_t    sc_bstat;
        char       sc_path[2 * MAXPATHLEN];
        int   sc_fd;
        int   sc_hsmflags;

        /*
         * we have to set the owner before we set extended attributes otherwise
         * capabilities will not be restored correctly as setting the owner with
         * fchmod will strip the capability attribute from the file. Hence we
         * need to do this before restoring xattrs and record it so we don't do
         * it again on completion of file restoration.
         */
        bool_t     sc_ownerset;
};


Further, user namespaces are irrelevant here - you can't run
xfsdump/restore outside the init_ns.  xfsdump requires access to the
handle interface, which is unsafe to use inside a user ns because it
allows complete access to any inode in the filesystem without
limitations. xfs_restore requires unfettered access to directly
manipulate the uid/gid/security attrs of inodes, which once again is
something that isn't allowed inside user namespaces.

Setting Posix acls by directly poking the on-disk attr format rather
than going through the proper kernel ACL namespace is not a *general
purpose user interface*.  Thi exists for backup/restore utilities to
do things like restore ACLs and security labels simply by treating
them as opaque xattrs.  If a user sets ACLs using this low level
"opaque xattr" method, then they get to keep all the broken bits to
themselves.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
