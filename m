Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 835317F51
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 02:42:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0BA33AC003
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 00:42:15 -0700 (PDT)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	knBGY6yQN7CaFo6D for <xfs@oss.sgi.com>;
	Wed, 25 Mar 2015 00:42:14 -0700 (PDT)
Date: Wed, 25 Mar 2015 15:42:08 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [dgc-xfs:fallocate-insert-range 10/10]
	fs/xfs/xfs_bmap_util.c:1387:1: sparse: symbol 'xfs_shift_file_space'
	was not declared. Should it be static?
Message-ID: <201503251558.Dje24s0l%fengguang.wu@intel.com>
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
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: linux-kernel@vger.kernel.org, kbuild-all@01.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs fallocate-insert-range
head:   a904b1ca5751faf5ece8600e18cd3b674afcca1b
commit: a904b1ca5751faf5ece8600e18cd3b674afcca1b [10/10] xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
reproduce:
  # apt-get install sparse
  git checkout a904b1ca5751faf5ece8600e18cd3b674afcca1b
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/xfs/xfs_bmap_util.c:1387:1: sparse: symbol 'xfs_shift_file_space' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
