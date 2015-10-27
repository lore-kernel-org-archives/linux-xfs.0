Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A3677F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 17:38:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B31530404E
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 15:38:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	deiApMy5B3GoKylz for <xfs@oss.sgi.com>;
	Tue, 27 Oct 2015 15:38:15 -0700 (PDT)
Date: Wed, 28 Oct 2015 09:38:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
Message-ID: <20151027223814.GN19199@dastard>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
	<20151024152254.GA22232@bfoster.bfoster>
	<20151026213228.GI8773@dastard>
	<CAHc6FU68MYTGWKM5S14_dQBqXeebd2GwQcKj4RztLvPWL2eksA@mail.gmail.com>
	<20151027053045.GL8773@dastard>
	<CAHc6FU4ZgJDKphScucvDfEWPFFu4dGfDVund9Wrah=X-vxnz3w@mail.gmail.com>
	<20151027201825.GO8773@dastard>
	<CAHc6FU4dXfXyTBW2GgckeqaLGuUwney32orV6=M8VA+ix5h1Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU4dXfXyTBW2GgckeqaLGuUwney32orV6=M8VA+ix5h1Uw@mail.gmail.com>
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

On Tue, Oct 27, 2015 at 10:39:51PM +0100, Andreas Gruenbacher wrote:
> On Tue, Oct 27, 2015 at 9:18 PM, Dave Chinner <david@fromorbit.com> wrote:
> > Further, user namespaces are irrelevant here - you can't run
> > xfsdump/restore outside the init_ns.  xfsdump requires access to the
> > handle interface, which is unsafe to use inside a user ns because it
> > allows complete access to any inode in the filesystem without
> > limitations. xfs_restore requires unfettered access to directly
> > manipulate the uid/gid/security attrs of inodes, which once again is
> > something that isn't allowed inside user namespaces.
> >
> > Setting Posix acls by directly poking the on-disk attr format rather
> > than going through the proper kernel ACL namespace is not a *general
> > purpose user interface*.  Thi exists for backup/restore utilities to
> > do things like restore ACLs and security labels simply by treating
> > them as opaque xattrs.  If a user sets ACLs using this low level
> > "opaque xattr" method, then they get to keep all the broken bits to
> > themselves.
> 
> Any process capable of CAP_SYS_ADMIN can getxattr and setxattr those

CAP_SYS_ADMIN = enough rope to hang yourself.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
