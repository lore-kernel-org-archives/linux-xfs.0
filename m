Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1618F9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440676; cv=none; b=RAsW/278ykiJ7BhvdAMfbXkl9F/Oq2abdLkDOF+JvJBg7zN5mGS08QiQfWCliiB/MwWmZS5q4MJ9+87qcARnJdfctWcw2R8mYksimBVdOz8hEMzmaTF8FJGqSPKnevJbCWLo3ytynr6jpeAG7wzEWzPdgSpqlac1Rx2JLuvpZd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440676; c=relaxed/simple;
	bh=v7K5vlRgSuh8iVZvQE2EOFW+3L/lMyVchCaQqMlAHWo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KZXp05WxUgKUZIJLnip4LCorcgDJaqxTZK4m1jXAwg8EefoFxy1uCfueX8mgZVcBCLl7c9ek5g9WTz1gQEqj4cUek6Als/m2B8VcthuScMM4e8THJiLkKVWu7R4mE3qrPTL8wJh3qCuBHyyJv+KlDjqCp0xTJIQddoFGoXklLLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rs+M9W1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rs+M9W1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F9DC2BD10;
	Mon,  3 Jun 2024 18:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440676;
	bh=v7K5vlRgSuh8iVZvQE2EOFW+3L/lMyVchCaQqMlAHWo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rs+M9W1K2zkix/VdsVgHvLSFq9BPMBqL89gC3wUaHcn475h249qzfGBzRFi3FpMK9
	 qiW9VICePxavWfBRD0DTXtsJaXKJhTDKGZ6wn5YLrisTPIcTtD5kNVjgBjbXAK2tGe
	 lamxnbu+O7bn9JK9QXoDCuFEPkvTwoKFsqwdeCXNfka9Plj+LCVbrDwxUcuYxQIzTj
	 qvY+2TjHNjKKrIeF+30XUHnSvcdJFQ+jryZYsY/f8yNtmEtvtnpCG7mP+/tW/lzOBV
	 80Caa+LEUAghefpRwX7ojhNV4dvhKgdhXgZghbFqcpISOu3St4nrMfkGyWXrEelW+1
	 oV5XctB1Ms7zg==
Date: Mon, 03 Jun 2024 11:51:16 -0700
Subject: [PATCHSET v30.5 10/10] mkfs: cleanups for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744043839.1450599.5227191261879163757.stgit@frogsfrogsfrogs>
In-Reply-To: <20240603184512.GD52987@frogsfrogsfrogs>
References: <20240603184512.GD52987@frogsfrogsfrogs>
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

Clean up mkfs' open-coded symlink handling code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-cleanups-6.9
---
Commits in this patchset:
 * mkfs: use libxfs to create symlinks
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/proto.c             |   72 ++++++++++++++++++++++++----------------------
 2 files changed, 39 insertions(+), 34 deletions(-)

