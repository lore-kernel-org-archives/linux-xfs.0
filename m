Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D622DCF45;
	Tue, 29 Sep 2026 01:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645932; cv=none; b=ZC5oVEb8jmWpyi4+LtQ1pidytCAjU7KotwnhJVR++IJOSJty13nHrfDeZGXy3agjnT+pbZh8vrQ2cptyQ6aA0ClNWGftAIwPUccNB7F0G9aNhFrKzy9LJD1OfZ9UkK/L+FqHO9f1U8gca8F5TGYzTVWAgBnFyLmcjz2VMmVgCqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645932; c=relaxed/simple;
	bh=jEZgvxvp6mwjpjd6SEvUOmEUkspGfCwHwOyzK+JXXIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kzMBxYTKFa6SCsCHqUvT9QIihj7/7O5r+Dn4//NlPl6t5AJbbWOWfhALbtqUXTjo92jtQafl9OXj7sPTIrISNAJjcsDB1mggbUd6ajX7xxuV/vjhgForYmWkUVPkom+b17Rj4RdHYhlUdUGr9ZlMYcSCvJ+GzvsjJSb/daqL4g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEvVi8/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEvVi8/q"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DBA0C1F000FF;
	Tue, 29 Sep 2026 01:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790645930;
	bh=XAfaiDdLUQIqL0eH+w39mpkEnHyT0Ez0XZSFlTmFRJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SEvVi8/qF89I52BrQWUxBNBvAPmsshooia8VbCieT+UrXEa4fKhFvOT6wW8PlV/LI
	 CtMFprlBOnKdaCpCftiwPhTAsgIC+xyod95cKT0b06xEG6phynIqAo00FGWMj1E8um
	 N/G4HTil8BmAYYmANyb8CkckFEKjmr2AzTp7fq7pRu4/6uISzgnJJZzit9mnhbms8G
	 btD+nVoLV3owBDRxrmh4K72HmXCplrQHiD5a/Cw2LzqeaVeYmO99Y/y2UUOx8VBsVx
	 73UieYCOKZagMYcuwNadPxCHvh2em+FbeHBbpCmT6QioA+PJEGeHlb+FDopG89jfNu
	 Ab8JcBIW8VQPw==
Date: Mon, 28 Sep 2026 18:38:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: add a _require_xfs_data_csum helper
Message-ID: <20260929013850.GH2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-6-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:46PM +0200, Christoph Hellwig wrote:
> Add a helper to check if a given mountpoint supports (RT) data checksums
> on XFS.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 8254e48603af..e9f6877c98cd 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2448,3 +2448,16 @@ _require_xfs_healer()
>  
>  	_scratch_mkfs_xfs_supported "$arg" concurrency=0
>  }
> +
> +# require (RT) data checksum support on the passed mountpoint
> +_require_xfs_data_csum()
> +{
> +	mnt=$1
> +
> +	csumval=$($XFS_IO_PROG -c 'statfs -g' $mnt | \
> +		grep "geom.rtcsum_type" | awk '{print $3}')
> +	echo "csumval: $csumval" >> $seqres.full
> +	if [ -e "$csumval" -o "$csumval" -eq "0" ]; then
> +		_notrun "requires XFS data checsums"

		                           checksums

Any chance we could export file data checksum type via statx or
somewhere?

With the typo fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	fi
> +}
> -- 
> 2.53.0
> 
> 
