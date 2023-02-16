Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CEBC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBPUaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBPUaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:30:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6986D196B9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:30:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2F8C60C0D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A70DC433EF;
        Thu, 16 Feb 2023 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579404;
        bh=djIeqQpU4JyR/OE2uWpAnE7uVmwjYjvmsT4PBo9TvQg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uTAhhyqsdWukzZD5Ua1COoH1cSDYJsTupGjlwAUvVXbudCJiSB2UgTRI39EiJUZj5
         gIJh4fOAMXtRzkWOL/BmpjZ6OOvqGP6tTEXzR9vOKk7anbW3z+p+44CbBQ6KVIb2VH
         Mi70MG/hOv5k/Hd4oE2kF/vFIakKb8IB8ihozyxpkTzONcXr+zzG+2+S8G5zk8AEtD
         xnCgyXscxqO7Wcf9i3H9/2ddvEFm6VA5DsACWBm/W8LAbGdZ7ggk2eHV0yK3Cv3fef
         47smC2hpcA9U8iyZ7MxYifxkRXtQLbqcUbM7mP57bVNCdrUHGmoz6uNc9cZAPYSKS7
         wREwFL+04tGeQ==
Date:   Thu, 16 Feb 2023 12:30:03 -0800
Subject: [PATCHSET v9r2d1 0/4] xfsprogs: offline fsck support patches
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880680.3477371.18364607478868446486.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are all the patches that I needed to port from the patchset that
backports various online fsck things to offline fsck so that I can start
writing offline fsck for parent pointers and directories.

IOWS, we're blatantly copying things from the online repair part 1
megaseries; this is what online repair part 2 requires.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-fsck-backports

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-online-fsck-backports
---
 configure.ac             |    3 +
 db/attr.c                |    2 
 db/metadump.c            |    2 
 include/builddefs.in     |    3 +
 libxfs/Makefile          |   14 +++
 libxfs/libxfs_api_defs.h |    1 
 libxfs/xfblob.c          |  148 +++++++++++++++++++++++++++++
 libxfs/xfblob.h          |   25 +++++
 libxfs/xfile.c           |  235 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfile.h           |   57 +++++++++++
 libxfs/xfs_dir2.c        |    6 +
 libxfs/xfs_dir2.h        |    1 
 m4/package_libcdev.m4    |   50 ++++++++++
 repair/attr_repair.c     |    6 +
 repair/phase6.c          |    4 -
 repair/xfs_repair.c      |   15 +++
 16 files changed, 563 insertions(+), 9 deletions(-)
 create mode 100644 libxfs/xfblob.c
 create mode 100644 libxfs/xfblob.h
 create mode 100644 libxfs/xfile.c
 create mode 100644 libxfs/xfile.h

