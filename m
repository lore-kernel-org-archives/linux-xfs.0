Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26593 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755591AbcI2UNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 16:13:45 -0400
Date: Thu, 29 Sep 2016 13:13:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 46/63] xfs: CoW shared EOF block when truncating file
Message-ID: <20160929201317.GC14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503151218.30303.13404244896095456650.stgit@birch.djwong.org>
 <20160929172918.GA18008@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929172918.GA18008@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 10:29:18AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 07:58:32PM -0700, Darrick J. Wong wrote:
> > When shrinking a file, the VFS zeroes everything in the associated
> > page between the new EOF and the previous EOF to avoid leaking data.
> > If this block is shared we need to CoW it before the VFS does its
> > zeroing to avoid corrupting the other files.
> 
> This shouldn't be needed. Zeroing the EOF block goes through the
> iomap interface, which should handle the COW case properly.

Yep.  One more patch gone, yay! :)

Will run a full regression test tonight, but the test that extends a
reflinked file via truncate passes.

--D
