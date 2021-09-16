Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA241C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F2E611C8
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbhIPGAJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 02:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbhIPGAJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 02:00:09 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3558EC061574;
        Wed, 15 Sep 2021 22:58:49 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q3so6526177iot.3;
        Wed, 15 Sep 2021 22:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yPMMvHj/PtnLUvheo+76/JaQaHj1Ft+313LVXjTJKMQ=;
        b=Ee9vi5P3O0C7vStO+GGQP7fs3f08Y22Aui3rJMuAcOkNSB1xiueXa2WO33CxXA7rCp
         wQ+J2t2llWUOpryXegjeiiyyjLCtId0cjk9kX1lg7tMIzFIBbvNgTt21GQRkHeT1Iu3L
         d4YlS7LiCQB50GTqMgCHlwwyIutnB6Al4Pxq1JcmN2PNmCCXR5RcLFXsT2akzKVoh6z/
         BinV0T1XQwjaesh7bi/4waAzVq0NqDu7b7wEunb4hPoOhCLn1JystRkCXuZcwoqC32sm
         +ubss3LAzZ4SpC+rFBgkK7SUlyx3LwUtGcLfAKBnLM/vzN1ik80eXAcGtOebc1PIjksc
         fS2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yPMMvHj/PtnLUvheo+76/JaQaHj1Ft+313LVXjTJKMQ=;
        b=Nsn2/ba2luD3NqwmICx8OCGTd6TGLKdtfAwKNGLL4j1WatB404l7qKYOEgnoPggykz
         tFONkDlVIM2nOhwveJsbKfed+bGICQTxOljWZ/J5zVazuHIbEqZexv6ATwY58PXg5+MT
         iUyeSydQK/7Z6HruFCmLI3zU/uW+rSpAu+aXiBlZu8mo2eDcSlwaaVwrZYUTd4y+mDde
         6ANHdRBo1sJFDXYdo+1TN7Q2tW+av7/+z8TRq2dz8iMPnD+ll5S0XYIjYJf1MhsUmduv
         /9hhkbgZojxlftFv9RLaIUdzd5xNRJfoH89KtcbrPq3Cw90ews5UalblVz8heIwiK/r0
         cnNg==
X-Gm-Message-State: AOAM531ikkb9Sq4fly1TOL2LIZs33xddzaasNPDWGLMkOEZrPf2FosK2
        bcVmtcupEu+YlTGKE8kpyjOyu45uiHgE8VsjJTE=
X-Google-Smtp-Source: ABdhPJw3ZHwwrFcjLFF/OK6LdgOZgqjCgiZ5OwosWCwXFnCX6LW6lH6Bg8LtgKHbXP/4Pqrapz614Ib1SE+SXOd7T14=
X-Received: by 2002:a6b:f007:: with SMTP id w7mr3048238ioc.112.1631771928606;
 Wed, 15 Sep 2021 22:58:48 -0700 (PDT)
MIME-Version: 1.0
References: <163174935747.380880.7635671692624086987.stgit@magnolia> <163174939022.380880.4370326262613244115.stgit@magnolia>
In-Reply-To: <163174939022.380880.4370326262613244115.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Sep 2021 08:58:37 +0300
Message-ID: <CAOQ4uxhPA8dULNa9V+dZ0JPcsyxivXraZQ4vON_Q5=CPL8knKg@mail.gmail.com>
Subject: Re: [PATCH 6/9] tools: make sure that test groups are described in
 the documentation
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 2:43 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Create a file to document the purpose of each test group that is
> currently defined in fstests, and change mkgroupfile to check that every
> group mentioned in the tests is also mentioned in the documentation.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  common/preamble     |   21 ++++++++
>  doc/group-names.txt |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/mkgroupfile   |   33 +++++++++---
>  3 files changed, 181 insertions(+), 8 deletions(-)
>  create mode 100644 doc/group-names.txt
>
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
> index 0681e5d2..e4244507 100755
> --- a/tools/mkgroupfile
> +++ b/tools/mkgroupfile
> @@ -9,12 +9,28 @@ fi
>
>  test_dir="$PWD"
>  groupfile="$1"
> +GROUPNAME_DOC_FILE="$(readlink -m ../../doc/group-names.txt)"
> +export GROUPNAME_DOC_FILE
>
>  if [ ! -x ../../check ]; then
>         echo "$0: Run this from tests/XXX/."
>         exit 1
>  fi
>
> +cleanup() {
> +       test -z "$groupfile" && return
> +       test -z "$ngroupfile" && return
> +
> +       if [ $ret -eq 0 ]; then
> +               mv "$ngroupfile" "$groupfile"
> +       else
> +               rm -f "$ngroupfile"
> +       fi
> +}
> +
> +ret=1  # trigger cleanup of temporary files unless we succeed
> +trap 'cleanup; exit $ret' EXIT INT TERM QUIT
> +
>  generate_groupfile() {
>         cat << ENDL
>  # QA groups control file, automatically generated.
> @@ -24,19 +40,20 @@ ENDL
>         cd ../../
>         export GENERATE_GROUPS=yes
>         grep -R -l "^_begin_fstest" "$test_dir/" 2>/dev/null | while read testfile; do
> -               test -x "$testfile" && "$testfile"
> +               test -x "$testfile" && "$testfile" || return 1
>         done | sort -g
> +       ret="${PIPESTATUS[1]}"
>         cd "$test_dir"
>  }
>
>  if [ -z "$groupfile" ] || [ "$groupfile" = "-" ]; then
>         # Dump the group file to stdout and exit
> +       unset groupfile
>         generate_groupfile
> -       exit 0
> +else
> +       # Otherwise, write the group file to disk somewhere.
> +       ngroupfile="${groupfile}.new"
> +       rm -f "$ngroupfile"
> +       generate_groupfile >> "$ngroupfile"
> +       # let cleanup rename or delete ngroupfile
>  fi
> -
> -# Otherwise, write the group file to disk somewhere.
> -ngroupfile="${groupfile}.new"
> -rm -f "$ngroupfile"
> -generate_groupfile >> "$ngroupfile"
> -mv "$ngroupfile" "$groupfile"
>
