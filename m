Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F10C4320E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 04:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32EB560F23
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 04:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241815AbhIAErL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 00:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241684AbhIAErK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 00:47:10 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D77FC061575;
        Tue, 31 Aug 2021 21:46:14 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id j15so2115971ila.1;
        Tue, 31 Aug 2021 21:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zsHyYeSR9ACZUZpjPtsYlGcvCJ8qMXDCUzjBMk6kPkQ=;
        b=LMV/7YIRYOIoNB2Kp+7qEIFKC07giHsCnwXQnNcvXtHyuuRFfGChyKkMUvsIrz63se
         E4/UdNoN+h56l1s+0DvlV2GpaO6uPNWcBnRz4R57RxH9AF0yK/vnkoEPUfZnW6i1MxKS
         oPxKk1kK0GYwlQMBVEYs7ABSXAh5SBV1rGeSRtezTX4Iq4JQt6GOEdlpfcFGo+rD+Ns+
         PK9hdt8OQBwXGLsdisFYeBThbpKe3QdqCjuzZW+Aw+bWAgCjVqEBYR9VFpvkZk3B/1gu
         hUQTHZScBsjU2sofYKmitEQLfKbJbgVmFtJ7Wwo6KeGhfEpMD9v8d64fnMy8OaND7wrE
         wxGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zsHyYeSR9ACZUZpjPtsYlGcvCJ8qMXDCUzjBMk6kPkQ=;
        b=qzBOClT6UP1FrA1DMrl1h72A/rylq68sygs/t4Hxh21CI1bXwOUbMKqOQHNO11KpyS
         hEQh8hLd7UIZEx2qJ8aJfCkVWO+mHFED/MPJqUMK3ABY/dM6cg6GaV6offSMSTuMAp8O
         Krs37My8afJH9NwwqJKcp1a9C8O3MFSqPzB+gDOTw5J+hdfLe9qAnEgTky/qs9VQ+pbi
         Bx9cwZXVRlZiNT4Chyf0g56cNJPMhIwSAJgOI1ZKPW5fy4RGHO8nEOnFh9U7iEPVAqQh
         6hPR/8Hke/SiDkaZuL5tbjC1eN4Rjq+kKXpF6dDpStkp5F9vWH7NX8lAMl+iJwTNaVuR
         hiHQ==
X-Gm-Message-State: AOAM531iWdMxvzxNuHZxmMB95zUh6rJU7IrSBvBP4mm5duy+SC9JZec9
        uUR+a3Dfb7Ha9XlbX4XwvZMkcaRLIU/UH9+orRUb8oQwbDA=
X-Google-Smtp-Source: ABdhPJz4Y3Rm6ELofvyyeWwTKq9zbV6qB7AaBxGYp8m+f/HKCiNVBM7MtIWnRKG3PVXvNuxWXnh+2DDUmTMMeEeLsLc=
X-Received: by 2002:a05:6e02:10d0:: with SMTP id s16mr23828439ilj.275.1630471573579;
 Tue, 31 Aug 2021 21:46:13 -0700 (PDT)
MIME-Version: 1.0
References: <163045514980.771564.6282165259140399788.stgit@magnolia> <163045517173.771564.1524162806861567173.stgit@magnolia>
In-Reply-To: <163045517173.771564.1524162806861567173.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 1 Sep 2021 07:46:01 +0300
Message-ID: <CAOQ4uxi7205Ae+un1w4C4Dzh9-SykL=ogHQSBH=nnVGDkPfkhw@mail.gmail.com>
Subject: Re: [PATCH 4/5] tools: make sure that test groups are described in
 the documentation
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 1, 2021 at 3:37 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Create a file to document the purpose of each test group that is
> currently defined in fstests, and add a build script to check that every
> group mentioned in the tests is also mentioned in the documentation.
>

This is awesome and long due.
Thanks for doing that!

Minor nits about overlayfs groups below...

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  doc/group-names.txt    |  136 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/buildgrouplist |    1
>  tools/check-groups     |   33 ++++++++++++
>  3 files changed, 170 insertions(+)
>  create mode 100644 doc/group-names.txt
>  create mode 100755 tools/check-groups
>
>
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> new file mode 100644
> index 00000000..ae517328
> --- /dev/null
> +++ b/doc/group-names.txt
> @@ -0,0 +1,136 @@
> +======================= =======================================================
> +Group Name:            Description:
> +======================= =======================================================
> +all                    All known tests, automatically generated by ./check at
> +                       runtime
> +auto                   Tests that should be run automatically.  These should
> +                       not require more than ~5 minutes to run.
> +quick                  Tests that should run in under 30 seconds.
> +deprecated             Old tests that should not be run.
> +
> +acl                    Access Control Lists
> +admin                  xfs_admin functionality
> +aio                    general libaio async io tests
> +atime                  file access time
> +attr                   extended attributes
> +attr2                  xfs v2 extended aributes
> +balance                        btrfs tree rebalance
> +bigtime                        timestamps beyond the year 2038
> +blockdev               block device functionality
> +broken                 broken tests
> +cap                    Linux capabilities
> +casefold               directory name casefolding
> +ci                     ASCII case-insensitive directory name lookups
> +clone                  FICLONE/FICLONERANGE ioctls
> +clone_stress           stress testing FICLONE/FICLONERANGE
> +collapse               fallocate collapse_range
> +compress               file compression
> +convert                        btrfs ext[34] conversion tool
> +copy                   xfs_copy functionality
> +copy_range             copy_file_range syscall
> +copyup                 overlayfs copyup support

