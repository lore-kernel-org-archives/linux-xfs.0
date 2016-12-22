Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32793 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755644AbcLVJ3A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 04:29:00 -0500
Date: Thu, 22 Dec 2016 01:28:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: use the actual AG length when reserving blocks
Message-ID: <20161222092858.GA10562@infradead.org>
References: <20161221001015.GE9865@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161221001015.GE9865@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Dec 20, 2016 at 04:10:15PM -0800, Darrick J. Wong wrote:
> We need to use the actual AG length when making per-AG reservations,
> since we could otherwise end up reserving more blocks out of the last
> AG than there are actual blocks.
> 
> Complained-about-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
