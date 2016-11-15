Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33792 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941354AbcKOKYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:24:55 -0500
Date: Tue, 15 Nov 2016 02:24:51 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/10] xfs: defer should abort intent items if the trans
 roll fails
Message-ID: <20161115102451.GW1607@infradead.org>
References: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
 <147830463967.27129.5595100010243490335.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830463967.27129.5595100010243490335.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:10:39PM -0700, Darrick J. Wong wrote:
> If the deferred ops transaction roll fails, we need to abort the intent
> items if we haven't already logged a done item for it, regardless of
> whether or not the deferred ops has had a transaction committed.  Dave
> found this while running generic/388.
> 
> Move the tracepoint to make it easier to track object lifetimes.
> 
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
