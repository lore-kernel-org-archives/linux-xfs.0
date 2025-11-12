Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7867C2BEFFB
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 02:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762914736; cv=none; b=gAM3cJ6MizM51Rr4AtQLU6wZYzcrs5VAfa/6/rMW6EK7LzhgtiqHiiWNpH2mMSvpTw8+Rd6BVSSnjQqSK2FsoDm4IdfhSQHnV1l3F1eLxi7mTyCx82ggyRjHp0knY2kBMgZ7/GzoV2YgHXIdQs1DUNr4OPEaDvAoTGD+BVl6h5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762914736; c=relaxed/simple;
	bh=Gdjdw65xkxY33Jf2lW/Y80szlq8GxaFicMUP0Lk0YHs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XyA5dYnl80pLnYTaKQE4MdZicBIZ8UC4snTYVbf88v4ajXda2a1Y3Ex5UizcsuW7/bcV39ElzZzJuoiRWi8roej5SpZYBHKFBWxdQcfIsgdG7XoUJiR+E2xDZCtx+ETn6kuK3Wj/crcRFsnlthuW0Yp6CcMhy72lK/42z+kBHbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYD6W5AD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYD6W5AD"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C42AC4CEFB
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 02:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762914736;
	bh=Gdjdw65xkxY33Jf2lW/Y80szlq8GxaFicMUP0Lk0YHs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jYD6W5ADx4B9JlJB+7MSkHZ2bj7gmKz3L86BsojT7BzsoHI3FQYhxfwdgMpwPNRHQ
	 jgARz2UqDlQHQaPnIoAmWgetkpoS8IQb9g5di6GGT+M7EyuL9DKFl+QslT2bbdCsWF
	 oZUFuyPLrluW+BwFebTRqQFbaFjXHxpDCvK9+g9gr4JAAynAwGpwnzZWg5tcBDHtIA
	 NCWENgu6yPQ1BnCeYZhpTr7IrNPcFUXkm1M0uZ0bHIMgPlUc4qSd2YroHNlmcJywS6
	 ROyLCSlHDmFxCLvm77Sp2LuNkgQlJhzCcBdV1Ji6ZC650KfwLumK8yL1t8q/veAeVc
	 fwvJ5+sAHOm4w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EBCE1C41613; Wed, 12 Nov 2025 02:32:15 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 216031] forced kernel crash soon after startup exposes XFS
 growfs race condition
Date: Wed, 12 Nov 2025 02:32:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216031-201763-4B599n5Z93@https.bugzilla.kernel.org/>
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
                 CC|                            |sandeen@sandeen.net

--- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
I retested the reproducer on 6.15 and saw no errors.
I'm not entirely sure when or how this got fixed, but it seems to be fixed =
now,
so closing.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
