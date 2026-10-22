Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792675583;
	b=1S1Dp34k9Zz5tqKxBG0vSzIdHSNjqliM/dVee8OfIvDiMH6UpdyCX8jKv/SlVzk/s065
	 sTROoPYfx+bJuPdXmVWKJZk+RgRkh3g8Xp86X9ENaT3pocJ+j0DphI9QcVQFWd4LOSipa
	 MWZs0Zbzwpv+Y0CFjr7qSeqtEjOE8h4TMc7cwVsbAyYyW9iSik+/GIBaKoJpbob38qVDn
	 N3nAbzE8FwgA8CCNO/RCwj2TxwLgbO4zAeXA1vYrEc8m9PzCBcJ2vmjQ+Ej5LxC2D+ehl
	 SbZXOd3DAhdXDMQ/csTj4DxOaCNmmFRN48jD9E1xUdyZtZRztQ5ib4d6Af2CvrZJitw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792675583;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=4/DGRkNQiV1KJWdtQ6rC+i/U0wKyT8NwFnLB9VWxUA0=;
	b=odCnjfhcs+6b93twRhuavVg3QtE9fjL90jyzU5nMEPKFrksRW8M+APkrcppWQc868OR+
	 BrM3EGYL4a9Xt/8+JXBCTFLSjZNoBgElp1+NLNCtZszA6+GIfZutwIegd8r8Sbtcok7Q5
	 aUtB1BdlUUlooDZT9WWR8XkpFyLuzXzLPB0d2VdOjS976KWEXc9CLKNockBLxCxRFci61
	 E+CJa85vlV0O2tsF7JJ3czzz6qfl0rq5qFyhKGf4T9uPKWiuBI40mN6kFzg73r4JYiVYo
	 H3bn49tx4eCa/TcOGLZzL7FdUm5pWO6jcU+UDBjomUYUN5u6cy6k9tY8lC9Re6yQyUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a6a4KZOb;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCB4606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2026 13:26:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CCB4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a6a4KZOb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792675582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4/DGRkNQiV1KJWdtQ6rC+i/U0wKyT8NwFnLB9VWxUA0=;
	b=a6a4KZObmpojIaNm6r+AfAlMLxfJtr4XYVq5fPmpzwmIASIMrWCY128X1HB6+yUHECcAVr
	JLfN4hbq5l3kr9yhcXJD7OJ0x+9NyKPKWSMIsxMgEP+sIp6beTStPLgsmVnQaNvE6vXhSp
	JbgiMzPW5MjHfumghfpln+kIXvzdBD8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-1-ZdFnIKOK2CuXx6ZuU4YQ-1; Thu,
 22 Oct 2026 09:26:13 -0400
X-MC-Unique: 1-ZdFnIKOK2CuXx6ZuU4YQ-1
X-Mimecast-MFC-AGG-ID: 1-ZdFnIKOK2CuXx6ZuU4YQ_1792675572
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 053171955DC0;
	Thu, 22 Oct 2026 13:26:12 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB1791956089;
	Thu, 22 Oct 2026 13:26:10 +0000 (UTC)
Date: Thu, 22 Oct 2026 09:26:08 -0400
From: Brian Foster <bfoster@redhat.com>
To: Lukas Herbolt <lherbolt@redhat.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/1] xfs: add test for ENOSR/ENOSPC on DIO into delalloc
 extents
