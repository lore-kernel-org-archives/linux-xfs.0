Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C15521C16E
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761177622; cv=none; b=JFKtOoTTStRdow/SptLbsd3J0gjaQOckDo/keiXBbgpd+bM+cxSc5qqC6NL52hduBBUKuJx75MdaqNa8353+ruT6+6t5gj7DvlaSpJm550GVdF/WXb+CGerthmptpRyzl+DSPNrvTH0CYF+ItBJDUGyfcDea3Jv30tLvkDffiP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761177622; c=relaxed/simple;
	bh=P/MLUkLTU48FjAhVlhKpfZne0IhhR4+SfS1GxAD8klw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xqqe1RYdP7gpFrh4nxPXvzAzbkFlsBsxtCTtp5zYFoJjycKpSUbYXOVEgXOeJzgWstu9n4Uwchpj8UIMy80PMo6qoPbHwepA615HORsKDw9IoQCWXoXSy8oFipL1SUBGvpY/9kC6Fbu5sau6PuifbzvDIl+KZgVBf4dP1NDzOzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IjIRIbET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IjIRIbET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83522C4CEE7;
	Thu, 23 Oct 2025 00:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761177620;
	bh=P/MLUkLTU48FjAhVlhKpfZne0IhhR4+SfS1GxAD8klw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IjIRIbETPcdMEE8ahSSbT3ij/KhcGPacOmCq8rt2BTqXOA3BJhHghs9No/YalsWas
	 RkroiP3NpMt1T8SubOXOKuw35zwwX8paUi93kUX3530SmXRQ1J7ZW1PrkW9yFOQzx5
	 n4Q9uVwixz74RW44gIYPbIxRXtRD3fLq0xLAyuy407Ne0CKGCKBFCXPYnjsHzPglCo
	 UMLCzfPIxt+UlNK8prOB+ztKB8UdSi0TNefJY1A9xMVY8ZbGnhxXtnwnOCo6qInW5b
	 XumSQSPpCxVi0bg8xKw+dOTzeqvBcyhP9Mx6+Rf+tBrr/NGbuZeRrcj/oXUZ5hdPlL
	 lH3YypWkq4PBg==
Date: Wed, 22 Oct 2025 17:00:20 -0700
Subject: [PATCHSET V2 2/2] xfsprogs: autonomous self healing of filesystems in
 Rust
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
In-Reply-To: <20251022235646.GO3356773@frogsfrogsfrogs>
References: <20251022235646.GO3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

The initial implementation of the self healing daemon is written in
Python.  This was useful for rapid prototyping, but a more performant
and typechecked codebase is valuable.  Write a second implementation in
Rust to reduce event processing overhead and library dependence.  This
could have been done in C, but I decided to use an environment with
somewhat fewer footguns.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring-rust
---
Commits in this patchset:
 * xfs_healer: start building a Rust version
 * xfs_healer: enable gettext for localization
 * xfs_healer: bindgen xfs_fs.h
 * xfs_healer: define Rust objects for health events and kernel interface
 * xfs_healer: read binary health events from the kernel
 * xfs_healer: read json health events from the kernel
 * xfs_healer: create a weak file handle so we don't pin the mount
 * xfs_healer: fix broken filesystem metadata
 * xfs_healer: check for fs features needed for effective repairs
 * xfs_healer: use getparents to look up file names
 * xfs_healer: make the rust program check if kernel support available
 * xfs_healer: use the autofsck fsproperty to select mode
 * xfs_healer: use rc on the mountpoint instead of lifetime annotations
 * xfs_healer: use thread pools
 * xfs_healer: run full scrub after lost corruption events or targeted repair failure
 * xfs_healer: use getmntent in Rust to find moved filesystems
 * xfs_healer: validate that repair fds point to the monitored fs in Rust
 * debian/control: listify the build dependencies
 * debian/control: pull in build dependencies for xfs_healer
---
 healer/bindgen_xfs_fs.h          |    6 +
 configure.ac                     |   84 ++++++++
 debian/control                   |   30 +++
 debian/rules                     |    3 
 healer/.cargo/config.toml.system |    6 +
 healer/Cargo.toml.in             |   37 +++
 healer/Makefile                  |  143 +++++++++++++
 healer/rbindgen                  |   57 +++++
 healer/src/fsgeom.rs             |   41 ++++
 healer/src/fsprops.rs            |  101 +++++++++
 healer/src/getmntent.rs          |  117 +++++++++++
 healer/src/getparents.rs         |  210 ++++++++++++++++++++
 healer/src/healthmon/cstruct.rs  |  354 +++++++++++++++++++++++++++++++++
 healer/src/healthmon/event.rs    |  122 +++++++++++
 healer/src/healthmon/fs.rs       |  163 +++++++++++++++
 healer/src/healthmon/groups.rs   |  160 +++++++++++++++
 healer/src/healthmon/inodes.rs   |  142 +++++++++++++
 healer/src/healthmon/json.rs     |  409 ++++++++++++++++++++++++++++++++++++++
 healer/src/healthmon/mod.rs      |   47 ++++
 healer/src/healthmon/samefs.rs   |   33 +++
 healer/src/lib.rs                |   17 ++
 healer/src/main.rs               |  390 ++++++++++++++++++++++++++++++++++++
 healer/src/repair.rs             |  390 ++++++++++++++++++++++++++++++++++++
 healer/src/util.rs               |   81 ++++++++
 healer/src/weakhandle.rs         |  209 +++++++++++++++++++
 healer/src/xfs_types.rs          |  292 +++++++++++++++++++++++++++
 healer/src/xfsprogs.rs.in        |   33 +++
 include/builddefs.in             |   13 +
 include/buildrules               |    1 
 m4/Makefile                      |    1 
 m4/package_rust.m4               |  163 +++++++++++++++
 31 files changed, 3851 insertions(+), 4 deletions(-)
 create mode 100644 healer/bindgen_xfs_fs.h
 create mode 100644 healer/.cargo/config.toml.system
 create mode 100644 healer/Cargo.toml.in
 create mode 100755 healer/rbindgen
 create mode 100644 healer/src/fsgeom.rs
 create mode 100644 healer/src/fsprops.rs
 create mode 100644 healer/src/getmntent.rs
 create mode 100644 healer/src/getparents.rs
 create mode 100644 healer/src/healthmon/cstruct.rs
 create mode 100644 healer/src/healthmon/event.rs
 create mode 100644 healer/src/healthmon/fs.rs
 create mode 100644 healer/src/healthmon/groups.rs
 create mode 100644 healer/src/healthmon/inodes.rs
 create mode 100644 healer/src/healthmon/json.rs
 create mode 100644 healer/src/healthmon/mod.rs
 create mode 100644 healer/src/healthmon/samefs.rs
 create mode 100644 healer/src/lib.rs
 create mode 100644 healer/src/main.rs
 create mode 100644 healer/src/repair.rs
 create mode 100644 healer/src/util.rs
 create mode 100644 healer/src/weakhandle.rs
 create mode 100644 healer/src/xfs_types.rs
 create mode 100644 healer/src/xfsprogs.rs.in
 create mode 100644 m4/package_rust.m4

