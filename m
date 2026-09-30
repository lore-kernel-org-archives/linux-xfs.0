Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6A03CF039
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 19:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795599; cv=none; b=SplQvEYgCpZeL52TQSuALnv+FgT/peDSQpVFxacQeFT443V1X3S/GtO1AmI5RpmqNwZuDwy+hXJJNGqZkBAstttw4KiGfvjJa7TFFACpRe63c8GYy96tgUbQjyj8kdVGSO++H2NHqGkbuQI5EJ2SQ/wYkGruudItnD22pzl7uqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795599; c=relaxed/simple;
	bh=DIoflC5K/0u0FJ/k38VNxJ+nrPoW6N9HhM2KaEa4w04=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CDVk+uvwySZ2OxsQ21EGdzv/1OFlsXRSP8RrbFHTaFsOiCrQJGyrHPasLMRdMbFL2IzLIErLA0cjCIgUF0L0SUsOJzW0kDp03BWAs+gx4CA4tFdk106C2k+JER5L23F4nxKqM159IVDFY75M5YIZzFbt8RMgbgHHYEkDdCKqLIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jc3lu7d7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jc3lu7d7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8348EC4AF12
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 19:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790795599;
	bh=DIoflC5K/0u0FJ/k38VNxJ+nrPoW6N9HhM2KaEa4w04=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Jc3lu7d7VvUxNsEtjKxaAJlIds8fqZTJe0s2KWxYgByOVR24EO0OxfFlwab0A+l1+
	 Tn9wa48T+2b7SGn4F15KFSTFz1aIaEFHrnXaVmG5xjPyHv8WuzZL52J++bc1dtWowj
	 1k5PZCvshFv/bJTKU3ff4WWNEzI092GClD+Lf1AEX5dpBsreFjOXbppPr5/iMZ6k/y
	 Pq+80Brd4EbeGCVY4Rf7UpR4QRrGia9ZZfOZcO/O5fk00gnJvoaGN7/sOk04PVTZxX
	 8jYh8RlyjJNQEr2y/HjbJTUtEl0G89XNcBJCWWSG6RkTrz7nqV5xEevhRc1dxxc+mq
	 BcWANVUht8TAQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6B7BFC41614; Wed, 30 Sep 2026 19:13:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Wed, 30 Sep 2026 19:13:19 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-222081-201763-qIhp41rPwk@https.bugzilla.kernel.org/>
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

--- Comment #2 from sachse@gmx.net ---
Created attachment 310979
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D310979&action=3Dedit
Output of find with link count

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
