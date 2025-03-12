Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C8A1DE894;
	Wed, 12 Mar 2025 20:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810996; cv=none; b=iY2215oEAJMHBVuDH0l72/rKrzjz1t7PeGVYof40infHVeefSW46Z2fH8JT0/9J+K3ex4soOYKhRAwrN+U16/T74AU2SsBYnuJYq95OAOt5KdgKGCXN1QBuhprQfD1Dlg2C0h9ZS0yXcRtOu6IfLcaZRQvbRy5pCRMTfnN8Hrv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810996; c=relaxed/simple;
	bh=sUqrh1Tt+qu1X23XoAcwq9jW5CUHZf46U5rHV19lgJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pkQFdxk7IBSo7kVvggc2Cdl9PPswRbE1ibhqVfJ2r6zRk8mQjzrvSxQmwktkiecSkUiqT48vzX0tENL8TdAMCS5F96U0DTVzg9rhmIQIfDIdFaIPT1CNOOquVB8WmZM+9SQHOc6VkSW/3pL372zhCKz5yxOF7ZKX/QanYWcH09I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUsRhTD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUsRhTD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA9FC4CEDD;
	Wed, 12 Mar 2025 20:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810995;
	bh=sUqrh1Tt+qu1X23XoAcwq9jW5CUHZf46U5rHV19lgJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DUsRhTD56KZNvQmTbdf2rQ5PmN4KWNaLHJCixJW+O/pQM5LrKpVc8wQKNZrGpN70k
	 WTvVD8zHFUHhFWamt6DNtimzWtnsWJWkw1lngvjsOLV/u97QyPtVFFG98Lgh9EyNK5
	 bX4LSX7OariCQb7ofGQfL5VYdsyvxubvhJxWfsQCkJxNSFCsoONqyhnpsUV53v5Y9r
	 nJrsQXyPU4KuHGoIXeGyWnxjb8wiQTieVyfUTSj5VUyGW/QLvGhWqhZFK9lrQQAX8j
	 TKU4MO5O6k05LOMjeAW9Y6+123DAmKpXlvD6yYhHvk1Frmzuu+FvhuYz67D6OdjP5G
	 qlwzWczf6syog==
Date: Wed, 12 Mar 2025 13:23:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/17] xfs: handle zoned file systems in
 _scratch_xfs_force_no_metadir
Message-ID: <20250312202314.GL2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-12-hch@lst.de>

On Wed, Mar 12, 2025 at 07:45:03AM +0100, Christoph Hellwig wrote:
> Zoned file systems required the metadir feature.  If the tests are run
> on a conventional block device as the RT device, we can simply remove
> the zoned flag an run the test, but if the file systems sits on a zoned
> block device there is no way to run a test that wants a non-metadir
> file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 86953b7310d9..a18b721eb5cf 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2054,6 +2054,12 @@ _scratch_xfs_find_metafile()
>  # Force metadata directories off.
>  _scratch_xfs_force_no_metadir()
>  {
> +	_require_non_zoned_device $SCRATCH_DEV
> +	# metadir is required for when the rt device is on a zoned device
> +	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
> +		_require_non_zoned_device $SCRATCH_RTDEV
> +	fi
> +
>  	# Remove any mkfs-time quota options because those are only supported
>  	# with metadir=1
>  	for opt in uquota gquota pquota; do
> @@ -2074,6 +2080,11 @@ _scratch_xfs_force_no_metadir()
>  	if grep -q 'metadir=' $MKFS_XFS_PROG; then
>  		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
>  	fi
> +
> +	# zoned requires metadir
> +	if grep -q 'zoned=' $MKFS_XFS_PROG; then
> +		MKFS_OPTIONS="-m zoned=0 $MKFS_OPTIONS"

I think this cause mkfs to fail due to the respecification of -mzoned
if MKFS_OPTIONS originally had -mzoned= in it?

--D

> +	fi
>  }
>  
>  # do not run on zoned file systems
> -- 
> 2.45.2
> 
> 
