Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCCC10E1
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 00:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Sam James <sam@gentoo.org>
Subject: [PATCH v2 0/4] LFS and time64 fixes
Date: Fri, 15 Dec 2023 00:42:09 +0000
Message-ID: <20231215004333.860034-1-sam@gentoo.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Require 64-bit off_t & time_t, pass the relevant macros to enable them, and
adapt some printfs accordingly.

Tested on x86_64-pc-linux-gnu, i686-pc-linux-gnu, armv7a-unknown-linux-gnueabihf.

Sam James (3):
  io: Assert we have a sensible off_t
  build: Request 64-bit time_t where possible
  io: Adapt to >= 64-bit time_t

Violet Purcell (1):
  Remove use of LFS64 interfaces

 copy/xfs_copy.c           |  2 +-
 fsr/xfs_fsr.c             |  2 +-
 include/builddefs.in      |  4 ++--
 io/bmap.c                 |  6 +++---
 io/copy_file_range.c      |  4 ++--
 io/cowextsize.c           |  6 +++---
 io/fadvise.c              |  2 +-
 io/fiemap.c               |  6 +++---
 io/fsmap.c                |  6 +++---
 io/init.c                 |  3 +++
 io/io.h                   | 10 +++++-----
 io/madvise.c              |  2 +-
 io/mincore.c              |  2 +-
 io/mmap.c                 | 13 +++++++------
 io/pread.c                | 22 +++++++++++-----------
 io/pwrite.c               | 20 ++++++++++----------
 io/reflink.c              |  4 ++--
 io/seek.c                 |  6 +++---
 io/sendfile.c             |  6 +++---
 io/stat.c                 |  8 ++++----
 io/sync_file_range.c      |  2 +-
 io/truncate.c             |  2 +-
 libxfs/rdwr.c             |  8 ++++----
 mdrestore/xfs_mdrestore.c |  2 +-
 repair/prefetch.c         |  2 +-
 scrub/spacemap.c          |  6 +++---
 spaceman/freesp.c         |  4 ++--
 spaceman/trim.c           |  2 +-
 28 files changed, 83 insertions(+), 79 deletions(-)

-- 
2.43.0

