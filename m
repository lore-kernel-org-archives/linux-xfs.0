Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33116 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbdAKGiq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 01:38:46 -0500
MIME-Version: 1.0
In-Reply-To: <1483968625-29160-4-git-send-email-amir73il@gmail.com>
References: <1483968625-29160-1-git-send-email-amir73il@gmail.com> <1483968625-29160-4-git-send-email-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Jan 2017 08:38:45 +0200
Message-ID: <CAOQ4uxhoDdfoh0-OMkNgB6VEOpeOO5qj1GG9=D+cXpi6XLPQkA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] xfs: test readlink/readdir with malformed inode mode
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org

On Mon, Jan 9, 2017 at 3:30 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> In addition to testing xfs_repair on inodes with malformed mode,
> and fstat of those inodes on a mounted fs, try to also list content
> of mock directory and readlink of mock symlink.
>
> Readdir of mock directory triggers XFS assertion on kernel 4.9 with
> XFS_DEBUG=y
>
> XFS: Assertion failed:
>      rval == 0 || args->dp->i_d.di_size == args->geo->blksize,
> file: /home/amir/build/src/linux/fs/xfs/libxfs/xfs_dir2.c, line: 634
>
> A fix patch, as suggested by Darrick, changes this ASSERT() to
> return -EFSCORRUPTED ("xfs: sanity check directory inode di_size").
>
> Merging this test should be deferred to after fix patch is merged.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/xfs/348 | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/tests/xfs/348 b/tests/xfs/348
> index 30825a4..20d5d7e 100755
> --- a/tests/xfs/348
> +++ b/tests/xfs/348
> @@ -133,6 +133,15 @@ for dt in $dtypes; do
>                         cat $tmp.stat.err
>                 else
>                         echo "stat: '$testdir/$file' is a $ftype"
> +                       # Verify that readlink of a file posing as a symlink
> +                       # and ls of a file posing as a directory does not blow up.
> +                       # NOTE that ls DOES ASSERT with kernel 4.9 and XFS_DEBUG=y
> +                       # on malformed directory
> +                       if [ -d $testdir/$file ]; then
> +                               ls "$safety" $testdir/$file &> /dev/null

leftover: "$safety"

> +                       elif [ -h $testdir/$file ]; then
> +                               readlink $testdir/$file &> /dev/null
> +                       fi
>                 fi | _filter_scratch
>         done
>         _scratch_unmount
> --
> 2.7.4
>
