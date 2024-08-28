Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E6715C0
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 00:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803834; cv=none; b=rACR6meMk/ToL/BgENKvDXFXvAXBkdf++kPsiEas6UWYdZmuHQ4KIudi+7LQATthMvWTFtOlXDaMyIngLUy134iWnlfDUKs528zj4vXXT682LvVSXTTFHG7yEd+9nH0LwePxoaNY9K68XwbUkqD9Rgc2rS1HThniKQ4uSgz3zno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803834; c=relaxed/simple;
	bh=DttySCtIrlLJ4FcT+TbCXQ0pzwU5+F5SJ0NakZ3N5G0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EVbBTIrcVk21IAxCeZGCa0bmBE5MCPqEL3DTu2pG72Z5rIkELb+3kCmRMdrwwgUMqTTv+yFoyTKFO57CcaGQyhafdASs9dRRx+QCAU5on8UaVWE7tCK5DRUkKOFyOhx8tnUKSPJWGco8IRTjj7U+jD+T4Hwo2vMSF5cxfPVHMfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jL3b4IwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jL3b4IwB"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EB3CC4DDE0
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 00:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724803833;
	bh=DttySCtIrlLJ4FcT+TbCXQ0pzwU5+F5SJ0NakZ3N5G0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jL3b4IwBidUfNCmR+gpN+XfYUGBOwk95dHIjT4KYXuQFnT6vkzBE8ODVbQZqoQO3P
	 fOcDXHTGYItVAqplD3RuudahzeBJB3p3BqO+X0X5hZ9qrqXQ+KrFNys9so8EhcONPs
	 A5N+qq+Oje8E/EOWqvyZ1sMSbTNMd2Hvj57EFOs+DBJlzGIdb58ISALtKx8uPskJEy
	 SMijMdUfg4qPrQ2nU5UK2D6CEyINBfmo/eUoxrAI+ngtK/35aNkAIb8wEkhM9m+HXO
	 +7OlUonDLgJc4ZKEgc4k8grpTPdWSjI7eWlgsQ/o+NtYT7OVS4DQzokfKZuJd421qp
	 ueYm8xumAKF+w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 76D61C53BC0; Wed, 28 Aug 2024 00:10:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219203] xfsprogs-6.10.0: missing cast in
 /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec) causes error in C++
 compilations
Date: Wed, 28 Aug 2024 00:10:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219203-201763-PNOecMFymz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219203-201763@https.bugzilla.kernel.org/>
References: <bug-219203-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219203

--- Comment #4 from Dave Chinner (david@fromorbit.com) ---
On Tue, Aug 27, 2024 at 03:30:52PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 28, 2024 at 07:40:15AM +1000, Dave Chinner wrote:
> > On Tue, Aug 27, 2024 at 09:07:03PM +0000, bugzilla-daemon@kernel.org wr=
ote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D219203
> > >=20
> > >             Bug ID: 219203
> > >            Summary: xfsprogs-6.10.0: missing cast in
> > >                     /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec)
> > >                     causes error in C++ compilations
> > >            Product: File System
> > >            Version: 2.5
> > >           Hardware: All
> > >                 OS: Linux
> > >             Status: NEW
> > >           Severity: normal
> > >           Priority: P3
> > >          Component: XFS
> > >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> > >           Reporter: kernel@mattwhitlock.name
> > >         Regression: No
> > >=20
> > > C allows implicit casts from void* to any pointer type, but C++ does =
not.
> Thus,
> > > when including <xfs/xfs_fs.h> in a C++ compilation unit, the compiler
> raises
> > > this error:
> > >=20
> > > /usr/include/xfs/xfs_fs.h: In function 'xfs_getparents_rec*
> > > xfs_getparents_next_rec(xfs_getparents*, xfs_getparents_rec*)':
> > > /usr/include/xfs/xfs_fs.h:915:16: error: invalid conversion from 'voi=
d*'
> to
> > > 'xfs_getparents_rec*' [-fpermissive]
> > >   915 |         return next;
> > >       |                ^~~~
> > >       |                |
> > >       |                void*
> > >=20
> > >=20
> > > The return statement in xfs_getparents_next_rec() should have used an
> explicit
> > > cast, as the return statement in xfs_getparents_first_rec() does.
> > >=20
> > > --- /usr/include/xfs/xfs_fs.h
> > > +++ /usr/include/xfs/xfs_fs.h
> > > @@ -912,7 +912,7 @@
> > >         if (next >=3D end)
> > >                 return NULL;
> > >=20
> > > -       return next;
> > > +       return (struct xfs_getparents_rec *)next;
> > >  }
> >=20
> > We shouldn't be putting static inline code in xfs_fs.h. That header
> > file is purely for kernel API definitions. Iterator helper functions
> > aren't part of the kernel API definition - they should be in some
> > other exported header file if they are needed at all. The helpers
> > could be defined in the getparents man page in the example code that
> > uses them rather than exposing the C code to the world...
> >=20
> > I note that we've recently added a static inline function type
> > checking function to xfs_types.h rather than it being an external
> > function declaration, so there's more than one header file that
> > needs cleanup....
>=20
> XFS has been exporting tons of static inline functions via xfslibs-dev
> for ages:
>=20
> $ grep static.*inline /usr/include/xfs/ | wc -l
> 103

