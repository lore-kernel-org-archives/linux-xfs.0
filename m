Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36262 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731477AbeGSRai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 13:30:38 -0400
Date: Thu, 19 Jul 2018 09:46:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] xfs: clean up xfs_btree_del_cursor callers
Message-ID: <20180719164638.GG10151@infradead.org>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192905779.31685.9007503975897283723.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153192905779.31685.9007503975897283723.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 08:50:57AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Less trivial cleanups of the error argument to xfs_btree_del_cursor;
> these require some minor code refactoring.

Both cases don't rely share a common patter, why have them in a single
patch?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
