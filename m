Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58941 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbeBWCCo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Feb 2018 21:02:44 -0500
Date: Fri, 23 Feb 2018 03:02:43 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: don't block on the ilock for RWF_NOWAIT
Message-ID: <20180223020243.GA5611@lst.de>
References: <20180222150653.18479-1-hch@lst.de> <20180223000819.GJ7000@dastard> <20180223002242.GA4007@lst.de> <20180223010326.GL7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180223010326.GL7000@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Feb 23, 2018 at 12:03:26PM +1100, Dave Chinner wrote:
> Where can I find all of your patches, because it seems we're
> unnecessarily duplicating a lot of work in this area...

I've pushed my current O_ATOMIC WIP tree here:

    git://git.infradead.org/users/hch/xfs.git O_ATOMIC-wip

gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/O_ATOMIC-wip

Note that at least the last commit is most certainly actually broken
at the moment, and also too ugly to live without further refactoring.
