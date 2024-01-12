Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06637691B;
	Fri, 12 Jan 2024 16:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ibXE1mdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBF7C433F1;
	Fri, 12 Jan 2024 16:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705077671;
	bh=NiAV+pH2vkWie3W/mp3HLZG4xMRxK9FVvngGFg2Jz58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ibXE1mdX6vJVf4n7U4hJhU85ke/hZaKmoqV84lpVcu1ir2ExpeTmAWdb78ZdLP9Jf
	 /a+/xDLefqIxY/2UaSl843IFon6mTnbQJoyvebqKNPs6cGVOXjsnyaQiAceUc8EWQW
	 QtLKJwe/zJ53J4VD5Pbttn6EPU+ps7EsK9OmESAUzOOlHKcufnVGlGVy9PADigmh0O
	 uSAb3Zp3XRS+F0UAoucAvn6p+I1ACGHQ2r3UoreDlATYEO9UUakIMjcl2QbEbYWKhR
	 VjOQ+GPUimnbmxLCnkMFULA8eUzY8bf6L+sscRC8fc7sc8C1f+xN2DKpfuScR1lyRb
	 +N198j1l50WNQ==
Date: Fri, 12 Jan 2024 08:41:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: check that the mountpoint is actually mounted
 in _supports_xfs_scrub
Message-ID: <20240112164111.GQ722975@frogsfrogsfrogs>
References: <20240112050833.2255899-1-hch@lst.de>
 <20240112050833.2255899-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112050833.2255899-2-hch@lst.de>

On Fri, Jan 12, 2024 at 06:08:30AM +0100, Christoph Hellwig wrote:
> Add a sanity check that the passed in mount point is actually mounted
> to guard against actually calling _supports_xfs_scrub before
> $SCRATCH_MNT is mounted.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index f53b33fc5..4e54d75cc 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -649,6 +649,9 @@ _supports_xfs_scrub()
>  	test "$FSTYP" = "xfs" || return 1
>  	test -x "$XFS_SCRUB_PROG" || return 1
>  
> +	mountpoint $mountpoint >/dev/null || \
> +		_fail "$mountpoint is not mounted"

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
>  	# Probe for kernel support...
>  	$XFS_IO_PROG -c 'help scrub' 2>&1 | grep -q 'types are:.*probe' || return 1
>  	$XFS_IO_PROG -c "scrub probe" "$mountpoint" 2>&1 | grep -q "Inappropriate ioctl" && return 1
> -- 
> 2.39.2
> 
> 
