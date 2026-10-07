Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B3441379A
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 07:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791359438; cv=none; b=NLdXHXoXxxB7BT8r/EZDqqGKNRGYF3pBmqF0TRvZl4WQ4Y2G80hd9ZDU40abi1DsxcBKCVtCu8Ab3mk5TU8y2mqRXUK3sWIHYh7E4VwtYme4cox+oqaCvAogBvdRjNjGah71ZuHqTCHNMOti9aaqtAPUjBwZ6lQbPSciQ4rVpUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791359438; c=relaxed/simple;
	bh=SaDCvpGJSTi3JimzSI4JZmUL380CIiLgUIYiiem6wEM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=koTHHVq9kNm4J6FFPXrrAltZnNFbeaRWzvRTyXQQma7qJTNV8FoW1uOAV3tZ1Stj3qgAnCBsMN4FmOfnZS7ZoC2Z4TeVAmVec1lgAQhwvka/osivWvMLpCtBO1AkkM1wKqQUxkq6eNIksmAcadvo6Nr5lL2Xdqe9P+8btXEQOOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vp9H3Z4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vp9H3Z4L"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE68CC4AF0B
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 07:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791359438;
	bh=SaDCvpGJSTi3JimzSI4JZmUL380CIiLgUIYiiem6wEM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Vp9H3Z4Lh4AuxcqjtwBXo1fTkHy+sIx54UUTlorVtmLE/N43jx5QMX2hlieJK/+wr
	 CfTU6Mzhx3l3MAFaWHnXO+XfW+VDdFIMrEcnEY4gqeAq60BA3Mr9EPXsDD14aMxYip
	 OkgUkw3ujCcdefbF6vgjNGKXhmJovGSFgViK/UTvwBXXTZODmHsv7NMJzH6kgs9oWs
	 44bjI4jWo2yheoQIyhx2DgB+VQVr4BvaKIbqFOQ00x3TXidcnwr2BJgqrg23+AVoKu
	 BKBz2aZmeyniEyzsGrFTrMkqDOCwX88pNrl/VqEuSabzKRIGLdhjOwdbutWipDgBav
	 0XRwtwBoujJUw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D7644C41614; Wed,  7 Oct 2026 07:50:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Wed, 07 Oct 2026 07:50:37 +0000
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
Message-ID: <bug-222081-201763-nJXHm42U34@https.bugzilla.kernel.org/>
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

--- Comment #6 from sachse@gmx.net ---
The crashed filesystem no longer exists because its a productive system whi=
ch
must be fixed fast.
From the current running filesystem I can create it if you provide me the
commands.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
