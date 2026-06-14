Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64A1222590;
	Sun, 14 Jun 2026 18:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781463185; cv=none; b=uFEJGxUIF2xVVl4iJSfqaZmJ7c0LBmgu9gGTS0RBMAZO3R5ZYn2bmDhLcDx1q7A7hl/OH/Oet3J7k82IN8dL1BsGBOEvPGDPM0TC9tEFM3fohP1JeOTAQZGQpCEc2X9uI7p6rBqplcmPrW8798q/tZIeAewNEKxM7w4Qd2tvXW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781463185; c=relaxed/simple;
	bh=0IkDNzvs5HVx6quuYlexaIYHqqgbLYQCEUiqu0/AV54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tgbu4M/LvKqkOGK7Oqc7XUhw0pDiExOUE6bHPUEMwvZubWD8mUbHTaIPHSB/X2HE5bnAV4dP8w+n6fKm2H/T2JosZsR7ffaU35wB+QwPf/W1WOl9oSQVQMpNKpAK/a4r2FgCQ99BCIDDSJ5Pzcznp/PYdOCzZVxwvUe7nmosMBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QsBAgDP+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QsBAgDP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032681F000E9;
	Sun, 14 Jun 2026 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781463183;
	bh=LNR/GdBrMIMbKEevaIicbyP0puHylnA0PLZKFUSybpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QsBAgDP+BQBu0URGUibCqDVwDqEd4CiJWcfzobwbMgSLWWFeczOU4d0LHmTCZdens
	 IJZRoHPeKKFuRf13bwwwSxvL4n+Qaq8hagMGoBVIJ41055O7xJbG3wbMdx3O/yUCHB
	 Ue8CDR369LuNUWmSBN/oxBUf38pg5BnaCBzHQ3L15Af+L+rqDdyMkdN5XvHclGRmXz
	 UHLWQuM9dPGIrORbyfeuRnNTsgMmjqj02yon5/O3rgxoiIk/IwwlKn7/JZYzVUcl1E
	 4UN78Hv8jM2+Ecyw/+SA3pdudVTyFjizZIM99ekHe6+3PF3C/dYEP7UopRMsCgQTDD
	 Io7uqNEu7AIYQ==
Date: Mon, 15 Jun 2026 02:52:57 +0800
From: Zorro Lang <zlang@kernel.org>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/842: test close() deadlocks on frozen filesystems
Message-ID: <ai7oBqnd2dy32Ew9@zlang-mailbox>
Mail-Followup-To: Aditya Srivastava <aditya.ansh182@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>, "Darrick J . Wong" <djwong@kernel.org>, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org
References: <20260612123742.2389-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612123742.2389-1-aditya.ansh182@gmail.com>

On Fri, Jun 12, 2026 at 12:37:42PM +0000, Aditya Srivastava wrote:
> From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> 
> When a file with active speculative post-EOF preallocations is closed,
> XFS synchronously attempts to free them via xfs_free_eofblocks().
> This requires allocating a write transaction, which blocks indefinitely
> if the filesystem is frozen, causing close() to hang.
> 
> Add a regression test using a helper C program to verify that close()
> returns cleanly (with -EAGAIN if using XFS_TRANS_WRITECOUNT_TRYLOCK)
> without blocking the close system call.
> 
> This is a regression test for the corresponding kernel patch:
> "xfs: prevent close() from hanging on frozen filesystems"
>
> On a successfully patched kernel, the close system call returns cleanly
> and the test helper outputs 'close() completed immediately!', matching
> the golden output. On an unpatched kernel, the close system call blocks,
> the helper times out and outputs 'close() hung under freeze!', cleanly
> flagging the deadlock to fstests.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=205833
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1474726
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> ---
>  src/Makefile                 |   1 +
>  src/xfs_freeze_close_repro.c | 127 +++++++++++++++++++++++++++++++++++
>  tests/xfs/842                |  32 +++++++++
>  tests/xfs/842.out            |   2 +
>  4 files changed, 162 insertions(+)
>  create mode 100644 src/xfs_freeze_close_repro.c
>  create mode 100755 tests/xfs/842
>  create mode 100644 tests/xfs/842.out
> 
> diff --git a/src/Makefile b/src/Makefile
> index 31ac43b2..9553e7c9 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -68,6 +68,7 @@ LCFLAGS += -DHAVE_FILE_GETATTR
>  endif
>  
>  ifeq ($(PKG_PLATFORM),linux)
> +LINUX_TARGETS += xfs_freeze_close_repro

Please add xfs_freeze_close_repro into above/original "LINUX_TARGETS = ..."
directly.

>  TARGETS += $(LINUX_TARGETS)
>  endif
>  
> diff --git a/src/xfs_freeze_close_repro.c b/src/xfs_freeze_close_repro.c
> new file mode 100644
> index 00000000..075f2d18
> --- /dev/null
> +++ b/src/xfs_freeze_close_repro.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2026 Aditya Prakash Srivastava. All Rights Reserved.
> + *
> + * xfstests helper to reproduce close() hang on frozen XFS filesystems.
> + */
> +#define _GNU_SOURCE

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <sys/ioctl.h>
> +#include <sys/vfs.h>
> +#include <linux/fs.h>
> +#include <libgen.h>
> +
> +int close_started;
> +int close_completed;

volatile ?

