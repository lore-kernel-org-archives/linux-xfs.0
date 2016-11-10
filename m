Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40725 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932259AbcKJTSB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Nov 2016 14:18:01 -0500
Date: Thu, 10 Nov 2016 20:17:12 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] xfs: fix the AG loop in xfs_alloc_vextent for busy
        extents
Message-ID: <20161110191712.GA20980@lst.de>
References: <1476735753-5861-1-git-send-email-hch@lst.de> <1476735753-5861-2-git-send-email-hch@lst.de> <20161108061539.GB28922@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161108061539.GB28922@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On Tue, Nov 08, 2016 at 05:15:39PM +1100, Dave Chinner wrote:
> Here's the problem: At ENOSPC, we dirty AG headers fixing freelists,
> then fail to allocate inodes, resulting in a shutdown - a regression
> that xfs/076 trips over quite regularly on my test machines.

I could not reproduce it, but based on the discussion with Brian I
agree.  But that sad part is that this bug already exists in the
existing code due to the busy extent tracking code - my little
patch just made it a lot easier to hit.  I'll see how I can come up
with a proper fix for it.
