Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46202 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755499AbcI2UWW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 16:22:22 -0400
Date: Thu, 29 Sep 2016 13:22:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 46/63] xfs: CoW shared EOF block when truncating file
Message-ID: <20160929202220.GA6575@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503151218.30303.13404244896095456650.stgit@birch.djwong.org>
 <20160929172918.GA18008@infradead.org>
 <20160929201317.GC14092@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929201317.GC14092@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 01:13:18PM -0700, Darrick J. Wong wrote:
> Will run a full regression test tonight, but the test that extends a
> reflinked file via truncate passes.

Thanks.  Module the few comments from today the series looks fine
and passes testing both locally and over NFS here.  I'd say everything
else left is probably something we could fixup post merge.