> +
> +void *
> +close_thread(void *arg)
> +{
> +	int fd = *(int *)arg;
> +
> +	close_started = 1;
> +	close(fd);
> +	close_completed = 1;
> +	return NULL;
> +}
> +
> +int
> +main(int argc, char *argv[])
> +{
> +	struct statfs sfs;
> +	char *dir_buf;
> +	char *parent_dir;
> +	int freeze_fd;
> +	int write_fd;
> +	char buf[65536];
> +	pthread_t thread;
> +	int hung = 1;
> +	int i;
> +
> +	if (argc < 2) {
> +		fprintf(stderr, "Usage: %s <file_on_xfs>\n", argv[0]);
> +		return 1;
> +	}
> +
> +	if (statfs(argv[1], &sfs) < 0) {
> +		dir_buf = strdup(argv[1]);
> +		parent_dir = dirname(dir_buf);
> +		if (statfs(parent_dir, &sfs) < 0) {
> +			perror("statfs");
> +			free(dir_buf);
> +			return 1;
> +		}
> +		free(dir_buf);
> +	}
> +	if (sfs.f_type != 0x58465342) {
> +		fprintf(stderr, "Not on XFS\n");
> +		return 1;
> +	}

Why limit this program run on XFS? There're not XFS specific test steps.

> +
> +	dir_buf = strdup(argv[1]);
> +	freeze_fd = open(dirname(dir_buf), O_RDONLY);
> +	if (freeze_fd < 0) {
> +		perror("open dir");
> +		free(dir_buf);
> +		return 1;
> +	}
> +	free(dir_buf);
> +
> +	write_fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
> +	if (write_fd < 0) {
> +		perror("open file");
> +		close(freeze_fd);
> +		return 1;
> +	}
> +
> +	memset(buf, 'A', sizeof(buf));
> +	for (i = 0; i < 320; i++) {
> +		if (write(write_fd, buf, sizeof(buf)) < 0) {
> +			perror("write");
> +			close(write_fd);
> +			close(freeze_fd);
> +			return 1;

goto out_err;

> +		}
> +	}
> +
> +	if (ioctl(freeze_fd, FIFREEZE, 0) < 0) {
> +		perror("ioctl FIFREEZE");
> +		close(write_fd);
> +		close(freeze_fd);
> +		return 1;

goto out_err;

> +	}

frozen = 1;

> +
> +	if (pthread_create(&thread, NULL, close_thread, &write_fd) != 0) {
> +		perror("pthread_create");
> +		ioctl(freeze_fd, FITHAW, 0);
> +		close(write_fd);
> +		close(freeze_fd);
> +		return 1;

goto out_err;

> +	}
> +
> +	while (!close_started)
> +		usleep(1000);
> +
> +	for (i = 0; i < 30; i++) {

I'm wondering if "3 seconds" is enough to make sure "it's hang" absolutely :)

> +		usleep(100000);
> +		if (close_completed) {
> +			hung = 0;
> +			break;
> +		}
> +	}
> +
> +	if (hung)
> +		printf("close() hung under freeze!\n");
> +	else
> +		printf("close() completed immediately!\n");
> +
> +	ioctl(freeze_fd, FITHAW, 0);

frozen = 0;

> +	pthread_join(thread, NULL);
> +	close(freeze_fd);
> +	return hung ? 0 : 1;

out_err:
	if (write_fd >= 0)
		close(write_fd);
	if (frozen)
		ioctl(freeze_fd, FITHAW, 0);
	if (freeze_fd >= 0)
		close(freeze_fd);
	return 1;

> +}
> diff --git a/tests/xfs/842 b/tests/xfs/842
> new file mode 100755
> index 00000000..8b225ea2
> --- /dev/null
> +++ b/tests/xfs/842
> @@ -0,0 +1,32 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Aditya Prakash Srivastava.  All Rights Reserved.
> +#
> +# FS QA Test No. 842
> +#
> +# Verify that closing a file with active speculative post-EOF preallocations
> +# on a frozen XFS filesystem does not deadlock inside close().
> +#
> +. ./common/preamble
> +_begin_fstest auto quick freeze
> +
> +# Import helper functions
> +. ./common/rc
> +. ./common/filter
              ^^^^^^
It's useless.

> +
> +# Real-world configs
> +_supported_fs xfs

There's not "_supported_fs" helper anymore.

And I don't think this case is a xfs specific test case. I think it can be
run on all filesystems which supports fsfreeze --

_require_freeze

> +_require_scratch
> +_require_test_program "xfs_freeze_close_repro"
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +TEST_FILE=$SCRATCH_MNT/test_eofblocks_freeze
> +
> +# Execute the reproducer helper on scratch mount
> +$here/src/xfs_freeze_close_repro $TEST_FILE
> +
> +status=$?

The output of xfs_freeze_close_repro will break the .out, don't need to
set status=$? at here. If you want, you can call _fail ... after the
xfs_freeze_close_repro returns non-zero.

> +_scratch_unmount

"unmount" is not necessary at here. But I think you need a specific _cleanup()
function for this case. Due to your C program does fs freeze. If it's killed
by something suddently, we must make the fs is freezed before running next
test case.

_cleanup()
{
        # Make sure $SCRATCH_MNT is unfreezed
        xfs_freeze -u $SCRATCH_MNT 2>/dev/null

        ....
        ....
}

> +_exit

_exit 0

Since to your kernel patch is still under review, let's see how it goes at first

Thanks,
Zorro

> diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> new file mode 100644
> index 00000000..386fb9cc
> --- /dev/null
> +++ b/tests/xfs/842.out
> @@ -0,0 +1,2 @@
> +QA output created by 842
> +close() completed immediately!
> -- 
> 2.47.3
> 
