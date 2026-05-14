Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD8E2868A9
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 00:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778718465; cv=none; b=PNqHug7GZHJksalr2v+S25WsymhxGe/DO55kmpIZBLxlBAHri4VVBxThIF9ecdlUoD81KA4g9Q0sr9AOzVZtPCnJtfD6nqi31cPxHTVDDpSmn6Z4Y5eERCKj2OJBgeHTixMCHV6tuDtYhEcH6B717JNOHbxRAd3di8QG/CoABLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778718465; c=relaxed/simple;
	bh=EIEHFYzBQW1u0c0+5HPObt0cDgbdi3qOBmE3gc5FMr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnMCCXQxvqw4Phv/VDTZ1bXuWtnqBRFVvZGzuSpaytUM+iSqz2zoKiody6weRhxsF84MomCgy2rx/Yv7ehTYDSPU7A424pw91zAor07d8r9tIV9wGqnff9bpXrgR67n1wIWLDrQHlRqdZx3xdq0h4wBN5RqnHSyEdUJm9Q3OlIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=td2RIne+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="td2RIne+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3685BC19425;
	Thu, 14 May 2026 00:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778718465;
	bh=EIEHFYzBQW1u0c0+5HPObt0cDgbdi3qOBmE3gc5FMr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=td2RIne+gDAx8yqh+2k8rexItOF5xNle+wD6CSqqITAagyUCWT2vNjeth+kF+ea6P
	 Dim3VNlPfwaq88X+PmFF+LSrP0UxHyRlBSmJuwAD2bWzDZBG8yjaNdG3j3D86nk5nE
	 BZP7BgpJrwvSqoHunS/jhVK02tKzo+g2DYfCJSx9z+yc1aw6zgMrxcAiltiH80u2PM
	 wvpWVIs+mz40vjxFORAp4OuV7kfvdtHBe4FkOVpMshnYsxxOQKze1RB4pJbvHO/jFk
	 toQVx2P77OWQDecAkJ2k/Oq0Dhj2xstU7wYr90tDW+xtV8Wf1/nTeKZDUGct1XOCrh
	 5l1a5fFUMDDPQ==
Date: Wed, 13 May 2026 17:27:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anthony Iliopoulos <ailiop@suse.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] configure: always check for statmount supported_mask
Message-ID: <20260514002744.GR9555@frogsfrogsfrogs>
References: <20260513193040.2130-1-ailiop@suse.com>
 <20260513193040.2130-2-ailiop@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513193040.2130-2-ailiop@suse.com>

On Wed, May 13, 2026 at 09:30:37PM +0200, Anthony Iliopoulos wrote:
> On systems with kernel headers older than v6.8 that preceed the addition
> of the statmount syscall, have_listmount will be set to false and thus
> checking of the statmount supported_mask is being skipped since the
> check is currently conditional to listmount support.

ahah, that's why it doesn't build on Mageia 9, I gather.

> This causes compilation failures since need_internal_statmount will not
> be set, and thus struct statmount will not be available to xfs_healer.
> 
> Fix this by always checking for statmount supported_mask support even
> when listmount is not available.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 2ac5e3d8181a..fe2ffddd9ec4 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -192,8 +192,8 @@ AC_HAVE_CLOSE_RANGE
>  AC_HAVE_LISTMOUNT
>  if test "$have_listmount" = "yes"; then
>  	AC_HAVE_LISTMOUNT_NS_FD
> -	AC_HAVE_STATMOUNT_SUPPORTED_MASK
>  fi
> +AC_HAVE_STATMOUNT_SUPPORTED_MASK

Yeah, we should test both.  Sorry about the braino there. :/
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  AC_HAVE_FANOTIFY_MOUNTINFO
>  
>  if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
> -- 
> 2.49.0
> 
> 
