Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60081 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbcI2RFi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 13:05:38 -0400
Date: Thu, 29 Sep 2016 10:05:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 43/63] xfs: teach get_bmapx about shared extents and the
 CoW fork
Message-ID: <20160929170537.GI4546@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503149320.30303.9720221974285402096.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503149320.30303.9720221974285402096.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Sep 27, 2016 at 07:58:13PM -0700, Darrick J. Wong wrote:
> +#define BMV_IF_COWFORK		0x20	/* return CoW fork rather than data */

I think exposing an implementation detail like the COW fork that has
no on-disk equivalent is a bad idea and would feel much better if this
part of the patch was dropped.

