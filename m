Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:44684 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfBLCme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 21:42:34 -0500
MIME-Version: 1.0
References: <154993786231.2062.8490515215533507881.stgit@magnolia> <154993787478.2062.17047634303195751186.stgit@magnolia>
In-Reply-To: <154993787478.2062.17047634303195751186.stgit@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 12 Feb 2019 04:42:21 +0200
Message-ID: <CAOQ4uxjz=Wp1wg2vmvmTe8g69qzN2FF_+nJ=FJZkTsNPMPLCvA@mail.gmail.com>
Subject: Re: [PATCH 2/2] generic: check the behavior of programs opening a lot
 of O_TMPFILE files
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Tue, Feb 12, 2019 at 4:18 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Create a test (+ helper program) that opens as many unlinked files as it
> possibly can on the scratch filesystem, then closes all the files at
> once to stress-test unlinked file cleanup.  Add an xfs-specific test to
> make sure that the fallback code doesn't bitrot.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  src/Makefile          |    2 -
>  src/tmpfile.c         |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/710     |   65 +++++++++++++++++++++++++
>  tests/generic/710.out |    2 +
>  tests/generic/711     |   73 ++++++++++++++++++++++++++++
>  tests/generic/711.out |    2 +
>  tests/generic/group   |    2 +
>  tests/xfs/736         |   71 +++++++++++++++++++++++++++
>  tests/xfs/736.out     |    2 +
>  tests/xfs/737         |   79 ++++++++++++++++++++++++++++++
>  tests/xfs/737.out     |    2 +
>  tests/xfs/group       |    2 +
>  12 files changed, 428 insertions(+), 1 deletion(-)
>  create mode 100644 src/tmpfile.c
>  create mode 100755 tests/generic/710
>  create mode 100644 tests/generic/710.out
>  create mode 100755 tests/generic/711
>  create mode 100644 tests/generic/711.out
>  create mode 100755 tests/xfs/736
>  create mode 100644 tests/xfs/736.out
>  create mode 100755 tests/xfs/737
>  create mode 100644 tests/xfs/737.out
>
>
> diff --git a/src/Makefile b/src/Makefile
> index 41826585..5fce881d 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -27,7 +27,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>         renameat2 t_getcwd e4compact test-nextquota punch-alternating \
>         attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
>         dio-invalidate-cache stat_test t_encrypted_d_revalidate \
> -       attr_replace_test swapon mkswap
> +       attr_replace_test swapon mkswap tmpfile
>
>  SUBDIRS = log-writes perf
>
> diff --git a/src/tmpfile.c b/src/tmpfile.c

Let's go crazy and call it t_open_tmpfiles ?
Missing .gitignore patch.

...
> +/* Put an opened file on the unlinked list and leak the fd. */
> +void leak_tmpfile(void)
> +{
> +       int fd = -1;
> +       int ret;
> +
> +       /* Try to create an O_TMPFILE and leak the fd. */
> +#ifdef O_TMPFILE
> +       fd = open(".", O_TMPFILE | O_RDWR, 0644);

Pass in path as argv[1], so you won't need to cd $SCRATCH_MNT
all the time. Or does it have a purpose?

Thanks,
Amir.
