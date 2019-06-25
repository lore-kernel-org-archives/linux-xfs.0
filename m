Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37036 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbfFYLCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 07:02:55 -0400
Date: Tue, 25 Jun 2019 04:02:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12] libfrog: cvt_u64 should use strtoull, not strtoll
Message-ID: <20190625110254.GE9601@infradead.org>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104938235.1172531.7192571581132527840.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156104938235.1172531.7192571581132527840.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Thu, Jun 20, 2019 at 09:49:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> cvt_u64 converts a string to an unsigned 64-bit number, so it should use
> strtoull, not strtoll because we don't want negative numbers here.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
