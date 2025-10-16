Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C44BDDD2
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 04:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760589528; cv=none; b=jcxk1xbWTSxBDYDu9Ehc/DDzFYUZMqpr7oN7lp1dyNqZf5V/AtGRerHIFJGT/K/tin7HmD3n5nJtlYFdECyZ7bQEKTDdoVntac0ZWSKMcznM387AeCjBgslyg/X0oQAVxFc3bfY2ccC47Qq9TAFOeWmpew5MxG82s9LjBP3nWAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760589528; c=relaxed/simple;
	bh=Fsjl7nFWlgXz9erICS7phdlCBrrUoaty9cXc29zBYEk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U/uTb/MpRFN/xUtw49w4YvYjq/HCDr/3rJteuae0H0Iiqu1aOhja/dRAkgmM0iJCGDRObTJfES3aju3a+2uCCJFHC5ZsPP+sfRjhGmI+eQz17AYLiy9HhuYzdydokE2GhKk98Lhe8ONMU0FCzYFOBWhpvqlRTyMtpI/os9zOT90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHG0TeCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHG0TeCi"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22386C4CEFB
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 04:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760589528;
	bh=Fsjl7nFWlgXz9erICS7phdlCBrrUoaty9cXc29zBYEk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fHG0TeCiVLXkIxOITfSFKoF7ZO9VFSYtH/JVKm7OJqOArR32iiOw3L14P7vJmsZ9j
	 MXR/Xa3Lb9rRFAheX/A7p6RD8SrBnaYXIW3f9TBlrleoxFeKOPeWBw5wkUhEoCjUPm
	 iyUPr41l2puHGcJCKmmFg9Bpq7OMKt/7o8jcBnydo3x+FXIlc9jUEFIz60eLzl2+EK
	 FMn9POYMHuaAEieH8/uQdP8zGe1lJL8/dnknTzzYrp1tQGio21cI3EXoVZlCplFsIX
	 nd2JbUf3LY05LwHZZNnCh6H4jtjyWsy/xJoXTu82Mr8X5/Q30ftFmenFlbRXjthbcx
	 ZU23eqp/i/AEg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1DC82CAB781; Thu, 16 Oct 2025 04:38:48 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 220669] Drive issues cause system and coredump and reboot
Date: Thu, 16 Oct 2025 04:38:47 +0000
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
Message-ID: <bug-220669-201763-gOMPxuSgDN@https.bugzilla.kernel.org/>
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

--- Comment #2 from Dave Chinner (david@fromorbit.com) ---
On Thu, Oct 16, 2025 at 12:10:43AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D220669
>=20
>             Bug ID: 220669
>            Summary: Drive issues cause system and coredump and reboot
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: bshephar@bne-home.net
>         Regression: No
>=20
> We have a number of drives across our clusters that don't present as fail=
ing,
> but seem to have read errors that cause the system to coredump and reboot.
> Failing drives is obviously not the fault of XFS, but my expectation woul=
d be
> that it doesn't completely cause the system to hang and need to reboot.

Fixed upstream a couple of months back by commit ae668cd567a6 ("xfs:
do not propagate ENODATA disk errors into xattr code"). You'll need
to raise a distro bug (Rocky Linux) to get them to back port it for
you.

Please close this bz.

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
