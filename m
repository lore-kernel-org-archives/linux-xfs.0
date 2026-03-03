Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982DE4964F;
	Tue,  3 Mar 2026 00:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498030; cv=none; b=XSoRbEjl2S3zcQkInzQx548PCzUxp0C6tT03sxz9o5lND79Fl0Ad11eJNIzw6zJ6jkMCaFcppzQR0g9LQ/Ye/5XE362pg4BodUXOUo17ADUJze+AYn3qB6VaC2IYpBwURqune+IkUgCowUpd+vWKWn2mveq7O9hKKX87FJGbaqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498030; c=relaxed/simple;
	bh=0lOGS6e+hmHwD7ZfEjaYYs5P+Di78s2bTn+JCBv6WP4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pIuBvxhDNnCZGpvVQrzRvryGO29nPQtIwJvPbx0HsD/06r4G1AqJxJF9X0HKp4gs9Uhh8NFPlN0LNW7tYkE44/qWwHPye3jiLjUWG1BCzX/XgVNTAOoYYCwQv735yp+fe7zol47LQqUBDGP51LwUSl6/2jM49GJkk/KrEf5Eiac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nViEs9Cd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nViEs9Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413FEC19423;
	Tue,  3 Mar 2026 00:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498030;
	bh=0lOGS6e+hmHwD7ZfEjaYYs5P+Di78s2bTn+JCBv6WP4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nViEs9Cd8zNV8VBM+BSZ6NbUX5YoiE05LKwV4szIeceOhcht1k2ktwCXKj5UQO2xV
	 7CyhgZvDi4txxK8x60WpvgexOq0OKcubqv9oPJ9VOn4tYn78aR1CviNHwT8Jind/+6
	 mpnPjNij25qY/EyJ1TJadXoiabaBeq+GyxscUVW13Xz86z0KxL/X6AeM+TZ8nE5dJ1
	 YZt/zac89SfqaauwSSTqr7bhKW8GmxbU9u8s9BSlEQYo0IRioRl5/Y6vuzm4EsIZ4p
	 ztyQylpfkJZ4hSRDiCoRFOKrbxx7J9vomA+PYFvmJ4jiEND5YvACRQWSe9Q8XktGBf
	 Q3oclCnT89Jeg==
Date: Mon, 02 Mar 2026 16:33:49 -0800
Subject: [PATCHSET v8 2/2] fstests: autonomous self healing of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
In-Reply-To: <20260303002508.GB57948@frogsfrogsfrogs>
References: <20260303002508.GB57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series adds functionality and regression tests for the automated
self healing daemon for xfs.

v8: clean up userspace for merging now that the kernel part is upstream
v7: more cleanups of the media verification ioctl, improve comments, and
    reuse the bio
v6: fix pi-breaking bugs, make verify failures trigger health reports
v5: add verify-media ioctl, collapse small helper funcs with only
    one caller
v4: drop multiple client support so we can make direct calls into
    healthmon instead of chasing pointers and doing indirect calls
v3: drag out of rfc status

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=health-monitoring

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=health-monitoring
---
Commits in this patchset:
 * xfs: test health monitoring code
 * xfs: test for metadata corruption error reporting via healthmon
 * xfs: test io error reporting via healthmon
 * xfs: set up common code for testing xfs_healer
 * xfs: test xfs_healer's event handling
 * xfs: test xfs_healer can fix a filesystem
 * xfs: test xfs_healer can report file I/O errors
 * xfs: test xfs_healer can report file media errors
 * xfs: test xfs_healer can report filesystem shutdowns
 * xfs: test xfs_healer can initiate full filesystem repairs
 * xfs: test xfs_healer can follow mount moves
 * xfs: test xfs_healer wont repair the wrong filesystem
 * xfs: test xfs_healer background service
---
 common/config       |   14 +++
 common/rc           |   15 ++++
 common/systemd      |   32 ++++++++
 common/xfs          |  114 ++++++++++++++++++++++++++++
 doc/group-names.txt |    1 
 tests/xfs/1878      |   93 +++++++++++++++++++++++
 tests/xfs/1878.out  |   10 ++
 tests/xfs/1879      |   93 +++++++++++++++++++++++
 tests/xfs/1879.out  |    8 ++
 tests/xfs/1882      |   44 +++++++++++
 tests/xfs/1882.out  |    2 
 tests/xfs/1884      |   89 ++++++++++++++++++++++
 tests/xfs/1884.out  |    2 
 tests/xfs/1885      |   53 +++++++++++++
 tests/xfs/1885.out  |    5 +
 tests/xfs/1896      |  210 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1896.out  |   21 +++++
 tests/xfs/1897      |  172 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1897.out  |    7 ++
 tests/xfs/1898      |   37 +++++++++
 tests/xfs/1898.out  |    4 +
 tests/xfs/1899      |  108 ++++++++++++++++++++++++++
 tests/xfs/1899.out  |    3 +
 tests/xfs/1900      |  115 ++++++++++++++++++++++++++++
 tests/xfs/1900.out  |    2 
 tests/xfs/1901      |  137 +++++++++++++++++++++++++++++++++
 tests/xfs/1901.out  |    2 
 tests/xfs/1902      |  152 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1902.out  |    2 
 tests/xfs/802       |    4 -
 30 files changed, 1549 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/1878
 create mode 100644 tests/xfs/1878.out
 create mode 100755 tests/xfs/1879
 create mode 100644 tests/xfs/1879.out
 create mode 100755 tests/xfs/1882
 create mode 100644 tests/xfs/1882.out
 create mode 100755 tests/xfs/1884
 create mode 100644 tests/xfs/1884.out
 create mode 100755 tests/xfs/1885
 create mode 100644 tests/xfs/1885.out
 create mode 100755 tests/xfs/1896
 create mode 100644 tests/xfs/1896.out
 create mode 100755 tests/xfs/1897
 create mode 100755 tests/xfs/1897.out
 create mode 100755 tests/xfs/1898
 create mode 100755 tests/xfs/1898.out
 create mode 100755 tests/xfs/1899
 create mode 100644 tests/xfs/1899.out
 create mode 100755 tests/xfs/1900
 create mode 100755 tests/xfs/1900.out
 create mode 100755 tests/xfs/1901
 create mode 100755 tests/xfs/1901.out
 create mode 100755 tests/xfs/1902
 create mode 100755 tests/xfs/1902.out

