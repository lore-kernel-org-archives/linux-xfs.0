Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A58729CE7
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 20:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738094408; cv=none; b=F/CZrXhBU/imfYSoL47OppvotbJL377qpQ57N1JVtkVYoM1CV6fpaoXrOsuAfP94N/GZsNXRou4ONN9mvoabibKrej9EFD6FhgTXwBIKPc5alDUqiNdoBVHiPqHSmiViMDfnaIVga8+chhnJAJHui6/JJP7iFRkv7YtNxDw0ooY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738094408; c=relaxed/simple;
	bh=P1Kj5lBUhXQ0RKcE/qLMyLbbla18bWiSPDFCeSE8rnU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RyDLyJ2T4z9SIye/7VwYTk93Rv9Lx3EVtS7oNwH6F9sPdHLf54uyqTXg4+XExmvi7jDvb5v/J7J/blkgf3K625DsAi9th+CSWRUf+UJPhjI3x0PdbxZVkjl/aaDW92orQQHtOVkyvKy+EFL0B/WW0/84pM0ZGGfxWd68G4WurHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W2HurVgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W2HurVgu"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F2D3C4CEE4
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738094407;
	bh=P1Kj5lBUhXQ0RKcE/qLMyLbbla18bWiSPDFCeSE8rnU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=W2HurVguiaIjJGNpcZrASb5Sqkj9yEZQIQNWa8s/IGExY+gi70jrKiGDOXLe9Bepy
	 vk6uEuzl/oEbMJOHbT/CFd8u++2zUycnrmNEyy6Kq/dWfhWbBotg7U7n4ivBoF8TU+
	 0pfpZ/qcgrVqREVCOYM05+6T/SXRNmtf7Sqch2k0JX679+FNEmpsoyo9xzbx3Gd6oo
	 bm8mazS5Oy43Vw2ErhddxfmgdOvF6EUP3UJEWfCW+pu3RMCSq12f5BjIoETWQolatp
	 VVk6wlOdJjHfRMUnZm+75FRHVTlumZjZz6ZjBDk7dZDjMVXD1PG2tiYnXZJ0qD3Ggt
	 ht6UyNSu6+7OQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 89133C41616; Tue, 28 Jan 2025 20:00:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] iomap/buffered-io/XFS crashes with kernel Version >
 6.1.91. Perhaps Changes in kernel 6.1.92 (and up) for XFS/iomap causing the
 problems?
Date: Tue, 28 Jan 2025 20:00:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: speedcracker@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219504-201763-WrmvklirOy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219504-201763@https.bugzilla.kernel.org/>
References: <bug-219504-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219504

--- Comment #8 from Mike-SPC (speedcracker@hotmail.com) ---
(In reply to marco.nelissen from comment #7)

> There are patches for 2 separate 32-bit issues, both of which are in
> linux-next,
> though only one of them appears to have been selected for 6.1, 6.6 and 6.=
12.
> These patches are:
> https://lore.kernel.org/linux-xfs/20250102190540.1356838-1-marco.
> nelissen@gmail.com/
> https://lore.kernel.org/linux-xfs/20250109041253.2494374-1-marco.
> nelissen@gmail.com/

It looks like both patches are in kernel 6.1.127.
When I have time again, I will test kernel 6.1.127 (or higher) and report b=
ack.
Thanks so far.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
