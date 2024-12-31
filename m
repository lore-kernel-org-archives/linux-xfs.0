Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EBA2A1BA
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 22:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735683097; cv=none; b=VH5eJEHp4CdgYGOxL/U0bIhxp1mxhQpKf+E2YHFEtCKwkTzkApNB+xs8SE//wfgXJEpsFqy5zLf0stOQ5ITn3WuY8RpntsyQmN/XtpP3Tamm8JQlms3pMdiCsxS1Ma6T2lo/JZP/CJZ0JMANYiUr9/shXr5RGDKmFBLtjfUqyT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735683097; c=relaxed/simple;
	bh=zXLsFpRXgPrYp66KGwJLEbS4/n9pP0HCxmMvPaUOuh8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z2k7eYBPHPszCLWic5sxykSqtXN2/3Q6dwcfOe//xLGj/wwHI32wGBQwJU2FUYOEX1Ii331lv5s+WDYVYmZZlNWf2atRjZ5kfFSgNafAK3h68lcNkSDTfJ1O1qaPd3Sw+W+e5Kklcm0wnwQ6FMkX/AVZGOogfSKRFxsaiCrPM6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZARg8Q7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZARg8Q7L"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF936C4CEDF
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 22:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735683097;
	bh=zXLsFpRXgPrYp66KGwJLEbS4/n9pP0HCxmMvPaUOuh8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZARg8Q7L8P6e8AbvzNFSY2v2eH1M3dqE2R6KfT9fKSgpnD4483wDdKwxSM2YxL+qP
	 EwsC5neuifq5aEMeBEWhv2cJOnAE49egGS2WZz43cs5UEe8cFobuLUmDN/kZ8M8ohJ
	 1a0HeFGuH0vYvUGSBF4lrhmzefFh5yhCJZmOS7Hle9aOS9leqGsVYaWI+K0zWj9MXy
	 x3LVLArlcLuMXe2zENpQm8mT7hifb7O5Glx4sp5TUepFa3IyTYzbifVb2jFj9G584O
	 0+U1tVYpMCeGy1gGsxa9ABv/2Gyrct7aJar3H+VZv1Jmi+peF8w8UntrqqrSOZ7PCe
	 a1QveVPUii6MA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E61EEC53BC5; Tue, 31 Dec 2024 22:11:36 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] iomap/buffered-io/XFS crashes with kernel Version >
 6.1.91. Perhaps Changes in kernel 6.1.92 (and up) for XFS/iomap causing the
 problems?
Date: Tue, 31 Dec 2024 22:11:36 +0000
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
Message-ID: <bug-219504-201763-U0HxfgCrGG@https.bugzilla.kernel.org/>
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

--- Comment #5 from marco.nelissen@gmail.com ---
With the big caveat that I'm completely unfamiliar with this code, it seems
to me the problem is that here:
https://github.com/torvalds/linux/blame/ccb98ccef0e543c2bd4ef1a72270461957f=
3d8d0/mm/filemap.c#L2989
"bsz" is a 32-bit type on 32-bit kernels, and so when it gets used later
in that same function to mask the 64-bit "start" value with "~(bsz - 1)",
it's effectively truncating "start" to 32 bits.
This is more or less confirmed by the actual values of "start_byte" and
"punch_start_byte" when that WARN_ON_ONCE in buffer-io.c triggers, with
one being (close to) a 32-bit truncated version of the other.
Changing bsz to a 64-bit type fixes the problem for me.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
