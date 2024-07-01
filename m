Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31753D3BC
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719845961; cv=none; b=EU3ZrhpIOUytxatIIsDpTuzxJKunM8L2GBv3or1LNC3/8+3CMceMoX+NjduK/vWipVvESttl3fhedObxOtR994HyGt/4gbbE0vgpTOP+qgp30yzyavf06BHf4eRJ5XASyt5wlypNrbEt3+itlEZ1E4PaLn1NDSEVmVHkt5q4+Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719845961; c=relaxed/simple;
	bh=z0n7Zr0RysJtH6l+w8iv5zpD8A4wGbIpM0cSIVXYIMo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Px1oHNHezbyLfp+qqoKMlvxuPCiA2pzANZ+98IzannujlOF0CXTy5Z42kpeBjbH8/9ExAP0GeOgBrvcqeUVr64DCBgmvAWao1nMkoc35ucjv+glRIualYb8HUYEZzdZDM4DNRlhTesJhJ5Yc1NRrJ3gcZaL2/kLwTdgWIDWfXfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8Q5rvNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8Q5rvNy"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC27FC116B1
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 14:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719845959;
	bh=z0n7Zr0RysJtH6l+w8iv5zpD8A4wGbIpM0cSIVXYIMo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=C8Q5rvNynPVp1pCEVkbErqdAfzGYh5r7Bb+urU6IBchnB4+D8vD707cyAFwERdT5S
	 fyrR0Tko62eyYTklTuH/+STpXpK2C9awFk1sGkq4rrDL6MX8QWNHpXF+LzisoUu5fj
	 D1TT8DQXf5ZonhsAo/h9zSFW52noNYrK7UEfJQj8fFZ3VOC25AIetqImBnVxCwM4Jz
	 lx/91gzubWbasv+uqM7Txx3a8fhgBjLiV1cHcxweCjqDxx8QMhMMzGgwrsuCzhBZxL
	 XevYlIGdZTJamXruQ6zuU6M4f/n+V2NDToIbfEufeMmlJWM1vRTzOIYcjcy9ypSV5x
	 FVNITTudr216Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D23C4C53BB9; Mon,  1 Jul 2024 14:59:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 215851] gcc 12.0.1 LATEST: -Wdangling-pointer= triggers
Date: Mon, 01 Jul 2024 14:59:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-215851-201763-5fLrSocnYx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215851-201763@https.bugzilla.kernel.org/>
References: <bug-215851-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D215851

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
