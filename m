Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52493 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751085AbeEWF6T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 May 2018 01:58:19 -0400
Date: Wed, 23 May 2018 08:03:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/34] iomap: add initial support for writes without
        buffer heads
Message-ID: <20180523060340.GA13873@lst.de>
References: <20180518164830.1552-1-hch@lst.de> <20180518164830.1552-17-hch@lst.de> <20180521232700.GB14384@magnolia> <20180522000745.GU23861@dastard> <20180522082454.GB9801@lst.de> <20180522223806.GX23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522223806.GX23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Wed, May 23, 2018 at 08:38:06AM +1000, Dave Chinner wrote:
> Ok, I missed that detail as it's in a different patch. It looks like
> if (pos > EOF) it will zeroed. But in this case I think that pos ==
> EOF and so it was reading instead. That smells like off-by-one bug
> to me.

This has been fixed in the tree I pushed yesterday already.
