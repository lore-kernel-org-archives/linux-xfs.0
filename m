Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750936AbeETNSx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 20 May 2018 09:18:53 -0400
Message-ID: <e7ed8ce036a5148f9101f2498cbb593e67b72069.camel@kernel.org>
Subject: Re: [PATCH] fs: clear writeback errors in inode_init_always
From: Jeff Layton <jlayton@kernel.org>
Date: Sun, 20 May 2018 09:18:50 -0400
In-Reply-To: <20180520125843.GA25612@bombadil.infradead.org>
References: <20180518225037.GA26206@thunk.org>
         <630faadb74f608aa5a42649b81657e8b62d46bc3.camel@kernel.org>
         <20180519152700.GB4507@magnolia> <20180519231944.GB23448@thunk.org>
         <fa3b4dec3452aa5696b8657ef509891908901d95.camel@kernel.org>
         <20180520125843.GA25612@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

On Sun, 2018-05-20 at 05:58 -0700, Matthew Wilcox wrote:
> On Sun, May 20, 2018 at 07:45:31AM -0400, Jeff Layton wrote:
> > [PATCH] loop: clear wb_err in bd_inode when detaching backing file
> 
> Is this the right thing to do?  Putting the test-suite aside for the
> moment, if I have a loop device on a file and I hit a real error on the
> storage backing that file, I don't see why detaching the loop device
> from the file should clear the error.
> 
> I'm really tempted to say that we should fix the test-suite to consume
> the error; once it's been read by at least one reader, it won't go back
> to zero, but neither will it show up for new readers.

This is a bit of a grey area, for sure. FWIW, I looked at doing this in
invalidate_bdev, but backed off since I wasn't sure about the other
callers.

I still think it probably is the right thing to do. I'd think that
detaching the backing store is sort of an indicator that you really
don't care about it anymore (including any stored errors concerning it).

OTOH, my track record on predicting what applications care about is
pretty abysmal. I'll go with whatever the consensus is here...
-- 
Jeff Layton <jlayton@kernel.org>
