Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68AB175A68
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 00:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778718478; cv=none; b=uiosfj4QUSkoqr20RHRVL2w8Vib32ARqtO5CK6dy2QF82IdUSAiPdnjf+gajhv9TAAo9Dc6r3WkDMrBVfc0OX4zHHmX1YAttpLRnHa1xyzc+PlG36yfgMnI6u/mZU8scF6w00ibCwa8j0O6pn1wd4KvxjvkTO/FtK0NSxSs3b4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778718478; c=relaxed/simple;
	bh=C5J9MBZbMGac9OaH6p4sWLDeO1phRjDKnZ7/4tZdG9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EBN3rarW0AFJG25BByRJwVTSknqE5iyknrPkWsxq0lynDFTT08iLDWgEYcr4xySl5sACkFU/EAcIGRJ4EVIgl1dp4myGgvomeS949mQ4XI8DgmTGxAhvuABCAGRXhu9tQR8NNNeVqHJyzX/nLQRQFpFzrb17ApB2dvOUYjSfewk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VS8nX9g8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VS8nX9g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536F8C19425;
	Thu, 14 May 2026 00:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778718478;
	bh=C5J9MBZbMGac9OaH6p4sWLDeO1phRjDKnZ7/4tZdG9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VS8nX9g8GnVpGv9aZm99CVSZ2C+/TjqYIsj9BG7VdMu1QeNLLOrK8Fp0QzMKHlePL
	 Ds3I0P6EYmPy1tJ+2c6W0dXD7mSca/liwBabq643vH2dv3qsP+8mugtgEmwT3BRrcT
	 ecfonbFdtIZxd62OEY26b9ZAEGHIlo0cuCI4ot6kAPVTH/pFjEiy+ud2E0F47t048G
	 eTmFvkBnq7AYe5Pv8GUUKim9eLV5PPUInN+CCfxSjxyje2F4ylGI+9rbX07MRqvjug
	 D417FRwMxKxAdPnbUiXLgBwBatkipviyBBDPmtWDKs2eenSHb0Cm+JTUnTcOvb//mp
	 LoPYosZevszfg==
Date: Wed, 13 May 2026 17:27:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anthony Iliopoulos <ailiop@suse.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] libfrog: add missing statmount flag definitions
Message-ID: <20260514002757.GS9555@frogsfrogsfrogs>
References: <20260513193040.2130-1-ailiop@suse.com>
 <20260513193040.2130-3-ailiop@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513193040.2130-3-ailiop@suse.com>

On Wed, May 13, 2026 at 09:30:38PM +0200, Anthony Iliopoulos wrote:
> Add definitions for STATMOUNT_MNT_BASIC and STATMOUNT_MNT_POINT to support
> compilation of xfs_healer on systems with older kernel headers that predate
> the statmount syscall (introduced in v6.8).
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libfrog/statmount.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/libfrog/statmount.h b/libfrog/statmount.h
> index 7e281ce93029..b6f1338830a0 100644
> --- a/libfrog/statmount.h
> +++ b/libfrog/statmount.h
> @@ -52,6 +52,14 @@ struct statmount {
>  
>  /* all the new flags added since the beginning of statmount */
>  
> +#ifndef STATMOUNT_MNT_BASIC
> +#define STATMOUNT_MNT_BASIC		0x00000002U     /* Want/got mnt_... */
> +#endif
> +
> +#ifndef STATMOUNT_MNT_POINT
> +#define STATMOUNT_MNT_POINT		0x00000010U     /* Want/got mnt_point */
> +#endif
> +
>  #ifndef STATMOUNT_MNT_NS_ID
>  #define STATMOUNT_MNT_NS_ID		0x00000040U	/* Want/got mnt_ns_id */
>  #endif
> -- 
> 2.49.0
> 
> 
