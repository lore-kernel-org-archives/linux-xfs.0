Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9430F21D00A
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 08:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791792062; cv=none; b=Gh19SxfN7CN+Jw8aLeC0jysDNduXgxoda/VhCX+eImdcx15/WhCOQw/MX5Ux12m1Glve5AoKPDmbvrCkw5k8EVktDFcxlcr+4CBHrgQJcZVfuEfKTRZhUJBj7aiyifedTAz3jablJwb+LYKOY391ZsZNvPpUvB/gFVJA9zOGOCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791792062; c=relaxed/simple;
	bh=QNAieYMZdGBfIGnbYNl6OTqmhFHaKlpzasoX3FgONvE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OkHnNhs75tp2zjYDw7EqqJq06XqVwatXX8QVIez+DgCOXQ4o5bm9OqFjbI33QsiwjnMj6dCYYbPjUgKWkyfQ5wYNN6TkWyHuPF3xJjmfAd5xezp3VMNkn1g01P+opUjtVuuYsCrVt8/8v12z22gUE/HesJI8AnH0hZC2D3X26qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdGOfyJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdGOfyJC"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1425CC2BCFD
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 08:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791792062;
	bh=QNAieYMZdGBfIGnbYNl6OTqmhFHaKlpzasoX3FgONvE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UdGOfyJCOSHXdBvMzGo3DYui4ydXKUn+/MqGTYsLaAO43TGwgBFNWq09fPibhQ1c9
	 tf2Rp9NWM27X+l+itm2Ve05rYBGCwQ7p1cNUqm7fSCLc3NMlyvS9HnVJU6YSg8smxG
	 inReSs74Jon7a3K/pZZA3KzvEPuauwNZSSZRFNp5akc0YHNdKHVzyAtKbo5xB0OFjl
	 vIZuGP7bsH20Q4wWeiGQHWYAEA4gR7cauAv6hGhDfdfn06Gf5hOjsaxdZ9O/bIzoHU
	 Abj21gGP3MvE3m8122yW6vgHhtckx8k/xKb7r+2BXeRUrjkeTJquTBhytz2/3PlKuq
	 RcDW9JA7K9KlA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F02C4C3279F; Mon, 12 Oct 2026 08:01:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Mon, 12 Oct 2026 08:01:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sachse@gmx.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222081-201763-BHNfDsTdYa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222081-201763@https.bugzilla.kernel.org/>
References: <bug-222081-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D222081

--- Comment #9 from sachse@gmx.net ---
I found option -o, but I think you need the extended attributes.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
