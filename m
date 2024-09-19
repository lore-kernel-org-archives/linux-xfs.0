Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A145917C8B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 23:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726789980; cv=none; b=GfUjkhIuxLjic8uF2yjUzr1X1OyYVPGgVmBG3Oe/O+bMgLmy9E8O9N2sQagWxHLHtVmkdG4biVJqOrA+CfcMAGmq3g3uzyTLPggSArGoK9y3NKditWd7IO7EOmkzCQUMmJY4mKA6Oh6POJzO6AEyQH0n7o5ER5auDRo3+MQcJac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726789980; c=relaxed/simple;
	bh=hKcWRKlNrNO1yuILd5NcqnP78XgBHhE6oPFgOGMC4dg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=CEm8hq5ZfYAETDEyOoYPH3Cp5QD3m4zW8NT/IHKaz3UDfez+gt1jIqro2dITK2+kjBbOwkUfI57xxXaA+AMtPyhytJFdYqXThyNSPXUHYdY+riirpVPqQkPd8/DzVnom1Hlb+BUZ6IqDWV8ivDaKW7J4DpZD8oXkAS2kZBfxmHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mo8C0VZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mo8C0VZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123E6C4CEC4;
	Thu, 19 Sep 2024 23:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726789980;
	bh=hKcWRKlNrNO1yuILd5NcqnP78XgBHhE6oPFgOGMC4dg=;
	h=Date:Subject:From:To:Cc:From;
	b=mo8C0VZHZj9MvAqGjgfaRkejZV3ZdgR0J37R2PGu3bYSMfrHaRUcWbm0dfBUPwSc9
	 qdNwbDVh8uN6nt3V89IscvFputtzZW3FY10SIbInohv8yyjUdl5q6Bk6ztB7G9/pAp
	 t6R3lRI/UV0mgtms855WFFXLK9QwFATzHiJn0Jeydta8HOmtEGBxX/4ucRMKI7aEpd
	 c8e/PgbO0UimJO/BdNQ15WKsobGpij9kWDOmkurizxiR7wbMDkO2T4vl8fMym4oQ8R
	 fUkGMNxrrG8boC5H+R6G5hKkFiF9iz+ieqdubJ5v0kTw3YEFoGzqaT1hl7HQs8+7eC
	 ePbqtxKZN6AFw==
Date: Thu, 19 Sep 2024 16:52:59 -0700
Subject: [PATCHSET] xfsprogs: do not depend on deprecated libattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172678988199.4013721.16925840378603009022.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Remove xfsprogs dependence on libattr for certain attr_list_by_handle support
macros because libattr is deprecated.  The code in that library came from XFS
originally anyway, so we can do a special one-off for ourselves.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D
---
Commits in this patchset:
 * misc: clean up code around attr_list_by_handle calls
 * libfrog: emulate deprecated attrlist functionality in libattr
---
 configure.ac          |    2 --
 debian/control        |    2 +-
 include/builddefs.in  |    1 -
 libfrog/Makefile      |    8 ++-----
 libfrog/fakelibattr.h |   36 ++++++++++++++++++++++++++++++
 libfrog/fsprops.c     |   22 ++++++++++--------
 m4/package_attr.m4    |   25 ---------------------
 scrub/Makefile        |    4 ---
 scrub/phase5.c        |   59 +++++++++++++++++++++++++++----------------------
 9 files changed, 85 insertions(+), 74 deletions(-)
 create mode 100644 libfrog/fakelibattr.h
 delete mode 100644 m4/package_attr.m4

