Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33465 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728872AbfHFViQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 17:38:16 -0400
Date: Wed, 7 Aug 2019 07:37:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] [PATCH 00/24] mm, xfs: non-blocking inode reclaim
Message-ID: <20190806213708.GK7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190806055744.GC25736@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806055744.GC25736@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Mon, Aug 05, 2019 at 10:57:44PM -0700, Christoph Hellwig wrote:
> Hi Dave,
> 
> do you have a git tree available to look over the whole series?

Not yet, I'll get one up for the next version of the patchset and I
have done some page cache vs inode cache balance testing. That,
FWIW, is not looking good - the vanilla 5.3-rc3 kernel is unable to
maintain a balanced page cache/inode cache working set under steady
state tarball-extraction workloads. Memory reclaim looks to be have
been completely borked from a system balance perspective since I
last looked at it maybe a year ago....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
