Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5165B2DF12F
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 19:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773428708; cv=none; b=oaqTNq7bHZMNqtummoCtvmxjPrCDfR8ALzYzMdCSHXI9+A5PrOxt3cJf2gIKqFa4MXcwFUeqqaiFoBWP1FnHnbnC/cgjm3pUnf7ZrKAF0hVQsGPuu8H028Tu0p6NN2Cg5xiKgYVG6eZKiXODPGi3d95RV2l3RCr3DouOmI1OeY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773428708; c=relaxed/simple;
	bh=r1zSQ1NuPvbZwJj3bgLhSYGW5vljaD62sq7waoDJw2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ip6L8iWjgH91M7mbCNHZPTeGlb/4LPYrvkV97PIpvpBBZ4XvpbkEeK7qzwaQMLoVXG6h7g0slQjwCC/U43Cex96W32GHy5C5QV1RgBGKJyd58Js2YxWdGoC6mlpqTJEcy4ZTf/4cpDSiW/z5rMMuI7QEBZM90Rs+DeInIPvxWAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jF3SDEP4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fWjoPWB/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jF3SDEP4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fWjoPWB/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773428706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7FiyrzjKVrw7CP6CNfU6+LcpNHL78CMkpSfVSqkJIJY=;
	b=jF3SDEP4ja5tVkYoMAjzwLKyRqFmieCz7V2D05ZIQqF8NsLgD9MDik9YUessUITLHXnxtl
	mLQt916tdeU1DLXg2hYRvNmbS/1ddtD/xjwDy9HefZnfyBiJrOYRhv6TCnetNVhLA47Wr2
	RbGLymbWoe/Yd3JOdfXIlXl+BkNrLo8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-jcgMobbVO7KCJb9LuUQC2w-1; Fri, 13 Mar 2026 15:05:04 -0400
X-MC-Unique: jcgMobbVO7KCJb9LuUQC2w-1
X-Mimecast-MFC-AGG-ID: jcgMobbVO7KCJb9LuUQC2w_1773428703
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82a17153ee9so655303b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 12:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773428703; x=1774033503; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7FiyrzjKVrw7CP6CNfU6+LcpNHL78CMkpSfVSqkJIJY=;
        b=fWjoPWB/uTgNxLdwTk2hljo8RFgjF6vwvSCe/xDKtqIA015O+/iO5qDRXwDyiCeziN
         o3Ld56rtIXF3d3I75w7b/WJ3kB7ly0baDBavbPD24pX68CI/sTpwdLFdZyyFHQlDCiSZ
         D0v/AToX+x2D60uBcv8Yz8GxMHzPWQDJzjyhXxXGzrlAxtEUNKjMo+MRv33hacHhCOET
         70urQjS5saXsNyF6FfK3n445s8v39xqUyGDu2/aS2265lvhlyapMltl6gH8tlYHHONcB
         iSbAcx+FAkBYCVri0CpKD3QYjI7pXCS3XI0aINdaFRFGZOvgi7E1bApy5HvDMLh9e4p2
         yW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773428703; x=1774033503;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7FiyrzjKVrw7CP6CNfU6+LcpNHL78CMkpSfVSqkJIJY=;
        b=SeRiD+dwtXBA6nC1L/pAQWZyzoRSHpy7AuBjlu7D8lH09/qSEU6OyiT/qGdWbaQjn1
         fLKwhF3JoVv/bjENtHEmVipt8m/p178VolYi4O+vpCWAGR8QwK0Mp/19A57c6JK+MkyW
         oHEadXNtCsQX7kNiPQe7o8RckpHDYs9G11HMJWGoZr0dL09DyliiXkBqWDwjQ7JPpbVu
         LHOMfnW8qH4EBLWzVpJ4+gFPXOxjRqjtT/C1k92fVP2Dp0DAmFJ7YpMJ4P/BqUQ1I4cj
         hrXNn5+CxDuDYdGMSjGHZHCuuOBU7ipejPTYVwXXB2GjVmfDZw2kmO4bQyGuxdRyrM/w
         gdFA==
