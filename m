Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AD3136994
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 17:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708018132; cv=none; b=cyqSBOMXL+DVga5bs1/pTIU7JN6Z5yOrmpNFhIHMz73fwzN/pmytvF4iQujgbiYeReL5RZCYloV7yG5NsOFiTiSUNlvWpdzoVykxH2ZEWhMnQne+Qy0J5i5MsFuozsSxYH1VBUPV598PeaoJRlw496wYvsEKR4FY+iEKmk3wdWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708018132; c=relaxed/simple;
	bh=t2nuBDSOvY4Ep4yXczLWd5xI0u/25QiBM0FtjCJ1Dz8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kAzLeBGSYhMfraDZr5pZhTgDdSeNqEZSve5ezAUG9CQOAD0v+1wuOWFCbecH5dUR4pSv+H8DF1Cd+01K29SCoKaw6xbx8dgyb85sWlaWm3NwyF2jCbUOzxoXz/ZXlhegVDB6oG+a91pZ2wHfOQC1B1DPL4/neVQzY3vLyzGoB18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UC3veoec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UC3veoec"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FBE2C433A6
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708018132;
	bh=t2nuBDSOvY4Ep4yXczLWd5xI0u/25QiBM0FtjCJ1Dz8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UC3veoecbLVXVfTuf91JyiKD9F0iqOjYVcDbCt1S+TPDEwLkUZBzT4bdZmh4euCfd
	 dlGVjDUqZeKfiKS8GHpcJU0BJLuswPyi+VtFO0dyR5PyaAjvWOMqgr5z9UrGNR8YWM
	 p9CHPzdXrJjduSoxgZG7/ZHXhcv44hN13Fj3ZUV7HuxI8f6ShyEw3rSjVAJJSTaP90
	 45rbmzJkJuSFozxGGQrivuNOVOdlvSOgA/6LqL1+YlYy7GdiLba8f+Oi5RYtVFUdge
	 P/gRWXRR3Zf5Sk3UrSdvepwxr5Tg/EWD+HKF+eo//GjPoQOe0pkSzh5sG7LOWnriiM
	 +TDky31QNPg+g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3F336C53BD0; Thu, 15 Feb 2024 17:28:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218229] xfstests xfs/438 hung
Date: Thu, 15 Feb 2024 17:28:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218229-201763-2Yb4HvFzQX@https.bugzilla.kernel.org/>
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
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #3 from Luis Chamberlain (mcgrof@kernel.org) ---
I've confirmed this issue is no longer present on v6.8-rc2.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
