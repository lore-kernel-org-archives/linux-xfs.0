Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BD8363BA0;
	Thu, 30 Oct 2025 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761840240; cv=none; b=RzbBpMn0DBCfExj24iVNQYUkfDWbPfstbk1O9EC8jt6XYnovDiYaN+cQAX4S3nejUL5XR3ynWUY3sbFmSD9HR9l/wFFazrttRniu6b16vSdtIdwrgcULUpjUcbGBNUvcyetUeOHln5eAPrkElhoLjwfX5chwwF/z8Ig3nH9dWzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761840240; c=relaxed/simple;
	bh=zc1J58Ua79SZ/pyoU1p3jCoEM1jChlscYQUINVg9gAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9LLQjk39HG56wnUEAASNHdvwPA8K8LJvmj9MPemch/TueOAb+QtHySzJtbQuiAz2lfa24AAiRCWEBDktHmapYoC5pZPCkhdytH8A5KEOLQgXk7CD9ptuKCxsK2Jwp9DxuF7dhxXHza/enZGesIyZRoyU4BzfAnJGUmQpOnsPuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EmiTzV4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EmiTzV4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBC9C4CEF8;
	Thu, 30 Oct 2025 16:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761840240;
	bh=zc1J58Ua79SZ/pyoU1p3jCoEM1jChlscYQUINVg9gAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EmiTzV4K0sqtB9+0y2GtfNYGRwvLtIL8/thiAPWeJQwlGG0vzjwRwIWmI2EO1BEUE
	 i1drQZydSWv9gnNzK1F5gVHTWPwDRyMt5U4eKxhnxXQmjTYmzJM/mAfZqxbRwhdCfn
	 lbSQyeZ4AkD8eZtMjdXR2ttIQCEDXVMb8N1uyOYm1C28gE0id976pjqO1uqMu8HpoH
	 i8I3dAB/MTxFVBboIjiY2yI2nDEq67t79BXNVnrzmFQFSwWg39Tge3bhrk0mCaD5jy
	 TvxYltyBvHPdXk3JFGI+y3Ly09t0haMItUA+V2XEaN7e4PgrDcpsmAmuFB8a/JCihd
	 d22Pp6HJRE7rA==
Date: Thu, 30 Oct 2025 09:03:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, zlang@redhat.com,
	aalbersh@kernel.org
Subject: Re: [PATCH v2 1/2] generic/772: require filesystem to support
 file_[g|s]etattr
Message-ID: <20251030160359.GA6178@frogsfrogsfrogs>
References: <cover.1761838171.patch-series@thinky>
 <lwdr5ntyyszcvqe75ljcqtpcrtjioopoa3abm4fjrdupfmrmx7@2jebme2cchx7>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lwdr5ntyyszcvqe75ljcqtpcrtjioopoa3abm4fjrdupfmrmx7@2jebme2cchx7>

On Thu, Oct 30, 2025 at 04:30:20PM +0100, Andrey Albershteyn wrote:
> Add _require_* function to check that filesystem support these syscalls
> on regular and special files.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/rc         | 32 ++++++++++++++++++++++++++++++++
>  tests/generic/772 |  4 +---
>  tests/xfs/648     |  6 ++----
>  3 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 462f433197..be3cdd8d64 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6032,6 +6032,38 @@
>  	esac
>  }
>  
> +# Require filesystem to support file_getattr()/file_setattr() syscalls on
> +# regular files
> +_require_file_attr()
> +{
> +	local test_file="$TEST_DIR/foo"
> +	touch $test_file
> +
> +	$here/src/file_attr --set --set-nodump $TEST_DIR ./foo &>/dev/null
> +	rc=$?
> +	rm -f "$test_file"
> +
> +	if [ $rc -ne 0 ]; then
> +		_notrun "file_getattr not supported for regular files on $FSTYP"
> +	fi
> +}
> +
> +# Require filesystem to support file_getattr()/file_setattr() syscalls on
> +# special files (chardev, fifo...)
> +_require_file_attr_special()
> +{
> +	local test_file="$TEST_DIR/fifo"
> +	mkfifo $test_file
> +
> +	$here/src/file_attr --set --set-nodump $TEST_DIR ./fifo &>/dev/null
> +	rc=$?
> +	rm -f "$test_file"
> +
> +	if [ $rc -ne 0 ]; then
> +		_notrun "file_getattr not supported for special files on $FSTYP"
> +	fi
> +}
> +
>  ################################################################################
>  # make sure this script returns success
>  /bin/true
> diff --git a/tests/generic/772 b/tests/generic/772
> index cdadf09ff2..dba1ee7f50 100755
> --- a/tests/generic/772
> +++ b/tests/generic/772
> @@ -17,6 +17,7 @@
>  _require_test_program "file_attr"
>  _require_symlinks
>  _require_mknod
> +_require_file_attr
>  
>  _scratch_mkfs >>$seqres.full 2>&1
>  _scratch_mount
> @@ -43,9 +44,6 @@
>  ln -s $projectdir/bar $projectdir/broken-symlink
>  rm -f $projectdir/bar
>  
> -file_attr --get $projectdir ./fifo &>/dev/null || \
> -	_notrun "file_getattr not supported on $FSTYP"
> -
>  echo "Error codes"
>  # wrong AT_ flags
>  file_attr --get --invalid-at $projectdir ./foo
> diff --git a/tests/xfs/648 b/tests/xfs/648
> index e3c2fbe00b..58e5aa8c5b 100755
> --- a/tests/xfs/648
> +++ b/tests/xfs/648
> @@ -20,7 +20,8 @@
>  _require_test_program "file_attr"
>  _require_symlinks
>  _require_mknod
> -
> +_require_file_attr
> +_require_file_attr_special
>  _scratch_mkfs >>$seqres.full 2>&1
>  _qmount_option "pquota"
>  _scratch_mount
> @@ -47,9 +48,6 @@
>  ln -s $projectdir/bar $projectdir/broken-symlink
>  rm -f $projectdir/bar
>  
> -$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> -	_notrun "file_getattr not supported on $FSTYP"
> -
>  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
>  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> 
> -- 
> - Andrey
> 
> 
