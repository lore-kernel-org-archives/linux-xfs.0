Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4531D32D0EF;
	Mon, 20 Oct 2025 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978706; cv=none; b=m/c2zZZWDF7VPZioPWMM7qY02aGBfEJR2T1IVnVyGypl71kiv36FEtzbzdCSg+/Z9Wu4+iWnCOEQW2AniT/AQ60qYJJBsuiuj9CWlAq68ADxNz3Ga9cClJC8jO/g38lkjCrdZOXpDk+QvU9A44YJwj1gjbRNoDFMqIJVJEvTuc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978706; c=relaxed/simple;
	bh=csQgO1T7s3YW3v2p12NplfqdcsWvq3R/MNlLMbtU9IQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDR2Img1j4jnCujnWbC7LBnHEAYx1KyFMdNEl/TMn4WIemHAZG51bxPdMQvpGCJSn/pguUb0pDPSe1cQctFuurvQCqJ/705vHXcDN4bJcvIDYgn1KqwcU4LgNlNchcb/RFBOvUWCJcg5PThu0+LhL6iXeGM/8Qm1zXkmJFgRErk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c8Gyw9cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c8Gyw9cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CB2C4CEF9;
	Mon, 20 Oct 2025 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760978704;
	bh=csQgO1T7s3YW3v2p12NplfqdcsWvq3R/MNlLMbtU9IQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c8Gyw9cxq6hcEPCD2mh34N2NnXY4GVgZIlAfSTrIN0QWouzul3KugdQ/YtyyVcbRv
	 Nc9dL8oUWkEF0+nfK/CJI6tLm5dBaegi6RuW1c5h442fM+8gpezk5t4eRUE3NbB3f1
	 Ffwz+9QOICXr0+/Nlxz/SJK7XfPjkuUqkkaZ47ISaCE1sUB6Mdg3LBP8rbUOoK/Hif
	 7JxPpMJdXxRtRykrFCVSh5uzkpePwejb/Q897A5uMQUsQAYchnP4ut2W79LK/6CvN0
	 1Me9ZxHEgGBCcphkW1uWXv7bTFnzPbEwpKW9p013sRAYgEq/2VRKCQnnPWTVNtV3lX
	 uXC09zUUUGZKQ==
Date: Mon, 20 Oct 2025 09:45:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, zlang@redhat.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 2/3] generic/772: require filesystem to support
 file_[g|s]etattr
Message-ID: <20251020164503.GN6178@frogsfrogsfrogs>
References: <20251020135530.1391193-1-aalbersh@kernel.org>
 <20251020135530.1391193-3-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020135530.1391193-3-aalbersh@kernel.org>

On Mon, Oct 20, 2025 at 03:55:29PM +0200, Andrey Albershteyn wrote:
> Add _require_* function to check that filesystem support these syscalls
> on regular and special files.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  common/rc         | 32 ++++++++++++++++++++++++++++++++
>  tests/generic/772 |  5 ++---
>  tests/xfs/648     |  7 +++----
>  3 files changed, 37 insertions(+), 7 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index dcae5bc33b19..78928c27da97 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5994,6 +5994,38 @@ _require_inplace_writes()
>  	fi
>  }
>  
> +# Require filesystem to support file_getattr()/file_setattr() syscalls on
> +# regular files
> +_require_file_attr()
> +{
> +	local test_file="$SCRATCH_MNT/foo"

Should the test file be on $TEST_DIR so that you don't have an implicit
dependency on _require_scratch?

Otherwise looks fine to me.

--D

> +	touch $test_file
> +
> +	$here/src/file_attr --set --set-nodump $SCRATCH_MNT ./foo &>/dev/null
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
> +	local test_file="$SCRATCH_MNT/fifo"
> +	mkfifo $test_file
> +
> +	$here/src/file_attr --set --set-nodump $SCRATCH_MNT ./fifo &>/dev/null
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
> index e68a67246544..bdd55b10f310 100755
> --- a/tests/generic/772
> +++ b/tests/generic/772
> @@ -20,6 +20,8 @@ _require_mknod
>  
>  _scratch_mkfs >>$seqres.full 2>&1
>  _scratch_mount
> +_require_file_attr
> +_require_file_attr_special
>  
>  file_attr () {
>  	$here/src/file_attr $*
> @@ -43,9 +45,6 @@ touch $projectdir/bar
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
> index e3c2fbe00b66..a268bfdb0e2d 100755
> --- a/tests/xfs/648
> +++ b/tests/xfs/648
> @@ -20,10 +20,12 @@ _require_test_program "af_unix"
>  _require_test_program "file_attr"
>  _require_symlinks
>  _require_mknod
> -
>  _scratch_mkfs >>$seqres.full 2>&1
>  _qmount_option "pquota"
>  _scratch_mount
> +_require_file_attr
> +_require_file_attr_special
> +
>  
>  create_af_unix () {
>  	$here/src/af_unix $* || echo af_unix failed
> @@ -47,9 +49,6 @@ touch $projectdir/bar
>  ln -s $projectdir/bar $projectdir/broken-symlink
>  rm -f $projectdir/bar
>  
> -$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> -	_notrun "file_getattr not supported on $FSTYP"
> -
>  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
>  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> -- 
> 2.50.1
> 
> 
