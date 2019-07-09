Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60904 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfGIQuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 12:50:10 -0400
Date: Tue, 9 Jul 2019 09:49:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 00/11] iomap: regroup code by functional area
Message-ID: <20190709164952.GT1404256@magnolia>
References: <156200051933.1790352.5147420943973755350.stgit@magnolia>
 <20190708184652.GB20670@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708184652.GB20670@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jul 08, 2019 at 11:46:52AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 01, 2019 at 10:01:59AM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This series breaks up fs/iomap.c by grouping the functions by major
> > functional area (swapfiles, fiemap, seek hole/data, directio, buffered
> > writes, buffered reads, page management, and page migration) in separate
> > source code files under fs/iomap/.  No functional changes have been
> > made.
> > 
> > Note that this is not the final format of the patches, because I intend
> > to pick a point towards the end of the merge window (after everyone
> > else's merges have landed), rebase this series atop that, and push it
> > back to Linus.  The RFC is posted so that everyone can provide feedback
> > on the grouping strategy, not line-specific code movements.
> > 
> > This has been lightly tested with fstests.  Enjoy!
> > Comments and questions are, as always, welcome.
> 
> Do you have a branch somewhere for the layout?

I sent it out to for-next to see what it would collide with:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/log/?h=iomap-5.3-merge

Though I'll probably rebase it after the mm and block merges (which
might have already happened).

> To me it seems to be a little too fine grained and creates tons of tiny
> files, which make hacking the code painful.

It's nine files and now code is grouped by functional area which makes
it easier to keep track of which functions go with the publicly exposed
iomap apis.  I don't think we're going to more than a half dozen more
files ever.

--D
