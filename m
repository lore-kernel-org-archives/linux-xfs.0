Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C647D3B8D59;
	Tue, 10 Mar 2026 03:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114152; cv=none; b=s2npyUAmUrjmOHnPbdeC0jTekuxN141S7jl4mNcQGgn+yx+Q7hHY9EwL6ZXFYBbtFcG7HymgPttwdqwhzW1tFTv4R8OJeJ27DmuB8UJ29jhMRShNoGXe5IaEQsCk3xywZ/kYdrOfbZDUn4kOYK0q8HyosIFzPwmPiDwFSfGn2AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114152; c=relaxed/simple;
	bh=/PBpHKkIVBqtDgnGCakUe1TSMvEqWeb8P+0vPk4V2hM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=njpYgJC91WEsIxROnsMUSBWPfY7zH2EqHqrvJ9/v5eWQWYEFuUPq+qJtoJ0a6+sjVU1RJXsFYoWcXKFt9Dj4TF4LBITOFzmnXEYVlsTX1v/m7F4BbpBL1TgKPKhVXXyYDsC5NOb7OLe18unfoILNyW7Shl0gaXwEWYl/aKyagVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qJND+KSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qJND+KSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BD0C4CEF7;
	Tue, 10 Mar 2026 03:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114152;
	bh=/PBpHKkIVBqtDgnGCakUe1TSMvEqWeb8P+0vPk4V2hM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qJND+KSKSix7l1qKFRXAxqlpEco4XDLLjQdLNu70ER5KpJAXssClptJQk0eKfmp5D
	 pk7Ek5wyPAZ6NsIofjRl5jGrTAkJZDnjcS+1zzrpPqHLlfZvL3LFN3oKqiv/3CPysc
	 e4dteQ5EYuPDX4S6TKO5Sy/b4eLu3nXymNmp5yv8t5z02qL9YqVOuL4SAZNhP7IPam
	 +TiAHkAiTaqf5n98hGUlohXdX3ye7oHQbp3gy0ZBimqsd6z57vHUddSQboWvQFU2/8
	 rgVStAn6k8qXZSbTxKFw6NLa0ePUslI1plwmn3fizkQyayDjYcP04VuSc8F28N/73w
	 PKKKlxHPQaW/Q==
Date: Mon, 09 Mar 2026 20:42:32 -0700
Subject: [PATCHSET v9 2/2] fstests: autonomous self healing of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
In-Reply-To: <20260310033846.GH1105363@frogsfrogsfrogs>
References: <20260310033846.GH1105363@frogsfrogsfrogs>
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

v9: tweak fstests per userspace changes; improve attribution of the
    generic fserror test; fix some bugs pointed out by zorro
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
 * xfs: test xfs_healer startup service
---
 common/config      |   14 +++
 common/module      |   11 +++
 common/rc          |    5 +
 common/systemd     |   39 ++++++++++
 common/xfs         |   98 ++++++++++++++++++++++++
 tests/xfs/1878     |   93 +++++++++++++++++++++++
 tests/xfs/1878.out |   10 ++
 tests/xfs/1879     |   93 +++++++++++++++++++++++
 tests/xfs/1879.out |    8 ++
 tests/xfs/1882     |   44 +++++++++++
 tests/xfs/1882.out |    2 
 tests/xfs/1884     |   89 ++++++++++++++++++++++
 tests/xfs/1884.out |    2 
 tests/xfs/1885     |   59 +++++++++++++++
 tests/xfs/1885.out |    5 +
 tests/xfs/1896     |  210 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1896.out |   21 +++++
 tests/xfs/1897     |  172 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1897.out |    7 ++
 tests/xfs/1898     |   37 +++++++++
 tests/xfs/1898.out |    4 +
 tests/xfs/1899     |  108 +++++++++++++++++++++++++++
 tests/xfs/1899.out |    3 +
 tests/xfs/1900     |  115 ++++++++++++++++++++++++++++
 tests/xfs/1900.out |    2 
 tests/xfs/1901     |  137 ++++++++++++++++++++++++++++++++++
 tests/xfs/1901.out |    2 
 tests/xfs/1902     |  152 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1902.out |    2 
 tests/xfs/1903     |  124 +++++++++++++++++++++++++++++++
 tests/xfs/1903.out |    6 +
 tests/xfs/802      |    4 -
 32 files changed, 1676 insertions(+), 2 deletions(-)
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
 create mode 100755 tests/xfs/1903
 create mode 100644 tests/xfs/1903.out

