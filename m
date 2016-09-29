Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34823 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932267AbcI2VYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 17:24:03 -0400
Date: Thu, 29 Sep 2016 14:23:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 46/63] xfs: CoW shared EOF block when truncating file
Message-ID: <20160929212334.GI14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503151218.30303.13404244896095456650.stgit@birch.djwong.org>
 <20160929172918.GA18008@infradead.org>
 <20160929201317.GC14092@birch.djwong.org>
 <20160929202220.GA6575@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929202220.GA6575@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 01:22:20PM -0700, Christoph Hellwig wrote:
> On Thu, Sep 29, 2016 at 01:13:18PM -0700, Darrick J. Wong wrote:
> > Will run a full regression test tonight, but the test that extends a
> > reflinked file via truncate passes.
> 
> Thanks.  Module the few comments from today the series looks fine
> and passes testing both locally and over NFS here.  I'd say everything
> else left is probably something we could fixup post merge.

Ok.  I've incorporated everybody's comments into the patchset and it's
running through regression tests now.  Barring any major failures, I'm
going to re-patchbomb and push another branch to github this
afternoon.

The big change will be the reintroduction of the fallocate
UNSHARE_RANGE mode flag; can you have a look at both the VFS patch and
the unshare patch to see if it passes the smell test?

Basically, we take the existing functionality:

falloc(fd, 0, ...) => fill the holes
falloc(fd, KEEP_SIZE, ...) => fill the holes, don't change file size

Add these two features:

falloc(fd, UNSHARE, ...) => fill the holes, pre-COW shared extents
falloc(fd, UNSHARE|KEEP_SIZE, ...) => fill the holes, pre-COW shared
                                      extents, don't change file size

And prohibit this:

falloc(fd, UNSHARE|(any of punch, zero, insert, collapse), ...) =>
	-EINVAL

--D
