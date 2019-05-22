Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51861 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726553AbfEVX3D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 May 2019 19:29:03 -0400
Date: Thu, 23 May 2019 09:28:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/17] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190522232859.GK29573@dread.disaster.area>
References: <20190520161347.3044-1-hch@lst.de>
 <20190520161347.3044-15-hch@lst.de>
 <20190520233233.GF29573@dread.disaster.area>
 <20190521050943.GA29120@lst.de>
 <20190521222434.GH29573@dread.disaster.area>
 <20190522051214.GA19467@lst.de>
 <20190522061919.GJ29573@dread.disaster.area>
 <20190522173132.GA31394@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522173132.GA31394@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 07:31:32PM +0200, Christoph Hellwig wrote:
> Does this look fine to you?
> 
> http://git.infradead.org/users/hch/xfs.git/commitdiff/8d9600456c6674453dddd5bf36512658c39d7207

Yeah, that'll make it heaps easier to deal with. I'd rename "bp" in
that patch to something like "bufp" so it's not easily confused with
a xfs_buf bp, but otherwise it looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
