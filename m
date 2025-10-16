Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096F1261B60
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 11:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760613007; cv=none; b=A/mAE27/5Sfl3VCkhEBqM0kgibwem40P3MdyduSt8jTwBcJj5N1UYyn+nOdvDgdc+Q2vJnFvId0Ymn7BxyxqJJ3E0Hz79iug7tB0ER8I5I7f33SKksZn28d1xl6RfIty5YZRc89QMiSGtc378CJHUEx0UqcazEXeq6Gt4BSgi1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760613007; c=relaxed/simple;
	bh=aJFFJqnXQPEK+ZxnaYdxjPkRZbh36+Fqus4ydD4ponI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PPxr2UyMnkAqCWvmt+mWG2otNN6F7SB3BmtInlGJhlM184vzZbwqfGMaemv5sior87jxvNPxdw2nMmRVX9UkdujD2IKEtIE2rLDbKLUrrROOFm7MPWLVkqdNFKpZgPP0+h1rOOVouIbeB3ka+sDAOWPQeBVnHTS8pzNRiEwr3l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CUV21opf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUV21opf"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75C51C116B1
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 11:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760613004;
	bh=aJFFJqnXQPEK+ZxnaYdxjPkRZbh36+Fqus4ydD4ponI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CUV21opfSV3553fnCEyw1mC6x7bk5qP26A8VBp9bdrw6bzUii9+yFsV+oRlzEOFbs
	 prYTzIRbVoVNQ7mHIdzQukZq+6ul57FmofEsaAmf8UW5VsReAGDeq4pwJO5iDI70be
	 KXd5cOZWtWsddiZa0OyAZq8L5t9wq3sul0WeBGJ4fpanv64lEmbhNaGal1fiCwZDUv
	 f3QyCn3Ukakl/BMMnV0bdS0RUQUxWAkkj24+7OtJQAmrJT8QgYWNZOfOK7ayiFRNuZ
	 m2Up5s0QfApQr82AFB0fY2BkLyxiQTaEa11H+TPYvYkvFdrIIuTh3AyZNEgGwHbfVF
	 q20CuD5AEaxtA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6A6D7C53BC9; Thu, 16 Oct 2025 11:10:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 220669] Drive issues cause system and coredump and reboot
Date: Thu, 16 Oct 2025 11:10:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bshephar@bne-home.net
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220669-201763-4Lh4Vsj7JT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220669-201763@https.bugzilla.kernel.org/>
References: <bug-220669-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220669

--- Comment #5 from Brendan Shephard (bshephar@bne-home.net) ---
(In reply to Dave Chinner from comment #2)
> On Thu, Oct 16, 2025 at 12:10:43AM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D220669
> >=20
> >             Bug ID: 220669
> >            Summary: Drive issues cause system and coredump and reboot
> >            Product: File System
> >            Version: 2.5
> >           Hardware: All
> >                 OS: Linux
> >             Status: NEW
> >           Severity: normal
> >           Priority: P3
> >          Component: XFS
> >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> >           Reporter: bshephar@bne-home.net
> >         Regression: No
> >=20
> > We have a number of drives across our clusters that don't present as
> failing,
> > but seem to have read errors that cause the system to coredump and rebo=
ot.
> > Failing drives is obviously not the fault of XFS, but my expectation wo=
uld
> be
> > that it doesn't completely cause the system to hang and need to reboot.
>=20
> Fixed upstream a couple of months back by commit ae668cd567a6 ("xfs:
> do not propagate ENODATA disk errors into xattr code"). You'll need
> to raise a distro bug (Rocky Linux) to get them to back port it for
> you.
>=20
> Please close this bz.
>=20
> -Dave.

Legend! Thanks for the pointer to the commit. I really appreciate you takin=
g a
look so quickly!

All the best

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
