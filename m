Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC93F5BFA
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 23:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218784; cv=none; b=d1qO+jFs93EnmXcBIhc91cZfXPRkzuTGuPAanFREGl3BYlXMVskb7XMhHZN6xJenGr81V4xOTyzdO/KHFheDKSUC3VVBjmlS6V4BHcOWfZtb19+8lc3weBzDysHzhNY0zCD8ZioIEt6kL6fUqg4vgFCptbWwVzZNm2/7VezyXoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218784; c=relaxed/simple;
	bh=o0FyOygO23D1is/xvufwfZvlULNE0SV5GNe42l2ILSM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=LLOOpV73hClm3qidZ5t5BX3BqJqRiLp9lD8N4IvsqJ5VhSvXQXVGNyih0xrIbKwqprNku7EF5smq2qThmqSZHE7f5n0/10pxPFhecolZvJigOjC2PsyRSm0/A7mb5vd/z+HPinhQidBEZNrmIjx3na8G38TUZPMPqMAFXnBDHkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDWT0FRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDWT0FRO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 254211F000E9;
	Mon, 31 Aug 2026 23:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788218783;
	bh=XkwbTYKipLJ7ermVU5qQdvGi3uZIvg7Doe/OSvx6S8A=;
	h=Date:Subject:From:To:Cc;
	b=dDWT0FROYY5jDwxQ2z1Lol+faCDtDXG07CJ6hwZYWiMWM1m4QXm74zo+ixOaOM4C9
	 O8xjbr2u8X39cbgYPBojw7vyx50mozJ9YM6ctyq3EjG8rI1x/JkmBrs971xSrDuaXt
	 kmE+LwsmSRX2gSfAIGUJdUKRtIXOmOkBpAinoapAiRX9Ku5hDgKdbJSNku/qK4/ItG
	 lN1GuL8WnHUOkGEXS5QhFRBN/5+KSeYg7hFErXfdHGVB+Nz6bOgs4GUfKV8MjZugy/
	 IMzqbWkufq3JL29QyB2Aru5H6B/RGhCV/ZcjAf+Sp9zDCDfO1pJfjaxmSS9LLXTepn
	 /IBstm4lAOEOA==
Date: Mon, 31 Aug 2026 16:26:22 -0700
Subject: [PATCHSET 1/2] xfsprogs: various bug fixes for 7.2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178821870236.2381099.2561252941543842548.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series contains miscellaneous bugfixes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * xfs_scrub: terminate systemd services if the sysadmin unmounts
---
 scrub/xfs_scrub@.service.in       |    3 +++
 scrub/xfs_scrub_media@.service.in |    3 +++
 2 files changed, 6 insertions(+)

