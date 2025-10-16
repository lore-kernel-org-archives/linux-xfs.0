Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0FA2E2667
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 08:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760602152; cv=none; b=I8T+SqdRoIoq+3B1F6AvaGZ/h9r6fPnitHEr1JAiIY3xHc0+X4bHWUa3D7jS7pNTvl6sRdH4BdlUUEErIuGEjRMIgL+hAZ2ePl9OW2SWPIBmhHZWEuSCQCbbIVJJTrEeHsnVTNjVx/BD5OmVXgRC372EQDbcoJ0T5EzB9Sy05Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760602152; c=relaxed/simple;
	bh=v3PNf2HT54k7eyr/PeKHmWbH2m2AC2AJhq+ZcMMee78=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QCyaom1EHJOMm+6IHytCaNIebDIWaqscocGbLk//RXmeLOa/haKQZoPjAXU1zCzV4oPWPrfBq3P7vSgeS7Sx3I3AVSdUVoYkIcV3ntdfj17BdsGDqGQacXVzq3HaHgVUHu8gBkEq1rD28g1r16apS9igiIan8Mcp3HYZVRuFEg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCAgeEOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCAgeEOR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B18E7C116D0
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 08:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760602151;
	bh=v3PNf2HT54k7eyr/PeKHmWbH2m2AC2AJhq+ZcMMee78=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fCAgeEORVqUX1mNn3JqTh7V5LqCkBzhp2PVNWFEdItz3c3yo+a3a19XkO1VN+ynSl
	 SV1lO0h8LD2ckF7FLl+xXstPVQv65iu/Te9nTvk33yKd+DAs2JnHSgUbECTrNwPmQt
	 7XtiqNLJjT0c7UhpchFb7JhR3wJYib/zkr0Nbfl1xlrUfQyWMZ2n1NWZjXTlbsaIU/
	 +kLhR4hP+PNohZGkYYlsThJ+tyM1On1NDrs4CvTfnb0m4isHfBtsKFsszpMQmYYFbF
	 5TSj4zKVRlC1ZvcqcoXnfBIOA67/AnCkOgQyvt9HdElZ8pjTlbFmfHSZHbRGyCL1ir
	 L24iLlByA+sHQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AB2C8C53BC9; Thu, 16 Oct 2025 08:09:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 220669] Drive issues cause system and coredump and reboot
Date: Thu, 16 Oct 2025 08:09:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220669-201763-hV0yeIVPrj@https.bugzilla.kernel.org/>
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

--- Comment #4 from Artem S. Tashkinov (aros@gmx.com) ---
> [  998.356008] sd 0:0:21:0: [sdv] tag#415 FAILED Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_SENSE cmd_age=3D3s
> [  998.365528] sd 0:0:21:0: [sdv] tag#415 Sense Key : Medium Error [curre=
nt]
> [descriptor]
> [  998.373544] sd 0:0:21:0: [sdv] tag#415 Add. Sense: Unrecovered read er=
ror
> [  998.380347] sd 0:0:21:0: [sdv] tag#415 CDB: Read(16) 88 00 00 00 00 05=
 01
> 1f 6d 90 00 00 00 08 00 00
> [  998.389524] blk_update_request: critical medium error, dev sdv, sector
> 21493673360 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 0

You may need to replace your failing hardware first.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
