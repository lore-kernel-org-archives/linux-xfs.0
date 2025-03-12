Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8381D5CD4;
	Wed, 12 Mar 2025 20:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741811142; cv=none; b=YzOuCQLF6VjTQt5aqkETgfwT86gP+la5oumfCiRPEUqZQKEcw14B+iauIYSB6GsgmjmsV2xF+UNAfw1gThymNZDi+NcevjBq4DlWNHJF/A9FDJxnvfXj3Bjqav/DEA1UyNVCeO4aFn2GaoNhO6SmYybHk/EuWGoJU/2zk/JR084=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741811142; c=relaxed/simple;
	bh=dwJhInyDi4aDNheLJaY6QX0SsDZUvkZMplzUrhhn0lM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APSbBRRNVaOxPq3YoiujM/KmOKncP9EpwLT28tR5Y3ls/sHqmEMZDta0qw/GsSWdh14G5kjbP2WpdlbZEBCzpg7XuU/gvITrGvyuuPqj3FWROjSOKYGNOP2ndvo04T1iZX7/GANbOfC2JVdN/oYMYLjsfLfqr1yoJPhAZz0+9pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=El+TFbmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="El+TFbmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6CDC4CEDD;
	Wed, 12 Mar 2025 20:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741811142;
	bh=dwJhInyDi4aDNheLJaY6QX0SsDZUvkZMplzUrhhn0lM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=El+TFbmp14Y6GdLAnnh0ibmnYQ4jhVUdGwmFbP5rlyPj8hPROOwVFJM6RiJoSuuYw
	 C7E/z5MsBtJQEZHOVBm+bNu+u0EdC2/ykEl3vvSGV9JfZbrm5/2UrrqJ/WHeIt4aAl
	 ICUlTyX25JWGN8EHUatyXEBU6YC2WhPI0XzV3PA0BJjDF/9hKaAJDRJIrgwou+d7Fp
	 6HbkjcCjjXKY0N22Or/Aj3ZUWrNWr6ZmF1qSIzAJ4EKYFogyLDKttCMn4oIBApjOIY
	 bhzcRqaKA7QHSwUYY56+27EZocmy9kXpLSEPQb7sLXUf7b/TSI3f6Qc8+uhAzFlcPa
	 Yezj0jyuvD1YQ==
Date: Wed, 12 Mar 2025 13:25:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/17] xfs: xfs_copy doesn't like RT sections
Message-ID: <20250312202541.GN2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-14-hch@lst.de>

On Wed, Mar 12, 2025 at 07:45:05AM +0100, Christoph Hellwig wrote:
> internal or external..
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 3f9119d5ef65..7756c82cf0e5 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1561,6 +1561,9 @@ _require_xfs_copy()
>  	[ "$USE_EXTERNAL" = yes ] && \
>  		_notrun "Cannot xfs_copy with external devices"
>  
> +	xfs_info "$TEST_DIR" | grep -q 'realtime.*internal' &&

	$XFS_INFO_PROG

(here and in the surrounding patches)

--D

> +		_notrun "Cannot xfs_copy with internal rt device"
> +
>  	# xfs_copy on v5 filesystems do not require the "-d" option if xfs_db
>  	# can change the UUID on v5 filesystems
>  	touch /tmp/$$.img
> -- 
> 2.45.2
> 
> 
