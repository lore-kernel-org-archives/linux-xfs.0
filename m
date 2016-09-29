Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45471 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755529AbcI2TvP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 15:51:15 -0400
Date: Thu, 29 Sep 2016 12:51:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 43/63] xfs: teach get_bmapx about shared extents and the
 CoW fork
Message-ID: <20160929195112.GA26321@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503149320.30303.9720221974285402096.stgit@birch.djwong.org>
 <20160929170537.GI4546@infradead.org>
 <20160929174059.GX14092@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929174059.GX14092@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 10:40:59AM -0700, Darrick J. Wong wrote:
> There are a few xfstests that check the contents of the CoW extent fork
> to make sure it's working properly.  How about a compromise -- leave the
> flag in, but return -EINVAL unless CONFIG_XFS_DEBUG=y ?

Personally I'd prefer to remove it.  Maybe we'll need Dave as a tie
breaker?
