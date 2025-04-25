Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E05A26D4DE;
	Fri, 25 Apr 2025 15:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745593506; cv=none; b=fFOrNDwjhTEpfkpKRceaziQ5gQ+eJaTsU25uHPS91dChNwR8K076RwcQhZeWAI3d4fSDcJyGHjOLnCqhUfW7A1IxTqljYKx2mw5pfDVUsMfLliPNPteUnM9UCr/LejD2jxCLsCa9OxkMxNhRIrkUhnyF8E1zOBGx39gE20mMO4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745593506; c=relaxed/simple;
	bh=mJ5BRMzYDg3ycbwAnlzNi5oIBdiqjlgEe47UBsM1zDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5DiYzLpJrjsWa+jgDGGMDPDvl5Mrw4/tJZTqk1OdHlyUeOO4vB/wWD7sa2XZcM/zS+DJL1DrZ5eXkxfEmwM3u4+f33tV8CA8to5WKCrEvaDUIngiJpLkNL8IfNacxy3HKwLvUWtu+y2F00/zKM0Yj7ChrScZODP4AwSG66oqLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q2iLbXQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q2iLbXQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA37BC4CEE9;
	Fri, 25 Apr 2025 15:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745593505;
	bh=mJ5BRMzYDg3ycbwAnlzNi5oIBdiqjlgEe47UBsM1zDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q2iLbXQDn1dTtP5pbs+ramhLF3IwCWxWYL+bmC6aFt9oRbFk2bSYXjS7VkTR3Yg8b
	 et+gYDAHlSp2bJKlovqMwcDRTmyjM64QddjOPfPU4sJlFhVGhp4O1AiOJNro2PpqZu
	 ELr2WwdtKggCSUQqDVDMpM3x3xGpNipK809YlnCWFuXpmCByKQZy7FOUh98AngTv1w
	 6wyUhpVA2dRALFNF/HSJkiDDT3W9csVFfHXYZeewV/pve8wOHU9enKGBmLkjq2cGe2
	 DluGIB2nZdUNTOgZEerJO68U+aSjSH0Ct/73TPCjM+SeChnM/lnnHEL3oEEuP7y3TL
	 8PiTlztPXfduA==
Date: Fri, 25 Apr 2025 08:05:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"zlang@kernel.org" <zlang@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>, hch <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: add mount test for read only log devices
Message-ID: <20250425150504.GH25667@frogsfrogsfrogs>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-3-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425090259.10154-3-hans.holmberg@wdc.com>

On Fri, Apr 25, 2025 at 09:03:23AM +0000, Hans Holmberg wrote:
> Make sure that we can mount log devices read-only if them themselves
> are marked as read-only.
> 
> Also make sure that rw re-mounts are not allowed if the device is
> marked as read-only.
> 
> Based on generic/050.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
>  tests/xfs/838     | 55 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/838.out | 10 +++++++++
>  2 files changed, 65 insertions(+)
>  create mode 100755 tests/xfs/838
>  create mode 100644 tests/xfs/838.out
> 
> diff --git a/tests/xfs/838 b/tests/xfs/838
> new file mode 100755
> index 000000000000..93a39a7ec8e9
> --- /dev/null
> +++ b/tests/xfs/838
> @@ -0,0 +1,55 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2009 Christoph Hellwig.
> +# Copyright (c) 2025 Western Digital Corporation.
> +#
> +# FS QA Test No. 838
> +#
> +# Check out various mount/remount/unmount scenarious on a read-only logdev
> +# Based on generic/050
> +#
> +. ./common/preamble
> +_begin_fstest mount auto quick
> +
> +_cleanup_setrw()
> +{
> +	cd /
> +	blockdev --setrw $SCRATCH_LOGDEV
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +_require_logdev
> +_require_local_device $SCRATCH_LOGDEV
> +_register_cleanup "_cleanup_setrw"
> +
> +_scratch_mkfs >/dev/null 2>&1
> +
> +#
> +# Mark the log device read-only
> +#
> +echo "setting device read-only"
> +blockdev --setro $SCRATCH_LOGDEV
> +
> +#
> +# Mount and make sure it can't be written to.
> +#
> +echo "mounting read-only log block device:"
> +_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
> +if [ "${PIPESTATUS[0]}" -eq 0 ]; then
> +	echo "writing to file on read-only filesystem:"
> +	dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M count=1 oflag=direct 2>&1 | _filter_scratch

As I mentioned over in the other thread, perhaps this test should check
that a readonly log device results in a norecovery mount and that
pending changes don't show up if the mount succeeds?

Also, ext4 supports external log devices, should this be in
tests/generic?

--D

> +else
> +	_fail "failed to mount"
> +fi
> +
> +echo "remounting read-write:"
> +_scratch_remount rw 2>&1 | _filter_scratch | _filter_ro_mount
> +
> +echo "unmounting read-only filesystem"
> +_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
> +
> +# success, all done
> +echo "*** done"
> +status=0
> diff --git a/tests/xfs/838.out b/tests/xfs/838.out
> new file mode 100644
> index 000000000000..673b48f42a4e
> --- /dev/null
> +++ b/tests/xfs/838.out
> @@ -0,0 +1,10 @@
> +QA output created by 838
> +setting device read-only
> +mounting read-only log block device:
> +mount: device write-protected, mounting read-only
> +writing to file on read-only filesystem:
> +dd: failed to open 'SCRATCH_MNT/foo': Read-only file system
> +remounting read-write:
> +mount: cannot remount device read-write, is write-protected
> +unmounting read-only filesystem
> +*** done
> -- 
> 2.34.1
> 
