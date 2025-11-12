Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DD7221F03
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 02:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762914751; cv=none; b=eOdbDAv1Cbp/GFmTOdLxVkm32T5JWUbJ6MrZ+JGHh0QXHygKShZW3HBUQfTrQbqGCORu08D11TOx5m9BbnH55InW4ngb+s9dBdiwfKLl1dUUWqiQNwKRfYpCMhfhz8jrlfrDvgKqxJEK3ccI/UcKopGEgwmrx1mUjN5fcgia0rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762914751; c=relaxed/simple;
	bh=1YOWcbQEPM1qdgIXaBlhJ2VXRn2kLtjy6wFNqdE+BqE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cfIfK/0uNfoiK1Z3KT8xj9KTgSUJt8vsDmHI8xhSNqpQ5YG0s78InWt2ep9zPtzSPuXNRr88ZhzIDF1n9x8NNF1ugJcjAmgbSy99IZz/bB7FK2wRPTtBh9m5lXv27aTuOaoYwSjVLkAyXe0Oyfk7ur94LlCZX3zryo3fz8AtwJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8IsOieT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8IsOieT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E71EBC16AAE
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 02:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762914750;
	bh=1YOWcbQEPM1qdgIXaBlhJ2VXRn2kLtjy6wFNqdE+BqE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=S8IsOieT6PyQNE94Q/neV+wpwObSua/fmvyIvBdPlzk/hpDIik0xRar1wi2nNqHmC
	 HajBQKew6Xx5rS/f0RW+PqumjCdGob6zhxzMoxvEDXJ0U4cIxOKIPYLTfIFaomcJnv
	 wfZuEihB10cB0b5tSEXnb21fxW0+RBevX/Gr+QfeNarE4TuJShe+nMWzyxeyeupodH
	 mwSSz3a1z25eKC1h7UX6AKtSS319Dh0bidd8bPMFSkp0K3N+sj31xVqY7Omu907mog
	 /L+Bdol0axOjtsxhr83VYYnwO0ZpMhc1CwTu3wWYoPaKJgrrqGQgSN7jwlQ5IcqpMz
	 AIG6Vz6zFk6rQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D8456CAB780; Wed, 12 Nov 2025 02:32:30 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 216031] forced kernel crash soon after startup exposes XFS
 growfs race condition
Date: Wed, 12 Nov 2025 02:32:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216031-201763-ehVUdf2odn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216031-201763@https.bugzilla.kernel.org/>
References: <bug-216031-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216031

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