Message-ID: <atoO8FTTt97n5oXv@bfoster>
References: <20261016091628.295119-1-lherbolt@redhat.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016091628.295119-1-lherbolt@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Oct 16, 2026 at 11:16:25AM +0200, Lukas Herbolt wrote:
>   Test if a DIO extending write into a speculative delalloc region on a
>   fragmented XFS filesystem does not trigger a dirty transaction cancel
>   (-ENOSR) or return a spurious -ENOSPC.
> 
>   With allocsize=128MB, a buffered write creates a large delalloc extent.
>   A subsequent DIO write at i_size lands in the speculative prealloc
>   region. On a fragmented filesystem, xfs_bmapi_write converts the
>   delalloc starting from offset 0 but the allocation is too short to
>   reach the DIO offset, causing either -ENOSR (dirty transaction cancel
>   and filesystem shutdown) or -ENOSPC (wrong error from xfs_bmapi_write).
> 
>   Assisted by LLM.
> 
>   Fixed by kernel commits:
>     2a9b99d45be0 xfs: pass the actual offset and len to xfs_bmapi_allocate
>     21255afdd729 xfs: do not allocate the entire delalloc extent
>     6773da870ab8 xfs: fix error returns from xfs_bmapi_write
> 
> Co-developed-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Lukas Herbolt <lherbolt@redhat.com>
> ---
>  .gitignore                 |   2 +
>  src/Makefile               |   3 +-
>  src/buffer_direct_io.c     | 154 ++++++++++++++++++++++++++++++++
>  src/fragment_fs.c          | 101 +++++++++++++++++++++
>  src/mix_buffer_direct_io.c | 175 +++++++++++++++++++++++++++++++++++++
>  tests/xfs/842              |  63 +++++++++++++
>  tests/xfs/842.out          |   2 +
>  7 files changed, 499 insertions(+), 1 deletion(-)
>  create mode 100644 src/buffer_direct_io.c
>  create mode 100644 src/fragment_fs.c
>  create mode 100644 src/mix_buffer_direct_io.c
>  create mode 100755 tests/xfs/842
>  create mode 100644 tests/xfs/842.out
> 
...

Just a few higher level comments..

