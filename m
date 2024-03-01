Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A572939AE3;
	Fri,  1 Mar 2024 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315277; cv=none; b=Q5XeknhD1zJOw4opTxyuKBFAhOtCLXaouw222qFhqBrFEZDS5HzrGR5XT5Bn6ANJnKQmgBtitKWTmPl7PjkwdychVLRNNAYYOwGm7hFd04qEEWzehZlF16hUGpfK9p8DNOW80O6AkSW2tm08xPzPU7BNmJxf+tzpHFmBIWr4v9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315277; c=relaxed/simple;
	bh=/Lnzc6duzAPTzKTTWlob3cz+GoTEPyZNY1/b5QKdR9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L4B8JmQ3EVMK6C/QV1i7JQPlZo+FwrLb6BdwdkTidrzlVR0HJCMebIJpgvvylcfwpIL41031IRz9sAn+U9AuyPXIC5xzPvk+S+g06ZnMeI6juHOJQAy9DKvXjeZrEXfTvmVVbRLAGltVAjbkxgYvBbMIXF5JJJJxyekD5EiMx3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kutQmT3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kutQmT3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6387BC433C7;
	Fri,  1 Mar 2024 17:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709315277;
	bh=/Lnzc6duzAPTzKTTWlob3cz+GoTEPyZNY1/b5QKdR9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kutQmT3XEFerRN8wbNjdQ5V/m8UHhyGNotwm2uRAN94U4kiLBc4UtuYxmyJQrPAcM
	 PYU1fY3msWrEPXaKItpgoNJ/gyQaWBg+Lg5SSgGvmFl8bHCb4IfcidW9wAFzA3Txg9
	 5beeBvWfnT3UJBW4hB+C6KzmfsRrblyduuACY0kRUqyKFW4+VuBkxA04jGAJiU1uig
	 H4p9J3rf5XTk2vB83DL0gqMNx4moPYrgNnLKwn4wTEyWbg85uAfxvYKQHjXw5jmCvb
	 UaM70ra/X50B3iCeV5uqemLBN/jfPPT8hFaSthxu76y1+PsLL91Kez74eBEuzxonxm
	 HX1Ym4fUXJC+Q==
Date: Fri, 1 Mar 2024 09:47:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] shared/298: run xfs_db against the loop device instead
 of the image file
Message-ID: <20240301174756.GG1927156@frogsfrogsfrogs>
References: <20240301152820.1149483-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240301152820.1149483-1-hch@lst.de>

On Fri, Mar 01, 2024 at 08:28:20AM -0700, Christoph Hellwig wrote:
> xfs_db fails to properly detect the device sector size and thus segfaults
> when run again an image file with 4k sector size.  While that's something
> we should fix in xfs_db it will require a fair amount of refactoring of
> the libxfs init code.  For now just change shared/298 to run xfs_db
> against the loop device created on the image file that is used for I/O,
> which feels like the right thing to do anyway to avoid cache coherency
> issues.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/shared/298 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/shared/298 b/tests/shared/298
> index 071c03dee..f657578c7 100755
> --- a/tests/shared/298
> +++ b/tests/shared/298
> @@ -69,7 +69,7 @@ get_free_sectors()
>  	agsize=`$XFS_INFO_PROG $loop_mnt | $SED_PROG -n 's/.*agsize=\(.*\) blks.*/\1/p'`
>  	# Convert free space (agno, block, length) to (start sector, end sector)
>  	_umount $loop_mnt
> -	$XFS_DB_PROG -r -c "freesp -d" $img_file | $SED_PROG '/^.*from/,$d'| \
> +	$XFS_DB_PROG -r -c "freesp -d" $loop_dev | $SED_PROG '/^.*from/,$d'| \

Might want to leave a comment here about why xfs uses $loop_dev unlike
the other clauses that use $img_file

# Use $loop_dev to work around sector size misdetection bugs in xfs_db
$XFS_DB_PROG...

With that changed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		 $AWK_PROG -v spb=$sectors_per_block -v agsize=$agsize \
>  		'{ print spb * ($1 * agsize + $2), spb * ($1 * agsize + $2 + $3) - 1 }'
>  	;;
> -- 
> 2.39.2
> 
> 
