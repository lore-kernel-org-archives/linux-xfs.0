Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50891 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbcI3IXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:23:19 -0400
Date: Fri, 30 Sep 2016 01:23:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 51/63] xfs: garbage collect old cowextsz reservations
Message-ID: <20160930082317.GD32335@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520507171.29434.10328089950905629681.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520507171.29434.10328089950905629681.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

I don't really like the eof_scan_owner magic, but that's just copying
the existing eofblock scan code, so I guess I shouldn't complain here.

Besides that and what appears to generally be a lot of duplication of
the eofblock scanning code this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

