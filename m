Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07A876056
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 21:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724794822; cv=none; b=ZVsx8jeDA5Jhq40HlghIZQ36xcC0krYFKxQTgZWiB3XwjaK45ngKADFsFwl/tGVQ5/L3ZfS45x9Zr0w/XptvQ+p3g8YyLBnzknwLORvMrgjzEvl5ZG1Yy2dHle23HrQw55CV3+MH1EwpcM9m/RZkIPf7TBvPSjU4RhYQKGWvfv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724794822; c=relaxed/simple;
	bh=LjC3o4R5Boz8VA3VX7b6I/4Jz0WsoK4n9/AunYcgDWA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t/+rcxGGFX5LCPcJiG1LK7khm5Qck/X0qv+vzrzQVyNFRHXYpldEWgeOgPI2PL+OZ8uXwUZeb3W+z7S0KKBYbklogC9HnchVWQhKtXdeYUIF1OpTsX90D523Xfx8KG72fd7nuCvoZwOLzbtrpx9My3VUX7RtumgQKdjGiMZVJjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+AjDlx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+AjDlx3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C0E1C4AF10
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 21:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724794822;
	bh=LjC3o4R5Boz8VA3VX7b6I/4Jz0WsoK4n9/AunYcgDWA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=D+AjDlx3j45pBBSNoFjpmHnp2yckKKaI/dxIwribHeg9lVS9ucAmK/r8gVwrXz/IQ
	 +YPwJjAz5HNjmx77evR3NxEWVZDnTf/ilSOdWYMlmFBSgkH2bXrPb1n9K91KvFB9lR
	 vBxq2n6f24VdQhZcV0tOEI3nlCrQLrwx/I+HW7CNi2rBHt8x1/wBMLxwyneqhHqtC2
	 2hE6ZR6rDaIIgdxn4qqBbfiq/XZLUJOtZtHNf5xHROgKcHi5A6/9o0XfaH24wmOZ1s
	 glAiSkmlFtGXc9M1aKsDOFiFJiXQk/rCOn/wc2lzJlGVjT0Gnl53vfwx38iuvFQqC8
	 bt/fC/+mhKzHw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 484E8C53BC0; Tue, 27 Aug 2024 21:40:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219203] xfsprogs-6.10.0: missing cast in
 /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec) causes error in C++
 compilations
Date: Tue, 27 Aug 2024 21:40:21 +0000
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
Message-ID: <bug-219203-201763-CxQ8BdFsAg@https.bugzilla.kernel.org/>
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

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Tue, Aug 27, 2024 at 09:07:03PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219203
>=20
>             Bug ID: 219203
>            Summary: xfsprogs-6.10.0: missing cast in
>                     /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec)
>                     causes error in C++ compilations
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: kernel@mattwhitlock.name
>         Regression: No
>=20
> C allows implicit casts from void* to any pointer type, but C++ does not.
> Thus,
> when including <xfs/xfs_fs.h> in a C++ compilation unit, the compiler rai=
ses
> this error:
>=20
> /usr/include/xfs/xfs_fs.h: In function 'xfs_getparents_rec*
> xfs_getparents_next_rec(xfs_getparents*, xfs_getparents_rec*)':
> /usr/include/xfs/xfs_fs.h:915:16: error: invalid conversion from 'void*' =
to
> 'xfs_getparents_rec*' [-fpermissive]
>   915 |         return next;
>       |                ^~~~
>       |                |
>       |                void*
>=20
>=20
> The return statement in xfs_getparents_next_rec() should have used an
> explicit
> cast, as the return statement in xfs_getparents_first_rec() does.
>=20
> --- /usr/include/xfs/xfs_fs.h
> +++ /usr/include/xfs/xfs_fs.h
> @@ -912,7 +912,7 @@
>         if (next >=3D end)
>                 return NULL;
>=20
> -       return next;
> +       return (struct xfs_getparents_rec *)next;
>  }

We shouldn't be putting static inline code in xfs_fs.h. That header
file is purely for kernel API definitions. Iterator helper functions
aren't part of the kernel API definition - they should be in some
other exported header file if they are needed at all. The helpers
could be defined in the getparents man page in the example code that
uses them rather than exposing the C code to the world...

I note that we've recently added a static inline function type
checking function to xfs_types.h rather than it being an external
function declaration, so there's more than one header file that
needs cleanup....

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
