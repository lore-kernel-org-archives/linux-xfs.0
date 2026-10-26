Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792980633;
	b=nlCkGT0nj0J3ttojWi05BmG1N8V1FPAbaQ8VWQiMlDdzlMs9zpzgYHpH3hRD+jLxbi8Y
	 81eMEAxlx65D7E2NLnuJ3LVld0TKFTqLNwZlHKmv6EvBIArSXYSH4wk1ADCOMqUZ5Hf/e
	 tujj3Rbdt9WOErrWnkABXNcfvGsmb1XzF/t4rQY1TKSdfSRRrWK+4OcVzch9kDJveALFc
	 UgXv5n+Iz9Wbu8tKwpMxOxasXioIMvbD/FDZBlOKJ+7vK70ya4D5G+Ij+ctA6hzglqEa5
	 /fQHRFou2wS1wk6UczLlaF8q1OlCZg7for/Ycn/RtRbXHKj5MPkwVUQWVimzlNFKTvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792980633;
	h=Received:Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:MIME-Version;
	bh=J4vQbZEefBiCTAws9ZKPL2pdQEFEf8sgsXtUgFmXVBI=;
	b=B4lS9dR1YKyIsvib/A9ZnLl1U9FIARX1jpwv2odTMi2iKzu3LE+77JOjPbVG5FBtxr4L
	 hVsg98l2XMjzXoVpfVPAQtSfj/TCziQlukEqM9bG4ynbeGCkm3Hzdfsu2gxtNZiB+0Ayy
	 CT6DOw7F+oyweGkkUUy7g9RQLrAYGW5QtbJ9oHPYVkozHbyCIHsGXvvkzzqQ8Tpbb4RwP
	 Ji6/I6qNVzp0ixHu7MjJATbqboLkDE1iCC8ynZaIu8Hs0ngrNU4Xv88aY8JZljo6Pehpf
	 XK9/UWs3KRhHCtY8SI6V97CIK6uyF2phM41y4hAUmEAmKN3pbnqIe4FRREveYnnUrtQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ZX0yNGoi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
Received: from aws-us-west-2-korg-listserv-1.web.codeaurora.org (ip-10-30-226-211.us-west-2.compute.internal [10.30.226.211])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB60D606A31A
	for <linux-xfs.vger.kernel.org@localhost.mlmmj>; Mon, 26 Oct 2026 02:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ZX0yNGoi
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28676513C0
	for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2026 02:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792980633; cv=none; b=IFDAMNlM8K1zXPQ5msQit2Eb0xFUt/FE129FcNA9TQehAtb1XnamfEz8g+AJFyF++4GfFtYsnIXTmxDjV8vWsNLfUJPeETzIvoFnJ3CvnMa9GIq8/pUUbeg/2Of4lrRCzrvscr4njCgZ/b8LlGx/HRREbGIuJ6KUOZlGxdac4gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792980633; c=relaxed/simple;
	bh=F33l8/QToesyBpz5sTQtpS8s/wxnQl1+B8tuRr+YgyQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e0BeUa3M4yUVA7ST0F7PpL6k9rVMfiTWGIxcTsOhzXFz11eoxb5KBau/2hX4/P20lARx+Ix7hgXRrZTmzILuDiiq02m749MU+MHiVd7ahQYj6MyyvBsBhXnO2Xkv5UJ1O+sMBYngPf4VSD2M/qLOqiOu6HtyIDjwaYN7hdCSp5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZX0yNGoi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12988C32781
	for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2026 02:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792980633;
	bh=F33l8/QToesyBpz5sTQtpS8s/wxnQl1+B8tuRr+YgyQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZX0yNGoiT+N54eOOIdKr9ClBbcURMUDHyt/Hh2bw0LowOC4DQKpXwWSar9Niji7xB
	 EpLXP1kV0yt6+jvJx5zTxuFHpcb3AEuEBXPzvwo15rvZRWnbgDVvG5gmH7bC027reh
	 bZLM/h1etjgxbhEUdU45zyJt+XwyLBbeS+/CYEfMoRiHROi96H12Ybjqt1Gq6enHXM
	 Z72g2GjK01WZIKjuXM/l3sA6LzzfZVXA5UBllAlNXimZ4Ewv1s1yS070ETKklD4Mh+
	 /2/EvVV+Xi8JXmx5Di+xl7NNn/vgECd/ncRZ//nIljrlX4ENgljvQavdyQfbYHNlbt
	 sucS5Cjr/lifg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F277DC53BC5; Mon, 26 Oct 2026 02:10:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Mon, 26 Oct 2026 02:10:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sandeen@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-222081-201763-BoWgSn3NTS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222081-201763@https.bugzilla.kernel.org/>
References: <bug-222081-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D222081

Eric Sandeen (sandeen@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #12 from Eric Sandeen (sandeen@redhat.com) ---
Without -o, any filename of length > 4 should get obfuscated. Is that not
happening?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
