Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A696979E3
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 03:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FTnKNRpw"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EE07C43391
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 03:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701747659;
	bh=wkoC0GKEXruFWLn6mhsTJNlLN+ea03sZQG2VDqIf0D0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FTnKNRpwfd5G2Sj+Lis0oJ9nsv0mHGSTlzVgWVVBVw2LnHAWOSXwTW6qcyxeRVZJE
	 VV5wJb8af+AVzoBPu5HuInsTz/cUZxdINDP7cqhhN8eF389nIZNJ4WOspfqV2Dx/UE
	 LR6S+azCEAspOR5UCDUQPXehsjj26cCCDQ+Bqn6Fra9BRQJJG5CVY9ZbEf/2xPSLq0
	 AltT4RCThYyxAfOJNThxuI+KEEkPLDWfVO83pzKnf38pxCyDod/L3Fv1q7L39hinLf
	 ANDcR/KFrmYDkRRRYXj0n3wDWvSpp2ZhvLWfyZTY+hOMktZE596rUDdaichO1LbYQP
	 kIYFYFh6YWV4g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6A8FEC53BCD; Tue,  5 Dec 2023 03:40:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218226] XFS: Assertion failed: bp->b_flags & XBF_DONE, file:
 fs/xfs/xfs_trans_buf.c, line: 241
Date: Tue, 05 Dec 2023 03:40:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218226-201763-2oSDt08gVh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218226-201763@https.bugzilla.kernel.org/>
References: <bug-218226-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218226

--- Comment #1 from Luis Chamberlain (mcgrof@kernel.org) ---
Other sections and tests which can trigger this:

  * xfs_crc_rtdev_extsize_28k:
  - generic/531:
https://gist.github.com/mcgrof/a339c5f7f2a6b5af08f2b373e0c80294
  - xfs/502: https://gist.github.com/mcgrof/129316fad6a7f2c19d2263df30aea2e6

  * xfs_reflink:
  - generic/531:
https://gist.github.com/mcgrof/4185a54c4b67b1a7ce00b4e4244f61d0
  - xfs/013: https://gist.github.com/mcgrof/0a2dd092ea36d09d65e52d063e967269

  * xfs_reflink_2k:
  - generic/531:
https://gist.github.com/mcgrof/fa8659342f8f4599f6ab6ad4bab5c3e9

  * xfs_reflink_normapbt:
  - generic/531:
https://gist.github.com/mcgrof/e169257f7a139243171d7e0202673bec
  - xfs/013: https://gist.github.com/mcgrof/ab61de6d6de7a9b1673e47dc06bd7a3c

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