X-Forwarded-Encrypted: i=1; AJvYcCWpxrt4GLd9TNSFfOV3feeuLsOEU4I9g7OV368xpNh0MXQT6VLQuX82EUxo6jfBB8aIZfzOSwDMT7M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+D9P28LKXxTehpT0JjDklj/S0tBHsGFobypvRU8j1LiCCDexe
	tNeFO2pbl4ilbEHMMWTOnKL8GtwigEmFwHlJPaE7tAPYnqPrYEPclNbd1KRLzvGdlRLYyMLPKw9
	UcvqDrfTMUm1COuD88ejE2dESjC8V3HkwA14xhz//0x9c0DyHWMrOWe223SsxTA==
X-Gm-Gg: ATEYQzziSy8/IVFLW92tIVbF/xHWsf2KzEbBfIIV/NXFj2JpOL24VlMofD+Za6oirWw
	KjZMTn1Zsy0Wq/RnhKCt27SwUY6+r5q93LHSm7jODqyNVVl9sTgUENa5q21L44Rw1fiYHnGa4A3
	aGFy5I9gBS4nzWKXrviGyMiwxoOoEapbmUz7xO/IqutvDR2XZZA413XRBdvcFhkBLnWivzFPIDf
	TwoXhkdaEmw042Wo3PLrCPcszeqs2tOLNwDAwFdL40oHQ4bBd/gnFZaiXN8VdtX5o11RG+t5V1+
	aeptxd9bcAXOxM1ab+jkmtG6ICZ1OQ+cH9xVoWlmauaZKy/lrqGlb83OoFasvel5uRkfkS7ozH3
	VinsFOU9MEGw1a5ysTX4wUAh4XO396hbwIs5LnhT3Mtm+e/whycJdzvdIY02gWg==
X-Received: by 2002:a05:6a00:94d1:b0:827:298e:b7c0 with SMTP id d2e1a72fcca58-82a198afd10mr4274843b3a.47.1773428702870;
        Fri, 13 Mar 2026 12:05:02 -0700 (PDT)
X-Received: by 2002:a05:6a00:94d1:b0:827:298e:b7c0 with SMTP id d2e1a72fcca58-82a198afd10mr4274825b3a.47.1773428702368;
        Fri, 13 Mar 2026 12:05:02 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a072612e2sm8718835b3a.21.2026.03.13.12.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 12:05:01 -0700 (PDT)
