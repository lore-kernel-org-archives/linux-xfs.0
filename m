Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39588 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbeKPS6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 13:58:21 -0500
Received: by mail-pg1-f196.google.com with SMTP id r9-v6so10306937pgv.6
        for <linux-xfs@vger.kernel.org>; Fri, 16 Nov 2018 00:47:00 -0800 (PST)
Date: Fri, 16 Nov 2018 00:46:58 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] block: fix 32 bit overflow in __blkdev_issue_discard()
Message-ID: <20181116084658.GT23828@vader>
References: <20181113214337.20581-1-david@fromorbit.com>
 <10a8dd78-7c00-8593-9f4e-b20eb1161b92@kernel.dk>
 <20181115010651.GD32603@ming.t460p>
 <20181115012201.GX19305@dastard>
 <20181115031035.GE32603@ming.t460p>
 <20181115221337.GY19305@dastard>
 <20181115222419.GV4235@magnolia>
 <20181116040457.GA19305@dastard>
 <20181116083232.GA9023@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116083232.GA9023@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Nov 16, 2018 at 12:32:33AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 16, 2018 at 03:04:57PM +1100, Dave Chinner wrote:
> > They don't run on my test machines because they require a modular
> > kernel and I run a monolithic kernel specified externally by the
> > qemu command line on all my test VMs.
> > 
> > generic/349     [not run] scsi_debug module not found
> > generic/350     [not run] scsi_debug module not found
> > generic/351     [not run] scsi_debug module not found
> 
> Same here, btw.  Any test that requires modules is a rather bad idea.

I'll plug my vm.py script that supports running a kernel build with
modules without installing them into the VM (by mounting the modules
over 9p): https://github.com/osandov/osandov-linux#vm-setup
