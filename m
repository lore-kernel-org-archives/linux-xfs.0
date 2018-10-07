Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41705 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbeJGRUH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Oct 2018 13:20:07 -0400
Date: Sun, 7 Oct 2018 12:13:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/8] xfs: remove magic handling of unwritten extents in
 xfs_bmapi_allocate
Message-ID: <20181007101319.GA25721@lst.de>
References: <20181002174207.25275-1-hch@lst.de> <20181002174207.25275-4-hch@lst.de> <20181006093433.GA18095@dastard> <20181006094331.GA5845@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181006094331.GA5845@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Sat, Oct 06, 2018 at 11:43:31AM +0200, Christoph Hellwig wrote:
> I suspect the asserts actually are what is incorrect.  But given
> how late we are in the cycle I've just dropped the patch and kicked
> off xfstests runs (now including rmap, sigh..).

Without this patch test runs including rmap succeed.  Do you want
me to resend with the patch dropped (thing should just apply without
it as-is).
