Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA83D528
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309537; cv=none; b=IP6bVJfH/1s6JMpV41HF58uaEmwUJa0KKXpbZAGdBYbuLoGjrYG0Sy9tVIt6svgef8tfBpFtYdB5XdPIL6t6is5VpxmFbYTmu/0tQWyACLztuDwfStIVtEnzd0EVyg9jkYXKrhR1YuH+YalFobQPw1LIQ+dNltw8N1PQSpCOTYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309537; c=relaxed/simple;
	bh=HHPxXmnKAopzoU2SJLwte1/Ph5aYhxmI+TnsnTelTeM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ONwovgFWLXfE7GK4F8wZEDi8sZF66STMqKaLRP3SlEbkLmOA71u4oSZ0sJmr8qXlU/PY5XHMqgEDXsU8xA40ij7pd77tig80BK88v7vIYKKuWT3AbHmy3QI8qNTXyQjVi+wOGg+9uF6jsWgMKAc6XEnUk+PejjlOmTPcazMfZk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMjbM7pX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMjbM7pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F36C32786;
	Tue, 30 Jul 2024 03:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309537;
	bh=HHPxXmnKAopzoU2SJLwte1/Ph5aYhxmI+TnsnTelTeM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SMjbM7pXnSDbUmW3P68o2sUNfEIhWi9bLgqHRZ66kbNZnWXyIlFrJUtoRC/FXn0qu
	 RAHHVokMIISQ8zwVKGLaxV8KpfzYBzwDOecs10FIy3MizQ0mgBeBkh5y/iVp2Mzrq5
	 VgPWgf+fM35R30pMhwEXmc5/ce0VoqRrVYYhOvhtmxjtv6Fa8qmD+z8c3BdN4Oxcl5
	 TxnmuXzMH3ORJLuyl0tRm3HsQwLcWYFV3mLPHQyVckNVB6QA7D8/F3lXQSj5qfLrJw
	 GM3v9JTihAsj/PUkpO310DWoIQ+L7trLLByBq8lQcYcXCtUOvG04FgYj/f8QxwZAHp
	 Vg1EdhW+27g5w==
Date: Mon, 29 Jul 2024 20:18:56 -0700
Subject: [PATCHSET v30.9 1/3] xfsprogs: filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730031030.GA6333@frogsfrogsfrogs>
References: <20240730031030.GA6333@frogsfrogsfrogs>
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

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=filesystem-properties

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=filesystem-properties
---
Commits in this patchset:
 * libfrog: support editing filesystem property sets
 * xfs_spaceman: edit filesystem properties
 * xfs_db: improve getting and setting extended attributes
 * libxfs: hoist listxattr from xfs_repair
 * libxfs: pass a transaction context through listxattr
 * xfs_db: add a command to list xattrs
 * xfs_property: add a new tool to administer fs properties
---
 db/attrset.c            |  463 ++++++++++++++++++++++++++++++++++++++++++++++-
 libfrog/Makefile        |    7 +
 libfrog/fsproperties.c  |   39 ++++
 libfrog/fsproperties.h  |   50 +++++
 libfrog/fsprops.c       |  214 ++++++++++++++++++++++
 libfrog/fsprops.h       |   34 +++
 libxfs/Makefile         |    2 
 libxfs/listxattr.c      |   42 ++--
 libxfs/listxattr.h      |   17 ++
 man/man8/xfs_db.8       |   68 +++++++
 man/man8/xfs_property.8 |   52 +++++
 man/man8/xfs_spaceman.8 |   27 +++
 repair/Makefile         |    2 
 repair/listxattr.h      |   15 --
 repair/pptr.c           |    9 +
 spaceman/Makefile       |    7 +
 spaceman/init.c         |    1 
 spaceman/properties.c   |  342 +++++++++++++++++++++++++++++++++++
 spaceman/space.h        |    1 
 spaceman/xfs_property   |   77 ++++++++
 20 files changed, 1422 insertions(+), 47 deletions(-)
 create mode 100644 libfrog/fsproperties.c
 create mode 100644 libfrog/fsproperties.h
 create mode 100644 libfrog/fsprops.c
 create mode 100644 libfrog/fsprops.h
 rename repair/listxattr.c => libxfs/listxattr.c (84%)
 create mode 100644 libxfs/listxattr.h
 create mode 100644 man/man8/xfs_property.8
 delete mode 100644 repair/listxattr.h
 create mode 100644 spaceman/properties.c
 create mode 100755 spaceman/xfs_property

