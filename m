Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3562mqd221063 for <xfs@oss.sgi.com>; Tue, 5 Apr 2011 01:02:48 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BE12B6EE05
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2011 23:06:01 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	uUMFtRoIksocITbA for <xfs@oss.sgi.com>;
	Mon, 04 Apr 2011 23:06:01 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.72)
	(envelope-from <david@fromorbit.com>) id 1Q6zOo-0001kr-7A
	for xfs@oss.sgi.com; Tue, 05 Apr 2011 16:05:58 +1000
Date: Tue, 5 Apr 2011 16:05:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix variable set but not used warnings
Message-ID: <20110405060558.GA31057@dastard>
References: <20110404125544.GA726@infradead.org>
	<1301941280.2630.61.camel@doink>
	<20110404235226.GC31675@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110404235226.GC31675@twin.jikos.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Tue, Apr 05, 2011 at 01:52:27AM +0200, David Sterba wrote:
> Hi,
> =

> I've seen this one too and I think this may not be a trivialy removable o=
ne, at
> least not without some analysis.

Sure.

Background: the quotaon syscall on XFS can only change whether
quotas are enforced or not in XFS. It can't switch quotas on at
all because that has to be done at mount time. Switching quotas on
at mount time sets the appropriate flags in the superblock, so we
can always rely on a superblock flag check for whether accounting
is enabled or not.

> On Mon, Apr 04, 2011 at 01:21:20PM -0500, Alex Elder wrote:
> > > Index: linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux-2.6.orig/fs/xfs/quota/xfs_qm_syscalls.c	2011-04-03 06:40:45=
.399789765 -0700
> > > +++ linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c	2011-04-03 06:43:00.2197=
82939 -0700
> > > @@ -313,14 +313,12 @@ xfs_qm_scall_quotaon(
> > >  {
> > >  	int		error;
> > >  	uint		qf;
> > > -	uint		accflags;
> > >  	__int64_t	sbflags;
> > >  =

> > >  	flags &=3D (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
> > >  	/*
> > >  	 * Switching on quota accounting must be done at mount time.
> > >  	 */
> > > -	accflags =3D flags & XFS_ALL_QUOTA_ACCT;
> > >  	flags &=3D ~(XFS_ALL_QUOTA_ACCT);
> > =

> > Unrelated, but isn't the effect of this line plus the one a few
> > lines up the same as this?
> > =

> > 	flags &=3D XFS_ALL_QUOTA_ENFD;
> =

> yes it its, but then why was the separate accflags there? That's why I'm =
not
> sure it should go away so easily.

It's dead, Jim.

>From the historical XFS archives, the accflags were used when the
root filesystem was special and quota accounting for the root
filesystem was not done at mount time. That was removed in late
2002:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Darchive/xfs-import.git;a=3Dcommit=
;h=3D3e01b37c1ba0a3839956660b78e09a17ac5ff67b
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Darchive/xfs-import.git;a=3Dcommit=
diff;h=3D3e01b37c1ba0a3839956660b78e09a17ac5ff67b

so accflags has been unused for almost 10 years. I've gone through
quite a bit more of the history, but th=E6t commit it the key one.

> and not only this, a few lines below:
> =

>         if (((flags & XFS_UQUOTA_ACCT) =3D=3D 0 &&
>               ^^^^^^^^^^^^^^^^^^^^^^^

The above commit should have removed these checks are they were not
needed anymore.

> =

>             (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) =3D=3D 0 &&
>             (flags & XFS_UQUOTA_ENFD))
>              ^^^^^^^^^^^^^^^^^^^^^^^

And those are the checks that are meaningful.

> The code is there since ages so I wonder whether anybody hit this bug or
> if I misunderstood xfs/quota documentation.

Not a bug. Crufty, yes, but functioning correctly.

> Besides, there are more cleanups and fixups in this function:
> =

> line 331:
>         /* No fs can turn on quotas with a delayed effect */
> 	ASSERT((flags & XFS_ALL_QUOTA_ACCT) =3D=3D 0);
> =

> seems to be broken too:
> * the acct flags are masked out -> always asserts true
> * doing s/flags/accflags/ does not make sense

No, that makes perfect sense given the commit above. We use ASSERT()
statements to document constraints and assumptions in the code, and
that is exactly what this does....

> I'd like to ask maintainers to be cautious when accepting these
> simply looking cleanups, they may actually hide bugs.

Well, yes. that's why we have a relatively strict review process -
the reviewer needs to check stuff like this, not just blindly trust
the person who wrote the code did it. That's the essence of the
meaning of the Reviewed-by tag we throw around all the time - it's
not just a rubber stamp.

Indeed, it's not uncommon for me to spend hours doing this sort of
analysis when reviewing complex changes, and all you might see on
the mailing list is (maybe) a short comment accompanying a
Reviewed-by tag....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
