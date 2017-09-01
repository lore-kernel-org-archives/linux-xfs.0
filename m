Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59860 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbdIAJwY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Sep 2017 05:52:24 -0400
Date: Fri, 1 Sep 2017 11:52:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170901095222.GC24482@lst.de>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com> <20170831134722.GA6912@lst.de> <CAOQ4uxgrdijqVpFm+rZ4JE_ZY0A_CZdSPHQEb8S1_R_dyJYzSg@mail.gmail.com> <20170831163954.GH21939@bfoster.bfoster> <CAOQ4uxisPbcoNp8N8Y4yGdWDBfZ=PR7CgkKGbLGS6cbU6bx2rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxisPbcoNp8N8Y4yGdWDBfZ=PR7CgkKGbLGS6cbU6bx2rw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>, "stable [v4.9]" <stable@vger.kernel.org>

On Thu, Aug 31, 2017 at 10:20:19PM +0300, Amir Goldstein wrote:
> > IIUC, basically we need to guarantee that a flush submits after
> > file_write_and_wait() and completes before we return.
> 
> Yeh. unless we check if file_write_and_wait() submitted anything
> at all.

Even if file_write_and_wait did not submit anything we need to
make sure a flush was submitted and completed after entering
xfs_file_fsync.  For one to deal with the case where we wrote
back data from the flusher threads or the VM, and also for
the direct I/O case.


Btw, do you have any results for your simple catch?  I wonder
how much of an issue it actually is in practice.
