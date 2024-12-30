Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D990188CB1
	for <linux-xfs@vger.kernel.org>; Mon, 30 Dec 2024 21:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735593991; cv=none; b=Yv5k2B/n+oWqdy8owNVVuuAjyLFsmXM6PSHDEUWqFeVxm49b6H4qcV7MV+8qpJhmoCDCaIMIo8Q45Vg0ihS4UBc7xMzntvCjMUEU5WwdtYAcxakNiqul9a+SrqFwK7XfSYuRRTQfZonEVx+r/Y3rAbsMTAZBjA+c/VxFm5bC57c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735593991; c=relaxed/simple;
	bh=jprXibkrhfBqrAJNfToAO3hl1PQRx7WCSopAJ872jTM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RxufE4bQ9+U5EIBTEGTlLSaiehgIzvl+MVGvIGOj4aLKbp9zMJxraVDamFY2U9a6t/X/1t7HV7e+K/D4UIm+VhqXo62Qfygj2+kx12I81S8lJjGiOZURGHTTYH2KS+woZpwHvyouPKTycgizsBGjHD/wZFuRBvI/756H6LmEt3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHMAdQk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHMAdQk+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAA7AC4CEDC
	for <linux-xfs@vger.kernel.org>; Mon, 30 Dec 2024 21:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735593990;
	bh=jprXibkrhfBqrAJNfToAO3hl1PQRx7WCSopAJ872jTM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZHMAdQk+MQhBCcwlWQAnQY+Ye4LgdzVSsqDfUAdmC0/Hwjw2yuNmSwsvWP/PPgwSz
	 b6wGEFvd/Pf+yStGzoJdSqRyq3msS1QbfxoM5QxoiUJUthJfZ0CbdwQTXhsG+pBXec
	 W9PJXlg7UoOBJ5MeNcJPvCDlAn5RSKUCRXCtK0F+pmWQonHPi6OzumX2cQHV78oJc3
	 FKpRvWOD+QawgRT44yy0btQDqAp8TcYyS/9DX4TP1XCBEkqCHikHCZx8Pxan2328Bq
	 anfqziZIII2zBmbDbtH+Xp/4ZVPNUwmMoJJGqzJ61AslAuTTXk7I+nOpID1GfRBl1Y
	 q3N6NUVAKbFhA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C9CE0C41616; Mon, 30 Dec 2024 21:26:30 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] iomap/buffered-io/XFS crashes with kernel Version >
 6.1.91. Perhaps Changes in kernel 6.1.92 (and up) for XFS/iomap causing the
 problems?
Date: Mon, 30 Dec 2024 21:26:30 +0000
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
Message-ID: <bug-219504-201763-pFw5xpVcDC@https.bugzilla.kernel.org/>
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

--- Comment #4 from marco.nelissen@gmail.com ---
I think this might be the same problem I'm running in to, which only seems
to happen on 32-bit kernels, starting with commit f43dc4dc3eff0.
Problem is still present in 6.13.

Easy repro steps are as follows:

hash mkfs.xfs || apt install -y xfsprogs
rm -f xfsimg.bin
truncate -s 6G xfsimg.bin  # I can reproduce this with an xfs image, but not
with ext4
mkfs.xfs xfsimg.bin
mkdir -p xfs
mount xfsimg.bin xfs
truncate -s 5G xfs/diskimg.bin
mkfs.ext4 xfs/diskimg.bin  # this can probably be any fs type, it happens w=
ith
fat too
mkdir -p mnt
mount xfs/diskimg.bin mnt
dd if=3D/dev/zero of=3Dmnt/file.bin bs=3D1M of=3Dmnt/file.bin bs=3D1M

The above almost immediately prints a warning to the kernel log, after
which there is a kworker thread hogging the CPU

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
