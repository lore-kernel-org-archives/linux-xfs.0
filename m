Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D0A1422A8
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 17:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738085760; cv=none; b=m6O0IVpu2BJMFYOd4f6TodL4kUaa8JUW+tFBubLGLxq647pPDuEsN3W7KjMrK4cM9xNCwP1PP9SybpE0GxTBd/dIqjv4dlMwXfxcBeW9HvNFXZc9HqL3mucVri87ltOY2EwVBSKH1FVeL0zGYHkAalhXC+T0civt3yTrxAmWRwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738085760; c=relaxed/simple;
	bh=lKmCWmP2Al9dUNBPQBlMaTZyQecMqNQRbOhqsHjM34I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3f4sdMHNkTtpWXtzxpmCk1SuwRKvoFgZGsBOnPFWVg42BH6/y1ASu/w3JFA/jeimKg5N9aJbBdiwj0dMBv0UDMPF01UkM3XCNrY+DcHdgwRQs5D9o2debdvw26V59yXyJ0NhT/yWifs62QlQdB9n79cHIvW1iKl3DYAMU31eK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TF+xXGao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TF+xXGao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F92DC4CED3;
	Tue, 28 Jan 2025 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738085759;
	bh=lKmCWmP2Al9dUNBPQBlMaTZyQecMqNQRbOhqsHjM34I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TF+xXGaosB9O6UPakmHOgpu5IIzPSCp9raMsug0UN7/7tdKA9Gngk7+eTSe+dhGPr
	 jcyjdVTaY6+vMBpQxvkqrUGQ001FiNjseLVq/clplUoeCs2/ZTWZhlc5i9wJ/8NyEd
	 h+k1EJ1yb9Yh1j+VlMxM6yUyX7GqSzdG5HOVaUtMJBDaOhFc3pqzT9cyrAyBIgIap2
	 OMMRNZHreWBoldYJCRHeeQeUeMWXqWOyJv9QIdMvb9GizarzpY1hs2pzHhNiD3Dg0x
	 u/ypNWMzaE/6jZ06XJ/Vu5C05d4Zu+Mp1KB35PCBmw1C2M3OhqmzfKyWZIYIplTlU6
	 2jfxjivQ2dlVQ==
Date: Tue, 28 Jan 2025 09:35:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v2 2/7] release.sh: add --kup to upload release tarball
 to kernel.org
Message-ID: <20250128173558.GL1611770@frogsfrogsfrogs>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
 <20250122-update-release-v2-2-d01529db3aa5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122-update-release-v2-2-d01529db3aa5@kernel.org>

On Wed, Jan 22, 2025 at 04:01:28PM +0100, Andrey Albershteyn wrote:
> Add kup support so that the maintainer can push the newly formed
> release tarballs to kernel.org.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good now,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  release.sh | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/release.sh b/release.sh
> index b15ed610082f34928827ab0547db944cf559cef4..b036c3241b3f67bfb2435398e6a17ea4c6a6eebe 100755
> --- a/release.sh
> +++ b/release.sh
> @@ -16,6 +16,30 @@ set -e
>  version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
>  date=`date +"%-d %B %Y"`
>  
> +KUP=0
> +
> +help() {
> +	echo "$(basename) - create xfsprogs release"
> +	printf "\t[--kup|-k] upload final tarball with KUP\n"
> +}
> +
> +while [ $# -gt 0 ]; do
> +	case "$1" in
> +		--kup|-k)
> +			KUP=1
> +			;;
> +		--help|-h)
> +			help
> +			exit 0
> +			;;
> +		*)
> +			>&2 printf "Error: Invalid argument\n"
> +			exit 1
> +			;;
> +		esac
> +	shift
> +done
> +
>  echo "Cleaning up"
>  make realclean
>  rm -rf "xfsprogs-${version}.tar" \
> @@ -52,4 +76,11 @@ gpg \
>  
>  mv "xfsprogs-${version}.tar.asc" "xfsprogs-${version}.tar.sign"
>  
> +if [ $KUP -eq 1 ]; then
> +	kup put \
> +		xfsprogs-${version}.tar.gz \
> +		xfsprogs-${version}.tar.sign \
> +		pub/linux/utils/fs/xfs/xfsprogs/
> +fi;
> +
>  echo "Done. Please remember to push out tags using \"git push origin v${version}\""
> 
> -- 
> 2.47.0
> 
> 
