Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B250B7FA3
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 01:01:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A16AF8F8054
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 23:01:28 -0800 (PST)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	Jhn8YswenvrHHMvF for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 23:01:23 -0800 (PST)
Date: Mon, 2 Feb 2015 15:00:42 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [dgc-xfs:xfs-ioctl-setattr-cleanup 10/12] fs/xfs/xfs_ioctl.c:1102:1:
	sparse: symbol 'xfs_ioctl_setattr_check_extsize' was not declared.
	Should it be static?
Message-ID: <201502021535.BvQbm6Lm%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, kbuild-all@01.org, xfs@oss.sgi.com

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs xfs-ioctl-setattr-cleanup
head:   9b94fcc39822b450af823b3d8cbef6b53ce87ed9
commit: d4388d3c0988ec00787ad1f8e63b5e2a6abef1dc [10/12] xfs: factor extsize hint checking out of xfs_ioctl_setattr
reproduce:
  # apt-get install sparse
  git checkout d4388d3c0988ec00787ad1f8e63b5e2a6abef1dc
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/xfs/xfs_ioctl.c:1102:1: sparse: symbol 'xfs_ioctl_setattr_check_extsize' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
