Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04280C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 17:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245320AbiEZR1p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 13:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244001AbiEZR1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 13:27:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B4B674F2;
        Thu, 26 May 2022 10:27:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA1BE60FD0;
        Thu, 26 May 2022 17:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF843C385A9;
        Thu, 26 May 2022 17:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653586061;
        bh=ZSSJA0QqqPK+JAKsEo0gD0TsxHRHJIBz3VFGL0uie28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jkispk5p5o0fmqhvy8WqOyfs7oD86N6BWEiiadus/BfUH73cVmePTEIDDRle3pyND
         4e7etnLRkG7Fi/DSu7MegfEHyBD05hQYkCqixjjryA2fkleY5ajoOJMyWTiFNq4IpH
         e5RJAOKp0pThDMeOga6Tlw/tnL40llU5k4QoxlyQYfhvMdqUmh9nxp+hOBijDqUjbT
         P8eS4R2jlLRxinK4smpbqfTP54YX+iMAyv+FFu52eNUsuKbOPEs0sPOJh4Hsfwo0jj
         AtqPqlSImCz4224eUPRWCXQ678VxZJCPp4D71EoLCqdmxE/kxqZCVPf+zugD//TQ+H
         BvhwdhD+n7zPA==
Date:   Thu, 26 May 2022 10:27:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, Leah Rumancik <lrumancik@google.com>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
Message-ID: <Yo+4jW0e4+fYIxX2@magnolia>
References: <20220525111715.2769700-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525111715.2769700-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 25, 2022 at 02:17:11PM +0300, Amir Goldstein wrote:
> Hi all!
> 
> During LSFMM 2022, I have had an opportunity to speak with developers
> from several different companies that showed interest in collaborating
> on the effort of improving the state of xfs code in LTS kernels.
> 
> I would like to kick-off this effort for the 5.10 LTS kernel, in the
> hope that others will join me in the future to produce a better common
> baseline for everyone to build on.
> 
> This is the first of 6 series of stable patch candidates that
> I collected from xfs releases v5.11..v5.18 [1].
> 
> My intention is to post the parts for review on the xfs list on
> a ~weekly basis and forward them to stable only after xfs developers
> have had the chance to review the selection.
> 
> I used a gadget that I developed "b4 rn" that produces high level
> "release notes" with references to the posted patch series and also
> looks for mentions of fstest names in the discussions on lore.
> I then used an elimination process to select the stable tree candidate
> patches. The selection process is documented in the git log of [1].
> 
> After I had candidates, Luis has helped me to set up a kdevops testing
> environment on a server that Samsung has contributed to the effort.
> Luis and I have spent a considerable amount of time to establish the
> expunge lists that produce stable baseline results for v5.10.y [2].
> Eventually, we ran the auto group test over 100 times to sanitize the
> baseline, on the following configurations:
> reflink_normapbt (default), reflink, reflink_1024, nocrc, nocrc_512.
> 
> The patches in this part are from circa v5.11 release.
> They have been through 36 auto group runs with the configs listed above
> and no regressions from baseline were observed.

Woot!

> At least two of the fixes have regression tests in fstests that were used
> to verify the fix. I also annotated [3] the fix commits in the tests.
> 
> I would like to thank Luis for his huge part in this still ongoing effort
> and I would like to thank Samsung for contributing the hardware resources
> to drive this effort.
> 
> Your inputs on the selection in this part and in upcoming parts [1]
> are most welcome!

/me wonders if you need commit 9a5280b312e2 xfs: reorder iunlink remove
operation in xfs_ifree ?  Or did that one already get pulled in?

The changes proposed look reasonable to me, and moreso with the testing
to prove it.  Minor nit: patchsets should be tagged "PATCH", not "PATH".

Thanks to you and Luis for doing this work! :)

> Thanks,
> Amir.
> 
> [1] https://github.com/amir73il/b4/blob/xfs-5.10.y/xfs-5.10..5.17-fixes.rst
> [2] https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/5.10.105/xfs/unassigned

/me looks and sees a large collection of expunge lists, along with
comments about how often failures occur and/or reasons.  Neat!

Leah mentioned on the ext4 call this morning that she would have found
it helpful to know (before she started working on 5.15 backports) which
tests were of the flaky variety so that she could better prioritize the
time she had to look into fstests failures.  (IOWS: saw a test fail a
small percentage of the time and then burned a lot of machine time only
to figure out that 5.15.0 also failed a percentage of th time).

We talked about where it would be most useful for maintainers and QA
people to store their historical pass/fail data, before settling on
"somewhere public where everyone can review their colleagues' notes" and
"somewhere minimizing commit friction".  At the time, we were thinking
about having people contribute their notes directly to the fstests
source code, but I guess Luis has been doing that in the kdevops repo
for a few years now.

So, maybe there?

--D

> [3] https://lore.kernel.org/fstests/20220520143249.2103631-1-amir73il@gmail.com/
> 
> Darrick J. Wong (3):
>   xfs: detect overflows in bmbt records
>   xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
>   xfs: fix an ABBA deadlock in xfs_rename
> 
> Kaixu Xia (1):
>   xfs: show the proper user quota options
> 
>  fs/xfs/libxfs/xfs_bmap.c    |  5 +++++
>  fs/xfs/libxfs/xfs_dir2.h    |  2 --
>  fs/xfs/libxfs/xfs_dir2_sf.c |  2 +-
>  fs/xfs/xfs_inode.c          | 42 ++++++++++++++++++++++---------------
>  fs/xfs/xfs_iwalk.c          |  2 +-
>  fs/xfs/xfs_super.c          | 10 +++++----
>  6 files changed, 38 insertions(+), 25 deletions(-)
> 
> -- 
> 2.25.1
> 
