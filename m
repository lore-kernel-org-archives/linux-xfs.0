Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF4D1E531
	for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2025 23:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737244300; cv=none; b=dFloXmMtUeRCHcOpddbCdIiSqc9X/WJ383BBmIaJfTX+s1l7f9kq2cmIvzQwzrPSmDSO6YxHXUvfwbA7vPoIpvjag4t6tQCtNncK7VtLzYnFMH1ZbfM4vhmKV5dMsH8kjpPF0Ie7C3QbvTThduQstD9uKkOgjjVKNTWKKRDBv2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737244300; c=relaxed/simple;
	bh=cle8oooNseMPtKNxHTP1xZoqCjY8ia7hs/pnFs5mJik=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MbDx3Q3dUcZd+jJ0OzyWCG+XZCY2KQ8LpJZBupVoi3K/RzC9lRyNbBt8FyayrZpgMaoccY0REV4tLIYCx6SZTXd1lllTWR7/q2v/bBhDX17JG17KIzxwIrrIiuDsbjNDNZ2trsPaQ25MKsus6ex0SAM0GJvXZbKw+3h/+dlVjqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6eb2zvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6eb2zvP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2143EC4CEE4
	for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2025 23:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737244300;
	bh=cle8oooNseMPtKNxHTP1xZoqCjY8ia7hs/pnFs5mJik=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=P6eb2zvPzcLkUPrbh9Ds3qLYnUbRX3znbe0I/w2+MtNKHOLCgaIeI3K6u9cB5wwhL
	 2tPSv7KVo2Fwk8xa7VLPoe3/nMjTPjXn1XLm/vdRwiwK6oxB3U1QNt1JiXAFaWpeii
	 5sVdYnBw1+QxF69mbENXHJjOISPWUAfQhJBFu016QfBmxEWh5+GweQ40mqHhRAH/G4
	 T0wYw6uggvFQhcoLCxKzugGM5X5MCV/nc/1g6JZ1TINhGP1/aMDIavx8Vbg1S0ZMUf
	 rVQ/OYpNLug+ayg3PSTbafyqT7XMdDH21QqDISnf/SP3NMFxYXHcQAWhZ9Vh6DzFR/
	 dNYbTuGFM5QRg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 19758C41606; Sat, 18 Jan 2025 23:51:40 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] iomap/buffered-io/XFS crashes with kernel Version >
 6.1.91. Perhaps Changes in kernel 6.1.92 (and up) for XFS/iomap causing the
 problems?
Date: Sat, 18 Jan 2025 23:51:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marco.nelissen@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219504-201763-oCW8gxKHFH@https.bugzilla.kernel.org/>
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

--- Comment #7 from marco.nelissen@gmail.com ---
On Sat, Jan 18, 2025 at 6:00=E2=80=AFAM <bugzilla-daemon@kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219504
>
> --- Comment #6 from Mike-SPC (speedcracker@hotmail.com) ---
> I am experiencing the same issue on a 32-bit system when using Kernel ver=
sion
> 6.1.92 and above.
>
> As a non-programmer, I find this problem challenging to address
> independently.
>
> It would be greatly appreciated if a fix could be provided in the form of=
 a
> patch. Could the maintainers consider releasing one?

There are patches for 2 separate 32-bit issues, both of which are in
linux-next,
though only one of them appears to have been selected for 6.1, 6.6 and 6.12.
These patches are:
https://lore.kernel.org/linux-xfs/20250102190540.1356838-1-marco.nelissen@g=
mail.com/
https://lore.kernel.org/linux-xfs/20250109041253.2494374-1-marco.nelissen@g=
mail.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
