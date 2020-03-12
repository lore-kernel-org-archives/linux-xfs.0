Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D794AC4CECE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0C8720736
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgCLKmm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 06:42:42 -0400
Received: from verein.lst.de ([213.95.11.211]:36158 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLKmm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Mar 2020 06:42:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3E5C768C4E; Thu, 12 Mar 2020 11:42:39 +0100 (CET)
Date:   Thu, 12 Mar 2020 11:42:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     David Howells <dhowells@redhat.com>
Cc:     mbobrowski@mbobrowski.org, darrick.wong@oracle.com, jack@suse.cz,
        hch@lst.de, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Is ext4_dio_read_iter() broken? - and xfs_file_dio_aio_read()
Message-ID: <20200312104239.GA13235@lst.de>
References: <969260.1584004779@warthog.procyon.org.uk> <1015227.1584007677@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1015227.1584007677@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 10:07:57AM +0000, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
> > Is ext4_dio_read_iter() broken?  It calls:
> > 
> > 	file_accessed(iocb->ki_filp);
> > 
> > at the end of the function - but surely iocb should be expected to have been
> > freed when iocb->ki_complete() was called?

The iocb is refcounted and only completed when the refcount hits zero,
and an extra reference is held until the submission has completed.
Take a look at iocb_put().

> I think it's actually worse than that.  You also can't call
> inode_unlock_shared(inode) because you no longer own a ref on the inode since
> ->ki_complete() is expected to call fput() on iocb->ki_filp.

the file reference also hold an inode reference.

> 
> Yes, you own a shared lock on it, but unless somewhere along the
> fput-dput-iput chain the inode lock is taken exclusively, the inode can be
> freed whilst you're still holding the lock.
> 
> Oh - and ext4_dax_read_iter() is also similarly broken.

In addition to that DAX never executes asynchronously.

> And xfs_file_dio_aio_read() appears to be broken as it touches the inode after
> calling iomap_dio_rw() to unlock it.

Same as above.
