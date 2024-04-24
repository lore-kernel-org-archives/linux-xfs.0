Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3731F101F2
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929974; cv=none; b=TJcmVMmkLuzM0r2+s5Twb6vAElWtMquZqwUWd9abhDVUy3D840YLiQHY43QNI5Y//CXg0AMpgimoh8E5np5wYIYphc8zAblSzgPISFc/TWQOwK5EGCShwH/9w+wLXh+Na3lUbb7SdXUW8nhGlLVm3MAHTK+yvJbid3G/u6H3hW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929974; c=relaxed/simple;
	bh=Gd7vXeXXhFiFwAs1eStXMqr9TOtgGeZJsTi/eGCrw94=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WYn4edGnMU3LokFfAkYilqWjUM7b3s71RCWfJ30DZ+uAWqMJmxPVGkKSS5b69Xa97bHh1LM5wL9cCiu0KUputpHYFBgOIfT/RHqp6box71cK7UiE3/KjlPj94K9bLfbWD+DobXax3bn9YShtRCt3sPNQ4FWbbkBd3TubCWMgNlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLBSDLBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLBSDLBn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C540FC32786
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929973;
	bh=Gd7vXeXXhFiFwAs1eStXMqr9TOtgGeZJsTi/eGCrw94=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WLBSDLBnd1tot7g3IfA4nDbfxxNQHAwQQu6VnNiqTVAVI4L68l27rCnF7p2W3gyHi
	 ex/FmD47E4tEomDTHzfNBM2t7KNX9nBv1adPTcWmC2b/FOJMQVlipvHFwfwufEKB8J
	 nce1TFeIH0bRybddKz8owVFTxbA5wX7XNl+CTGXXosM3BGsUCAwKvWGJNWc24RzCDN
	 5y7a/WHsZAXQb/0CkiO2GCwXJeoyNo/sMFPaHeCCWUjQTttzoOi37tbAZMI+WeLsuX
	 LBxGIXEs1ZTo8Q2r4NJu2whomXcA+du8fI/X+WKingFivqQxk4UQkJdWgnQ3EGi0X6
	 BWa8X6qHI+ZEw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id BC987C53B50; Wed, 24 Apr 2024 03:39:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218764] xfs_scrub_all.in: NameError: name 'path' is not defined
Date: Wed, 24 Apr 2024 03:39:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218764-201763-ssx1qYtUga@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218764-201763@https.bugzilla.kernel.org/>
References: <bug-218764-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218764

--- Comment #1 from Darrick J. Wong (djwong@kernel.org) ---
On Tue, Apr 23, 2024 at 03:24:32AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218764
>=20
>             Bug ID: 218764
>            Summary: xfs_scrub_all.in: NameError: name 'path' is not
>                     defined
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: 60510scott@gmail.com
>         Regression: No
>=20
> Created attachment 306198
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D306198&action=3Dedit
> journalctl -b -u xfs_scrub_all.service
>=20
> `path` variable is not defined in
>
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scr=
ub_all.in#n166
>=20
>=20
> Attached is the error log of `xfs_scrub_all.service`

Working on it; there's a largeish rewrite of xfs_scrub{,_all} pending
now that the kernel part is done.  This patch should fix the problem:
https://lore.kernel.org/linux-xfs/168506075234.3746473.4940860665627249144.=
stgit@frogsfrogsfrogs/

But it might take a bit of time to get the last ~150 userspace patches
merged.

--D

>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
