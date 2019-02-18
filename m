Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43688 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfBRJJn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Feb 2019 04:09:43 -0500
Date: Mon, 18 Feb 2019 10:09:42 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/10] xfs: retry COW fork delalloc conversion when no
Message-ID: <20190218090942.GA4899@lst.de>
References: <20190215144725.8894-1-hch@lst.de> <20190215144725.8894-11-hch@lst.de> <20190215233225.GR32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215233225.GR32253@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Feb 15, 2019 at 03:32:25PM -0800, Darrick J. Wong wrote:
> I /think/ the way that this series (+ Brian's before that) solve the
> truncate/writeback race is that we now only convert existing delalloc
> reservations to real extents when we're preparing to do writeback;
> _writepage_map only cares about the mapping of the offset_fsb that it
> happens to be looping right now (because the page lock serializes with
> page cache truncate/punch); and we use the new sequence counters for
> both the data and cow forks to decide when our cached mapping might be
> invalid and therefore we need to get a new mapping?

Well, we already tried to do that before, we just weren't all that good
at it.  The big difference is that the delalloc conversion now doesn't
blindly reuse the range looked up a long time before under a different
ilock critical section, but instead just uses that as a hint and
only converts the extent that the writeback offset falls into, and
only does so if it actually still is in delalloc state.
