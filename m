Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33353 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdIEGmN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 02:42:13 -0400
Received: by mail-io0-f169.google.com with SMTP id y123so10966104iod.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Sep 2017 23:42:12 -0700 (PDT)
Date: Mon, 4 Sep 2017 23:42:08 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical
 sectorsize
Message-ID: <20170905064208.GB15686@vader>
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
 <20170905063139.GA679@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170905063139.GA679@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, sandeen@sandeen.net, Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org

On Mon, Sep 04, 2017 at 11:31:39PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 05, 2017 at 11:14:42AM +0530, Chandan Rajendra wrote:
> > Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
> > physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
> > physical sector size of loop devices. On ppc64, this causes loop devices
> > to have 64k as the physical sector size.
> 
> Eek.  We'll need to revert the loop change ASAP!

Most annoying patch series ever. It hasn't made it to Linus' tree yet,
right? We can revert (although the later change depends on that), fold
in a fix, or apply a fix on top of it, whatever Jens prefers.
