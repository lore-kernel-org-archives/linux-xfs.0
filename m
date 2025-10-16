Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A30B1C69D
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 00:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760573990; cv=none; b=GBm6QaILZCRLFey+1K2PWSQF8oU7cKb8s1lzuPKqYOhCTc7j7HNgXkQ6yvxaDqHts4rAy+4yOhjFrmtjRVsjiy0hNJ/Bw1C9PLo7rmiWt2biNr4ScDEMfiz3sN5RXgtRRqx38YkKKJd0dB+4PAW41tjlQedun/SG5qCzNLcIhcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760573990; c=relaxed/simple;
	bh=XYa200Nf/gsEWTcUkMk6E25Nm/NBQk6GT3PDKC9HCng=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lxE/PmUavoNBu3khdMgQHw6pxbz93jvzR8oBj/iDh/bS81Wt5h+gM0YZBBmX0DFD+ndu3TFr+TaQ3xeD3AMtlw7k30bI3q7Xl2kO7ipsmo1bDVX35cqnH9I/kqyIgp1xCplxOTZHYLsuTCxCojl+9p1JGHaScBCFy2jCfmSiqwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9v7Xo/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9v7Xo/r"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BBACC116D0
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 00:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760573990;
	bh=XYa200Nf/gsEWTcUkMk6E25Nm/NBQk6GT3PDKC9HCng=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=a9v7Xo/rzm+dgs8uMuWWWSdlfJvYaGBFjrSaetw8K1pqc4Mhdk9z0H353SUcPDOgP
	 NWmkCbyaRfuO4pvrfspq1OmoTchnctT61Y/pKwrlt82cIGmU0NI0A3tlWIZ9Ir/OpE
	 bEIA/uW/B/x3wFatwoCaJbzYy11Cr/NQWPVBgRhULie/0yPJ7nI8FNkIYj/PhDyB+4
	 gZiWD0QS5EEI71kit5ydluls79JWpbkaw4WSlEnIavcftDa3XlCXzxyA6KJhCkzQmr
	 CT+UCIKC6Rm0ef0xITkZm57EUUAXY//caExhdzFcsLYdy3mqkr0JF5H+iNgn/H0ZX4
	 kKImblOb6wVFg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 22230C53BC5; Thu, 16 Oct 2025 00:19:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 220669] Drive issues cause system and coredump and reboot
Date: Thu, 16 Oct 2025 00:19:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bshephar@bne-home.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220669-201763-mGn60LPGd2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220669-201763@https.bugzilla.kernel.org/>
References: <bug-220669-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220669

--- Comment #1 from Brendan Shephard (bshephar@bne-home.net) ---
Created attachment 308812
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308812&action=3Dedit
vmcore-dmesg.txt

The generated vmcore-dmesg.txt file

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
