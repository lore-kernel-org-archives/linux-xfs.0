Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKIId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 03:08:33 -0500
Date: Mon, 11 Feb 2019 00:08:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190211080831.GA16422@infradead.org>
References: <154947207759.22369.11575570374120223292.stgit@magnolia>
 <154947213625.22369.7330296004413590907.stgit@magnolia>
 <20190207143114.GB2880@bfoster>
 <20190208080016.GB5523@infradead.org>
 <20190208120623.GA21317@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190208120623.GA21317@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Feb 08, 2019 at 07:06:24AM -0500, Brian Foster wrote:
> It's not clear to me whether you're suggesting we return 0, error or
> nothing at all here. The assert otherwise seems fine to me as I don't
> think we'd ever expect anything outside of success or -ENOMEM.

I'm arguing that we should return nothing.

> That said, I don't see any reason to ever leak an iu if we know it
> didn't make it into the table. I could probably go either way on whether
> we wanted to allow the filesystem to continue or not on unexpected
> insert errors. The original comment was just that we probably shouldn't
> explode on "expected" errors like -ENOSPC.

Well, IFF the only error case that should happen is either ENOMEM or
E2BIG we don't have an allocation in that case.  Everything else is
a programming bug where we should assert / shut the file system down,
in which case the tiny leak is the least of our problems.
