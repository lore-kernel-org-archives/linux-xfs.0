Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A3C36EA93
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 07:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791791938; cv=none; b=uL70lR85Ni9KWe0JBRgileS/JQFsVra6OZETb/TvE9HmRpwVJ4s6k0Tr05K3OECYgF2XCFvJKU3RCglu6mcqun0heqDAXDs0ejgPG+gW6lpaPjh2RVnPJUc27k2Od3WX4Uus1K8C0qW/PxYRKKXLSYruZYYoNocOzMXs0wP8kbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791791938; c=relaxed/simple;
	bh=w6z6lwZ+7XeluofLcaQ7xSrNgEhpjH4XTf20dUQJ+jg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WrPDvpD05F7V2IhnzJQXW+6Q9H8e9wplSqKId/viOcJJvII437zy6G3Xt8ucSQiRswBWKOwNVeE5NoFAgEUziLIfjQdNjZVxn54cDHCzi6B2aR9NwVT29/9kQ6URUnYTbwB4tspjtZgCk68nFDowvX6mIwdCeu2SK2fZ3RgupUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5uKLbei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5uKLbei"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3A53C2BCF4
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 07:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791791937;
	bh=w6z6lwZ+7XeluofLcaQ7xSrNgEhpjH4XTf20dUQJ+jg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=B5uKLbeiwToyNZ4rAVDLnZ67M1RTEoCF0HoGGQxd7UrWChmUfybL0BwFL0IRGmODw
	 OqRUIf4kMWnsuv6lksxTXCMgWQDskakJx32nHjNkhOEsb3qpprYZHAWmV8ZU1fnMDr
	 j2q2K7cif+/kJQi/F5A5kiK52d+zRht5WdzsDEJa2gdyhwYlG1hLvTPsqLwboZXRiW
	 fJQaJWf2lrijVhSgS22a+ahtIN/fUsXvuEW9JwkkiCWEJts5XdagDlfzWBJn79ObZh
	 q/nhvSURX8kinlCziQ/YreEIncpe9D7RNqgNauDJwZJh/vkWzct5Mw7FOW01E6CBOh
	 TVeKSJHdif6UQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9A443C53BC5; Mon, 12 Oct 2026 07:58:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Mon, 12 Oct 2026 07:58:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sachse@gmx.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222081-201763-4YQMWamAdD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222081-201763@https.bugzilla.kernel.org/>
References: <bug-222081-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D222081

--- Comment #8 from sachse@gmx.net ---
Is the a possibility to create the dump without filenames?
It current created dump contains to much internal data.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
