Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38462 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163782AbeBOVrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Feb 2018 16:47:13 -0500
Date: Thu, 15 Feb 2018 13:47:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
Message-ID: <20180215214708.GA10446@infradead.org>
References: <151873070632.53899.3320294279108510082.stgit@djiang5-desk3.ch.intel.com>
 <151873085471.53899.4916392112937742603.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151873085471.53899.4916392112937742603.stgit@djiang5-desk3.ch.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>
Cc: darrick.wong@oracle.com, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, dan.j.williams@intel.com

> +	if ((XFS_IS_REALTIME_INODE(ip)) &&

No need for the inner braces.

Except for that the whole series looks fine to me.
