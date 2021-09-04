Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1EEC433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Sep 2021 08:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95E2161056
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Sep 2021 08:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhIDIxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 4 Sep 2021 04:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbhIDIxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Sep 2021 04:53:46 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D77C061575;
        Sat,  4 Sep 2021 01:52:44 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id g9so1565271ioq.11;
        Sat, 04 Sep 2021 01:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O/xdQPpLcqkGoDAHT5/yUOG1/iTmxRco6mo/vfFXA5c=;
        b=o3WBTcUsGkRCnoZ/WRgbIrhjj5wKDdyrNP8nNg2pjsRmfNAeRFw2BkWccSr0tb0KmV
         GHOslKK9XrL6o0yMERvGozEOPD+MegFqoOp/W+iiWCN5+Jr07V6H//sTmGgdWCImzfBF
         FaEAcJhnOcpu2u8VkN3qOriv7oFys84sCuhAJUG3iOt+3BoJrI301oZHRPxA/jglq4up
         u2nDla36YEnaPSwMXGStG1f/eKv+LqYzf5aQoG7clLg5J+vcuhQ1WkbISYQ45LaY6nQh
         Iwnv34OHPkU+6vuEzpvGxKDtD664PdNXRR1wMtVGOiWcsbLOPkVsbi8Y3Qq+Lny//lyE
         agTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O/xdQPpLcqkGoDAHT5/yUOG1/iTmxRco6mo/vfFXA5c=;
        b=W4IAnpE+v6ujY2YRt2dKt9SP8+ET8PrHI76x42zGDgZ7npWAeYP7MV6GpDBCJA9ATo
         M6aG/3h0UXXALuKuo8+CrcpqISlDOzdMS3q+RRvg6fV1xG04/Bkr4xOIzRdqHkiXNy+o
         9nOQKVFlae9kS1h6b7+NnjFhPHNo+B8TUj7g8KyVHEnzJA0OXmppLAwSUtuo3on6Fl7h
         Sfb4C22/bgZcILKF67IAWexRO8uBmv040/8+iEymMbcnfNlgRXwmSJUMWTX96LcW+wPy
         raT7WTMQFhC1IMor3X6Sg9+uDncCPN8BMbmMHQgIN814TZFJwwwHk3YpGI37I4EY/Vbq
         gzjA==
X-Gm-Message-State: AOAM5303ujihJqoFAzWISQw68PaFnRRfgxnDYkVbE/C1IniJrPsO1jne
        L7Pwd8oxrnIdZ1wVqcwpYhlSDvSNqZXbVFA4arU=
X-Google-Smtp-Source: ABdhPJxi14rzfyHO1VJ+9YXtvh2Ka7f9BNTIQEetFkc6zBecb6h6fG0FvGG46AtU5B73nvkqQkx/PRVAxtHbywYn4qA=
X-Received: by 2002:a05:6638:1301:: with SMTP id r1mr2567280jad.32.1630745563855;
 Sat, 04 Sep 2021 01:52:43 -0700 (PDT)
MIME-Version: 1.0
References: <163062674313.1579659.11141504872576317846.stgit@magnolia>
 <163062677608.1579659.1360826362143203767.stgit@magnolia> <20210904030600.GB2270902@magnolia>
