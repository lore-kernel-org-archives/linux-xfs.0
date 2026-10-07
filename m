Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5127C38E8D8
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 15:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791385861; cv=none; b=WchT01kMOdGDCM59umRF9InUi1EQepbvMvZlxqDgRDSDKz+Z5KtvFa0nLMQyGms5DNTkpYeYhzWchXm6zzWhe23qR8H7VemNUyTsAF2QaLUB1MOKpH+t2Qfci2ety+21X/wwNJGMqAJd12vJ/Uij/czZYELc+8halRd2EEfjkT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791385861; c=relaxed/simple;
	bh=Ep89SNasS6nZLfGXcPvKRXKnX7fZAAzg0ccWyyY3EiY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pOJeTGRO9lYiaxTltlw2K0DHVB8gt5b9WkSQGjnXDKJnC0Ukoj/pzm0RajxCoZswtjAHyjsg7xWHQKKeROiGUxvD/gMhxoiL2WmAHmK/Kwr+vcxhRgsgZ9/uOyZqUjqIKlU4mk2Hltu6RZGGxS37hC89tLiwtqhWPgQYTfCbsTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iDsIcEZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iDsIcEZU"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D572EC2BCFB
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 15:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791385860;
	bh=Ep89SNasS6nZLfGXcPvKRXKnX7fZAAzg0ccWyyY3EiY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iDsIcEZU5hOlk1ttYpNmulVKVJ1l02MlPjcTq7zPcQPEukf3KDI8xYt+0k+FRnHis
	 FUIDBSENelorIfZP2bDLv/s8WtETWK17jyEx+v1leWaQH1pB/ypzznDc3nG77/dYia
	 89JO05oHaVZnhVoHPpjgZJyZmcnZ+IkF58U14pQ8/dUV+CkhGytirKogq6ETdnOPiZ
	 cBk2vJjHb+J1OtxcCrECzTOTXAfHyI/5avS/4npE9Xz3M7EGt0//hfMK0bN84JNtrB
	 Wn0+3mz5yF/RzL1e2hU/A9uzXn4HpXGWaLJs3beBsC4TtS5Erz2Xbo9+if/0mPR5pX
	 5cHFDlAxPMw+Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C164DC41616; Wed,  7 Oct 2026 15:11:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Wed, 07 Oct 2026 15:11:00 +0000
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
Message-ID: <bug-222081-201763-51xh1yYIUo@https.bugzilla.kernel.org/>
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

--- Comment #7 from Darrick J. Wong (djwong@kernel.org) ---
On Wed, Oct 07, 2026 at 07:50:37AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D222081
>=20
> --- Comment #6 from sachse@gmx.net ---
> The crashed filesystem no longer exists because its a productive system w=
hich
> must be fixed fast.
> From the current running filesystem I can create it if you provide me the
> commands.

# xfs_metadump -a -g -o /dev/sdXX /tmp/brokenfs.metadump
# zstd -9 /tmp/brokenfs.metadump

--D

> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
