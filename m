Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492024F4049
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 20:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790799874; cv=none; b=StzMBkYLTfL9AAzhjmrmxBnk2dViicRUv/YEfjAfyzqh68XS8TXALcCAIR/ecq2UKKRWYiGjbWQU2bUXh3v2YejDkfPb1jn3c6N6xq7LvQyeptLrVrvEV0qboyrErPgehBoygEmEBU+4cKWYROUdY/fASEE/lWzfc6SE4XLv62s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790799874; c=relaxed/simple;
	bh=HZDd09GJvt2KRmxIO6e+E0zELHxGszvkEmIZTkkHteA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DUqnK7DxeaJjfEg27Mb6iOct7USHWDJ3BuBPXC9idsAJ99n8HWYBsdpqr+5Ca50ctXfCH+LnH7uTJAFUJhvTPQorMiXUPLxvh9IexWW6E+lOITi/zNhq+Xk00Aes/BpPvmeNBeDm9PDM7UI5eflwdw9khOdHzVtr13ECdnJARQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxf8pI30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxf8pI30"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB329C2BCF4
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 20:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790799873;
	bh=HZDd09GJvt2KRmxIO6e+E0zELHxGszvkEmIZTkkHteA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nxf8pI30xeDjSrniOEwuEEL0aFNE2K1dsut0J3ydJKGBbRcfolZoi8vo4wv2PaSka
	 MvIVy5NN3mgg697vJ1qm6dsiuuJBfsBnHe5AW1Te3nE22MarCpYC+R82TO/Z91cVOP
	 VzZd1FSXfVhAZcpjT9f6gYb4ueq2OQePqfFbthsRNREdGTcg3BJ57ZK06dvmH5q5yM
	 k3b3IbWUYAeSDb2hlua18b93PbvUfC+cRpqCbGjVPnYiX2O6oRLS7sPr9R1jJEatmm
	 rnvst54z42CmPPjDITwVpxrQ25NoxtXbnG0fQO5DVH6UrQeQ4UxjeZO5IgQbDB8Bla
	 eyfviR6nPWYPA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C2C99C53BC5; Wed, 30 Sep 2026 20:24:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Wed, 30 Sep 2026 20:24:33 +0000
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
Message-ID: <bug-222081-201763-wszw4NAn6Q@https.bugzilla.kernel.org/>
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

--- Comment #4 from sachse@gmx.net ---
Note: Creating the the filesystem with "parent=3D0" the crash not occurs.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
