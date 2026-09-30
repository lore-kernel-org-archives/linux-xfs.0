Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC013D45D5
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 19:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795260; cv=none; b=A8QvcfSUOtGvYMdLXLSke6ozw5uy2aQDhgxfXVsFERINb8bXmXB0iwhrxufdpkTH7uvYL2oajT6VBUtFa0xbUmwWw9/ekfGoGTKOgXFgTv9eIDfcY8E2kUpomraYePzi6l4ckRldjxTHTR+Z+HQsv7T6mtrOtLdZCsVrdd82f6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795260; c=relaxed/simple;
	bh=ms3DLon+5jtZGHtEzWFVBbmBiLcFUtqnGMT6NkU7fno=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sLsAEwmdM8YHT7mtVcKYT/qxIW1wPyaQMA8/gZMmvrY7pFdMHIphV7G69vtjeefmN94/TwIkWoVPCO86UKvfmy5Zqbwjl69jCEwumZftA0n6zBfqX3sphpMMHBw+CeAtVFmKH/8iqH5GEUNPU9boxs0npt3zh61fpoHyF9OMLW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDJ3cVpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDJ3cVpl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1310FC4AF12
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 19:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790795260;
	bh=ms3DLon+5jtZGHtEzWFVBbmBiLcFUtqnGMT6NkU7fno=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PDJ3cVpleO71yVaH6lMyKEms/RD/Ig1kwZJc7pQcls7fgAWfmTzBHr2AFifjWEbph
	 aXqO6s9LTnoG76NpK7qt57H9shG1a8N8JeKJQGyMYdfSJb1M5NYrNCjL8UyPG751Dt
	 Dz/easUVClPGWQy+L+4DvDcLhGrV9A8FXt8EdnQSWLDz8TDfNRyLS0W/FzJ+f3CSOW
	 Vr/0Ho2lvQn4Czy74XJRvBlwsZ+G73Tin/i3XDdl73J70+yeAV/YHHXrnsNeuq9yXv
	 aSvWVM7aRJgbN9Fy2iFDuMGikOTPHx6osybtnx5j4BmvgYGSMzR6akDCylik1IhS1m
	 9KzljM9U8kAxw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 03847C53BC5; Wed, 30 Sep 2026 19:07:40 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Wed, 30 Sep 2026 19:07:39 +0000
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
Message-ID: <bug-222081-201763-3O7BB6dBVv@https.bugzilla.kernel.org/>
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

--- Comment #1 from sachse@gmx.net ---
Created attachment 310978
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D310978&action=3Dedit
Output of xfs_info

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
