Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B74F1DA62E;
	Fri, 21 Mar 2025 15:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742571832; cv=none; b=PJ0BsrtcTUPM4U8VP7TGisOoGoW3MrRJl3QcQv+tKzxqe8q23menXWcNabFuLwW97iUx33OxiyHZTWm69jMW8XZf3dvPp3FwC2pWazADrIpjRK73toQjTmQIPeCNZs3JRVowa+AAq76bAj3v3eQGJ1VLeO3CMgJ1IBTKyuCX5RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742571832; c=relaxed/simple;
	bh=qLt7MBCEvEfE29n7ki763pA92Oe7/fYuFfWZyJsILr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdnZZK41ytgik559+bkk/jGh/8L/AIVXzSwE1B1kq+UQO5OfhcHiR7rB6FAs3Lfi2nZEwW679oA71IPOUPp8CxhUcM8Qv5Kw78NGZZqLewBbVA35GXXrYjahu9ppuSoamRWBJe7fuc2FiS1hEN4LF6mWPib8Dfz5vYn7y3OYZkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qdxr/ZXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qdxr/ZXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B65C4CEE3;
	Fri, 21 Mar 2025 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742571831;
	bh=qLt7MBCEvEfE29n7ki763pA92Oe7/fYuFfWZyJsILr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qdxr/ZXqZDPPXf9oQ30MNVrTEzEyGXYCN/rZ166Y8/R4k98hwBg7+LDQpsIsIKy4b
	 maLft8N5hnvRi+JSh/D+0BIWSJuguhzeIpkBH2Nj8NpcbZEMeyrUa3l5cktC9TLeit
	 UpKn4jchriIHvWuo2pOd29CFYIkTPMTOIkYH1F11gjBUUTTFppbu5VAe+BEY8CeICp
	 9Cf6GE9utV+DgoHNRuuX8cnwZKMHifmWjUH6hBushRy/GpHySpvyM/fHoEQwq8BQZF
	 NDpYBaf3cxAYqpZYvqCTZmHUsXo7IcdJ/S1tWoZlSRAAtf6xgdxgYyEOUl/GE//5lE
	 MwdowydSf6sSQ==
Date: Fri, 21 Mar 2025 08:43:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] generic/537: disable quota mount options for
 pre-metadir rt filesystems
Message-ID: <20250321154351.GF4001511@frogsfrogsfrogs>
References: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
 <174182089142.1400713.12586249978501158339.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174182089142.1400713.12586249978501158339.stgit@frogsfrogsfrogs>

On Wed, Mar 12, 2025 at 04:11:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this regression in generic/537:
> 
> mount: /opt: permission denied.
>        dmesg(1) may have more information after failed mount system call.
> mount -o uquota,gquota,pquota, -o ro,norecovery -ortdev=/dev/sdb4 /dev/sda4 /opt failed
> mount -o uquota,gquota,pquota, -o ro,norecovery -ortdev=/dev/sdb4 /dev/sda4 /opt failed
> (see /var/tmp/fstests/generic/537.full for details)
> 
> for reasons explained in the giant comment.  TLDR: quota and rt aren't
> compatible on older xfs filesystems so we have to work around that.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Ping?

--D

> ---
>  tests/generic/537 |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> 
> diff --git a/tests/generic/537 b/tests/generic/537
> index f57bc1561dd57e..3be743c4133f4f 100755
> --- a/tests/generic/537
> +++ b/tests/generic/537
> @@ -18,6 +18,7 @@ _begin_fstest auto quick trim
>  
>  # Import common functions.
>  . ./common/filter
> +. ./common/quota
>  
>  _require_scratch
>  _require_fstrim
> @@ -36,6 +37,22 @@ _scratch_mount -o ro >> $seqres.full 2>&1
>  $FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1
>  _scratch_unmount
>  
> +# As of kernel commit 9f0902091c332b ("xfs: Do not allow norecovery mount with
> +# quotacheck"), it is no longer possible to mount with "norecovery" and any
> +# quota mount option if the quota mount options would require a metadata update
> +# such as quotacheck.  For a pre-metadir XFS filesystem with a realtime volume
> +# and quota-enabling options, the first two mount attempts will have succeeded
> +# but with quotas disabled.  The mount option parsing for this next mount
> +# attempt will see the same quota-enabling options and a lack of qflags in the
> +# ondisk metadata and reject the mount because it thinks that will require
> +# quotacheck.  Edit out the quota mount options for this specific
> +# configuration.
> +if [ "$FSTYP" = "xfs" ]; then
> +	if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
> +		_qmount_option ""
> +	fi
> +fi
> +
>  echo "fstrim on ro mount with no log replay"
>  norecovery="norecovery"
>  test $FSTYP = "btrfs" && norecovery=nologreplay
> 
> 
