Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE28D192B84;
	Mon, 20 Oct 2025 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978785; cv=none; b=nB1blQB2yAAYzWwusObnM/AVVYDjAjEqDFEX+KXpaBRMsnR4aMoiRZhtQ56nqnzA86YIWKi8Uld0SyKrioYqFkurIEN7jJE+Hwbg9MRaK8tk4Swt/9bjgnJQx1VwrGWvArtsxXyTCvvV70syWqMKFj3Q1Wpc88sxmnr47eZPuEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978785; c=relaxed/simple;
	bh=HA5j7ViFvKp4No+cr8W92dQqDnVAp0NVLVxdnzie66I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHvMX+zT/BFWHb3ziM8KbSpAcO62/g4yVlfPJoCa2d4b3Ny8ZOdc07ONn95/1eFzCy3OK+PsufS+klqzyFSkUJIfkuKz0nWMmNgQKGFtucpXj2rUrFBiSFCVwmMvAc7h7tNmQo2m2fIbPGBvUgR4UupNJ6LCImZS9jv7lCD04+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+gd0eNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+gd0eNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40930C4CEF9;
	Mon, 20 Oct 2025 16:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760978785;
	bh=HA5j7ViFvKp4No+cr8W92dQqDnVAp0NVLVxdnzie66I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L+gd0eNcNql9HFBfm+y46jy29Hc0n57eC4ywN21CIpkqAzth7YSjJFxgKTxHTwOg5
	 7iF/y0QD5g/k58FdWgIqCHCAb3boI9Wo+64BMeNe/wKxOfoyDn3wh9U5y6EKadHSB3
	 q1voVUYJgMhhdmSaoEPw4FBWXy5Q/e54onbr+S7WZlJ+O1VgEqTow/ovv16dNeKqOZ
	 +aDEpjrRlgKbckNDpVK0nWcpLty9qX0bsuCierg8+eB9MK0/asWu/xZfzTMehUcHmT
	 3QFWKO5Skq8Up32fqaFCsvPowXbFsc7PFqkxSfhSrUdnNQHE57B2HkPp6CEEp0by21
	 PH6ydImhCvtcA==
Date: Mon, 20 Oct 2025 09:46:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, zlang@redhat.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 1/3] common/filter: add missing file attribute
Message-ID: <20251020164624.GP6178@frogsfrogsfrogs>
References: <20251020135530.1391193-1-aalbersh@kernel.org>
 <20251020135530.1391193-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020135530.1391193-2-aalbersh@kernel.org>

On Mon, Oct 20, 2025 at 03:55:28PM +0200, Andrey Albershteyn wrote:
> Add n (nosymlinks) char according to xfsprogs io/attr.c
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

The updated version of "common/filter: fix _filter_file_attributes to
handle xfs file flags" that I'm about to send will fix this up by
documenting that _filter_file_attributes only handles xfs attrs and then
making it handle all the known flags.

--D

> ---
>  common/filter | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/filter b/common/filter
> index c3a751dd0c39..28048b4b601b 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -692,7 +692,7 @@ _filter_sysfs_error()
>  _filter_file_attributes()
>  {
>  	if [[ $1 == ~* ]]; then
> -		regex=$(echo "[aAcCdDeEfFijmNpPsrStTuxVX]" | tr -d "$1")
> +		regex=$(echo "[aAcCdDeEfFijmnNpPrsStTuVxX]" | tr -d "$1")
>  	else
>  		regex="$1"
>  	fi
> -- 
> 2.50.1
> 
> 
