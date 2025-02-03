Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8571FBE89
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 10:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738577026; cv=none; b=KUvdjc5GODrjlX53wYiByjoRnUI0u2+poo3XHnwkpUhKK32j7LQ6Q7OboG3TFk4eZ7GXVljhaqtVjhrXWBJnMWAX0bjv9Iqw/q4JaMrpSexT0Anedfk790kmJUWGpDQ3WyMMmFNgKIt2Q2YGWnO7d5wvojene8JgXB1gBBHIb9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738577026; c=relaxed/simple;
	bh=dJtyYaE5RV/NoVmikQgUg3FuTO0N9jcGXMVnOUHv7IY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dnKtHqzeWUlF2MaIfcG+4msy7e+9SHsKp+R5/eJ529Y696gMRJI3ak37R/WAHtiKszOzY5UQMyXRmjmPcAlKUeyk8Kbm3HfvAfJGHi2k7KVndVwQbi8LIK6X1EkXnrsGb+xI08bBp7KaY74i9XX0E7tCFmUzMvVmAmAv+IC3fFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vAV7QzcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vAV7QzcK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0C1AC4CEE8
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 10:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738577025;
	bh=dJtyYaE5RV/NoVmikQgUg3FuTO0N9jcGXMVnOUHv7IY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vAV7QzcKfMF5QKYzjkD0WzeugkJo9TLBSk+2S2PQeazZexUEwzXz4tAv0WZiWH8QD
	 IKCJrsUqaYJhMRbmsMMyK4Vad9sU+I/6030vypZRgAy+Ed+X0TmYpPBP9/5XQKZASA
	 gQL7f5gr1Z+Ki//tY/9RboaA/JtTAUa4MXN+iZhSo34gby7J1JoGYvZcKA7OLCFmwa
	 oyLL2D+A/VmFVSdYF0Ca3+DoUkl+txN7mY8CcJsl4U1BuU+0ukA3dunpSuTne689s5
	 7sGAGyZc9XXWTUc0cfBEdNDU00jRjdnrM2ilC1vYRj+8kZBhyhNj5eGy33Zhj8NktU
	 Zg1+sgge3pPWg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C8F53C41606; Mon,  3 Feb 2025 10:03:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] iomap/buffered-io/XFS crashes with kernel Version >
 6.1.91. Perhaps Changes in kernel 6.1.92 (and up) for XFS/iomap causing the
 problems?
Date: Mon, 03 Feb 2025 10:03:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: speedcracker@hotmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219504-201763-CUe1AHXpQS@https.bugzilla.kernel.org/>
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

Mike-SPC (speedcracker@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #9 from Mike-SPC (speedcracker@hotmail.com) ---
>(In reply to marco.nelissen from comment #7)
> On Sat, Jan 18, 2025 at 6:00=E2=80=AFAM <bugzilla-daemon@kernel.org> wrot=
e:

> There are patches for 2 separate 32-bit issues, both of which are in
> linux-next,
> though only one of them appears to have been selected for 6.1, 6.6 and 6.=
12.
> These patches are:
> https://lore.kernel.org/linux-xfs/20250102190540.1356838-1-marco.
> nelissen@gmail.com/
> https://lore.kernel.org/linux-xfs/20250109041253.2494374-1-marco.
> nelissen@gmail.com/

Hi there,

I've tested the latest kernel (6.1.128) and it works like it should be. :)=
=20
Thanks again for investigation and fixing the bug.

Regards,
Mike

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
