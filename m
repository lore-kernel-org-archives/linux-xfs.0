Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AE4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbiLaDUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaDUj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:20:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8530B55BF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:20:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2343361D60
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A0CC433D2;
        Sat, 31 Dec 2022 03:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456837;
        bh=x0jURG7av0Te5JNKZQt9TPi+qTmueNZlAmp+2WILzW8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rcucU7ZAp5I/z2B+kStwkLyV+2/tKPovK6szr9W0tyjIYUthvuSKCONIzw+b03HhE
         x/QqUvYdz59GLOOO4+ZFjiEl5JVWpHD4OFkKZPeI78UdVp2YobvW5pZoVE+OIFcw2B
         cOa57kqa0CB7UnYSmraY8ZZwsuHg+0eL6moIzp7ljOnuKYD+gD4/jhtdhWpNu2JtnM
         x5M5EPDtQzNSbo690FLm3j/5cYNmw48WxYXPMzkC5d7KIYbe9MK/4yOupWOh9DW6Iw
         n143chSWb1AKaOAcWCwnWAFQBjkmFXFDcOVox5ENtrGhKDq5xj9GF2lUH4iX/3uYmE
         vABS9/12vtfsw==
Subject: [PATCHSET 0/1] xfs: report refcount information to userspace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:27 -0800
Message-ID: <167243876696.727360.8931971090577962407.stgit@magnolia>
In-Reply-To: <Y69Uw6W5aclS115x@magnolia>
References: <Y69Uw6W5aclS115x@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Create a new ioctl to report the number of owners of each disk block so
that reflink-aware defraggers can make better decisions about which
extents to target.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=report-refcounts

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=report-refcounts

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=report-refcounts
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/xfs_fsrefs.c              |  935 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsrefs.h              |   34 +
 fs/xfs/xfs_ioctl.c               |  135 +++++
 fs/xfs/xfs_trace.c               |    1 
 fs/xfs/xfs_trace.h               |   74 +++
 include/uapi/linux/fsrefcounts.h |   96 ++++
 7 files changed, 1276 insertions(+)
 create mode 100644 fs/xfs/xfs_fsrefs.c
 create mode 100644 fs/xfs/xfs_fsrefs.h
 create mode 100644 include/uapi/linux/fsrefcounts.h

