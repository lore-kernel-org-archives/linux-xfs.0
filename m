Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27884 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933908AbcI2RXo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 13:23:44 -0400
Date: Thu, 29 Sep 2016 10:23:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v9 00/63] xfs: add reflink and dedupe support
Message-ID: <20160929172305.GW14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <20160929134631.GA17558@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160929134631.GA17558@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 06:46:31AM -0700, Christoph Hellwig wrote:
> Your tree only compiles with a few new warnings for me:
> 
> fs/xfs/xfs_reflink.c: In function ‘xfs_reflink_recover_cow_ag’:
> fs/xfs/xfs_reflink.c:839:8: warning: missing braces around initializer
> [-Wmissing-braces]
>   union xfs_btree_irec  low = {0};
>         ^
> s/xfs/xfs_reflink.c:839:8: warning: (near initialization for
> ‘low.a’) [-Wmissing-braces]
> fs/xfs/xfs_reflink.c:840:8: warning: missing braces around initializer
> [-Wmissing-braces]
>   union xfs_btree_irec  high = {0};
>         ^
> fs/xfs/xfs_reflink.c:840:8: warning: (near initialization for
> ‘high.a’) [-Wmissing-braces]

Hmm, now you're the second person to complain about this.  Evidently
gcc 5.4 doesn't care about this, but older versions (Dave said 4.9.3
also spat these warnings) do care.  Will push out fix.

--D
