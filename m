Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43166 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbeETM6q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 08:58:46 -0400
Date: Sun, 20 May 2018 05:58:43 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] fs: clear writeback errors in inode_init_always
Message-ID: <20180520125843.GA25612@bombadil.infradead.org>
References: <20180518225037.GA26206@thunk.org>
 <630faadb74f608aa5a42649b81657e8b62d46bc3.camel@kernel.org>
 <20180519152700.GB4507@magnolia>
 <20180519231944.GB23448@thunk.org>
 <fa3b4dec3452aa5696b8657ef509891908901d95.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa3b4dec3452aa5696b8657ef509891908901d95.camel@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

On Sun, May 20, 2018 at 07:45:31AM -0400, Jeff Layton wrote:
> [PATCH] loop: clear wb_err in bd_inode when detaching backing file

Is this the right thing to do?  Putting the test-suite aside for the
moment, if I have a loop device on a file and I hit a real error on the
storage backing that file, I don't see why detaching the loop device
from the file should clear the error.

I'm really tempted to say that we should fix the test-suite to consume
the error; once it's been read by at least one reader, it won't go back
to zero, but neither will it show up for new readers.
