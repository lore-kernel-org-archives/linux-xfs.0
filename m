Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2EE36EAB0
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 04:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791261798; cv=none; b=TtsR6v9/Wlpo8Y1FP206iuoToQpHO6WAG8PDWtazLamq+wtIxInYkHAy1zVO8umCGDK6gYCbRDrzI0VGd2aNGlmM/Xp2w/dRmmSYMbn4d+nlVxA9OD+hW2zH3/CIWg6z7r+EnN54RSzD/F9umQnBrp7z8fy099YNYsRGc5AS79I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791261798; c=relaxed/simple;
	bh=6D25wBHdJG07xicdIINjhi5gCDRlnE5NBKYUefPKBcA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bdx4d4uiQxeYnLDzL6eIGkmK/cIdCAmeDucRObTNTgYQbCmwpq9PmFu74TBJFK4BuV+I0w+hEStYHq5MXuUMTj/Y43bzDxRAKq03EVKOJMxmmwa42ZT3wWWCF2zU8fz4/+rXgSIggvXrSC14LV1w62TefO/unOZXPnnxoP6mjuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5Qi84Jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5Qi84Jr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15889C4AF0B
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 04:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791261798;
	bh=6D25wBHdJG07xicdIINjhi5gCDRlnE5NBKYUefPKBcA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=K5Qi84JrRlUSoHDDyTuOSufiLLr9CoUltRHubRZl6AtopjyRscS4RuCTq6GYZEPxa
	 HM9y4SHyMl7Q3D3aKJTHiS6Tt+LfMyrRJMqvK3pQFh3uGT7upb2zgIJ0eZwzDoGp7P
	 uC5Pmz7qUr+VDehtPpRgVqyGo/Z1Li5HsHek7yYQ6WUzZH43sWTi5GvRfOacFJdmFO
	 FUbQrRTsPuWWpCioSV2I/PzJhqX9O3MCPYmYv0QIYen4cIvMzTnFCfjZdUJ08xS74T
	 oYzf62D5PUX0IhqWocOjTh4NUy7SOL3dic7NQxOoEGghyeocy6QD69Wn+JpVpjLSEN
	 IKJQjlZvYIWog==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EF319C53BC9; Tue,  6 Oct 2026 04:43:17 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Tue, 06 Oct 2026 04:43:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222081-201763-hnRQhz5nkp@https.bugzilla.kernel.org/>
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

--- Comment #5 from Darrick J. Wong (djwong@kernel.org) ---
Could you capture a metadump of the affected filesystem, please?

I couldn't reproduce it on upstream 7.3-rc6 and nobody's responsible for
QA'ing 6.18 so there's little to work from, I'm afraid.

--D

On Wed, Sep 30, 2026 at 08:24:33PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D222081
>=20
> --- Comment #4 from sachse@gmx.net ---
> Note: Creating the the filesystem with "parent=3D0" the crash not occurs.
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
