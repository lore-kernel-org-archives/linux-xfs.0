Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:48155 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbdHaAHF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 20:07:05 -0400
Date: Thu, 31 Aug 2017 10:07:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning after merge of the xfs tree
Message-ID: <20170831100703.16eeb69f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

Hi all,

After merging the xfs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/xfs/xfs_buf_item.c: In function 'xfs_buf_item_unlock':
fs/xfs/xfs_buf_item.c:573:9: warning: unused variable 'ordered' [-Wunused-variable]
  bool   ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
         ^

Introduced by commit

  a097077ef708 ("xfs: remove unnecessary dirty bli format check for ordered bufs")

-- 
Cheers,
Stephen Rothwell
