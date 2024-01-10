Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C829495C1;
	Wed, 10 Jan 2024 17:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Od6OjdFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E647C433C7;
	Wed, 10 Jan 2024 17:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704908974;
	bh=8pdu4G+sxd/WYGBpfT1RJU2CDbMNbaFV/xtZR4KrAxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Od6OjdFATDbeth+zcTLl2vAOnTNSyBkryne2VtISqHX3eZK0vabs0ki1Pw8Y/PwQf
	 Aw8wXKV1z78hZ70PJDb0NMtjBo/hQmxTeudGUUVR9K3/BxIAdT3vwbyhvvKuP3aL+v
	 3Gkqjs5lXEKpa6zYwGG3bPUYulIHjTgJ3GZ0UNd4cIA/MZMJCaPHoab+SeFbUG70c1
	 bCiAvMWogojWT5wX/mDSeAzXFpQlXLCHIz5Lt7NS661GV/02dAEbPF4aBHMdOIJAmC
	 wisOIBuTh4M0O7SzRMz3moFE36lhZTmGZ+bDOF0exm1BQcvUZQheK5NMy3n5ZCG+GH
	 1xVOxziZVG3nQ==
Date: Wed, 10 Jan 2024 09:49:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/262: call _supports_xfs_scrub
Message-ID: <20240110174933.GJ722975@frogsfrogsfrogs>
References: <20240110174544.2007727-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110174544.2007727-1-hch@lst.de>

On Wed, Jan 10, 2024 at 06:45:44PM +0100, Christoph Hellwig wrote:
> Call _supports_xfs_scrub so that the test is _notrun on kernels
> without online scrub support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/262 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/xfs/262 b/tests/xfs/262
> index b28a6c88b..6df3c79f3 100755
> --- a/tests/xfs/262
> +++ b/tests/xfs/262
> @@ -29,6 +29,9 @@ _require_xfs_io_error_injection "force_repair"
>  echo "Format and populate"
>  _scratch_mkfs > "$seqres.full" 2>&1
>  _scratch_mount
> +
> +_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"

Can you refactor this into a common _scratch_require_xfs_scrub helper
for xfs/556 and xfs/716?

The patch itself looks sound.

--D

> +
>  cp $XFS_SCRUB_PROG $SCRATCH_MNT/xfs_scrub
>  $LDD_PROG $XFS_SCRUB_PROG | sed -e '/\//!d;/linux-gate/d;/=>/ {s/.*=>[[:blank:]]*\([^[:blank:]]*\).*/\1/};s/[[:blank:]]*\([^[:blank:]]*\) (.*)/\1/' | while read lib; do
>  	cp $lib $SCRATCH_MNT/
> -- 
> 2.39.2
> 
> 
