Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D84637F60
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 11:40:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 724AEAC012
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 09:40:11 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id hRWnT3LN6fAqaPkN for
	<xfs@oss.sgi.com>; Tue, 02 Jul 2013 09:40:08 -0700 (PDT)
From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH 00/13] Getting rid of get_unused_fd()
Date: Tue,  2 Jul 2013 18:39:24 +0200
Message-Id: <cover.1372777600.git.ydroneaud@opteya.com>
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
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Eric Paris <eparis@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Yann Droneaud <ydroneaud@opteya.com>

Hi,

Macro get_unused_fd() is a shortcut to call function get_unused_fd_flags(),
to allocate a file descriptor.

The macro use 0 as flags, so the file descriptor is created
without O_CLOEXEC flag.

This can be seen as an unsafe default eg. in most case O_CLOEXEC
must be used to not leak file descriptor across exec().

Newer kernel code should use anon_inode_getfd() or get_unused_fd_flags()
with flags provided by userspace. If flags cannot be given by userspace,
O_CLOEXEC must be the default flag.

Using O_CLOEXEC by default allows userspace to choose, without race,
if the file descriptor is going to be inherited across exec().

They are two ways to achieve this:

- makes get_unused_fd() use O_CLOEXEC by default

  It's difficult to get it right: every code using of get_unused_fd()
  must take this change into account and be fixed as soon as
  macro get_unused_fd() do the switch. Non updated code will have
  unexpected behavor and it's likely going to break API contract.

- remove get_unused_fd()

  It's going to break some out of tree, not yet upstream kernel code,
  but it's easy to notice and fix. Anyway, newer code should use
  anon_inode_getfd() or get_unused_fd_flags().

The latter option was choosen to ensure no unexpected behavor
for out of tree, not yet upstream code. Removing the macro is the safest
choice: it's better to break build than trying to make get_unused_fd()
use O_CLOEXEC by default and get all user of get_unused_fd() update.

Additionnaly, removing the macro is not going to break modules ABI.

In linux-next tag 20130702, they're currently:

- 15 calls to get_unused_fd_flags()
     not counting get_unused_fd() and anon_inode_getfd()
- 14 calls to get_unused_fd()
- 11 calls to anon_inode_getfd()

The following patchset try to convert all calls to get_unused_fd()
to get_unused_fd_flags(0) before removing get_unused_fd() macro.

Without get_unused_fd() macro, more subsystems are likely to use
anon_inode_getfd() and be teached to provide an API that let userspace
choose the opening flags of the file descriptor.

Yann Droneaud (13):
  ia64: use get_unused_fd_flags(0) instead of get_unused_fd()
  ppc/cell: use get_unused_fd_flags(0) instead of get_unused_fd()
  infiniband: use get_unused_fd_flags(0) instead of get_unused_fd()
  android/sw_sync: use get_unused_fd_flags(0) instead of get_unused_fd()
  android/sync: use get_unused_fd_flags(0) instead of get_unused_fd()
  vfio: use get_unused_fd_flags(0) instead of get_unused_fd()
  binfmt_misc: use get_unused_fd_flags(0) instead of get_unused_fd()
  file: use get_unused_fd_flags(0) instead of get_unused_fd()
  fanotify: use get_unused_fd_flags(0) instead of get_unused_fd()
  xfs: use get_unused_fd_flags(0) instead of get_unused_fd()
  events: use get_unused_fd_flags(0) instead of get_unused_fd()
  sctp: use get_unused_fd_flags(0) instead of get_unused_fd()
  file: remove get_unused_fd()

 arch/ia64/kernel/perfmon.c                | 2 +-
 arch/powerpc/platforms/cell/spufs/inode.c | 4 ++--
 drivers/infiniband/core/uverbs_cmd.c      | 4 ++--
 drivers/staging/android/sw_sync.c         | 2 +-
 drivers/staging/android/sync.c            | 2 +-
 drivers/vfio/vfio.c                       | 2 +-
 fs/binfmt_misc.c                          | 2 +-
 fs/file.c                                 | 2 +-
 fs/notify/fanotify/fanotify_user.c        | 2 +-
 fs/xfs/xfs_ioctl.c                        | 2 +-
 include/linux/file.h                      | 1 -
 kernel/events/core.c                      | 2 +-
 net/sctp/socket.c                         | 2 +-
 13 files changed, 14 insertions(+), 15 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
