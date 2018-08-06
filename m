Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56471 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729724AbeHFRyK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Aug 2018 13:54:10 -0400
Date: Mon, 6 Aug 2018 17:49:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 0/2] ext4: fix DAX dma vs truncate/hole-punch
Message-ID: <20180806154943.GA17666@lst.de>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com> <20180711081741.lmr44sp4cmt3f6um@quack2.suse.cz> <20180725222839.GA28304@linux.intel.com> <CAOxpaSWCT+XRtGxGQT_PVMcn79csMxbqb+cf4yycbV3eqjjnkQ@mail.gmail.com> <20180806035550.GE7395@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180806035550.GE7395@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <zwisler@kernel.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, lczerner@redhat.com, linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

> > > This allows the direct I/O path to do I/O and raise & lower page->_refcount
> > > while we're executing a truncate/hole punch.  This leads to us trying to free
> > > a page with an elevated refcount.
> 
> I don't see how this is possible in XFS - maybe I'm missing
> something, but "direct IO submission during truncate" is not
> something that should ever be happening in XFS, DAX or not.

The pages involved in a direct I/O are not that of the file that
the direct I/O read/write syscalls are called on, but those of the
memory regions the direct I/O read/write syscalls operate on.
Those pages could be file backed and undergo a truncate at the
same time.
