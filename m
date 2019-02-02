Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60602 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728267AbfBBQHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 11:07:17 -0500
Date: Sat, 2 Feb 2019 08:07:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190202160714.GA12145@infradead.org>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897672012.26065.1375987197453969157.stgit@magnolia>
 <20190201080343.GD22295@infradead.org>
 <20190201235900.GX6173@dastard>
 <20190202043159.GN5761@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190202043159.GN5761@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 08:31:59PM -0800, Darrick J. Wong wrote:
> 
> I wrote a silly program to open as many O_TMPFILE files as it can and
> then close them all.  I wrapped that in a script to crank up ulimit -n
> to fs.file_max (which on this VM was about 194000 files) and came up
> with this on a 5.0-rc4 kernel with deferred inactivation and iunlink
> backref caching:

Ah, cool.  Maybe throw a one-line summary of the results into the commit
log for the next version.
