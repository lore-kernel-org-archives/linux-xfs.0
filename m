Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC751C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjBPU3u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjBPU3u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:29:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4D3196A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:29:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A91060A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B39C4339E;
        Thu, 16 Feb 2023 20:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579388;
        bh=BkFemW5Y4SBQNWqZUf4FjNTx/8qKLgR80SRUgn81hpo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SKmBAHZpABbYAEPDsbHIfuo9oR0sT5PnQ9L0Gdwstr6QMHzE6vroX0NhcD/b4rsUS
         /YEWTyDU9OHW00GZIQrPxGyi4IFEW+rpT+Ek8ETgy+XgLsSMIDLCq3XQRRikM24VcF
         1sVHkS1BDaJXEh3WVz1RQgFfyoALwM1BPJ4SzxEI1uvI4JqOH+b+cJfaODUElwqM/3
         cWZA8kATX96YRP3DYo6Ah2tRL63LOen1LZIyq+eG1wbxUjV8CIxSijGXXkoPiqUOJX
         F3QB1rESCLG7E7IVbLdgN/2WxoppfMzFAGlff/ltIKps0w+gPrOWYy70D5UyNn7UjS
         zFLNiqYhaL9LQ==
Date:   Thu, 16 Feb 2023 12:29:48 -0800
Subject: [PATCHSET v9r2d1 00/10] xfsprogs: actually use getparent ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880257.3477097.11495108667073036392.stgit@magnolia>
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

Yikes.  The userspace parent pointers support code dates from 2017 and
is very very moldy.  This patchset moves the xfs_io filtering stuff back
to xfs_io.  It also moves the parent pointer support code to libfrog
because we don't want to expose things via libhandle until we're
absolutely sure that we want to do that.

(We probably want to do that some day.)

Finally, adapt xfs_scrub to use parent pointer information whenever it
has something to say about a file handle that it has open.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-use-getparents
---
 include/parent.h   |   25 ------
 io/parent.c        |  122 ++++++++++++++++++-----------
 libfrog/Makefile   |    2 
 libfrog/paths.c    |   39 ++++++++-
 libfrog/paths.h    |    8 +-
 libfrog/pptrs.c    |  219 ++++++++++++++++++++++------------------------------
 libfrog/pptrs.h    |   25 ++++++
 libhandle/Makefile |    2 
 scrub/common.c     |   21 +++++
 scrub/inodes.c     |   26 ------
 scrub/inodes.h     |    2 
 11 files changed, 256 insertions(+), 235 deletions(-)
 rename libhandle/parent.c => libfrog/pptrs.c (50%)
 create mode 100644 libfrog/pptrs.h

