Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47329 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941132AbcIZAIH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 25 Sep 2016 20:08:07 -0400
Date: Mon, 26 Sep 2016 02:08:05 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Message-ID: <20160926000805.GA32252@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de> <1473438884-674-7-git-send-email-hch@lst.de> <20160909225557.GF30056@dastard> <20160910073646.GA18547@lst.de> <20160913155126.GA10622@linux.intel.com> <20160914070633.GA17278@lst.de> <20160923210237.GA23346@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160923210237.GA23346@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Fri, Sep 23, 2016 at 03:02:37PM -0600, Ross Zwisler wrote:
> I can just add a hack to hop over the writeback in generic_file_read_iter(),
> but I hesitate to do this because it seems like the correct thing to do is to
> separate the ext4 DAX & DIO paths, which I think you are already doing.

I've started on it, and the read path works fine.  I'm a bit stuck on
the write side as my attempts at it seems to corrupt data fairly easily
when running xfstests.

> I believe that my DAX PMD patches are ready to go, but because of this issue
> they currently only support XFS.  I'm tempted to send them out as they are
> right now since they add a bunch of complexity to DAX that we need to review,
> and that review can fully happen with only XFS support. We can add ext4
> support back in later when it's ready.

Yes, please send them out.  We really should move ext4 over to iomap for
DAX.  I'd love to get some help from someone more familar with ext4,
and can send my code dump to get started.
