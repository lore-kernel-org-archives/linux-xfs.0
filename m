Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269A8C6FD1F
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Mar 2023 17:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjCSRHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Mar 2023 13:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCSRHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Mar 2023 13:07:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3844019C7C
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 10:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98D75CE0F7F
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 17:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDCFC433EF;
        Sun, 19 Mar 2023 17:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679245648;
        bh=EjfrcAuhRMlXueLMrJaLeqEjVnpPs+z9BixEYoOLLvE=;
        h=Date:From:To:Cc:Subject:From;
        b=rdu+UNIUqlARlOK4WPJWPs8aikRcOrbHieBh+gmXu71eAzqiEeHagUIqAqZBXvVMv
         pP3Qyuub89o6UrLTDRX5H7QM09MRgzzPO39TRVdN3RwyJ6rc+nReHV5DeSDBkIdhNJ
         vQFNoVmPG13E9QGCRaxSSfBYuSc2XTZqbBe91IwzM0+w6X1psWQIRx8DVJ1MXFigCt
         drk5pfW6y2ExrT+cjTlWXPzhs3W4AZjtTUpT/vNgsrWOiyOVR5KCxDTOa4ki13Hrke
         mr2VbpXES69YKmRtIw+3MyrAUuXi37Eeej9KdF9t8dCuyiCqbXwEjMk85rT0iQTCI7
         /KPJ4ML5bgrUQ==
Date:   Sun, 19 Mar 2023 10:07:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to e9b60c7f9713
Message-ID: <167924555847.1683122.927802546974563473.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  Most of this push are simple(ish) bugfixes, with one
big caveat: I've merged a patch to selftest the dir/xattr name hash
function so that we might catch any platforms that are miscompiling it
and hence writing out bad xattr/directory trees.

The new head of the for-next branch is commit:

e9b60c7f9713 pcpcntr: remove percpu_counter_sum_all()

8 new commits:

Darrick J. Wong (4):
[6de4b1ab470f] xfs: try to idiot-proof the allocators
[9eb775968b68] xfs: walk all AGs if TRYLOCK passed to xfs_alloc_vextent_iterate_ags
[e6fbb7167ed0] xfs: add tracepoints for each of the externally visible allocators
[3cfb9290da3d] xfs: test dir/attr hash when loading module

Dave Chinner (4):
[1470afefc3c4] cpumask: introduce for_each_cpu_or
[8b57b11cca88] pcpcntrs: fix dying cpu summation race
[7ba85fba47bd] fork: remove use of percpu_counter_sum_all
[e9b60c7f9713] pcpcntr: remove percpu_counter_sum_all()

Code Diffstat:

fs/xfs/Makefile                |   1 +
fs/xfs/libxfs/xfs_alloc.c      |  36 ++-
fs/xfs/xfs_dahash_test.c       | 662 +++++++++++++++++++++++++++++++++++++++++
fs/xfs/xfs_dahash_test.h       |  12 +
fs/xfs/xfs_super.c             |   5 +
fs/xfs/xfs_trace.h             |   7 +
include/linux/cpumask.h        |  17 ++
include/linux/find.h           |  37 +++
include/linux/percpu_counter.h |   6 -
kernel/fork.c                  |   5 -
lib/find_bit.c                 |   9 +
lib/percpu_counter.c           |  37 +--
12 files changed, 799 insertions(+), 35 deletions(-)
create mode 100644 fs/xfs/xfs_dahash_test.c
create mode 100644 fs/xfs/xfs_dahash_test.h
