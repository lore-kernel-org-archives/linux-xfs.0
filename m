Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A92B1FAA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298760; cv=none; b=SvrsvxHogkTs5+A+GiBflDRM7EkICsM4gu+0bX86dDskqNTn/1plEYa+D/ZJ7oSkSyI/bFRWewTS1lUoQO+vwVzZn5Zv7G1mXJIE24q8rQvzPT5zI7rj0hI+svJnxIYUn+0bkU9I5MZ7993JJQqmXF2irzG1eBqFd+R/cwUItYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298760; c=relaxed/simple;
	bh=RCpC7wl5WKoshHiQYCs6Mikimb5/wMrUddFYJBU5t3k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TLZ/Ie1tP4nCIn8im5knIJSRSmsMWq1UXhZ/thJAlE8UbPD6o7rHbRWn9friRWm3fynomeQhI8lgLIRD7Bc0JA5c7T5kqjRz+ZcpCOKGsddKXyZAvMvetwvV3HtDyDvw59BwKPbcbDFa1bTcpuf4Z6NLmN/irB2FYx/aSizi0h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sAtNMFzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sAtNMFzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50199C32786;
	Tue, 30 Jul 2024 00:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298760;
	bh=RCpC7wl5WKoshHiQYCs6Mikimb5/wMrUddFYJBU5t3k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sAtNMFzNovAN0gjJQLH32DE+C3kEggNTPvFxqHQ4rIuafjGuBJ1clyJ/FLQQcLySP
	 /QsG7+9W8v/da/FEHM+V0DV1savAr6ui6EC2AVJGK2K/aL/bidT9uFr7CXZxhkcs34
	 9OSTPU23Ah/Jp/QjWxt9QyySaX5THh8T9/gyVfyDXidrHsW0M3FofdYT5OQEJdCNEn
	 JB798hQkH85sbwu2cf50gvtwvLCBhd2LGiVlQGvY4Y6uUhgrgmOjJyVgwPnoS/sViB
	 KkPlPQjiMFMa2UzsLlI6iiEML5KX8Sg8K0bO5BODDbG//EsJZEgxM3EskT9K0FIwwM
	 BykrBXt/hpsjA==
Date: Mon, 29 Jul 2024 17:19:19 -0700
Subject: [PATCHSET v30.9 11/23] xfs_scrub: detect deceptive filename
 extensions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

In early 2023, malware researchers disclosed a phishing attack that was
targeted at people running Linux workstations.  The attack vector
involved the use of filenames containing what looked like a file
extension but instead contained a lookalike for the full stop (".")
and a common extension ("pdf").  Enhance xfs_scrub phase 5 to detect
these types of attacks and warn the system administrator.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-detect-deceptive-extensions-6.10
---
Commits in this patchset:
 * xfs_scrub: use proper UChar string iterators
 * xfs_scrub: hoist code that removes ignorable characters
 * xfs_scrub: add a couple of omitted invisible code points
 * xfs_scrub: avoid potential UAF after freeing a duplicate name entry
 * xfs_scrub: guard against libicu returning negative buffer lengths
 * xfs_scrub: hoist non-rendering character predicate
 * xfs_scrub: store bad flags with the name entry
 * xfs_scrub: rename UNICRASH_ZERO_WIDTH to UNICRASH_INVISIBLE
 * xfs_scrub: type-coerce the UNICRASH_* flags
 * xfs_scrub: reduce size of struct name_entry
 * xfs_scrub: rename struct unicrash.normalizer
 * xfs_scrub: report deceptive file extensions
 * xfs_scrub: dump unicode points
---
 scrub/unicrash.c |  532 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 426 insertions(+), 106 deletions(-)

