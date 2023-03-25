Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF49EC6FD1C
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 18:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjCYSdW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 14:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYSdV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 14:33:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6787EE181
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 11:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A8EDB80782
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 18:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6CCC433D2;
        Sat, 25 Mar 2023 18:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679769197;
        bh=IWsafZpvOSjIM1TjGBIcYK2PBenst8ne1xSTCtd84xM=;
        h=Date:From:To:Cc:Subject:From;
        b=Jyh5E40l7V0LzYpqcbTFOQs9fabMAjCAKu8Ej/OnHCogKX40CwUmD5BY2PK23wHZT
         zrNEi/dqV/8YFSft/5BMvGUZUy4wHL5U12sLNWtQz1nGO6YGBWtvZ1b03RZI4BFy0x
         N2BmE8pjBzbzTFJtWOt6oYB/4LsDhOCY4paXLYC4ffuorBXTr19etYhlsFxgsPOt/9
         sNZsxSvdnIflEIsMzlj0Xq6RsrMV7OnUjlOy1Y09QI+YY9iRh3QxGCxvYciAZ0JaSp
         n4Un6EhO9wTT/oj6xC0wWh4EibJzpEfCb7+fEkYbScf5hMMQ4tuH7MrSyq3wPr2JoI
         9tf7uoleO4ZfQ==
Date:   Sat, 25 Mar 2023 11:33:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, torvalds@linux-foundation.org
Cc:     david@fromorbit.com, dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 2/3] xfs: percpu counter bug fixes for 6.3-rc3
Message-ID: <167976583201.986322.4007693111843261305.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with a correction to the percpu counter
summation code.  We discovered a filesystem summary counter corruption
problem that was traced to cpu hot-remove racing with the call to
percpu_counter_sum that sets the free block count in the superblock when
writing it to disk.  The root cause is that percpu_counter_sum doesn't
cull from dying cpus and hence misses those counter values if the cpu
shutdown hooks have not yet run to merge the values.

I'm hoping this is a fairly painless fix to the problem, since the dying
cpu mask should generally be empty.  It's been in for-next for a week
without any complaints from the bots.  However, if this is too much for
a bug fix, we could defer to 6.4.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 3cfb9290da3d87a5877b03bda96c3d5d3ed9fcb0:

xfs: test dir/attr hash when loading module (2023-03-19 09:55:49 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-4

for you to fetch changes up to e9b60c7f97130795c7aa81a649ae4b93a172a277:

pcpcntr: remove percpu_counter_sum_all() (2023-03-19 10:02:04 -0700)

----------------------------------------------------------------
Fixes for 6.3-rc3:

* Fix a race in the percpu counters summation code where the summation
failed to add in the values for any CPUs that were dying but not yet
dead.  This fixes some minor discrepancies and incorrect assertions
when running generic/650.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Dave Chinner (4):
cpumask: introduce for_each_cpu_or
pcpcntrs: fix dying cpu summation race
fork: remove use of percpu_counter_sum_all
pcpcntr: remove percpu_counter_sum_all()

include/linux/cpumask.h        | 17 +++++++++++++++++
include/linux/find.h           | 37 +++++++++++++++++++++++++++++++++++++
include/linux/percpu_counter.h |  6 ------
kernel/fork.c                  |  5 -----
lib/find_bit.c                 |  9 +++++++++
lib/percpu_counter.c           | 37 ++++++++++++++-----------------------
6 files changed, 77 insertions(+), 34 deletions(-)
