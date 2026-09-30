Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3C83CF039
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 19:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795618; cv=none; b=qZLsBz/Vk2JoiWV0r/cxPV5t+CbDR1eOjGOGH0vFsLC1uWwUTla4mjXQB/qWaD2lwbckDfrl0ZsYE2VlmykjFtHWqkSD/KgolQ1DYV780QTzfHeF46zwnDW+lBPCse9mWGy8VA5Ji4ExMqgGyCPSiipHEFjRqoNRsSf0E1Ww1Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795618; c=relaxed/simple;
	bh=1nmbJSNRrmQvTcpsSZzlqNwkC7aTnxOBI5++FQlx/uE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mGVSqtSXB8G3xpol77kgVVimuHRHoly4Rr1omteN7Jh/dXIJOpFCw7B/YoEzxhO95lSM8gNRWUCYV8F43ZJMkZMN8yCshH1ercFSZWvm+KVXjkDhbVKH3Hy4Dbs8Bired2fo+xO+CTALUWpY7/EqJGPhMWjnlWc+dFh5dZyyD14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBpwj/YN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBpwj/YN"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BBFAC4AF12
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790795618;
	bh=1nmbJSNRrmQvTcpsSZzlqNwkC7aTnxOBI5++FQlx/uE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FBpwj/YNkhVcozWXVmbjfvp+Es0C5txLvXSiy5pS9UwxE9/1YqEdyrnBDME3oKjdz
	 ysHt46lzRyiQWPDOKlS6Ml/v1/Dxi3pFQv9sqW98hSqg6gP6E1xipSy6sir3scYUSu
	 OwGcMx9iSbLfFXh11rO7B+xXpksk/xvFZcPR9fj+ivmmq50XzDrZn7B2JAY5GLJ9xs
	 JeGhP43QeWHY8NObRGNYV47aOdzDDXSMpQDT6CcK6xAQ66dc71HszKYE8aWIkd3rzi
	 X0G4ZkCIYMSg2Xa8AMm6v71pf05F7osa2NuNWVOID128oOVFrP65MDDHe2IH0T8IyJ
	 TSrIuODcdSA3w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0C6DDC53BC5; Wed, 30 Sep 2026 19:13:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Wed, 30 Sep 2026 19:13:37 +0000
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
Message-ID: <bug-222081-201763-9EZ7zgy39j@https.bugzilla.kernel.org/>
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

--- Comment #3 from sachse@gmx.net ---
mkfs.xfs version 6.19.0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