The tests in this group exercise copy up.
There is no such thing as overlayfs without "copyup support",
so guess my point is - remove the word "support"

> +dangerous              dangerous test that can crash the system
> +dangerous_bothrepair   fuzzers to evaluate xfs_scrub + xfs_repair repair
> +dangerous_fuzzers      fuzzers that can crash your computer
> +dangerous_norepair     fuzzers to evaluate kernel metadata verifiers
> +dangerous_online_repair        fuzzers to evaluate xfs_scrub online repair
> +dangerous_repair       fuzzers to evaluate xfs_repair offline repair
> +dangerous_scrub                fuzzers to evaluate xfs_scrub checking
> +data                   data loss checkers
> +dax                    direct access mode for persistent memory files
> +db                     xfs_db functional tests
> +dedupe                 FIEDEDUPERANGE ioctl
> +defrag                 filesystem defragmenters
> +dir                    directory test functions
> +dump                   dump and restore utilities
> +eio                    IO error reporting
> +encrypt                        encrypted file contents
> +enospc                 ENOSPC error reporting
> +exportfs               file handles
> +filestreams            XFS filestreams allocator
> +freeze                 filesystem freeze tests
> +fsck                   general fsck tests
> +fsmap                  FS_IOC_GETFSMAP ioctl
> +fsr                    XFS free space reorganizer
> +fuzzers                        filesystem fuzz tests
> +growfs                 increasing the size of a filesystem
> +hardlink               hardlinks
> +health                 XFS health reporting
> +idmapped               idmapped mount functionality
> +inobtcount             XFS inode btree count tests
> +insert                 fallocate insert_range
> +ioctl                  general ioctl tests
> +io_uring               general io_uring async io tests
> +label                  filesystem labelling
> +limit                  resource limits
> +locks                  file locking
> +log                    metadata logging
> +logprint               xfs_logprint functional tests
> +long_rw                        long-soak read write IO path exercisers
> +metacopy               overlayfs metadata-only copy-up
> +metadata               filesystem metadata update exercisers
> +metadump               xfs_metadump/xfs_mdrestore functionality
> +mkfs                   filesystem formatting tools
> +mount                  mount option and functionality checks
> +nested                 nested overlayfs instances
> +nfs4_acl               NFSv4 access control lists
> +nonsamefs              overlayfs layers on different filesystems
> +online_repair          online repair functionality tests
> +other                  dumping ground, do not add more tests to this group
> +overlay                        using overlayfs on top of FSTYP

This description is a bit confusing, because the recommended
way to run overlayfs tests as described in README.overlay is
to set FSTYP=xfs and run ./check -overlay

I'm struggling for a better description but perhaps:
"using overlayfs regardless of ./check -overlay flag"?


> +pattern                        specific IO pattern tests
> +perms                  access control and permission checking
> +pipe                   pipe functionality
> +pnfs                   PNFS
> +posix                  POSIX behavior conformance
> +prealloc               fallocate
> +preallocrw             fallocate, then read and write
> +punch                  fallocate punch_hole
> +qgroup                 btrfs qgroup feature
> +quota                  filesystem usage quotas
> +raid                   btrfs RAID
> +realtime               XFS realtime volumes
> +recoveryloop           crash recovery loops
> +redirect               overlayfs redirect_dir feature
> +remote                 dump and restore with a remote tape
> +remount                        remounting filesystems
> +rename                 rename system call
> +repair                 xfs_repair functional tests
> +replace                        btrfs device replace
> +replay                 dm-logwrites replays
> +resize                 resize2fs functionality tests
> +richacl                        rich ACL feature
> +rmap                   XFS reverse mapping exercisers
> +rotate                 overlayfs feature of some sort"

I guess that works :-D
but to be accurate, this is actually a unionmount testsuite feature -
at selected test points in the workload, a new upper layer is stacked
on to overlayfs, so maybe:
"upper layer rotate tests from the unionmount test suite"?

> +rw                     read/write IO tests
> +samefs                 overlayfs when all layers are on the same fs
> +scrub                  filesystem metadata scrubbers
> +seed                   btrfs seeded filesystems
> +seek                   llseek functionality
> +send                   btrfs send/receive
> +shrinkfs               decreasing the size of a filesystem
> +shutdown               FS_IOC_SHUTDOWN ioctl
> +snapshot               btrfs snapshots
> +soak                   long soak tests of any kind
> +spaceman               xfs_spaceman functional tests
> +splice                 splice system call
> +stress                 fsstress filesystem exerciser
> +subvol                 btrfs subvolumes
> +subvolume              btrfs subvolumes (again?)

A cleanup patch to fix this typo in btrfs/233?

Thanks,
Amir.