In-Reply-To: <20210904030600.GB2270902@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 4 Sep 2021 11:52:32 +0300
Message-ID: <CAOQ4uxgReLEdycbNqYfNUVNaSgPa_30E_gfoppN9M2RwVu9c6Q@mail.gmail.com>
Subject: Re: [PATCH v2.1 6/8] tools: make sure that test groups are described
 in the documentation
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 4, 2021 at 6:06 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Create a file to document the purpose of each test group that is
> currently defined in fstests, and change mkgroupfile to check that every
> group mentioned in the tests is also mentioned in the documentation.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/preamble     |   21 ++++++++
>  doc/group-names.txt |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/mkgroupfile   |   15 +++++-
>  3 files changed, 168 insertions(+), 3 deletions(-)
>  create mode 100644 doc/group-names.txt
>
> diff --git a/common/preamble b/common/preamble
> index 66b0ed05..64d79385 100644
> --- a/common/preamble
> +++ b/common/preamble
> @@ -23,6 +23,26 @@ _register_cleanup()
>         trap "${cleanup}exit \$status" EXIT HUP INT QUIT TERM $*
>  }
>
> +# Make sure each group is in the documentation file.
> +_check_groups() {
> +       test -n "$GROUPNAME_DOC_FILE" || return 0
> +
> +       local testname="$(echo "$0" | sed -e 's/^.*tests\///g')"
> +       declare -a missing=()
> +
> +       for group in "$@"; do
> +               if ! grep -q "^${group}[[:space:]]" "$GROUPNAME_DOC_FILE"; then
> +                       missing+=("\"${group}\"")
> +               fi
> +       done
> +       test "${#missing}" -eq 0 && return 0
> +
> +       local suffix=
> +       test "${#missing}" -gt 1 && suffix="s"
> +       echo "$testname: group$suffix ${missing[@]} not mentioned in documentation." 1>&2
> +       return 1
> +}
> +
>  # Prepare to run a fstest by initializing the required global variables to
>  # their defaults, sourcing common functions, registering a cleanup function,
>  # and removing the $seqres.full file.
> @@ -42,6 +62,7 @@ _begin_fstest()
>         # If we're only running the test to generate a group.list file,
>         # spit out the group data and exit.
>         if [ -n "$GENERATE_GROUPS" ]; then
> +               _check_groups "$@" || exit 1
>                 echo "$seq $@"
>                 exit 0
>         fi
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> new file mode 100644
> index 00000000..e8e3477e
> --- /dev/null
> +++ b/doc/group-names.txt
> @@ -0,0 +1,135 @@
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
> +collapse               fallocate FALLOC_FL_COLLAPSE_RANGE
> +compress               file compression
> +convert                        btrfs ext[34] conversion tool
> +copy                   xfs_copy functionality
> +copy_range             copy_file_range syscall
> +copyup                 overlayfs copyup
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
> +insert                 fallocate FALLOC_FL_INSERT_RANGE
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
> +pattern                        specific IO pattern tests
> +perms                  access control and permission checking
> +pipe                   pipe functionality
> +pnfs                   PNFS
> +posix                  POSIX behavior conformance
> +prealloc               fallocate for preallocating unwritten space
> +preallocrw             fallocate, then read and write
> +punch                  fallocate FALLOC_FL_PUNCH_HOLE
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
> +rotate                 overlayfs upper layer rotate tests from the unionmount
> +                       test suite
> +rw                     read/write IO tests
> +samefs                 overlayfs when all layers are on the same fs
> +scrub                  filesystem metadata scrubbers
> +seed                   btrfs seeded filesystems
> +seek                   llseek functionality
> +send                   btrfs send/receive
> +shrinkfs               decreasing the size of a filesystem
> +shutdown               FS_IOC_SHUTDOWN ioctl
> +snapshot               btrfs snapshots
> +soak                   long running soak tests of any kind
> +spaceman               xfs_spaceman functional tests
> +splice                 splice system call
> +stress                 fsstress filesystem exerciser
> +subvol                 btrfs subvolumes
> +swap                   swap files
> +symlink                        symbolic links
> +tape                   dump and restore with a tape
> +thin                   thin provisioning
> +trim                   FITRIM ioctl
> +udf                    UDF functionality tests
> +union                  tests from the unionmount test suite
> +unlink                 O_TMPFILE unlinked files
> +unshare                        fallocate FALLOC_FL_UNSHARE_RANGE
> +v2log                  XFS v2 log format tests
> +verity                 fsverity
> +volume                 btrfs volume management
> +whiteout               overlayfs whiteout functionality
> +xino                   overlayfs xino feature
> +zero                   fallocate FALLOC_FL_ZERO_RANGE
> +zone                   zoned (SMR) device support
> +======================= =======================================================
> diff --git a/tools/mkgroupfile b/tools/mkgroupfile
> index 0681e5d2..767bac90 100755
> --- a/tools/mkgroupfile
> +++ b/tools/mkgroupfile
> @@ -9,6 +9,8 @@ fi
>
>  test_dir="$PWD"
>  groupfile="$1"
> +GROUPNAME_DOC_FILE="$(readlink -m ../../doc/group-names.txt)"
> +export GROUPNAME_DOC_FILE
>
>  if [ ! -x ../../check ]; then
>         echo "$0: Run this from tests/XXX/."
> @@ -24,19 +26,26 @@ ENDL
>         cd ../../
>         export GENERATE_GROUPS=yes
>         grep -R -l "^_begin_fstest" "$test_dir/" 2>/dev/null | while read testfile; do
> -               test -x "$testfile" && "$testfile"
> +               test -x "$testfile" && "$testfile" || return 1
>         done | sort -g
> +       local ret="${PIPESTATUS[1]}"
>         cd "$test_dir"
> +       return $ret
>  }
>
>  if [ -z "$groupfile" ] || [ "$groupfile" = "-" ]; then
>         # Dump the group file to stdout and exit
>         generate_groupfile
> -       exit 0

Now the comment above is incorrect, but I think you
did want to exit $ret?

>  fi
>
>  # Otherwise, write the group file to disk somewhere.
>  ngroupfile="${groupfile}.new"
>  rm -f "$ngroupfile"
>  generate_groupfile >> "$ngroupfile"
> -mv "$ngroupfile" "$groupfile"
> +ret=$?
> +if [ $ret -eq 0 ]; then
> +       mv "$ngroupfile" "$groupfile"
> +else
> +       rm -f "$ngroupfile"
> +fi
> +exit $ret

I think that a cleanup() trap would have made this script a lot cleaner,
not having to deal with ${PIPESTATUS[1]} and whatnot, but if there is
a reason not to use cleanup() trap, I'm fine with this as well.

Thanks,
Amir.
