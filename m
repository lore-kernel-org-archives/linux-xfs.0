Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43403B95E3;
	Tue, 10 Mar 2026 03:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773113928; cv=none; b=rQtTxiZA74oisdIKobTEDoRu71CEpWKOw6S0Vfp2bTcUnA2hkBaUYo0rQpohDJNI91ChoI0dL1TGT2Rd9ZX5BnuI2LUKPOgdGn61WAk5sB/KuXCYEl12n1HO2jlyLMCUTHaAXgWoT5ih+Ewd8d78MXH9amvOyJlw08TOV+KYEeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773113928; c=relaxed/simple;
	bh=8I2OyWa/VrlqwEVdUgbomoalO+ztE8KEOxmdvzO0ly0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FcYg/YL5wU03a5g+T9nT8GgQ8DGI4rn9gHDUAdpk+leWWiio8myBqASoW82MFuY8CkkHgDpdf8R2IDrrcsXKWiVlPeRo+WIYJgqW0ilogTeR6t0Eb8JOjN18m7N/covnvrIIKwQeOz7WMDFgR6+dfXgjRsM4O1XIRuSkc6cKwcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TcZUoBR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TcZUoBR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BF5C4CEF7;
	Tue, 10 Mar 2026 03:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773113927;
	bh=8I2OyWa/VrlqwEVdUgbomoalO+ztE8KEOxmdvzO0ly0=;
	h=Date:From:To:Cc:Subject:From;
	b=TcZUoBR3e5b03f4B6/9sdh+Jvli6W1mhr3rgGB+6Qx63XqRnH+u/ULr3Fptd29fbV
	 +ar06u8r/3zcpVKbnUMQLLyN4Xp4XSu37P7FksMf58LgN5ZtUIyl+Z1oRYjRlkzRAJ
	 w1b1si5jgOZ/FldzVUU1rg+N4O4mZjtm1sfAVm0uu6hXMmzfDhyEuuglxbnk4RPZt0
	 6UXaxhi9+SZ7/PSPybYRolYJiHtslE9KvmpearYzTaz4mMJH3uM7KsFFznXMX2rT1s
	 s5U4RoCe2eQYUMYn/PukCOK1RSRhcCw8EqyLKNZdQDAFjPUB0YItMAvW/Sebw2ED5T
	 amN2q0Un6BeEw==
Date: Mon, 9 Mar 2026 20:38:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	fstests <fstests@vger.kernel.org>, Zorro Lang <zlang@redhat.com>
Subject: [PATCHBOMB v9] xfsprogs: autonomous self healing of filesystems
Message-ID: <20260310033846.GH1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

This patchset contains the userspace and QA changes (xfs_healer) needed
to put to use all the new kernel functionality to deliver live
information about filesystem health events (xfs_healthmon.c) to
userspace.

In userspace, we create a new daemon program that will read the event
objects and initiate repairs automatically.  This daemon is managed
entirely by systemd and will not block unmounting of the filesystem
unless repairs are ongoing.  They are auto-started by a starter
service that uses fanotify.

When the patchsets under this cover letter are merged, online fsck for
XFS will at long last be fully feature complete.  The passive scan parts
have been done since mid-2024, this final part adds proactive repair.

These patches still need some review, please help if you can.  I will
get to the RWF_WRITETHOUGH series tomorrow.

[PATCHSET v9] xfsprogs: autonomous self healing of filesystems
  [PATCH 03/28] libfrog: add support code for starting systemd services
  [PATCH 05/28] libfrog: add wrappers for listmount and statmount
  [PATCH 13/28] xfs_healer: create a per-mount background monitoring
  [PATCH 14/28] xfs_healer: create a service to start the per-mount
  [PATCH 19/28] xfs_healer: use statmount to find moved filesystems
  [PATCH 20/28] xfs_healer: validate that repair fds point to the
  [PATCH 22/28] xfs_scrub: use the verify media ioctl during phase 6 if
  [PATCH 24/28] xfs_scrub: print systemd service names
  [PATCH 25/28] xfs_io: add listmount and statmount commands
  [PATCH 26/28] mkfs: enable online repair if all backrefs are enabled
  [PATCH 27/28] debian/control: listify the build dependencies
  [PATCH 28/28] debian: enable xfs_healer on the root filesystem by
[PATCHSET v9 1/2] fstests: test generic file IO error reporting
  [PATCH 1/1] generic: test fsnotify filesystem error reporting
[PATCHSET v9 2/2] fstests: autonomous self healing of filesystems
  [PATCH 01/14] xfs: test health monitoring code
  [PATCH 02/14] xfs: test for metadata corruption error reporting via
  [PATCH 03/14] xfs: test io error reporting via healthmon
  [PATCH 04/14] xfs: set up common code for testing xfs_healer
  [PATCH 05/14] xfs: test xfs_healer's event handling
  [PATCH 06/14] xfs: test xfs_healer can fix a filesystem
  [PATCH 07/14] xfs: test xfs_healer can report file I/O errors
  [PATCH 08/14] xfs: test xfs_healer can report file media errors
  [PATCH 09/14] xfs: test xfs_healer can report filesystem shutdowns
  [PATCH 10/14] xfs: test xfs_healer can initiate full filesystem
  [PATCH 11/14] xfs: test xfs_healer can follow mount moves
  [PATCH 12/14] xfs: test xfs_healer wont repair the wrong filesystem
  [PATCH 13/14] xfs: test xfs_healer background service
  [PATCH 14/14] xfs: test xfs_healer startup service

v9: reorg listmount/statmount, use it to find moved mounts, improve the
    commit messages and documentation
v8: clean up userspace for merging now that the kernel part is upstream
v7: more cleanups of the media verification ioctl, improve comments, and
    reuse the bio
v6: fix pi-breaking bugs, make verify failures trigger health reports
    and filter bio status flags better
v5: add verify-media ioctl, collapse small helper funcs with only
    one caller
v4: drop multiple client support so we can make direct calls into
    healthmon instead of chasing pointers and doing indirect calls
v3: drag out of rfc status

--D
