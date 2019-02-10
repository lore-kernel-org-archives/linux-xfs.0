Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37797 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfBJLFi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Feb 2019 06:05:38 -0500
Date: Sun, 10 Feb 2019 19:05:31 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v3] xfs/068: Verify actual file count instead of reported
 file count
Message-ID: <20190210110531.GT2713@desktop>
References: <20190205193118.30969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205193118.30969-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Feb 05, 2019 at 09:31:18PM +0200, Amir Goldstein wrote:
> This test has the number of files/dirs created by xfsrestore hardcoded
> in golden output.
> 
> When fsstress is added new ops, the number of files/dirs created with
> the same random seed changes and this regularly breaks this test,
> so when new fsstress ops are added they should be either added to the
> dump test blacklist or golden output of this test needs to be ammended
> to reflect the change.
> 
> The golden output includes only the file count reported by xfsrestore
> and test does not even verify that this is the correct file count.
> Instead, leave the golden output neutral and explicitly verify that
> file count before and after the test are the same.
> 
> With this change, the test becomes agnostic to fsstress ops and we
> could also stop blacklisting clone/dedup/copy ops if we want.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

This looks good to me, thanks a lot!

I added all blacklisted ops manually and tested again with both reflink
enabled/disabled XFS and tests passed fine, the dumped and restured
entry numbers did match. Next, I think we're ready to add all the ops in
the blacklist back.

Thanks,
Eryu