Date: Sat, 14 Mar 2026 03:04:58 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/14] xfs: set up common code for testing xfs_healer
Message-ID: <20260313190458.gih5me7v6v32qkta@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403849.1186408.3223809492518597284.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403849.1186408.3223809492518597284.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:51:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a bunch of common code so that we can test the xfs_healer daemon.
> Most of the changes here are to make it easier to manage the systemd
> service units for xfs_healer and xfs_scrub.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Tests and looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/config  |   14 ++++++++
>  common/rc      |    5 +++
>  common/systemd |   39 ++++++++++++++++++++++
>  common/xfs     |   98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/802  |    4 +-
>  5 files changed, 158 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/config b/common/config
> index 1420e35ddfee42..8468a60081f50c 100644
> --- a/common/config
> +++ b/common/config
> @@ -161,6 +161,20 @@ export XFS_ADMIN_PROG="$(type -P xfs_admin)"
>  export XFS_GROWFS_PROG=$(type -P xfs_growfs)
>  export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
>  export XFS_SCRUB_PROG="$(type -P xfs_scrub)"
> +
> +XFS_HEALER_PROG="$(type -P xfs_healer)"
> +XFS_HEALER_START_PROG="$(type -P xfs_healer_start)"
> +
> +# If not found, try the ones installed in libexec
> +if [ ! -x "$XFS_HEALER_PROG" ] && [ -e /usr/libexec/xfsprogs/xfs_healer ]; then
> +	XFS_HEALER_PROG=/usr/libexec/xfsprogs/xfs_healer
> +fi
> +if [ ! -x "$XFS_HEALER_START_PROG" ] && [ -e /usr/libexec/xfsprogs/xfs_healer_start ]; then
> +	XFS_HEALER_START_PROG=/usr/libexec/xfsprogs/xfs_healer_start
> +fi
> +export XFS_HEALER_PROG
> +export XFS_HEALER_START_PROG
> +
>  export XFS_PARALLEL_REPAIR_PROG="$(type -P xfs_prepair)"
>  export XFS_PARALLEL_REPAIR64_PROG="$(type -P xfs_prepair64)"
>  export __XFSDUMP_PROG="$(type -P xfsdump)"
> diff --git a/common/rc b/common/rc
> index ccb78baf5bd41a..0b740595d231b5 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3021,6 +3021,11 @@ _require_xfs_io_command()
>  	"label")
>  		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
>  		;;
> +	"verifymedia")
> +		testio=`$XFS_IO_PROG -x -c "verifymedia $* 0 0" 2>&1`
> +		echo $testio | grep -q "invalid option" && \
> +			_notrun "xfs_io $command support is missing"
> +		;;
>  	"open")
>  		# -c "open $f" is broken in xfs_io <= 4.8. Along with the fix,
>  		# a new -C flag was introduced to execute one shot commands.
> diff --git a/common/systemd b/common/systemd
> index b2e24f267b2d93..589aad1bef2637 100644
> --- a/common/systemd
> +++ b/common/systemd
> @@ -44,6 +44,18 @@ _systemd_unit_active() {
>  	test "$(systemctl is-active "$1")" = "active"
>  }
>  
> +# Wait for up to a certain number of seconds for a service to reach inactive
> +# state.
> +_systemd_unit_wait() {
> +	local svcname="$1"
> +	local timeout="${2:-30}"
> +
> +	for ((i = 0; i < (timeout * 2); i++)); do
> +		test "$(systemctl is-active "$svcname")" = "inactive" && break
> +		sleep 0.5
> +	done
> +}
> +
>  _require_systemd_unit_active() {
>  	_require_systemd_unit_defined "$1"
>  	_systemd_unit_active "$1" || \
> @@ -71,3 +83,30 @@ _systemd_unit_status() {
>  	_systemd_installed || return 1
>  	systemctl status "$1"
>  }
> +
> +# Start a running systemd unit
> +_systemd_unit_start() {
> +	systemctl start "$1"
> +}
> +# Stop a running systemd unit
> +_systemd_unit_stop() {
> +	systemctl stop "$1"
> +}
> +
> +# Mask or unmask a running systemd unit
> +_systemd_unit_mask() {
> +	systemctl mask "$1"
> +}
> +_systemd_unit_unmask() {
> +	systemctl unmask "$1"
> +}
> +_systemd_unit_masked() {
> +	systemctl status "$1" 2>/dev/null | grep -q 'Loaded: masked'
> +}
> +
> +_systemd_service_unit_path() {
> +	local template="$1"
> +	local path="$2"
> +
> +	systemd-escape --template "$template" --path "$path"
> +}
> diff --git a/common/xfs b/common/xfs
> index 7fa0db2e26b4c9..f276325df8fbac 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2301,3 +2301,101 @@ _filter_bmap_gno()
>  		if ($ag =~ /\d+/) {print "$ag "} ;
>          '
>  }
> +
> +# Run the xfs_healer program on some filesystem
> +_xfs_healer() {
> +	$XFS_HEALER_PROG "$@"
> +}
> +
> +# Compute the xfs_healer systemd service instance name for a given path.
> +# This is easy because xfs_healer has always supported --svcname.
> +_xfs_healer_svcname()
> +{
> +	_xfs_healer --svcname "$@"
> +}
> +
> +# Compute the xfs_scrub systemd service instance name for a given path.  This
> +# is tricky because xfs_scrub only gained --svcname when xfs_healer was made.
> +_xfs_scrub_svcname()
> +{
> +	local ret
> +
> +	if ret="$($XFS_SCRUB_PROG --svcname "$@")"; then
> +		echo "$ret"
> +		return 0
> +	fi
> +
> +	# ...but if not, we can fall back to brute force systemd invocations.
> +	_systemd_service_unit_path "xfs_scrub@.service" "$*"
> +}
> +
> +# Run the xfs_healer program on the scratch fs
> +_scratch_xfs_healer() {
> +	_xfs_healer "$@" "$SCRATCH_MNT"
> +}
> +
> +# Turn off the background xfs_healer service if any so that it doesn't fix
> +# injected metadata errors; then start a background copy of xfs_healer to
> +# capture that.
> +_invoke_xfs_healer() {
> +	local mount="$1"
> +	local logfile="$2"
> +	shift; shift
> +
> +	if _systemd_is_running; then
> +		local svc="$(_xfs_healer_svcname "$mount")"
> +		_systemd_unit_stop "$svc" &>> $seqres.full
> +	fi
> +
> +	$XFS_HEALER_PROG "$mount" "$@" &> "$logfile" &
> +	XFS_HEALER_PID=$!
> +
> +	# Wait 30s for the healer program to really start up
> +	for ((i = 0; i < 60; i++)); do
> +		test -e "$logfile" && \
> +			grep -q 'monitoring started' "$logfile" && \
> +			break
> +		sleep 0.5
> +	done
> +}
> +
> +# Run our own copy of xfs_healer against the scratch device.  Note that
> +# unmounting the scratch fs causes the healer daemon to exit, so we don't need
> +# to kill it explicitly from _cleanup.
> +_scratch_invoke_xfs_healer() {
> +	_invoke_xfs_healer "$SCRATCH_MNT" "$@"
> +}
> +
> +# Unmount the filesystem to kill the xfs_healer instance started by
> +# _invoke_xfs_healer, and wait up to a certain amount of time for it to exit.
> +_kill_xfs_healer() {
> +	local unmount="$1"
> +	local timeout="${2:-30}"
> +	local i
> +
> +	# Unmount fs to kill healer, then wait for it to finish
> +	for ((i = 0; i < (timeout * 2); i++)); do
> +		$unmount &>> $seqres.full && break
> +		sleep 0.5
> +	done
> +
> +	test -n "$XFS_HEALER_PID" && \
> +		kill $XFS_HEALER_PID &>> $seqres.full
> +	wait
> +	unset XFS_HEALER_PID
> +}
> +
> +# Unmount the scratch fs to kill a _scratch_invoke_xfs_healer instance.
> +_scratch_kill_xfs_healer() {
> +	local unmount="${1:-_scratch_unmount}"
> +	shift
> +
> +	_kill_xfs_healer "$unmount" "$@"
> +}
> +
> +# Does this mounted filesystem support xfs_healer?
> +_require_xfs_healer()
> +{
> +	_xfs_healer --supported "$@" &>/dev/null || \
> +		_notrun "health monitoring not supported on this kernel"
> +}
> diff --git a/tests/xfs/802 b/tests/xfs/802
> index fc4767acb66a55..18312b15b645bd 100755
> --- a/tests/xfs/802
> +++ b/tests/xfs/802
> @@ -105,8 +105,8 @@ run_scrub_service() {
>  }
>  
>  echo "Scrub Scratch FS"
> -scratch_path=$(systemd-escape --path "$SCRATCH_MNT")
> -run_scrub_service xfs_scrub@$scratch_path
> +svc="$(_xfs_scrub_svcname "$SCRATCH_MNT")"
> +run_scrub_service "$svc"
>  find_scrub_trace "$SCRATCH_MNT"
>  
>  # Remove the xfs_scrub_all media scan stamp directory (if specified) because we
> 

