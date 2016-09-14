Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48023 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755890AbcINHGl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Sep 2016 03:06:41 -0400
Date: Wed, 14 Sep 2016 09:06:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Message-ID: <20160914070633.GA17278@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de> <1473438884-674-7-git-send-email-hch@lst.de> <20160909225557.GF30056@dastard> <20160910073646.GA18547@lst.de> <20160913155126.GA10622@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160913155126.GA10622@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Tue, Sep 13, 2016 at 09:51:26AM -0600, Ross Zwisler wrote:
> I'm working on this right now.  I expect that most/all of the infrastructure
> between the bh+get_block_t version and the iomap version to be shared, it'll
> just be a matter of having a PMD version of the iomap fault handler.  This
> should be pretty minor.

Yes, I looked at it (although I didn't do any work yet), and the work
should be fairly easy.

> Let's see how it goes, but right now my plan is to have both - I'd like to
> keep feature parity between ext2/ext4 and XFS, and that means having PMD
> faults in ext4 via bh+get_block_t until they move over to iomap.
> 
> Regarding coordination, the PMD v2 series hasn't gotten much review so far, so
> I'm not sure it'll go in for v4.9.  At this point I'm planning on just
> rebasing on top of your iomap series, though if it gets taken sooner I
> wouldn't object.

So let's do iomap first.  I've got stable ext2 support, as well as support
for the block device, although I'm not sure what the proper testing
protocol for that is.  I've started ext4 and read / zero was easy, but
now I'm stuck in the convoluted mess that is the ext4 direct I/O and
DAX path.

Maybe we should get the iomap work into 4.9 and then convert over ext4
as well as adding PMD fault support in the next release.
