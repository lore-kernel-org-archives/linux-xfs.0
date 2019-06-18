Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39928 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfFRSRd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 14:17:33 -0400
Date: Tue, 18 Jun 2019 11:17:32 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: separate inode geometry
Message-ID: <20190618181732.GA873@infradead.org>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
 <155968493890.1657505.14039176301049696712.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968493890.1657505.14039176301049696712.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

Sorry for spotting this so late, but this one is pretty bogus as-is.

The geometry information is not an on-disk structure in any sense,
and has absolutely no business in xfs_format.h.
