Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61E82F549F
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589549; cv=none; b=oZTjimm/Z/7MW1QDMDbMdiipMOOK73Tff+jOY9ryES38Wcy7fQehxoJQxG9XxvuSG7jXJVWjvgERDNh4b71XBJBRkunnKccnO6t+AgxquUOb1osCSYuyDtZR1OSDu8TpNg0d4VPwq/pCk1cTV2PwRm1mkzAW5q8srBTemg/aHk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589549; c=relaxed/simple;
	bh=TB5ezH+CeGHmq/vfl1cVFGy7jcJscWOb18Uf7mQzzCk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=rSojz95D0XorJRrjX1MAvJ/YUTki4LIuUKhr9V2YNmCxnRZapR5Uey1M0Q+nNOziZ6dB3Fudwdcl7fzZsYVvl+K1Q2SiLXc2yjTAIQY8OcVXIZRbyhumNe7GFL874m8VAvpAwsxkjcVC/3r3dc8wPeEqrZYEakKrwMZgr5lJwxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKe9Ma6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKe9Ma6d"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 767741F000FF;
	Fri,  9 Oct 2026 23:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589548;
	bh=PUCf4LDslaY6jvmCp8Axv86M+anSN7W+sN0Tk1wWzAQ=;
	h=Date:Subject:From:To:Cc;
	b=bKe9Ma6dgEyxMw2rpGuKPz4CYDK0x5L6NtN19v5yqFKwxhiWiJOusVkQ+v5AZghAj
	 orJZF0SVZglcmT4ixecHjoARzMmAn6W+5oV9lkdIF0DGUDZJMI8Ls70vUIP23wMe4k
	 OiwZ8N8EoemIfcxOjoKHEGh0fhQKu99++LTqSh+q2O3h4HmXmC7jHt7rrySqhfJAJx
	 zjhs/bEIEK7yttfL9jrTd/lVHk0mHpiuW86rEvjqp6WggkWPcqlPD+SuiAsLKaKOMP
	 i5//yEQTRyaaDwPjIGIQo+TVO/ExcCkutKDDrM4mxHkJWACj0QkZtkk+Q2l10eHOiV
	 OcTRBcjRxZHxw==
Date: Fri, 09 Oct 2026 16:45:48 -0700
Subject: [PATCHSET 3/3] xfsprogs: enable metadir by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Metadata directory trees were added to the codebase two years ago, and
we dropped the EXPERIMENTAL tag almost a year ago.  We haven't gotten
any serious complaints about it in that year, so let's turn it on by
default.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=enable-metadir
---
Commits in this patchset:
 * tools: add a new script to generate fixes tags
 * mkfs: add config file for the 2026 LTS kernel
 * mkfs: enable metadata directory trees by default
---
 man/man8/mkfs.xfs.8.in |    6 ++++-
 mkfs/Makefile          |    3 ++
 mkfs/lts_7.3.conf      |   29 +++++++++++++++++++++++
 mkfs/xfs_mkfs.c        |    1 +
 tools/git-fixes        |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 98 insertions(+), 2 deletions(-)
 create mode 100644 mkfs/lts_7.3.conf
 create mode 100755 tools/git-fixes

