Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715441514DD
	for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2024 12:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719577293; cv=none; b=A9NJKAm2yNO+0tZb71S0cAv0H5JAobqpDfi04R+fK7ZunGIMzh7rUmoFXo3KCtRjvCSWcwenjyR86pkuCS+Emx0cXdn6GocJejXpEVQfzcAWI7HeFkBWmD7vd9D4Ot0J4Fe0DZwaFpw0ZiPTifwjVprK7MeAg735v5Ld5Aes+vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719577293; c=relaxed/simple;
	bh=l3UuQ/Xs7mMBfFP6McRp76NZQKDtnUD27WD2nH+H6zA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gGGd6DYtxpcInUA5yke4ER86ICokVzaHsIREp1JuKv6afs+exqorteDIBuW29ndjN3y8KnCTKLj8l82zavn6qlYFGR9OTIHl82EsVWCqAOloCgWJMre3o1GkXrsZvf8wVSjZ/VkY30b1hIfRiyMsJTaV0XD/Q74h/iDM62HnOH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iel0dnSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iel0dnSr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9C39C4AF0D
	for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2024 12:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719577291;
	bh=l3UuQ/Xs7mMBfFP6McRp76NZQKDtnUD27WD2nH+H6zA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iel0dnSrQ8xA4aluWBNBCTod5chGd/VuRJUUrO23RC9xMKECjlSIU65XLK4I3Aim3
	 nc+DyNPABGyg4Oc/MmXr0aX2EMBAWmuiR28qcm5svHGi0hXeOXaDtJeIRSAPQQiRNm
	 7jAhoc0qyX6xADgY3NcXIzixnDPixTKlXgtzkXnhFBxCXUXGgFGqdwq4055rqdvMd4
	 dwZBJ1PESxERct6Ang1iYQR6VvNla+j+Bx4IQIveCQ3rk4MSDTi/w1xr9PdxdcEtXN
	 MjpC6BSUKFYHSAxKADgSLWej5aZODCtmuhRh6r7gWtIo1WDbQTL/oxKCpaWvshy5Z2
	 ZMltenPfOe04A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D16A8C53B73; Fri, 28 Jun 2024 12:21:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 215851] gcc 12.0.1 LATEST: -Wdangling-pointer= triggers
Date: Fri, 28 Jun 2024 12:21:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: laraditta691@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215851-201763-IbijtebOTT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215851-201763@https.bugzilla.kernel.org/>
References: <bug-215851-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D215851

LinnDa (laraditta691@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |laraditta691@gmail.com

--- Comment #3 from LinnDa (laraditta691@gmail.com) ---
(In reply to Dave Chinner from comment #1)
> On Mon, Apr 18, 2022 at 08:02:41AM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D215851
> >=20
> >             Bug ID: 215851
> >            Summary: gcc 12.0.1 LATEST: -Wdangling-pointer=3D triggers
> >            Product: File System
> >            Version: 2.5
> >     Kernel Version: 5.17.3
> >           Hardware: All
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: XFS
> >           Assignee: https://myteamz.co.uk/linnworks/
> >           Reporter: Erich.Loew@outlook.com
> >         Regression: No
> >=20
> > Date:    20220415
> > Kernel:  5.17.3
> > Compiler gcc.12.0.1
> > File:    linux-5.17.3/fs/xfs/libxfs/xfs_attr_remote.c
> > Line:    141
> > Issue:   Linux kernel compiling enables all warnings, this has consequn=
ces:
> >          -Wdangling-pointer=3D triggers because assignment of an address
> >          pointing
> >          to something inside of the local stack=20
> >          of a function/method is returned to the caller.
> >          Doing such things is tricky but legal, however gcc 12.0.1
> complains
> >          deeply on this.
> >          Mitigation: disabling with pragmas temporarily inlined the
> compiler
> >          triggered advises.
> > Interesting: clang-15.0.0 does not complain.
> > Remark: this occurence is reprsentative; the compiler warns at many pla=
ces
>=20
> The actual warning message is this:
>=20
> fs/xfs/libxfs/xfs_attr_remote.c: In function =E2=80=98__xfs_attr3_rmt_rea=
d_verify=E2=80=99:
> fs/xfs/libxfs/xfs_attr_remote.c:140:35: warning: storing the address of
> local variable =E2=80=98__here=E2=80=99 in =E2=80=98*failaddr=E2=80=99 [-=
Wdangling-pointer=3D]
>   140 |                         *failaddr =3D __this_address;
> In file included from ./fs/xfs/xfs.h:22,
>                  from fs/xfs/libxfs/xfs_attr_remote.c:7:
> ./fs/xfs/xfs_linux.h:133:46: note: =E2=80=98__here=E2=80=99 declared here
>   133 | #define __this_address  ({ __label__ __here; __here: barrier();
> &&__here; })
>       |                                              ^~~~~~
> fs/xfs/libxfs/xfs_attr_remote.c:140:37: note: in expansion of macro
> =E2=80=98__this_address=E2=80=99
>   140 |                         *failaddr =3D __this_address;
>       |                                     ^~~~~~~~~~~~~~
> ./fs/xfs/xfs_linux.h:133:46: note: =E2=80=98failaddr=E2=80=99 declared he=
re
>   133 | #define __this_address  ({ __label__ __here; __here: barrier();
> &&__here; })
>       |                                              ^~~~~~
> fs/xfs/libxfs/xfs_attr_remote.c:140:37: note: in expansion of macro
> =E2=80=98__this_address=E2=80=99
>   140 |                         *failaddr =3D __this_address;
>       |                                     ^~~~~~~~~~~~~~
>=20
> I think this is a compiler bug. __here is declared as a *label*, not
> a local variable:
>=20
> #define __this_address ({ __label__ __here; __here: barrier(); &&__here; =
})
>=20
> and it is valid to return the address of a label in the code as the
> address must be a constant instruction address and not a local stack
> variable. If the compiler is putting *executable code* on the stack,
> we've got bigger problems...
>=20
> We use __this_address extensively in XFS (indeed, there
> are 8 separate uses in __xfs_attr3_rmt_read_verify() and
> xfs_attr3_rmt_verify() alone) and it is the same as _THIS_IP_ used
> across the rest of the kernel for the same purpose. The above is the
> only warning that gets generated for any of (the hundreds of) sites
> that use either _THIS_IP_ or __this_address is the only warning that
> gets generated like this, it points to the problem being compiler
> related, not an XFS problem.
>=20
> Cheers,
>=20
> Dave.

Does the gcc warns here?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
