Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793547579;
	b=ylXVs2Z1pkb/pgyvLtFlhNRpmuhyImA2vk/e/E5bg7/etyl9mfCGInPN71U6YHDdoalH
	 z2w8Gq7gank7PsFhEo3NBaa6I5QDIvRRm5LVKQj+OG+zcJIF0/H8xRE/EZBYQnf+8h3PC
	 OZbeoLrlOIDbPShSl2shOI/9qL2ZXzw0MtxBgsk9Z1e60w2DUahnGFWuDBYrtcqZCOlEq
	 xfN7Awm2XKdac6VqPSrkCihTfOULXsQ85CYUlhZIE5MhWddE8zKqv6sNyqQ0oCa7VwKZg
	 vyeJWMhQkTW+njIsoqucM6Gt3R2KgPXtBCYU3kgZ4ce6LYhaKXNKG/Ycws+uS7Uppuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793547579;
	h=Received:Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:MIME-Version;
	bh=NsqrTAunY5/Mb8zpEuoRAHKfK84PsE7Ww4C5LpbSwxM=;
	b=DC4LRGxFKQ4cthZ1/O3297ursg0/+4QILHpCEADjZ040VrHOHU6w6EtGun/Ev4oXcAng
	 htdHLzW+JNDdvul+q0qdcxRJf4h4e8BA8JNEV8X3i2GG+htEqH/+d65lg1hmJYAJIUdl2
	 obBPK0FRcBoTQBXa5CdjK0T6hTk3BzrQYofPRYtK/AyFGgrNRDfigGlmWRmipm1Zk2Whd
	 21CfUcwCc6Sx4YkAkZWo7pl0c8+NsdNfQ2PV8CtscH7GCyLcO1/liV9UOvCY25u+v9M/r
	 C8UZjDdaRz1Ui49GKngnbn2ptC8tTiX70pqEx9c/KOiQguBD1/5Ywq8GSa2hARWFPmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=dcaHwflO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
Received: from aws-us-west-2-korg-listserv-1.web.codeaurora.org (ip-10-30-226-211.us-west-2.compute.internal [10.30.226.211])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF7C606A324
	for <linux-xfs.vger.kernel.org@localhost.mlmmj>; Sun,  1 Nov 2026 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=dcaHwflO
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C13C6513C0
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1793547579; cv=none; b=HwYgvFUznj9QKjGbCVZuvLP8elSL0Z/0v4SI5ppXvpZKhJVK9dmdXZiyo5AtC7ImpqukU3FOfm5smyqBPvrl0yfO6mZL2HJy9hNanONfQniXaUGzXCkhdDNFrJ6Zf4tq6cGlHtBG1b/KOMNPVBEizKLdFOSvul5r96pnIrPsuTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1793547579; c=relaxed/simple;
	bh=NsqrTAunY5/Mb8zpEuoRAHKfK84PsE7Ww4C5LpbSwxM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S46LRRb9rkq9dNduDAZKXvp/KAyCYWTzZ2EMcFCZDwwt9BYDvqFoKvvdJPN868/vlWBQbVaYnClGI5nsion7j+QiKfzuL4K5YjFCrIMXG6Z9nnkKA7Nf2Jl+YVck7lW6uR1LifYBerbCvHd4MeazomHjJG7bJlEVc+jYWS8HVdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcaHwflO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2A60C32782
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1793547579;
	bh=NsqrTAunY5/Mb8zpEuoRAHKfK84PsE7Ww4C5LpbSwxM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dcaHwflONJb9jHttgy86yjeYzLtvdp2P03Sel29acJ7Bix91X6hi4s7hZvQ+oZkNS
	 J04Rhnk74c8qi7p+aajzdWHAjH7gGd/QG73hyRm1/FlS7X4M1+LQP8c9xqjRGOtvUI
	 KhtvNrjLmIDxPDCfXDsVr+izBu3RiAeLw5w9+ae4xdpxzNPaia8Hwudg3z2s3D0trI
	 FWUsZH2DXAMe3G5+4C7J80zFMkhs3RR30C5AhWjoI5UbPEaD4nCsP+qkIEhmzMamNW
	 C1PcJoDnnpsQz52/HpzIaS1Yt411+65gjsJCW4bEVFisLbLWuBVPJZkNDYW7AujBI2
	 hVyyylnI+yDcg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D7DD2CAB780; Sun,  1 Nov 2026 15:39:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222219] Support for option CPUAccounting= has been removed
Date: Sun, 01 Nov 2026 15:39:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: glitsj16@riseup.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-222219-201763-YT6gTfRXlL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-222219-201763@https.bugzilla.kernel.org/>
References: <bug-222219-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D222219

--- Comment #2 from glitsj16@riseup.net ---
Found two additional systemd units that also reference the deprecated
CPUAccounting option:

xfs_scrub_media@.service
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub=
_media@.service.in#n34

xfs_scrub@.service
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub=
@.service.in#n34

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
