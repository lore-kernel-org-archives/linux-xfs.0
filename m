Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077A9C3A59B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 04:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C932087E
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 04:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbfHSEkQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 00:40:16 -0400
Received: from verein.lst.de ([213.95.11.211]:44271 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfHSEkQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Aug 2019 00:40:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 699AC68B02; Mon, 19 Aug 2019 06:40:12 +0200 (CEST)
Date:   Mon, 19 Aug 2019 06:40:12 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190819044012.GA15800@lst.de>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com> <20190818071128.GA17286@lst.de> <20190818074140.GA18648@lst.de> <20190818173426.GA32311@lst.de> <20190819000831.GX6129@dread.disaster.area> <20190819034948.GA14261@lst.de> <20190819041132.GA14492@lst.de> <20190819042259.GZ6129@dread.disaster.area> <20190819042905.GA15613@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819042905.GA15613@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 06:29:05AM +0200, hch@lst.de wrote:
> On Mon, Aug 19, 2019 at 02:22:59PM +1000, Dave Chinner wrote:
> > That implies a kmalloc heap issue.
> > 
> > Oh, is memory poisoning or something that modifies the alignment of
> > slabs turned on?
> > 
> > i.e. 4k/8k allocations from the kmalloc heap slabs might not be
> > appropriately aligned for IO, similar to the problems we have with
> > the xen blk driver?
> 
> That is what I suspect, and as you can see in the attached config I
> usually run with slab debuggig on.

Yep, looks like an unaligned allocation:

root@testvm:~# mount /dev/pmem1 /mnt/
[   62.346660] XFS (pmem1): Mounting V5 Filesystem
[   62.347960] unaligned allocation, offset = 680
[   62.349019] unaligned allocation, offset = 680
[   62.349872] unaligned allocation, offset = 680
[   62.350703] XFS (pmem1): totally zeroed log
[   62.351443] unaligned allocation, offset = 680
[   62.452203] unaligned allocation, offset = 344
[   62.528964] XFS: Assertion failed: head_blk != tail_blk, file:
fs/xfs/xfs_lo6
[   62.529879] ------------[ cut here ]------------
[   62.530334] kernel BUG at fs/xfs/xfs_message.c:102!
[   62.530824] invalid opcode: 0000 [#1] SMP PTI

With the following debug patch.  Based on that I think I'll just
formally submit the vmalloc switch as we're at -rc5, and then we
can restart the unaligned slub allocation drama..


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 13d1d3e95b88..6a098d35931a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -97,6 +97,9 @@ xlog_alloc_buffer(
 	struct xlog	*log,
 	int		nbblks)
 {
+	void		*ret;
+	unsigned long	offset;
+
 	/*
 	 * Pass log block 0 since we don't have an addr yet, buffer will be
 	 * verified on read.
@@ -125,7 +128,14 @@ xlog_alloc_buffer(
 	if (nbblks > 1 && log->l_sectBBsize > 1)
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
-	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL);
+	ret = kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL);
+	if (!ret)
+		return NULL;
+	offset = offset_in_page(ret);
+	if (offset % 512)
+		printk("unaligned allocation, offset = %lu\n",
+			offset);
+	return ret;
 }
 
 /*


