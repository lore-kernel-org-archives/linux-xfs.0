Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48787 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752289AbcINJxz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Sep 2016 05:53:55 -0400
Date: Wed, 14 Sep 2016 11:53:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Message-ID: <20160914095352.GA21877@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de> <1473438884-674-7-git-send-email-hch@lst.de> <20160909225557.GF30056@dastard> <20160910073646.GA18547@lst.de> <20160913155126.GA10622@linux.intel.com> <20160914070633.GA17278@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160914070633.GA17278@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Wed, Sep 14, 2016 at 09:06:33AM +0200, Christoph Hellwig wrote:
> So let's do iomap first.  I've got stable ext2 support, as well as support
> for the block device, although I'm not sure what the proper testing
> protocol for that is.

Well, turns out DAX on block devices actually is dead despite a few
leftovers and there is no way to actually test it.  That was easy :)
