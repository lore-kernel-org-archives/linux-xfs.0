Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54933 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750700AbcI2Nqd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 09:46:33 -0400
Date: Thu, 29 Sep 2016 06:46:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v9 00/63] xfs: add reflink and dedupe support
Message-ID: <20160929134631.GA17558@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

Your tree only compiles with a few new warnings for me:

fs/xfs/xfs_reflink.c: In function ‘xfs_reflink_recover_cow_ag’:
fs/xfs/xfs_reflink.c:839:8: warning: missing braces around initializer
[-Wmissing-braces]
  union xfs_btree_irec  low = {0};
        ^
s/xfs/xfs_reflink.c:839:8: warning: (near initialization for
‘low.a’) [-Wmissing-braces]
fs/xfs/xfs_reflink.c:840:8: warning: missing braces around initializer
[-Wmissing-braces]
  union xfs_btree_irec  high = {0};
        ^
fs/xfs/xfs_reflink.c:840:8: warning: (near initialization for
‘high.a’) [-Wmissing-braces]
