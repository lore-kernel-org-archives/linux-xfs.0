Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2482B481CD
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724800371; cv=none; b=agWpUgYg+lkvrP34pQoccfpIuZ44OustXlDKE7Stq/iRSknemRmzi6COBEwZ4oOlXtnA2HLZEwudGsW6uRIW/q4DGmE8l+/xzdhIYtmYV9B/rXhyOeYTM/o/KZrMyI/e2re3Dx5Bi7VSZk7O6hOaIaL/r2dBxkIBrYQtMoL+PKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724800371; c=relaxed/simple;
	bh=crhUPPECf8EJvlrNWQXOXXEeens1Gl2CRfqzPEE8RH4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MJqf6wKBc7/HzAtum3VSOmbVKY0d1sX5V/qxkByVmqsGu7Gdh8jJHYrC2gRUl4afp+lL5lXH0DdA/kG9voa4wu9+WBHktFWS+CsElENNYLNUBjYRa9rANvbIcJ+9OAJFVDFNihfY5r/QMXeFVBu5yRW3e4xJYkxAxPgHf+poEkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PL91/zRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PL91/zRg"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7808C4AF13
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724800370;
	bh=crhUPPECf8EJvlrNWQXOXXEeens1Gl2CRfqzPEE8RH4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PL91/zRgt8AX8WUstOMsCj/Oy7Z2dOtHWIkp2nGng54XyC1r+pGw+RACFFKonwWKx
	 Q9zmluxKF2W540q27iUCvhgG7xlNOiu/Ned07nl8gYPlxm4EY9Yn8ooLzrJGXdUZkk
	 zUzn10E/dqO+VrBjEO/HSe/fgWuW45EQtyVtxMjwPsz0cpUrvwLsPwTYosPkYWmsey
	 valtEkujvW8QmHD5r3xxWrS/EjYfswpo1WYu65j6S8To170IikpQx8aAD7vTVGO1zh
	 dSvx5aSMx0p1UgBDe1X1pR9djWLCi7DpoMo18V9OQ0fWwGfvdzUp9g+XG7Q/xw/Si8
	 kAbYMxE8pj8hQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A005DC53BC0; Tue, 27 Aug 2024 23:12:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219203] xfsprogs-6.10.0: missing cast in
 /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec) causes error in C++
 compilations
Date: Tue, 27 Aug 2024 23:12:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel@mattwhitlock.name
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219203-201763-AZs1owRnQK@https.bugzilla.kernel.org/>
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

--- Comment #3 from Matt Whitlock (kernel@mattwhitlock.name) ---
(In reply to Darrick J. Wong from comment #2)
> -       void *next =3D ((void *)gpr + gpr->gpr_reclen);
> +       void *next =3D ((char *)gpr + gpr->gpr_reclen);

G++ 14 apparently didn't care about the arithmetic on a void*. Only the cas=
t in
the return statement was necessary for libktorrent to include <xfs/xfs_fs.h>
without error. (I did not check whether the compiler emitted a warning.)
Certainly it is preferable to do arithmetic on a pointer to a type of known
size, so thanks for suggesting this other fix as well.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
