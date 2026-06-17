Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AED35E95E;
	Wed, 17 Jun 2026 19:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781724845; cv=none; b=PNc9iMRSkopY0FfHvtvCZ+6VZO/VbnwFKjPmwwoNyENyN7/Qnus5FuAtD07CCjA9DvKh6Zd8r1tQYfOQTwzX9ROP9Hxd+uDq2IvHkEPWduY/sRrC5UZNBmwqtp+gqWPZo2F+s/1iH/PF/RnaB0/SOSIIGg3pruWFDtpd/xe4cn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781724845; c=relaxed/simple;
	bh=LnCfn0L8uW2K4ERRnDZfGkhWpJ5MFK/ivLwIyMb3UaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f49jWBEeIPlSTwAPl9EM0IXZ0vd+DjNITQZrBFIBuy/MAr4fm3JMOHD7lF5LkFqsdjkYhwoYEhNakiScTJwv4GI1707HJX7Ar78wYTQq5j+n57s8AW0JrGSpniE1y67ef/W7VH0H3ddgo3WytxloRmfvcfjiv+LE6Sx7p+qLoCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+qM9qgh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+qM9qgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7171F000E9;
	Wed, 17 Jun 2026 19:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781724843;
	bh=ffTa6hHqaK5+3W/CzirDC27Xv4cD99ayVp21XfNvBT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D+qM9qgh1RCkp4OaBaHqkLm1u7rA8G/drXle19wNaPkdaDW2rZ9NmvQRGwg/3h1xj
	 5TmfMOUn59Rs8o0UD03K/Qr3+jFGJOXyQtIDZsbtkDVULuJxA+lp8QSpT9MwzzAviY
	 zaFqBorGE2TlChE8R+XpaJehjU0Hm0y/LTbrGoKYhUtzLG5POxCBY6166/+hxUv69o
	 045pgf7JllLISNCQhxa5EruCk4h89mP4sy81cM0uHl5K3EslQr0M4Q18/4oXgLm6Ct
	 Qt+s+f9vTHYzFXLidlt8LhRofdrSIJsH2IuAyZmC6zszIWm56MDfG4v+cjdpkxJqQB
	 f6X+5uQMCbrhg==
Date: Thu, 18 Jun 2026 03:33:59 +0800
From: Zorro Lang <zlang@kernel.org>
To: Disha Goel <disgoel@linux.ibm.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, djwong@kernel.org
Subject: Re: [PATCH v3] common/defrag: skip defrag tests on DAX-enabled
 filesystems
Message-ID: <ajL2TaegDxDpPPk8@zlang-mailbox>
Mail-Followup-To: Disha Goel <disgoel@linux.ibm.com>, 
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org
References: <20260608102328.40916-1-disgoel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608102328.40916-1-disgoel@linux.ibm.com>

On Mon, Jun 08, 2026 at 03:53:28PM +0530, Disha Goel wrote:
> Online defragmentation is not supported on ext4 DAX-enabled filesystems.
> The ext4 defrag ioctl (EXT4_IOC_MOVE_EXT) returns EOPNOTSUPP when used
> on DAX files.
> 
> Add an ext4-specific check in _require_defrag() to skip tests when DAX
> is enabled, avoiding false failures on ext4/301-304, ext4/308, and
> generic/018.
> 
> XFS defrag works with DAX, so this check is ext4-specific.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
> Changes in v3:
> - Move the DAX check inside the ext4 case statement as
>   suggested by Darrick

Make sense to me,

Reviewed-by: Zorro Lang <zlang@kernel.org>

> 
>  common/defrag | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/common/defrag b/common/defrag
> index 055d0d0e..baf05d94 100644
> --- a/common/defrag
> +++ b/common/defrag
> @@ -13,6 +13,8 @@ _require_defrag()
>          DEFRAG_PROG="$XFS_FSR_PROG"
>  	;;
>      ext4)
> +        __scratch_uses_fsdax && _notrun "ext4 online defrag not supported with DAX"
> +
>  	testfile="$TEST_DIR/$$-test.defrag"
>  	donorfile="$TEST_DIR/$$-donor.defrag"
>  	bsize=`_get_block_size $TEST_DIR`
> -- 
> 2.45.1
> 
> 
