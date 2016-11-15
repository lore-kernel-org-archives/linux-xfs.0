Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55073 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966031AbcKOKQG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:16:06 -0500
Date: Tue, 15 Nov 2016 02:16:05 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/16] libxfs: remove unnecessary hascrc test in btree
 verifiers
Message-ID: <20161115101605.GD1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830450463.26713.17853370356150959278.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830450463.26713.17853370356150959278.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:08:24PM -0700, Darrick J. Wong wrote:
> xfs_btree_sblock_v5hdr_verify already checks _hascrc, so we can
> remove it from the verifier functions.  For whatever reason this
> change made it into the kernel but not xfsprogs.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
