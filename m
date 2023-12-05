Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E275D2E4
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 05:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2XRNkIi"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1C77C433CA
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 05:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701754921;
	bh=IBd0jP+ulM0np2mfcCyyIcVzms3twVPDtuyOJ4HCtOs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=b2XRNkIimCl55J1sGabZChIj0SAZAo+ep1PajigaUNXybNiI6Qun5H9v1SzNWZX7i
	 Yg+krTK02nY8aGRJzYf62blYpDOE4nI0SuC38eC+Yg57cvdkfTf/szHVoZneCKlW1R
	 B/Pbbkz2kHbLTs5xm7r3lNRNxxS2I1WTnwcH/2b8+5xM25vjAJBOKUr+aSX+2xRBOX
	 lzXkmAEK/pg0Xzvb8KnA5NZxaw+VmASDYzOuUiEfcZSX4aqWWhYdIqN//qjWZPdBGV
	 IeGXz6856/QJVYTJow8cwCdodIEokgpMlaztIuIXPJZrT1QekeUMPdpY9P509xkahq
	 qgubgIaE0TbXQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9F4CEC53BD3; Tue,  5 Dec 2023 05:42:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218226] XFS: Assertion failed: bp->b_flags & XBF_DONE, file:
 fs/xfs/xfs_trans_buf.c, line: 241
Date: Tue, 05 Dec 2023 05:42:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218226-201763-ZlgemB31OS@https.bugzilla.kernel.org/>
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

--- Comment #4 from Dave Chinner (david@fromorbit.com) ---
On Tue, Dec 05, 2023 at 03:22:44AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218226
>=20
>             Bug ID: 218226
>            Summary: XFS: Assertion failed: bp->b_flags & XBF_DONE, file:
>                     fs/xfs/xfs_trans_buf.c, line: 241
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: mcgrof@kernel.org
>         Regression: No
>=20
> While doing fstests baseline testing on v6.6-rc5 with kdevops [0] we found
> that
> the XFS assertion with:
>=20
> XFS: Assertion failed: bp->b_flags & XBF_DONE, file: fs/xfs/xfs_trans_buf=
.c,
> line: 241

Known issue.

https://lore.kernel.org/linux-xfs/20231128153808.GA19360@lst.de/

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
