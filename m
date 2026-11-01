Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793547382;
	b=GUPVYXo/coD8uMfJLGOuCShXraAddYvYJ1kEOBVleBqWrDg5bMVHUfJYm5hCwEi+6jRL
	 5+AzFG3cRkCMU1JgBYhYLl48ZDLaAtdBr/9eV4HvNz39xq1TX0j0P05bEQeMr5CZ+/pzJ
	 22NQn3G9g75Rxf2lRQc2mQ1uL1QLPvN/9BPgYT7bumFYmN6oX1M5q7Poc6BN/cDi6HFjf
	 0BkNKM8Xv6Nb2O+5xObQ+/G/9JajWz0Rd+UxHSUWE2cXRBObbfW0KaZH3sCcLw9MZ3DdY
	 E6m1Py1FBcVvDLZOXvk3viyQvdNWjir82CZ8pok4q0dRRUqlDuKU9EdzbOpaDtFWGXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793547382;
	h=Received:Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:MIME-Version;
	bh=iUPWshEQcS5/obAEFA8hty86kI+BW2U7T164dYJJnFs=;
	b=cej82Juwzw0i7iNx99J5/d/cP9Y1U1p6j/Qbd4LgC4+j1tQeTscdkFd7cB/VabYFONbP
	 gfCqkNPpjlQ2C1OsL/BLTKEmOyqooEPvW7x9Nkd2ize5M2X1ofLshxCyczugYIFtrZS8H
	 o9xzYoXX2k7KZ6vO8Lv82/JTybEmhQWJXjylIHxNTG20pZ6xUTPAMbHik7eePs1wnovbo
	 X2q2Zq4HWK05GCSCB6at3Er2XjFBz8jbEYv+uXIcmrCaCT05WPzw7RH9Kd9FoN0xdu2d2
	 iYv7bwKsR+NuGaHS6L3PtlQ8FlvqrdSLBPTPo4503Bt97Yq27mWN8vlidMc7ylXXBsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b="hmWcPJ/f";
	arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
Received: from aws-us-west-2-korg-listserv-1.web.codeaurora.org (ip-10-30-226-211.us-west-2.compute.internal [10.30.226.211])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29BE7606A324
	for <linux-xfs.vger.kernel.org@localhost.mlmmj>; Sun,  1 Nov 2026 15:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=hmWcPJ/f
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041BB6513C0
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 15:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1793547382; cv=none; b=sP8I13uBj8eKX5ny9P4XE9t+xlT3pVS/SKMBaHbYdS9ddfE6guNV4Lk7eujw+HcgeuhfJjueZDVnN2/U8FVwsRj2mZlds+UOCW48ndGe0J5dD/MHRdxXl4h1XHRfA6WQ3b3Hh4n92H5geTUCToT9tZisBSoGLbMTVO6cp/l+bmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1793547382; c=relaxed/simple;
	bh=iUPWshEQcS5/obAEFA8hty86kI+BW2U7T164dYJJnFs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g09RyqL/3M3Waca2lUXSJaP6Dxpjp3r50ulLLTH8+goiF50OoQPhBK2TppI6qavCv25ETNzWnVi/jhsZGHZNdrPd7GuPkj5ql3VYtWhQCPY/sLogu1MCoNxDlywvAw2H2kUAjbsq2ookT8KjRfMqIplaXok3/N2/x5+xhBzhE+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmWcPJ/f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B2FCC32782
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1793547381;
	bh=iUPWshEQcS5/obAEFA8hty86kI+BW2U7T164dYJJnFs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hmWcPJ/ffAlAuFPBI513iGEHBdjDFLZMfkgB5jcnq7T71D3HocQJVPiAein2fGbtg
	 4bZHctDu6uLfH6ybcw5XJLlVIs7+Yi1UK2okxhiahry7ImRLe6D2TBwlwDKXM7b9C3
	 nIGpcL3obBXR4yID4+++XX6CLGIDO7809hJlQIZlEWJNXiCg5DpdAZCTSAsyJyaoyd
	 VmUVEdEIKRBw/r3wO7Yyq8vXkGWdvtgJhBdemWSkU5dTynFrqDcYRM4HUMkaVH3OVm
	 /ngzDg5Nwj+IXTT8DEsnQQG9ZgbJpQOcHFcNCKxaIYThN79j8UC9Cnxy4XFYRTcx/j
	 5Nbh7UB+Gq9CA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3FBFBCAB780; Sun,  1 Nov 2026 15:36:21 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222219] Support for option CPUAccounting= has been removed
Date: Sun, 01 Nov 2026 15:36:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: glitsj16@riseup.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222219-201763-THm1yCX5HT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222219-201763@https.bugzilla.kernel.org/>
References: <bug-222219-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D222219

--- Comment #1 from glitsj16@riseup.net ---
Found two additional systemd units that also have the deprecated CPUAccount=
ing
option:

xfs_scrub_media@.service
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub=
_media@.service.in#n34

xfs_scrub@.service
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub=
@.service.in#n34

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
