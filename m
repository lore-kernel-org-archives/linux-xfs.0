Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59044 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751029AbeETR5u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 20 May 2018 13:57:50 -0400
Date: Sun, 20 May 2018 13:57:41 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] fs: clear writeback errors in inode_init_always
Message-ID: <20180520175741.GA5072@thunk.org>
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
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

On Sun, May 20, 2018 at 07:45:31AM -0400, Jeff Layton wrote:
> 
> I poked at this a bit this morning and found that if I ran generic/361
> twice in a row that I'd see a failure similar to what you were seeing.
> This patch seems to fix it for me.
> 
> Ted, could you test this against your reproducer? If this works for you
> I'll plan to flesh out the patch description and get this into -next and
> eventually to Linus before the next release.

Yup, this fixes shared/298 for me.   Many thanks!!

						- Ted
