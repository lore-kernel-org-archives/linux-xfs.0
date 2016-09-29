Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38014 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934123AbcI2Rl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 13:41:28 -0400
Date: Thu, 29 Sep 2016 10:40:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 43/63] xfs: teach get_bmapx about shared extents and the
 CoW fork
Message-ID: <20160929174059.GX14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503149320.30303.9720221974285402096.stgit@birch.djwong.org>
 <20160929170537.GI4546@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929170537.GI4546@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 10:05:37AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 07:58:13PM -0700, Darrick J. Wong wrote:
> > +#define BMV_IF_COWFORK		0x20	/* return CoW fork rather than data */
> 
> I think exposing an implementation detail like the COW fork that has
> no on-disk equivalent is a bad idea and would feel much better if this
> part of the patch was dropped.

There are a few xfstests that check the contents of the CoW extent fork
to make sure it's working properly.  How about a compromise -- leave the
flag in, but return -EINVAL unless CONFIG_XFS_DEBUG=y ?

--D
