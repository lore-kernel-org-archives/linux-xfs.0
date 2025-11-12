Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34C653A7
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 05:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762923881; cv=none; b=Ue6GIdSWmwluipZV7q3Ew+rrNEHRzlRFvnhevhY4dFvjdX1OFC8faqt8LpTnVtK4fM5psQBPmd/EH8mzWccfRiFf0zbJz+zTv8jMiBrmuZg/P/r27OI6jxTM/iqXqNobhd1yrPM9sBj1Vv6TMR8XPctoAYEPAqjid/KSf1vBCo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762923881; c=relaxed/simple;
	bh=J8qqRdA8MApRl8afGEFCqY3fLgDib1bJAemzCZpLrdY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=alq4ZSFbcGclLsBbXP8YbGG4abGfLSOegaF2CDMo9amByE7WxLuUWHpeUYUelRFOVDZO4L5h6B4VLe3jGh1LxwohTIRKTy24RM1aTiimdO9ypDhwaJ/jmRLQKbG94r5WpRwzrSNtITEHJfUUf1mHyzu9B/exdrm8b2WM8zg53zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1mBoKp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1mBoKp1"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FE19C4CEF7
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 05:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762923881;
	bh=J8qqRdA8MApRl8afGEFCqY3fLgDib1bJAemzCZpLrdY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=R1mBoKp1M7SxZ0XrHZRHzqo2VbXQ/qz8kL+3wciAnpKpcSxQFRlewEAJNz6DA16qg
	 PKE5KfmobY5xNnIF3vhCY7ISHzmbm0DDcH+5N6DXXq0QZ9AUiA6SCeNb+54tH8Qqg0
	 lGEUQYzflsSrSj0tAqOKEPEJMKoAu0ckdWoKi4KEVwzjs3vUkJoUWgvIUR8NWmeHa3
	 2QL1Hnzaw7sRPS3jN1uHU+02bPSwaEMoaH1Gy1bABDpV9EMhW58U9GPsgrnWf47Er1
	 SJxeGaNprhYD9ADut9YPitGy2T2PzTAKQVKdi5QNQx7lNcXwnPGwKDKlSwoaMSydC9
	 T1RngyA35m2uA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 14EF2CAB787; Wed, 12 Nov 2025 05:04:41 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 216031] forced kernel crash soon after startup exposes XFS
 growfs race condition
Date: Wed, 12 Nov 2025 05:04:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nirjhar.roy.lists@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216031-201763-WUfmR5XEi4@https.bugzilla.kernel.org/>
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

--- Comment #2 from nirjhar.roy.lists@gmail.com ---
On Wed, 2025-11-12 at 02:32 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216031
>=20
> Eric Sandeen (sandeen@sandeen.net) changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                  CC|                            |sandeen@sandeen.net
>=20
> --- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
> I retested the reproducer on 6.15 and saw no errors.
> I'm not entirely sure when or how this got fixed, but it seems to be fixed
> now,
> so closing.
Maybe https://lore.kernel.org/all/20241014060516.245606-7-hch@lst.de/?
--NR
>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
