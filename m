Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52310 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728109AbfGHSqx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 14:46:53 -0400
Date: Mon, 8 Jul 2019 11:46:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 00/11] iomap: regroup code by functional area
Message-ID: <20190708184652.GB20670@infradead.org>
References: <156200051933.1790352.5147420943973755350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156200051933.1790352.5147420943973755350.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jul 01, 2019 at 10:01:59AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series breaks up fs/iomap.c by grouping the functions by major
> functional area (swapfiles, fiemap, seek hole/data, directio, buffered
> writes, buffered reads, page management, and page migration) in separate
> source code files under fs/iomap/.  No functional changes have been
> made.
> 
> Note that this is not the final format of the patches, because I intend
> to pick a point towards the end of the merge window (after everyone
> else's merges have landed), rebase this series atop that, and push it
> back to Linus.  The RFC is posted so that everyone can provide feedback
> on the grouping strategy, not line-specific code movements.
> 
> This has been lightly tested with fstests.  Enjoy!
> Comments and questions are, as always, welcome.

Do you have a branch somewhere for the layout?

To me it seems to be a little too fine grained and creates tons of tiny
files, which make hacking the code painful.
