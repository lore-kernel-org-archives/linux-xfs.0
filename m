Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:57328 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932274AbdJZE7l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 00:59:41 -0400
MIME-Version: 1.0
In-Reply-To: <20171025204704.3382-1-ross.zwisler@linux.intel.com>
References: <CAOQ4uxh25JmAv3DjCp11fAfpHVP=d2sp+=Gk4SxYfBtmOgaUPw@mail.gmail.com>
 <20171025204704.3382-1-ross.zwisler@linux.intel.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 26 Oct 2017 07:59:39 +0300
Message-ID: <CAOQ4uxjAnMed7-BTZWe6JUC4Fa-nApKvx9-_PzewmfcZ48cP7g@mail.gmail.com>
Subject: Re: [fstests PATCH v3] generic: add test for DAX MAP_SYNC support
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Josef Bacik <jbacik@fb.com>, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, Oct 25, 2017 at 11:47 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Add a test that exercises DAX's new MAP_SYNC flag.
>
> This test creates a file and writes to it via an mmap(), but never syncs
> via fsync/msync.  This process is tracked via dm-log-writes, then replayed.
>
> If MAP_SYNC is working the dm-log-writes replay will show the test file
> with 1MiB of on-media block allocations.  This is because each allocating
> page fault included an implicit metadata sync.  If MAP_SYNC isn't working
> (which you can test by fiddling with the parameters to mmap()) the file
> will be smaller or missing entirely.
>
> Note that dm-log-writes doesn't track the data that we write via the
> mmap(), so we can't do any data integrity checking.  We can only verify
> that the metadata writes for the page faults happened.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>
> ---
>
> Changes since v2:
>  - Fixed _require_log_writes() so that DAX will be disallowed if the
>    version of the dm-log-writes target is older than v1.1.0.  (Amir)

It seems like your kernel patch bumped the version to 1.0.1...

>
> ---
>  .gitignore            |  1 +
>  common/dmlogwrites    |  4 ++-
>  common/rc             |  6 ++--
>  src/Makefile          |  3 +-
>  src/t_map_sync.c      | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/466     | 76 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/466.out |  3 ++
>  tests/generic/group   |  1 +
>  8 files changed, 182 insertions(+), 4 deletions(-)
>  create mode 100644 src/t_map_sync.c
>  create mode 100755 tests/generic/466
>  create mode 100644 tests/generic/466.out
>
> diff --git a/.gitignore b/.gitignore
> index 2014c08..9fc0695 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -119,6 +119,7 @@
>  /src/t_getcwd
>  /src/t_holes
>  /src/t_immutable
> +/src/t_map_sync
>  /src/t_mmap_cow_race
>  /src/t_mmap_dio
>  /src/t_mmap_fallocate
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> index 247c744..71d008d 100644
> --- a/common/dmlogwrites
> +++ b/common/dmlogwrites
> @@ -23,8 +23,10 @@ _require_log_writes()
>         [ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
>                 _notrun "This test requires a valid \$LOGWRITES_DEV"
>
> -       _exclude_scratch_mount_option dax
>         _require_dm_target log-writes
> +       if [[ ${DMTARGET_VER[0]} == 1 && ${DMTARGET_VER[1]} < 1 ]]; then
> +               _exclude_scratch_mount_option dax
> +       fi

IMO, this would be better as:

        local z=0
        _scratch_has_mount_option dax && z=1
        _require_dm_target log-writes 1 0 $z

Or something like that
