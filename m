Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44221 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfEWGW6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 May 2019 02:22:58 -0400
Date: Thu, 23 May 2019 08:22:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/17] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190523062235.GA11453@lst.de>
References: <20190520161347.3044-1-hch@lst.de> <20190520161347.3044-15-hch@lst.de> <20190520233233.GF29573@dread.disaster.area> <20190521050943.GA29120@lst.de> <20190521222434.GH29573@dread.disaster.area> <20190522051214.GA19467@lst.de> <20190522061919.GJ29573@dread.disaster.area> <20190522173132.GA31394@lst.de> <20190522232859.GK29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522232859.GK29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 09:28:59AM +1000, Dave Chinner wrote:
> Yeah, that'll make it heaps easier to deal with. I'd rename "bp" in
> that patch to something like "bufp" so it's not easily confused with
> a xfs_buf bp, but otherwise it looks good.

I had that in my original unpublished version, but it seemed to create
a lot of churn.  I'll throw it in as an additional cleanup patch at the
end.
