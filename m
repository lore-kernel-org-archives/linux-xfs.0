Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB5AC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Oct 2021 15:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A1E60F22
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Oct 2021 15:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhJaPWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Oct 2021 11:22:39 -0400
Received: from out20-86.mail.aliyun.com ([115.124.20.86]:49260 "EHLO
        out20-86.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhJaPWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Oct 2021 11:22:38 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2074538|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00533161-1.56259e-05-0.994653;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047193;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.Ll2dqIM_1635693604;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Ll2dqIM_1635693604)
          by smtp.aliyun-inc.com(10.147.44.129);
          Sun, 31 Oct 2021 23:20:05 +0800
Date:   Sun, 31 Oct 2021 23:20:04 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] tests/xfs: test COW writeback failure when
 overlapping non-shared blocks
Message-ID: <YX60JOknF5F5cvLJ@desktop>
References: <20211025130053.8343-1-bfoster@redhat.com>
 <20211025161022.GM24282@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025161022.GM24282@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 25, 2021 at 09:10:22AM -0700, Darrick J. Wong wrote:
> On Mon, Oct 25, 2021 at 09:00:53AM -0400, Brian Foster wrote:
> > Test that COW writeback that overlaps non-shared delalloc blocks
> > does not leave around stale delalloc blocks on I/O failure. This
> > triggers assert failures and free space accounting corruption on
> > XFS.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> LGTM.  Thanks for the patch + reproducer!
> 
> At some point this test ought to grow a link to the upstream fix patch,
> which is currently in the 5.16 merge branch, e.g.:
> 
> # Regression test for kernel commit:
> #
> # 5ca5916b6bc9 ("xfs: punch out data fork delalloc blocks on COW
> # writeback failure")

And this test triggers an ASSERT (though it won't crash the kernel
unless XFS_ASSERT_FATAL is set), I'd like wait for the fix to land so we
could have the correct commit ID by then.

> 
> ...but as Sunday afternoon came and went with neither -rc7 nor a final
> release being tagged, I'm not sure when that commit will appear
> upstream.  It's entirely possible that Linus is sitting in the dark
> right now, since I came back from my long weekend to a noticeable
> amount of downed trees around town.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks for the review, and for all the other reviews!

Eryu
