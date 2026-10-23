Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=10.30.226.211
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792762286;
	b=25v4FTUDfzf/xCqorcKQSCxk3w15ZEQyAja4OgbPRveCYZP2hNjnwLUEjmwvsnPCVwiJ
	 oDK/CXtcl8HS8flnmiNpSWZ2a4Sx32+6TpnQm97Lwfvh+2Kyqc4JPpGFTzVBXpGKBXc9H
	 vuk1BvXK1bMqbZWsj7vkoANmJIzC7wzJzrgdyhq7HSikolD8j08XOmo2RmBc/2TZZxCTB
	 8pjPT6JYxIv4mnNEnJr+zdMEoWoAiERgLynwKbYro9hEzbdoiozJmKmPxG0lMOAg9/f0W
	 0t1fBujN2POtY0Pmr2x3z1aIkHFiMumFy/Hik+yGnBQMUQtJdBBhkQO7ZEMMIEFr1RA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762286;
	h=Received:Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:MIME-Version;
	bh=Ka0XqMXs3EnGA5HQtOv5uV0ZANZm0SOtt33I8j42UMc=;
	b=W8VVzIpf2eNUfqqz0l6kZ6GcM3RuNJNgpB6d1bsA+n7hATh0FneYpg447sZrUkJL3Mkm
	 x8GHZTNco0cTARwLEF+utN2JVHn911/9EnS0kA3BzvLAZSSyLr0RQKQSlXrcVKqyPQEuG
	 wTvP+heJbKIKefuhbGVfJdIABLRGPi7PwAw0E33T/BTkJ7k+fZHey3TfmXm++e7gqWSVq
	 PRprMMHza/BXeULVPEMZHMD3Q5hs/1EamJuHcreOQoAuo0A68IH6aqHLBQ8LDPDiwBJTz
	 lbUXoA9spnYx20Kkso7KFI3d4KrSwBGM0vMbo2Rp28FC1Aq74rok4XJXRr2W1PTS3Cg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=CLT7SnE6;
	arc=fail smtp.remote-ip=10.30.226.211
Received: from aws-us-west-2-korg-listserv-1.web.codeaurora.org (ip-10-30-226-211.us-west-2.compute.internal [10.30.226.211])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA27606A324
	for <linux-xfs.vger.kernel.org@localhost.mlmmj>; Fri, 23 Oct 2026 13:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=CLT7SnE6
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A5025771
	for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2026 13:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792762286; cv=none; b=FwQ/nvebWgd7/nlknySzUsWDmJk63ITblxCd3vnlAqi0BbpmoR1OZYcs7wR+OJmwYBuWJaMeAGH91py4BFeHdlOypM4YvS6vCTchAKHCGWqkpyqYxaakN2JDbHRwqhcNl5D/AyTTdosUfrSArxrvo30Lu1HhCvnvMiE1aonD12g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792762286; c=relaxed/simple;
	bh=Ka0XqMXs3EnGA5HQtOv5uV0ZANZm0SOtt33I8j42UMc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p1yRCpdV05RXPM5C2Mg+evAulNhFGVVL75MYm/syP2sLRUmUnEc/hPfJkGTDcXlhs6ZatXi9nKDuU5H74R+fmYigEt4qXTg7FHa0LakAlp0IVmuKJ63EMGUdsVULPklMgzKyJj+4dv+Kif9dNTrEwyVdQmvexXfe9hWwrnbGnq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLT7SnE6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1B20C2BCF7
	for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2026 13:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792762285;
	bh=Ka0XqMXs3EnGA5HQtOv5uV0ZANZm0SOtt33I8j42UMc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CLT7SnE6DwLIF6yM54339nd056Fz3e6+rD+5yKHdpU07AQV226+e1a1sH1ZoFrMDP
	 mXmMHnwHmwdYqE6XS8bkomLHa0x30toWk9MwMKZKG0Pih8r2J+Cvma+a6TAjh6VIuP
	 dAZLKulpHDonlQYl/OG1NzQTxosfnFdVA+pDMNb+lOtITYl6VC4Uv51bJhk6xOR/Pu
	 YIyZvFNRGGbYyV4mxVv1W6XToi3dWGg6NGemaZbAmfxxwrTcyZEjOgd2M8+p+RAdM7
	 wOIfiSv2A5ywYX7HDpSAvxM8cUZ8jxM20orT/WRzahlaqu2QgOzL3ArjpXI6pUxdIO
	 fEAfEU6nusZzw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 85E94C53BC9; Fri, 23 Oct 2026 13:31:25 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] xfs stops if link count is to high
Date: Fri, 23 Oct 2026 13:31:25 +0000
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
Message-ID: <bug-222081-201763-DF3oCGx6sP@https.bugzilla.kernel.org/>
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

--- Comment #11 from sachse@gmx.net ---
I have created a dump without -o but it already contains filenames which
provide to much information to upload it.

Any ideas I can help you?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
