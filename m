Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57066 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbeLUG13 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Dec 2018 01:27:29 -0500
Date: Fri, 21 Dec 2018 07:27:27 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/11] xfs: introduce an always_cow mode
Message-ID: <20181221062727.GA31373@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181203222503.30649-12-hch@lst.de> <20181218232437.GS27208@magnolia> <20181219224335.GB4205@dastard> <20181220070741.GA9803@lst.de> <20181220210309.GE4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220210309.GE4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Dec 21, 2018 at 08:03:09AM +1100, Dave Chinner wrote:
> Yes, I know it's not persistent, but do we care for always_cow mode?
> Preallocation to prevent enospc is done just before the data is
> written, and if we put it in the COW fork then it will mostly just
> work and behave as expected for preventing ENOSPC on subsequent
> writes. Preallocation to control data layout is largely irrelevant
> to always_cow mode, so it really makes no difference to us if the
> preallocation disappears when the inode is cycled out of cache....

I'll have to see if we can get the semantics for the right.