> diff --git a/src/buffer_direct_io.c b/src/buffer_direct_io.c
> new file mode 100644
> index 000000000000..01b19994a2e2
> --- /dev/null
> +++ b/src/buffer_direct_io.c
...
> diff --git a/src/fragment_fs.c b/src/fragment_fs.c
> new file mode 100644
> index 000000000000..cee4edef73ff
> --- /dev/null
> +++ b/src/fragment_fs.c
> @@ -0,0 +1,101 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2026 Eric Sandeen, Lukas Herbolt
> + */
> +
> +/*
> + * Fragment filesystem by creating fixed-size files and then deleting
> + * every n-th one.
> + *
> + * Usage:
> + *	fragment_fs <directory> <prefix> <file size> <delete every n-th file>
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <sys/statvfs.h>
> +
> +static int fragment_fs(const char *dir, const char *prefix,
> +		       off_t size, int delete_nth)
> +{
> +	char path[4096];
> +	int i, fd;
> +	int created = 0;
> +
> +	fprintf(stderr, "Fragmenting filesystem (filling to ENOSPC)...\n");
> +
> +	for (i = 0; ; i++) {
> +		snprintf(path, sizeof(path), "%s/%s_%06d", dir, prefix, i);
> +		fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
> +		if (fd < 0) {
> +			if (errno == ENOSPC)
> +				break;
> +			perror("open frag file");
> +			return -1;
> +		}
> +		if (fallocate(fd, 0, 0, size) < 0) {
> +			close(fd);
> +			unlink(path);
> +			if (errno == ENOSPC)
> +				break;
> +			perror("fallocate frag file");
> +			return -1;
> +		}
> +		close(fd);
> +		created++;
> +	}
> +	fprintf(stderr, "Created %d files\n", created);
> +
> +	fprintf(stderr, "Deleting every %d-th file...\n", delete_nth);
> +	for (i = 0; i < created; i += delete_nth) {
> +		snprintf(path, sizeof(path), "%s/%s_%06d", dir, prefix, i);
> +		unlink(path);
> +	}
> +	sync();
> +
> +	{
> +		struct statvfs st;
> +		if (statvfs(dir, &st) == 0) {
> +			unsigned long free_mb = (st.f_bfree * st.f_bsize)
> +						/ (1024 * 1024);
> +			fprintf(stderr,
> +				"%d files remain, ~%lu MB free\n",
> +				created - created / delete_nth, free_mb);
> +		}
> +	}
> +
> +	return 0;
> +}
> +

Any chance we can reuse existing code in fstests for this sort of free
space fragmentation? For example, see the punch-alternating tool and/or
something like generic/186 (if useful, maybe that code can be lifted
into a common helper).

...
> diff --git a/src/mix_buffer_direct_io.c b/src/mix_buffer_direct_io.c
> new file mode 100644
> index 000000000000..0af227a7c9f0
> --- /dev/null
> +++ b/src/mix_buffer_direct_io.c
> diff --git a/tests/xfs/842 b/tests/xfs/842
...

It looks like we have two mix I/O helper programs here, where this one
appears unused..?

Also both appear to have some minor whitespace damage in the form of
trailing spaces at the end of some lines, so it might be worth fixing
that up as well.

> new file mode 100755
> index 000000000000..b2b2f7c493e7
> --- /dev/null
> +++ b/tests/xfs/842
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Lukas Herbolt.  All Rights Reserved.
> +#
> +# FS QA Test 842
> +#
> +# Regression test for XFS -ENOSR dirty transaction cancel during DIO
> +# write into a speculative delalloc region on a fragmented filesystem.
> +# With allocsize=128MB, a buffered write creates a large delalloc extent.
> +# A subsequent DIO extending write at i_size triggers xfs_bmapi_write to
> +# convert the delalloc from offset 0; on a fragmented FS the allocation
> +# is too short to reach the DIO offset, returning -ENOSR and cancelling
> +# a dirty transaction, which shuts down the filesystem.
> +#
> +. ./common/preamble
> +_begin_fstest auto enospc
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_require_test

Looks like we don't use the test dev in this test.

> +_require_scratch
> +_require_test_program "fragment_fs"
> +_require_test_program "buffer_direct_io"
> +
> +_scratch_mkfs_sized $((1<<30)) > "$seqres.full" 2>&1
> +_scratch_mount -o allocsize=131072k >> "$seqres.full" 2>&1
> +
> +src/fragment_fs $SCRATCH_MNT frag 4096 2 >> "$seqres.full" 2>&1
> +src/buffer_direct_io $SCRATCH_MNT >> "$seqres.full" 2>&1
> +RET=$?
> +
> +_dmesg_since_test_start | grep -q "detected at xfs_trans_cancel"
> +DMESG_CHECK=$?
> +
> +if [ $RET -eq 5 -a $DMESG_CHECK -eq 0 ]; then
> +	_fixed_by_kernel_commit 2a9b99d45be0 \
> +		"xfs: pass the actual offset and len to xfs_bmapi_allocate"
> +	_fixed_by_kernel_commit 21255afdd729 \
> +		"xfs: do not allocate the entire delalloc extent"
> +	_fail "ENOSR dirty transaction cancel detected (ret=$RET)"
> +
> +elif [ $RET -eq 28 ]; then
> +	_fixed_by_kernel_commit 2a9b99d45be0 \
> +		"xfs: pass the actual offset and len to xfs_bmapi_allocate"
> +	_fixed_by_kernel_commit 21255afdd729 \
> +		"xfs: do not allocate the entire delalloc extent"
> +	_fixed_by_kernel_commit 6773da870ab8 \
> +		"xfs: fix error returns from xfs_bmapi_write"
> +	_fail "ENOSPC returned from xfs_bmapi_write (ret=$RET)"
> +
> +elif [ $RET -eq 0 ]; then
> +	echo "Silence is golden"
> +else
> +	_fail "Unknown error: src/buffer_direct_io error code $RET"
> +fi

A brief comment above this might be helpful. I'm also curious if it can
be simplified a little. For example, I'm not sure we need to explicitly
_fail when we can rely on golden output and/or the dmesg checking that
happens by default. Also it looks like the commit hints are duplicate
except for the -ENOSPC specific one. So perhaps we could do something
like the following?

echo "Silence is golden"

# words about the error codes, i.e. EIO vs ENOSPC?
if [ $RET -neq 0 ]; then
	_fixed_by_kernel_commit <X>
	_fixed_by_kernel_commit <Y>
	[ $RET -eq 28 ] && _fixed_by_kernel_commit <Z>
	echo "... error code $RET"
fi

Brian

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> new file mode 100644
> index 000000000000..643d05289a33
> --- /dev/null
> +++ b/tests/xfs/842.out
> @@ -0,0 +1,2 @@
> +QA output created by 842
> +Silence is golden
> -- 
> 2.56.0
> 
> 

