Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55B02D29D6
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 11:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756123180; cv=none; b=gTd9n0I7UASoyjgNOli9N2gdkFapQgHzbcb3XQ3FZd1F4qE5e4BVZMXldMv+9Q8Pxm2wmEgu16YifZgjZFsXlruX96GvphPtcyVupBeCUIPJMtG/ZrF0gnKUoFZTIJj7qw6Age11ThgfXFWCHOKKOrOM9bX962TeC6u7cuvMmIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756123180; c=relaxed/simple;
	bh=lS3AWOgvDy1xyQdjhiTyovsqjPpiIeoliD87yKstrzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEDimrMOBBLNU47wZN+q7/C4+pFddo08pWSSKbKAWFB+ViQnloH5ziUuTZrDi8Nq7zEfmMnz0snZ6FcLWeQ6HJX4f2+Q6+BhSdXFI++gv5JFXDErV+EA421fZEtx8rdhQozcbrfXALUxUsbCTnOWJrLNXrrHasLv8Tpj76CUpQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UkTGXf19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UkTGXf19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F2BC4CEED;
	Mon, 25 Aug 2025 11:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756123180;
	bh=lS3AWOgvDy1xyQdjhiTyovsqjPpiIeoliD87yKstrzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UkTGXf19V8ywJ5fx51VMc0L65R5hh7RUeUGr1nnceWCQHHPHGbFvtBeVvzW7L81yZ
	 rOsCIYkqhB0Az2FW/EJ0FGdK+iFqKlv37nWX7lyHEgau2TrmtimUZ3RZyfIdPtCNvd
	 9BKNPjT7aRdiBd3Bd/T+GBLuTEOAOAM/YaWOKFQ/UNgWeVTefBnKUgLYQ6mW3BX5bK
	 vXxq/o8kw5QfA/hzqMApFUSx7uCt0rprvojVAu4HV2hVwO7tb5GkO9XnL/zvlXGX56
	 Xo5Ym4jX3bxVhs367Ap/LCoBy3fStl8lEIZELJGEPUDnQpFVWSptIJ7EYD/64ztUn6
	 +HdID3IlMJmFw==
Date: Mon, 25 Aug 2025 13:59:36 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Hans.Holmberg@wdc.com
Subject: Re: [PATCH] xfs: remove the unused bv field in struct xfs_gc_bio
Message-ID: <ak5tpekapqnezdta6nbdjs3xfw7o5turr5ps5rz3bj3qcznlt4@hcf6l3va6taz>
References: <sacMDWwSlHWPe4rLfJnV7cWv85IhaVjJ0oRPoFGpRMrscPhlMY_P-nMHPJ_WN4LFkd_ga9PdbD81l2dtjqD2ag==@protonmail.internalid>
 <20250825113511.474923-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825113511.474923-1-hch@lst.de>

On Mon, Aug 25, 2025 at 01:35:11PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_gc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 064cd1a857a0..d2d8fe547074 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -114,8 +114,7 @@ struct xfs_gc_bio {
>  	/* Open Zone being written to */
>  	struct xfs_open_zone		*oz;
> 
> -	/* Bio used for reads and writes, including the bvec used by it */
> -	struct bio_vec			bv;
> +	/* Bio used for reads and writes */
>  	struct bio			bio;	/* must be last */
>  };

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> --
> 2.47.2
> 
