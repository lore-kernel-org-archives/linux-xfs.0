Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A552A939
	for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2024 02:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707790445; cv=none; b=fSiPBfKkVa64xWYbiClfFzgJTWqZVZirxL7u5qrzHwzTdvOrcRPKzoAgznCZzwNJcJaxoLZjaDI3DvVZHknGJb17l5EZ1ktCHGRuW7h6jdN65e89XoIK/ku7UG87b6MlbecLbEtuU+k3AQOVfvzBOzo/QZZyn5FCuEdIjQNmHAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707790445; c=relaxed/simple;
	bh=d2O6Myb6JgQ0XVcIlfGxansx398OkKLnKKmKweEgkAk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kx8YZDeIeVhw0vmPvlfyqnISU2udA0FGKUkttgfMtZf9SZLD70s4VVz6UdGRJh4Dc/pDOKNvyyylgbHigOdc5KRakEkJkEi1xiOZt1mpLyaITHXLTDV4VnL1PnqiZzG7qxKPYQNj1YFZyfoTtgzzc0ghZ2dXGwkbufyR/A7BU0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6zTCdRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6zTCdRb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9480AC433A6
	for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2024 02:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707790444;
	bh=d2O6Myb6JgQ0XVcIlfGxansx398OkKLnKKmKweEgkAk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=j6zTCdRbSL3qF3bFSXMr7UeSPTz2czr5h4RTvXTRZt/4KqrR2fFJD/TLy/zi8KNxk
	 7TgZ77BVcfJJ/O6fgR5rns/vp5bK65u7prqNnQbwNYEZZxM6aPhOLuz1Y69G2ven5i
	 AzDXLUGY4ui9/jBSWfCG1n/pLasaE8iXh7SHYp3CxgJAXbk7DbGS1eZKe9QTjs9J3b
	 OoGMd3O5GoQDupcupQdWGtwGM93v2BznHydETx8g9p7JKXxcWTp/KpRjDxKud1wZX+
	 3TQvZ8qpdPLLPZjK9kUc36G+q3MuUYzdDY4F8O4/PretCS4jBYJhgEsRzBKpe8mxgr
	 NvxkcJkNI8Z9w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 83FFFC53BC6; Tue, 13 Feb 2024 02:14:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218229] xfstests xfs/438 hung
Date: Tue, 13 Feb 2024 02:14:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218229-201763-iT5TUfS5mM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218229-201763@https.bugzilla.kernel.org/>
References: <bug-218229-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218229

Luis Chamberlain (mcgrof@kernel.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mcgrof@kernel.org

--- Comment #2 from Luis Chamberlain (mcgrof@kernel.org) ---
That's commit 471de203 3dd ("xfs: up(ic_sema) if flushing data device fails=
")
merged on v6.7-rc2, I'm not seeing the issue on v6.8-rc2.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
