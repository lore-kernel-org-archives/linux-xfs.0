Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56178 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbeDQG6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 02:58:00 -0400
Date: Mon, 16 Apr 2018 23:58:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: cap the length of deduplication requests
Message-ID: <20180417065800.GA2857@infradead.org>
References: <20180417051918.GD5203@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417051918.GD5203@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Mon, Apr 16, 2018 at 10:19:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since deduplication potentially has to read in all the pages in both
> files in order to compare the contents, cap the deduplication request
> length at MAX_RW_COUNT (roughly 2GB) so that we have /some/ upper bound
> on the request length and can't just lock up the kernel forever.  Found
> by running generic/304 after commit 1ddae54555b62 ("common/rc: add
> missing 'local' keywords").

Looks fine.  btrfs limits to 16MB, I guess we don't want to go that low?
