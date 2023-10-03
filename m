Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA259E75457
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Oct 2023 12:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjJCMeq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 08:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjJCMep (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 08:34:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEE091
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 05:34:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AD9C433C7;
        Tue,  3 Oct 2023 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696336482;
        bh=pOe+uCjwXq/TsbFFbgrHKv8beCGetzlshP9d7vVI73M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=koMo1O4OlrrmKkyDdObDmeFNIpXUlX/yV0YzlxhlK+Etvjmig05/T9S8vpncUs6zC
         cz5Ae2ka/LsJcIuelRD6/BbWIW5G6VB/GXYBD/wmt0SyrG3vOLBo7Nm8dUIuPGVx/x
         2fdxh4wWnVD/ja199VFubDW40slYJbbAzIAx+/2hI9I7eLC7WzgRLeugH8FgqVHWnF
         XpFQH9bYzLYcO7jhhWdsooklw21cNqS5rLt4F6ieGOTAtgCB2THsMB35FkUvJfzopV
         XwdsxI+ivVBtU5c3xswBRTBzSomwJg8DgwY6QVPNMAZlgoY+FgTblX5HcQEEpIOOnJ
         ZPGrqgdLjc+eg==
Date:   Tue, 3 Oct 2023 14:34:38 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/2] xfsprogs: reload the last iunlink item
Message-ID: <20231003123438.ux27xj2d4dw5gf5g@andromeda>
References: <HguUDE7NBvzXuSgQMBOT37H6Ow6tXhEAT7zOzFfvMJMQEw_27F0-m2uAvLHKHR_RLS2WS1197CpcUQFnijTFZg==@protonmail.internalid>
 <169567917992.2320475.10415003566794205537.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169567917992.2320475.10415003566794205537.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 25, 2023 at 02:59:39PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> It turns out that there are some serious bugs in how xfs handles the
> unlinked inode lists.  Way back before 4.14, there was a bug where a ro
> mount of a dirty filesystem would recover the log bug neglect to purge
> the unlinked list.  This leads to clean unmounted filesystems with
> unlinked inodes.  Starting around 5.15, we also converted the codebase
> to maintain a doubly-linked incore unlinked list.  However, we never
> provided the ability to load the incore list from disk.  If someone
> tries to allocate an O_TMPFILE file on a clean fs with a pre-existing
> unlinked list or even deletes a file, the code will fail and the fs
> shuts down.
> 
> This first part of the correction effort adds the ability to load the
> first inode in the bucket when unlinking a file; and to load the next
> inode in the list when inactivating (freeing) an inode.
> 
> In userspace, we'll add a xfs_db command to create unlinked inodes on a
> (presumably) clean filesystem so that we can finally write some
> regression and functional testing of iunlink recovery to ensure that
> this all works properly.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 

For the series:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos

> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-iunlink
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fix-iunlink
> ---
>  db/Makefile              |    2
>  db/command.c             |    1
>  db/command.h             |    1
>  db/iunlink.c             |  400 ++++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/libxfs_api_defs.h |    2
>  man/man8/xfs_db.8        |   30 +++
>  6 files changed, 435 insertions(+), 1 deletion(-)
>  create mode 100644 db/iunlink.c
> 
