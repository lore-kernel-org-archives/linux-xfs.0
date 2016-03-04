Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 548FB7CA6
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 08:40:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0A22AC004
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 06:40:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AJcFyxGMuHuwR1yC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 06:40:33 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id A03C9D4E61
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 14:40:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-186.bos.redhat.com [10.18.41.186])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u24EeWrx012667
	for <xfs@oss.sgi.com>; Fri, 4 Mar 2016 09:40:32 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/4] fix up indlen reservations on extent split
Date: Fri,  4 Mar 2016 09:40:27 -0500
Message-Id: <1457102431-5215-1-git-send-email-bfoster@redhat.com>
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

Hi all,

Here's v3 of the delalloc indlen reservation fix. This version
incorporates Christoph's review feedback from v2. The test
instrumentation patch is updated to better compile out bits in !DEBUG
mode and patch 3/3 from v2 is split into two patches. The first
refactors the code and creates the new helper. The second updates the
mechanism to implement block borrowing from the data extent.

As a note, I investigated burying the DEBUG mode stuff down in
xfs_get_blocks(). The hope was that we could artificially mark the
buffers as new to maintain the aggressive block tossing behavior, but as
it turns out, the buffer_new() state is not returned out of that
context. __block_write_begin() zeroes and clears any new buffers in the
event of an error. This does raise the question of how relevant the
buffer_new() checks are in xfs_vm_write_failed(), but that's a separate
issue.

Thoughts, reviews, flames appreciated.

Brian

v3:
- Drop RFC from test instrumentation patch.
- Update test instrumentation patch to use inline helper and compile
  more out in !DEBUG mode.
- Split block borrowing patch into 2 patches.
v2: http://oss.sgi.com/pipermail/xfs/2016-February/047300.html
- Rebase to latest for-next branch.
- Include RFC test instrumentation patch.
v1: http://oss.sgi.com/archives/xfs/2014-10/msg00294.html
- xfs_bunmapi() code into independent patch.
- Refactor fix into separate helper function.
rfc: http://oss.sgi.com/archives/xfs/2014-09/msg00337.html

Brian Foster (4):
  xfs: debug mode forced buffered write failure
  xfs: update freeblocks counter after extent deletion
  xfs: refactor delalloc indlen reservation split into helper
  xfs: borrow indirect blocks from freed extent when available

 fs/xfs/libxfs/xfs_bmap.c | 161 ++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_aops.c        |   9 ++-
 fs/xfs/xfs_mount.h       |  25 ++++++++
 fs/xfs/xfs_sysfs.c       |  78 ++++++++++++++++++++---
 4 files changed, 219 insertions(+), 54 deletions(-)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
