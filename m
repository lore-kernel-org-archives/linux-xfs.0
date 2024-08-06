Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DA9770E8;
	Tue,  6 Aug 2024 18:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968313; cv=none; b=bJ2jYsSmBuGXd3it46SNX5TKOz9xIHKupngkikdLo2/uFQYDNrc/1X68+RSqyvCPIwrVW4nqOFewAJi5dvWYBVj26bV/LrKjOPT5XZ59X/saTZiJe0WiHmnVACBubyxx3bnNm/eSQRLdAcfQibesYkPDQh2WMXdiBjbHFUCHfhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968313; c=relaxed/simple;
	bh=urmKyRJZbNaTH9zg0uFKth+K9zgA2996/zYDc+PIFgg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VYap+1lm/k2v8rcNcJFOfhqqdSswyhgXqOsig12XaNKHazXz0pTI9tyf5/ylBP0uWMShVWVu8DTTFTsQIP3nHdUE8Gh0KhMBzshxiRRAOSRa4KNMj1WGPBVY+j+7EGFMUI9pvQrD4mJDKjOvNlPNAyK0UW+xQGTYfdWe+k2Ouy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrAVQYDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrAVQYDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1B1C32786;
	Tue,  6 Aug 2024 18:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968312;
	bh=urmKyRJZbNaTH9zg0uFKth+K9zgA2996/zYDc+PIFgg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qrAVQYDChs8LdnBquJJZDOV45Kt0hAeHEoH2t/QAXmy27hD0T1lar9s9U8JU89UQy
	 tWJRtiUu94Mm1bJ2XN/gYMTtkvgKJHgNCrn4dO4yES49waRkz+Yyf40jqv513MAOOg
	 83YtA1Mcmac8q83TH1uNYBVQVB8Kkz8xz/tRZ+ctS+2j7LivGfGVMWdAoEBnS9zAP5
	 HOnsI9HRMZY1n+Vu82B1ZEgiTSBcm+Fvg61lyxQX9pLtXmKG8iuwUWHbAEMeMMy/0m
	 MJXNLf1riq7MkXBmxtG+dwsPDdfenIHxjWtpFsdSfyWLKFM+yXWZAZdELL1UXdhWua
	 fEEszVcpv4LxA==
Date: Tue, 06 Aug 2024 11:18:32 -0700
Subject: [PATCHSET v30.10 1/3] xfsprogs: filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, dchinner@redhat.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs>
In-Reply-To: <20240806181452.GE623936@frogsfrogsfrogs>
References: <20240806181452.GE623936@frogsfrogsfrogs>
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

It would be very useful if system administrators could set properties for a
given xfs filesystem to control its behavior.  This we can do easily and
extensibly by setting ATTR_ROOT (aka "trusted") extended attributes on the root
directory.  To prevent this from becoming a weird free for all, let's add some
library and tooling support so that sysadmins simply run the xfs_property
program to administer these properties.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=filesystem-properties-6.10
---
Commits in this patchset:
 * libfrog: support editing filesystem property sets
 * xfs_io: edit filesystem properties
 * xfs_db: improve getting and setting extended attributes
 * libxfs: hoist listxattr from xfs_repair
 * libxfs: pass a transaction context through listxattr
 * xfs_db: add a command to list xattrs
 * xfs_property: add a new tool to administer fs properties
---
 db/attrset.c            |  463 ++++++++++++++++++++++++++++++++++++++++++++++-
 io/Makefile             |    4 
 io/fsproperties.c       |  365 +++++++++++++++++++++++++++++++++++++
 io/init.c               |    1 
 io/io.h                 |    1 
 io/xfs_property         |   77 ++++++++
 libfrog/Makefile        |    7 +
 libfrog/fsproperties.c  |   39 ++++
 libfrog/fsproperties.h  |   53 +++++
 libfrog/fsprops.c       |  202 +++++++++++++++++++++
 libfrog/fsprops.h       |   34 +++
 libxfs/Makefile         |    2 
 libxfs/listxattr.c      |   42 ++--
 libxfs/listxattr.h      |   17 ++
 man/man8/xfs_db.8       |   68 +++++++
 man/man8/xfs_io.8       |   16 ++
 man/man8/xfs_property.8 |   61 ++++++
 repair/Makefile         |    2 
 repair/listxattr.h      |   15 --
 repair/pptr.c           |    9 +
 20 files changed, 1430 insertions(+), 48 deletions(-)
 create mode 100644 io/fsproperties.c
 create mode 100755 io/xfs_property
 create mode 100644 libfrog/fsproperties.c
 create mode 100644 libfrog/fsproperties.h
 create mode 100644 libfrog/fsprops.c
 create mode 100644 libfrog/fsprops.h
 rename repair/listxattr.c => libxfs/listxattr.c (84%)
 create mode 100644 libxfs/listxattr.h
 create mode 100644 man/man8/xfs_property.8
 delete mode 100644 repair/listxattr.h

