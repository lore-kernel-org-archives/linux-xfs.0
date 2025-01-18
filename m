Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF8524B26
	for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2025 14:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737208838; cv=none; b=qtCe9tuvSrCk0KsqY0JD8gi/0WM6A2F6qLyTBHlzmeKRRdvV2/HVeg5A12oEtTfVYZv0gxs05qJ3AvwiU2j63LmqYzJ6KPuT2RNTyHVzl46VdsYySLW8loYyu88Bhhiua1698HOJ/FVuy6wUmkZHlax0wCbyHtfxhv4KNjHflzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737208838; c=relaxed/simple;
	bh=PmEeWhEJHCT2efU3Y5ueWx6WWkKkJPercSp3Q4eIiXg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GJkCuN58D3nGDSqNr8uNKIJV/JPkCkWUPMGh3eUn6dGEGB1RnVep1IweMSMsmcSEza0vcm2gXHyBkwU04hcsCJWeIa8K5nVCxqtrm4p4jravZRlqAyA3Gu4R66/6Md8rmrL9qwrGQ9vx62kf2Qpx3tE9LRhT/XEKrMY7QxBc3Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NH/+Hh8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NH/+Hh8B"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3832CC4CEE5
	for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2025 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737208838;
	bh=PmEeWhEJHCT2efU3Y5ueWx6WWkKkJPercSp3Q4eIiXg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NH/+Hh8BT3CuJ29aHogJUdGe/v4qRKJz/h0f1VXTwrgp64mv1ukyMLxz/fRw+m/Yz
	 benJdJx4khck0auejy7Kb+xYiqtzkGXa6RKnPV/7UYCLcRKddBqfLYdNNH7xpkThlW
	 qW3AzFU7eyEefHvji9lwHYokz2SU0DO8qpNbZM4G8wcMppcYkhhqZGIE/jdyz0CJqZ
	 94Yo7r61XIZ9aOg7wrjlpV/satcjNk61jBgMOh4s3tALWQspThUCSK8JSFqGW5X0QH
	 csAUnrNuCWNIQQiKqtC5w2SwBQddBB9I5+pQ0ywiDpT2ybOU6OMqFEYeIoPjsyTFv8
	 5Fha/3C8X6MgA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3317BC41606; Sat, 18 Jan 2025 14:00:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] iomap/buffered-io/XFS crashes with kernel Version >
 6.1.91. Perhaps Changes in kernel 6.1.92 (and up) for XFS/iomap causing the
 problems?
Date: Sat, 18 Jan 2025 14:00:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: speedcracker@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219504-201763-n9qDuhTcDb@https.bugzilla.kernel.org/>
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

--- Comment #6 from Mike-SPC (speedcracker@hotmail.com) ---
I am experiencing the same issue on a 32-bit system when using Kernel versi=
on
6.1.92 and above.=20

As a non-programmer, I find this problem challenging to address independent=
ly.

It would be greatly appreciated if a fix could be provided in the form of a
patch. Could the maintainers consider releasing one?

Thank you!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
