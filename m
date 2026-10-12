Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3794B8DF2
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791824576; cv=none; b=h3sLDwTptvHRJ3IdqtH1Ne9leiTo3bw1SGFzOcx+JwVlX0WpK5J6fPPup7aYNJe18fTUZsM4KbcHTvraFYuqdDIJWkmWXuFRYl79P1Y1ZgGRFN38zhWIIqfulzy7F24R+5X97caDS5ZDpqxdAf4m0k7auO8T+NEwsn1rKQ0Cna0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791824576; c=relaxed/simple;
	bh=iuvgAffrsoRAsGKej3ufx+WCGoG4dWKISrV+9FAS64g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SFEawgTqVvOyFgcHYl7L+fSFuijx2VkbRQfrK1kIbRJa34jXTBSnlNxeDyq/1ylgOdymsbZn5tCL81VFIueqpLcdv8gQuUAPbMd4chztdLgPGlNwJltSSntCPEUMBJImaLhI3Bo2SvQ/f2zSMUA6+cOaU3ycgBGnC+siSoJE5AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rG6g8HOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rG6g8HOV"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6B82C2BCFD
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 17:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791824575;
	bh=iuvgAffrsoRAsGKej3ufx+WCGoG4dWKISrV+9FAS64g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rG6g8HOV1FSAx17KtH5dMXt3p0z0+riiH5Df3DkuUaOKZbohMYqjhU6F7O7uyW7Tk
	 hYLAFqYBj+LrRGaonrQwTVbLsF/BqZc8wGxcHnBVmbJiIW1/nNtw1nyGXNnvUsktMX
	 2EIFD+b/9ABnKyoclNBxMZBpmi5FU1TvHVQIzn/YuqRE7XJaUZrsJ2Rv4BlJjN5WGs
	 8vYErJyaBb01Ms0ejKSgR7Nm85uv48Mab6fMcIR3Kj0Fkhft8fHcdboHYv5vMwkuI1
	 ykZiodVhrZKBkzEZzECNbl/er7QGykQwhio/kV9RV+VqnSV2+r4UAVVQCAAhJ1Ux/N
	 to+KZ0n8r1R7g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C0304CAB780; Mon, 12 Oct 2026 17:02:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Mon, 12 Oct 2026 17:02:55 +0000
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
Message-ID: <bug-222081-201763-DYDPEb4xMn@https.bugzilla.kernel.org/>
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

--- Comment #10 from Darrick J. Wong (djwong@kernel.org) ---
On Mon, Oct 12, 2026 at 08:01:01AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D222081
>=20
> --- Comment #9 from sachse@gmx.net ---
> I found option -o, but I think you need the extended attributes.

Yes, omitting -o will obfuscate names if that's critical for being able
to share a filesystem metadata image.  It will also pick up (and
obfuscate) the xattrs, even for parent pointers.

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
