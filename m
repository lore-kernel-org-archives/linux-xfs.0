Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754900AbdLOIz2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Dec 2017 03:55:28 -0500
Date: Fri, 15 Dec 2017 16:55:26 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/8] weekly fstests changes
Message-ID: <20171215085526.GL2749@eguan.usersys.redhat.com>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151314499003.18893.8687182548758898133.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Dec 12, 2017 at 10:03:10PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Here's the usual weekly pile of fstests changes. :)
> 
> We start with the same patch as last time that scans kmemleak for leaks
> after each test.
> 
> Then we move on to a fix in the scrub probe code because upstream
> xfsprogs changed xfs_io syntax again.
> 
> Third is a patch that adds Unicode linedraw character tests to the two
> tests that check that we can store arbitrary byte patterns without
> screwing things up.
> 
> The fourth patch amends various xfs tests to deal with our slow removal
> of zero-alloc transactions, which is causing unexpected fs shutdowns
> when free space nears zero.

I'm taking patch 2-4 for this week's update, I'll need more time to look
at & test & think more about the other patches.

Thanks,
Eryu

> 
> The fifth patch adds a new test to invoke dm-error on a fsstress run;
> this test simulates (for the filesystem) an internal "yank all the disk
> cables out" test.
> 
> The sixth patch adds FICLONERANGE/FIDEDUPERANGE support to fsstress.
> This was helpful in finding a bunch of unhandled corner cases in the xfs
> reflink implementation.
> 
> Patch seven test write-only fsstress to maximize testing of write paths
> where coding mistakes cannot be backed out of so easily.
> 
> The final patch in the series fixes the dir/file counts that are
> hardcoded in the xfs/068 golden output, since with fsstress doing
> reflink now we might get a lot more "files" than we used to.
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
