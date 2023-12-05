Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9884163DF
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 05:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndFU2abN"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18B63C433CD
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 05:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701753379;
	bh=//9MUVhL2CTL3BLtNsBRLsMjGSMFyQtIeVMEhXuIRic=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ndFU2abNPN8/2ANsBifzAKBxz6/kXpFWsmiWgm6g9FlNN1LaESxwyxcarGAc/8FJf
	 pS+KI6JnvDc2tCpsSrjbkCL3WEhwQV0weYFbMzkG0NmlryAmNAqYuerslai7i6GAVu
	 Ji7zEkYofa0GH2O3uB1yOqXmFRnqXbFvIoR4Vw5uh5A7/oxdppl21zriwYgZD5rfgE
	 4/rknJyi5aEf01ovtU+Pj4NPYl+BAEDu7gVaj2b+BLdoS0v65XLChlXtdQVZup7j8e
	 0taFhTHXFEkoVquy9lJFcMPX1xvrJmh2Xj3pQkgVeeZNsoQ1Lyg1S8EL+0y2oO9ppT
	 fFiA6kferedSw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0407EC53BD5; Tue,  5 Dec 2023 05:16:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218226] XFS: Assertion failed: bp->b_flags & XBF_DONE, file:
 fs/xfs/xfs_trans_buf.c, line: 241
Date: Tue, 05 Dec 2023 05:16:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218226-201763-tedGpoyqEV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218226-201763@https.bugzilla.kernel.org/>
References: <bug-218226-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218226

--- Comment #3 from Luis Chamberlain (mcgrof@kernel.org) ---
Here is an interesting tid bit: I ran generic/251 in a loop on xfs_nocrc_4k=
 and
cannot reproduce the assert there after 6693 loops.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
