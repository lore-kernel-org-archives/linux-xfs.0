Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39512 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbcI3HLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:11:16 -0400
Date: Fri, 30 Sep 2016 00:11:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/63] xfs: adjust refcount of an extent of blocks in
 refcount btree
Message-ID: <20160930071115.GE18305@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520481871.29434.5402547811567251580.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520481871.29434.5402547811567251580.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

> +#define RCNEXT(rc)	((rc).rc_startblock + (rc).rc_blockcount)

> +#define IS_VALID_RCEXT(ext)	((ext).rc_startblock != NULLAGBLOCK)

I would turn these into inline helpers with nice lower case names.
Not critical for the merge, though, so:

Signed-off-by: Christoph Hellwig <hch@lst.de>
