Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F718BF7
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 03:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gi24IqPd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D05FC433CD
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 03:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701748247;
	bh=qFlqtuHcEcyGsiEum2QiH5i4dBHh45xMwKCYoBhCqFM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gi24IqPdNQyBOMCVXjdyGbteH34cAPbZJMvigNyy3dL/BhuyxXLDBoNbhdLg09vwM
	 jWWm3+1LzKzhekiHt5mxKDmR5PG0s8YqzlXq/bSNdpzRyMlxEL9qF7OBQ/bJI7vvA+
	 1PrvKU5k4d10IFfq3S33d/s5KFmR88PTjEqYmdinLjq/QWyfYSmTXW/a0FgCTpJTle
	 IBPyj+KSKdYfIyY3m914uPJDiZ2h0Lcz9P3Ft7/zm7aa3peEl+ul2rp4SQdPOBKDfT
	 GxoRCWYzul4zc4UXlFm3fqg1SfLdTCUCm5xRwAg0FdOYN/Gqte1oDlUCg4whPg6h5I
	 1ec4+8CmtpI6A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 79935C4332E; Tue,  5 Dec 2023 03:50:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218226] XFS: Assertion failed: bp->b_flags & XBF_DONE, file:
 fs/xfs/xfs_trans_buf.c, line: 241
Date: Tue, 05 Dec 2023 03:50:47 +0000
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
Message-ID: <bug-218226-201763-QQZIhODWy9@https.bugzilla.kernel.org/>
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

--- Comment #2 from Luis Chamberlain (mcgrof@kernel.org) ---
And...

  * xfs_reflink_logdev:
  - xfs/013: https://gist.github.com/mcgrof/183e573797d0e7863c1f50eff6a2b8c5

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