Yes, but have you looked at what they are?

$ grep -Rl static.*inline /usr/include/xfs/
/usr/include/xfs/linux.h
/usr/include/xfs/xfs_arch.h
/usr/include/xfs/xfs_da_format.h
/usr/include/xfs/xfs_format.h
/usr/include/xfs/xfs_fs.h
/usr/include/xfs/xfs_log_format.h
/usr/include/xfs/xfs_types.h
$

The platform functions (linux.h) are explicitly
shipped as static inlines to avoid needing a compiled library to
use.

The byte swapping (xfs_arch.h) is a mess of macros and static
inlines that have no external dependencies. They are simply byte
swapping functions.

The on-disk format headers contain some helper functions. We try to
keep them out of htose headers because of the wide includes they get
in kernel and that creates header dependency hell. Hence the only
static inline code in them allowed is code that only uses structures
already specifically defined in the on-disk format header functions.
This avoids the dependency hell that these foundational header files
might otherwise create.

Further, they have nothing to do with the actual kernel API or
fundamental XFS type definitions, so very few applications are
actually using these header files. Hence it's not critical to keep
code out of them, and we -never- care if they fail to compile with
c++ compilers because they are aren't for general application
usage....

That leaves xfs_fs.h and xfs_types.h:

$ grep static.*inline libxfs/xfs_fs.h libxfs/xfs_types.h
libxfs/xfs_fs.h:static inline uint32_t
libxfs/xfs_fs.h:static inline struct xfs_getparents_rec *
libxfs/xfs_fs.h:static inline struct xfs_getparents_rec *
libxfs/xfs_types.h:static inline bool
$

There are -four- functions in 6.10, up from 2 in 6.9. These 2 new
helper functions are the source of the problem. IOWs, our general
rule to keep code out of these two files has largely worked over the
years...

> And the kernel itself has been doing that for years:
>=20
> $ grep static.*inline /usr/include/linux/ | wc -l
> 348

Direct kernel uapi header includes are a different issue and the
policy for them is not in our control at all.

> ...most of which don't trip g++ errors.  This was the first thing that
> broke a build somewhere, because neither the kernel nor xfsprogs use
> the C++ compiler.
>=20
> Shouldn't code review have caught these kinds of problems? Why wasn't
> there any automated testing to identify these issues before they got
> merged?  How many more guardrails do I get to build??

We've used the "no code in xfs_fs.h and xfs_types.h" rule to avoid
these problems in the past. The whole point of xfs_types.c existing
is to provide a location for type verifier code that isn't
xfs_types.h. The verification code has dependencies on xfs_mount,
xfs_perag, etc, and we simply cannot put such code in xfs_types.h
because it creates circular header file dependencies.

IOWs, xfs_fs.h and xfs_types.h are foundational definitions for both
kernel and userspace code. Adding static inline code into them leads
to external header dependencies, and that is something we have
always tried our best to avoid.  Hence the general rule is no static
inline code in these header files.

Clearly this was missed in review - it's a tiny chunk of code in the
massive merges that have recently occurred, and so it's no surprise
that little things like this get missed when reviewing tens of=20
thousands of lines of new code.

> Or: should we add a dummy cpp source file to xfsprogs that includes
> xfs.h so that developers have some chance of finding potential C++
> errors sooner than 6 weeks after the kernel release?

Put whatever thing you want in place to catch header compilation
issues in userspace, but the basic, fundamental principle is that no
static inline code should be placed in xfs_types.h and xfs_fs.h.

> So far as I can tell, this fixes the c++ compilation errors, at least
> with gcc 12:
>=20
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 0613239cad13..8fc305cce06b 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -971,13 +971,13 @@ static inline struct xfs_getparents_rec *
>  xfs_getparents_next_rec(struct xfs_getparents *gp,
>                         struct xfs_getparents_rec *gpr)
>  {
> -       void *next =3D ((void *)gpr + gpr->gpr_reclen);
> +       void *next =3D ((char *)gpr + gpr->gpr_reclen);
>         void *end =3D (void *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);
>=20=20
>         if (next >=3D end)
>                 return NULL;
>=20=20
> -       return next;
> +       return (struct xfs_getparents_rec *)next;
>  }

Sure, that fixes the compilation problem, but that's not the bug
that needs to be fixed. This code should not have been added to this
file in the first place.

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
