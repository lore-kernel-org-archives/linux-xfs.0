Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEA0C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Nov 2021 16:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55E43610E5
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Nov 2021 16:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhKCQMv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232101AbhKCQMu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Nov 2021 12:12:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 122F260F39;
        Wed,  3 Nov 2021 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635955814;
        bh=MTOlwL9ixoG0/cn+CkFE06ekXtE4UIVH8F89DefLvj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OxXi/kXe3zR6LYfRDj9LOJ15fz+kEsI4Mn3ZOCyQucC8d9EKlP2lMczvipUEQUuh7
         GnlS59q+RZ4wRzw5cqdnQfAUDyPYbI9IkeZqcCgB+vg1Gf+sRPKXjra6cpoBuSx2Cn
         npUkdKawnWtJYMv+1kwdKCLmVBGFnq+syCPv8n2S9tzeg7E2dXs6Nl9XVqIAWb/jrd
         KmcyWsEEiQrueopHjxVcX4gJzWDSQ92VE8S9qOXTAfQLncPnUQhNdB6M++tSPbqPAE
         bLuNEBCwBctmCI+AS1x4ijxuGtRMmkrF2S6z5a88u+MA2UAy1NkcA3H/YCd5KRGr3W
         YFq0OcVPJrtwQ==
Date:   Wed, 3 Nov 2021 09:10:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] tests/xfs: test COW writeback failure when
 overlapping non-shared blocks
Message-ID: <20211103161013.GO24307@magnolia>
References: <20211025130053.8343-1-bfoster@redhat.com>
 <20211025161022.GM24282@magnolia>
 <YX60JOknF5F5cvLJ@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YX60JOknF5F5cvLJ@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 31, 2021 at 11:20:04PM +0800, Eryu Guan wrote:
> On Mon, Oct 25, 2021 at 09:10:22AM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 25, 2021 at 09:00:53AM -0400, Brian Foster wrote:
> > > Test that COW writeback that overlaps non-shared delalloc blocks
> > > does not leave around stale delalloc blocks on I/O failure. This
> > > triggers assert failures and free space accounting corruption on
> > > XFS.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > 
> > LGTM.  Thanks for the patch + reproducer!
> > 
> > At some point this test ought to grow a link to the upstream fix patch,
> > which is currently in the 5.16 merge branch, e.g.:
> > 
> > # Regression test for kernel commit:
> > #
> > # 5ca5916b6bc9 ("xfs: punch out data fork delalloc blocks on COW
> > # writeback failure")
> 
> And this test triggers an ASSERT (though it won't crash the kernel
> unless XFS_ASSERT_FATAL is set), I'd like wait for the fix to land so we
> could have the correct commit ID by then.

...and now that the commit is in Linus' tree, please resubmit this test
with the kernel commit annotation (the commit id is unchanged). :)

--D

> > 
> > ...but as Sunday afternoon came and went with neither -rc7 nor a final
> > release being tagged, I'm not sure when that commit will appear
> > upstream.  It's entirely possible that Linus is sitting in the dark
> > right now, since I came back from my long weekend to a noticeable
> > amount of downed trees around town.
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Thanks for the review, and for all the other reviews!
> 
> Eryu
