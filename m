Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A5F3655EE
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589544; cv=none; b=pojYfoUf0fzVzjT1gvnfYzPiTxg3LEhjt2y5BlBIGSpAsBJIdVLvCg09oCu2kVvyCqB6+n3YDZFvJdgTtf31aDyS7ysP1bA23mCdmY6LwMMwKwsASpmZvaHfX+V4MNU1BnHkH9k0TJTCY7u0nWZM7DnfwH/nuXQZoFv6q2/KlwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589544; c=relaxed/simple;
	bh=g+xRZrwzM2+T5kqSMpo+GLQHas3Eg5n8d81/QLaUtMs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=pXRidWUgA/2xYdwcN3KLO3aGc0zWiFRHBO/4ofVNv3Lt0vPRXsn8+8SYUKja44nRD2nNIW1C0xGnhixk6Xkd0lflrbPufrExi5/aQUvG2VT+WTLmu7el6EZUrSyjZfaeHzg+qps21LQO1u1BoU/chqonhJfeJzcMcct8Fqm+3AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQ3d2Pfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQ3d2Pfd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CE12A1F000FF;
	Fri,  9 Oct 2026 23:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589542;
	bh=lpxGwLhkGtDneVl5lWK81kLijAo3rTSKcyWJqULQPgE=;
	h=Date:Subject:From:To:Cc;
	b=bQ3d2PfdnIqIYe1yQz61pykxwt3VCGXQip1tAlvzgDxJNyvgBqz/+/4PxDQEYH1q6
	 a0vl1KyK4RMY7lWb/Fo1bWBrBvHJQ49NdR40R9mDTWOoj3ZcfjivnNJBSkkO3wtlxT
	 877winxkTcUqVkhzGPXXkPMEd4W5jscxMslkNkxf7x1hWznJfC3LDhpKTLO5z/RncW
	 hhT3MXBUrh+x5uxdC18YY+D5Liyz078Trd3OSvdfc/As8WZgqys7Hu3aaPS1hD/WnO
	 GWVnHceTwKxSN4oLDT6aLpef3Km9RwYWQ4P4UjFVnInWCqiMiU8nmepA4/GWI67S8U
	 UgnueW39BrU5Q==
Date: Fri, 09 Oct 2026 16:45:42 -0700
Subject: [PATCHSET 2/3] libfrog: clean up quotactl some more
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179158948034.3720791.6624320009127284341.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Clean up the internal quotactl calls some more by adding type-checked
wrappers to prevent future screwups.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=quotactl-cleanups
---
Commits in this patchset:
 * misc: convert as many xfsquotactl callsites to xfrog_quotactl as possible
 * quotactl: deploy typechecked helpers
---
 libfrog/quotactl.h |   60 +++++++++++++++++++++++++++++++++++++
 quota/edit.c       |   84 ++++++++++++++++++++++++++--------------------------
 quota/free.c       |    6 ++--
 quota/path.c       |    2 +
 quota/quota.c      |    4 +-
 quota/report.c     |   22 +++++---------
 quota/state.c      |   12 ++++---
 spaceman/info.c    |   15 ++++++---
 8 files changed, 132 insertions(+), 73 deletions(-)

