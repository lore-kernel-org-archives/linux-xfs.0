Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53874C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiLaDV3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaDV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:21:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876A712A80
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0910CE1ACD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337C9C433D2;
        Sat, 31 Dec 2022 03:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456884;
        bh=Gi2ALtkrXwo/Ep8kZfkXy+LLR6nCkksCx+fJsD3pOkQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IFiEmRZ4kmEva6ee9sWt98K8tnzRNOe2zK4PPdWHZzVwO/fyJKVb/npGNDUJd4TfS
         Gqptpv3Dn7qKI5iybd6IZ2eyHjCECtFlvSNTU4lOx4FfQfozJsglQUkiMsHToKsmsp
         68glo/G1K/CcToEWenEYfh+A0BX2rtOU9Pel5ciVFCHJbIe9tzcPEq4M9mC/Jj2xAv
         a0rlNQv7M76IQakXT4juMm06G6M97jhiGNSdEABS+R+mR+ECbpCwV8i7FEWcUL/qQX
         WfdlUtdi8VcHWxsHEPwmQzc5SSDyNvoYBiPfmT6F62+wJKZuKmPAgjhgp0qhrTwhWH
         TVoGH6ObMlM2w==
Subject: [PATCHSET 0/1] libxfs: report refcount information to userspace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:44 -0800
Message-ID: <167243884464.739878.13512803839101968575.stgit@magnolia>
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
 configure.ac          |    1 
 include/builddefs.in  |    4 
 io/Makefile           |    5 +
 io/fsrefcounts.c      |  478 +++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c             |    1 
 io/io.h               |    1 
 libfrog/fsrefcounts.h |  100 ++++++++++
 m4/package_libcdev.m4 |   19 ++
 man/man8/xfs_io.8     |   86 +++++++++
 9 files changed, 695 insertions(+)
 create mode 100644 io/fsrefcounts.c
 create mode 100644 libfrog/fsrefcounts.h

