Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994E6224891
	for <linux-xfs@vger.kernel.org>; Sat, 15 Nov 2025 08:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763194382; cv=none; b=gmlt5olZbpw8pvon/Q8IcIcApMcRs3S1iXqsAuoABJFZc8jUVMSqkrbgrtumxMwfbwA6kdeOS7zOSvw/X1DNcnMXB+lOh4oZe8bynhKdE4oJnaF447gYfY5vVVIYngKNYobLmI+t6fiQCHhEOQxCHs9vlRai+VOF0N3cE1dWOYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763194382; c=relaxed/simple;
	bh=/AgaloahbkcUj0KduO2nC9vNYj4p9+/uGsu1xMhM/Gc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j2TCwv41Pphvg2YntONKKI6Fpa61TvEWNOAtXoWi8gCnsoJW0LPZG2a8umvova3cEuJNVEHW3Jvq9S/Ra4uKPMG6K+H1tSuLcAS31b8NKWMqxcvdGhhYbrPQrFMxWbSTgiT8UJdNA50mv0c1jxkPKQltp4+DDKuXjfYJNISqeIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wy+9lbHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wy+9lbHk"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26101C4CEF5
	for <linux-xfs@vger.kernel.org>; Sat, 15 Nov 2025 08:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763194381;
	bh=/AgaloahbkcUj0KduO2nC9vNYj4p9+/uGsu1xMhM/Gc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Wy+9lbHkpbOGTS7D7hr4ZnBlBKiqTlCmzQnQ/u0RCRFPE8K8+iTnSQcjg/SIjHbCJ
	 Zj65buA4zkA5cCIQlIGn1YxiZMpFPikqHoqtFmWgJ2mtHEuWJ4KJNCr9ndaZ2mRMjB
	 GpsJONkzjKFg2aBtkQOvjCvAy6aMce+7E2GIsQfALS45Evn09gLeNoLoJrKkZsAIOx
	 +oOsQ0+pB3chu7zrb2Zi4dla6I+a/TZMR3yarqaMPVwAJS8GYx03Dw5ZcwPD/KYG/p
	 pUfaH+moXBAFV8RnNGIg5nFzh1G7AiVsd8VZNWCTi5+ts3cOcJDfD/OtmjeNFwwva1
	 Nkz69ai0m3pEQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 168D6CAB782; Sat, 15 Nov 2025 08:13:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "attr2 mount option is deprecated"
 warning
Date: Sat, 15 Nov 2025 08:12:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: sam@gentoo.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-211605-201763-Gme0v3RU6m@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211605-201763@https.bugzilla.kernel.org/>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D211605

Sam James (sam@gentoo.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sam@gentoo.org

--- Comment #14 from Sam James (sam@gentoo.org) ---
See also
https://lore.kernel.org/linux-xfs/176107134023.4152072.12787167413342928659=
.stgit@frogsfrogsfrogs/.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
