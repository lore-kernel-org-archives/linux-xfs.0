Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC0E38E11C
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933627; cv=none; b=amyVU5m4UDusA9oMDBCmp+jIbxciqHY7j/D4s06Bq49saki6nw3PZvt60NU3XlA8Xq+CkWhLCWXtJWxnfq8U71y7IlLqMB1rOVGAU0yFVcrVB8hKjUWTp14a+BtFZMIFSpZ1Au/ko3WCt2M6bncxu0OfvOEMxucVch9F+vFB620=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933627; c=relaxed/simple;
	bh=orizcTDkq0n+ch4tj3t9LBSWkVsvEBqrS938hu7jzu0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=D2HEk1H4KI0QDz7qvKdxeZGJ5QXw/iqqFsENm63u0Dl3ZC5ml4T0699/Q2emU4rYXjB9AMZVrQjYhiDOFDw1pBJGwpAzGCVMxKPIP3KC4dwUMXfO69BT4YXDdQHrOpeAaVdGI2ryKGUgPFyET58dPssCUZaGq9N7Xh78gJUC8LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejejfPiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejejfPiG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 063F31F00A3D;
	Wed,  9 Sep 2026 06:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933626;
	bh=FOe17Yadq0QWE1uHm3CiY3NDzpO4aZw2EjBpeTyJGYk=;
	h=Date:Subject:From:To:Cc;
	b=ejejfPiGsOCVxzZDd4fRMUMzJxaiXx5P9DSGptfG6klLa4uCv/iXAiyeRa/t0pyLR
	 QKYFsVfEaYXep28flJ5mC848DiJv42uLULhlwqFl/cdscdQIOTXjIj72A2jw5eEAId
	 v2Wx3U6ZTVL4JX5nvOC+lXHMjbCZVcYukl/ChqAkjdr2xklUWcAOaNYGW5w6bXwo9Y
	 lklgxq+bDhAHFTDwvPuTw7xvJpYYT2t4kqOSnlx31ZXXbsLhxY8WlDPGw1xkFRAqKQ
	 MtVQuOfOYAH6D8/G77JGWac/Zx8CSEov6tdFOc8SSXFGjlH0AhrNrUpPLYUxqrbrnz
	 zB3KgLTchDmRw==
Date: Tue, 08 Sep 2026 23:00:25 -0700
Subject: [PATCHSET v3] xfsprogs: generate mkfs.xfs config files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@infradead.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Message-ID: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Every year, we generate a new mkfs.xfs configuration file to match the
stable feature set of that year's LTS kernel.  Right now I just do this
by copying the old configuration file and tweaking the values by hand.

Instead, let's create some library code that can emit the same
configuration variables that we've been shipping for some years now,
and hook that up to mkfs/xfs_db/xfs_spaceman so that we can generate
them either from the mkfs defaults or pre-existing filesystems.

v2: add rvb tags, add the defaults file patch from before, add a few
more metadata/v4 feature bits for spice
v3: add more file-related options and default config files

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=generate-cfgfiles
---
Commits in this patchset:
 * mkfs: automatically upgrade autofsck earlier
 * mkfs: print config file for a given mkfs configuration
 * xfs_db: print configuration file for mounted filesystems
 * xfs_spaceman: print configuration file for mounted filesystems
 * makecfg: handle metadir quota options
 * makecfg: handle old V4 options that are almost always on by default
 * makecfg: add a few more file related options
 * xfs_admin: print configuration file for mounted filesystems
 * mkfs: allow specification of default options via configuration file
---
 libfrog/fsgeom.h        |   12 +
 configure.ac            |    1 
 db/info.c               |  201 ++++++++++++++++
 db/xfs_admin.sh         |   15 +
 include/builddefs.in    |    1 
 libfrog/fsgeom.c        |  594 +++++++++++++++++++++++++++++++++++++++++++++++
 m4/package_libcdev.m4   |   19 ++
 man/man8/mkfs.xfs.8.in  |   23 ++
 man/man8/xfs_admin.8    |    7 +
 man/man8/xfs_db.8       |    6 
 man/man8/xfs_spaceman.8 |    6 
 mkfs/xfs_mkfs.c         |  213 ++++++++++++++---
 spaceman/Makefile       |    4 
 spaceman/info.c         |  218 +++++++++++++++++
 14 files changed, 1286 insertions(+), 34 deletions(-)

Unreviewed patches in this series:

[PATCHSET v3] xfsprogs: generate mkfs.xfs config files
  [PATCH 5/9] makecfg: handle metadir quota options
  [PATCH 6/9] makecfg: handle old V4 options that are almost always on
  [PATCH 7/9] makecfg: add a few more file related options
  [PATCH 9/9] mkfs: allow specification of default options via
