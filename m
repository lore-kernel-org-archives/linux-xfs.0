Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B44CF7CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 20:08:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A6AD304043
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 18:08:09 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id YXeVvMiTyATTHZIe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 18:07:59 -0700 (PDT)
Date: Thu, 21 Jul 2016 11:07:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the xfs tree with Linus' tree
Message-ID: <20160721110756.7a905ee8@canb.auug.org.au>
MIME-Version: 1.0
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
To: David Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Jann Horn <jann@thejh.net>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the xfs tree got a conflict in:

  fs/xfs/xfs_ioctl.c

between commit:

  3e0a39654645 ("xfs: fix type confusion in xfs_ioc_swapext")

from Linus' tree and commit:

  7f1b62457b58 ("xfs: fix type confusion in xfs_ioc_swapext")

from the xfs tree.

These are not quite the same patch :-(

I fixed it up (I used the version in the xfs tree) and can carry the
fix as necessary. This is now fixed as far as linux-next is concerned,
but any non trivial conflicts should be mentioned to your upstream
maintainer when your tree is submitted for merging.  You may also want
to consider cooperating with the maintainer of the conflicting tree to
minimise any particularly complex conflicts.

-- 
Cheers,
Stephen Rothwell

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
