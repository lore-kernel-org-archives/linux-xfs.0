Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 386317F7B
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 14:12:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29D9430406B
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:18 -0800 (PST)
Received: from mail-pb0-f74.google.com (mail-pb0-f74.google.com
	[209.85.160.74]) by cuda.sgi.com with ESMTP id jsTSTCHs3LkALSS2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:16 -0800 (PST)
Received: by mail-pb0-f74.google.com with SMTP id uo5so882364pbc.5
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:16 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH 00/10] Add tmpfs filesystem support
Date: Tue, 10 Dec 2013 12:11:51 -0800
Message-Id: <1386706321-15795-1-git-send-email-jayr@google.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

Hi all,

Boris Ranto has sent a series of 3 patches adding tmpfs support.
http://oss.sgi.com/archives/xfs/2013-05/msg00069.html

This one only contains the first patch from Boris Ranto's series followed by
more patches in order to either run or not run all generic tests instead of
failing.

This one does not contains other 2 patches in Boris Ranto's series just because
rest these patehes do not depend on those, but it will be nice if those are
also reviewed as well.

Boris Ranto (1):
  xfstests: Add tmpfs support

Hugh Dickins (3):
  xfstests: use mount point instead of device name
  xfstests: _scratch_mkfs_sized() for tmpfs
  xfstests: add executable permission to tests

Junho Ryu (6):
  xfstests: increase tmpfs memory size
  xfstests: do not unmount tmpfs during remount.
  xfstests: fix generic/225 to check fiemap support
  xfstests: fix generic/127 to call _cleanup() only once
  xfstests: check O_DIRECT support before testing direct I/O
  xfstests: skip parts of tests which cannot work on tmpfs

 check                 |  2 ++
 common/rc             | 78 +++++++++++++++++++++++++++++++++++++++++++++++++--
 tests/generic/053     |  6 ++--
 tests/generic/076     |  2 ++
 tests/generic/091     |  1 +
 tests/generic/127     |  1 -
 tests/generic/130     |  1 +
 tests/generic/133     |  1 +
 tests/generic/135     | 18 +++---------
 tests/generic/169     | 20 ++++---------
 tests/generic/169.out |  6 ++--
 tests/generic/192     |  3 +-
 tests/generic/225     |  1 +
 tests/generic/226     |  4 +--
 tests/generic/256     |  2 +-
 tests/generic/258     |  3 +-
 tests/generic/263     |  1 +
 tests/generic/273     |  2 +-
 tests/generic/277     |  2 ++
 tests/generic/299     |  1 +
 tests/generic/300     |  1 +
 tests/generic/306     |  3 +-
 tests/generic/311     |  0
 tests/generic/314     |  0
 tests/generic/315     |  0
 tests/generic/321     |  0
 tests/generic/322     |  0
 27 files changed, 110 insertions(+), 49 deletions(-)
 mode change 100644 => 100755 tests/generic/311
 mode change 100644 => 100755 tests/generic/314
 mode change 100644 => 100755 tests/generic/315
 mode change 100644 => 100755 tests/generic/321
 mode change 100644 => 100755 tests/generic/322

-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
