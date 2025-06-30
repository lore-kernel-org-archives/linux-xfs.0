Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F29225BEE8;
	Mon, 30 Jun 2025 12:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751285964; cv=none; b=Rz57SbJmshVF+wcogwvQiF7mE9WF2fTbysDzaOGwGh1SuGLaxzt9uWobRafpZ6OumjnoN6GGOW8rxcLcI7f/xBw0zWqNhiaof/lCdHD3316T9mdHD0EkDQQmcW2szBA2nysf1lfbFqgnUaX9Hif896JCFOh3a8NGTr71Qmo8TiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751285964; c=relaxed/simple;
	bh=Aj4Yxa0itULqgoCanKDASl6bSdQxZ+WXR03ovsQujoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcxERMOlAYnNg0/0F9vtGSC1TfLwzR1Kpe907UiMTz7MPJhpeVUxNK6dVnBj5HBM23eSCZqAmpfbbYPPLl3Ks3jsCpfnGO0jlBgcYNmtKOszsnqQtguPxQbLU+nfaUMRcEbWwQ2GdtBPXZJLIT8QOqXzUPcPpndj0+s2Yw7z+4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYHWWmpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYHWWmpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E69DC4CEE3;
	Mon, 30 Jun 2025 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751285963;
	bh=Aj4Yxa0itULqgoCanKDASl6bSdQxZ+WXR03ovsQujoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XYHWWmpRrpuQ1CKpstujy/n3Mb7HnZmawZpabwhKpBYrt2h+Od8HevPlcdwbavfSL
	 bQLksgovDeXGLJGPNmFwGV6tI0U0NPLmhG72YjDcT5HvzRGE/j1G6GNR34DdCHqief
	 JafNhSEheasFeqVweLa2ZW/3ZI998Bqptndcs4z3WJ36y+Tu3G1evjYd1drk/upfAf
	 J3bO4Jao1VVKlFJD0n1AZfC9xJt3VZp7FE7l42O4WO9fC6N4jeRrQMSFEQMK8wOyKS
	 Oca6f72bl8ReTF240MgMsTsnwIk6t/RjLY9whh0KCQjYJZlzPpMDlk8TemJ6xQ+7zN
	 EWLJJPFgVbFag==
Date: Mon, 30 Jun 2025 14:19:19 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: skhan@linuxfoundation.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] xfs: replace strncpy with memcpy in xattr listing
Message-ID: <huml6d5naz4kf6a3kh5g74dyrtivlaqyzajzwwmyvnpsqhuj3d@7zazaxb3225t>
References: <oxpeGQP7AC5GXfnifSYyeW7X_URDJhOvCxTG09iGmuvIXd330ZdXanoBmbUB3wpOcIORP1CakEzevsjtJKynhw==@protonmail.internalid>
 <20250617131446.25551-1-pranav.tyagi03@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617131446.25551-1-pranav.tyagi03@gmail.com>

On Tue, Jun 17, 2025 at 06:44:46PM +0530, Pranav Tyagi wrote:
> Use memcpy() in place of strncpy() in __xfs_xattr_put_listent().
> The length is known and a null byte is added manually.
> 
> No functional change intended.
> 
> Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> ---
>  fs/xfs/xfs_xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 0f641a9091ec..ac5cecec9aa1 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -243,7 +243,7 @@ __xfs_xattr_put_listent(
>  	offset = context->buffer + context->count;
>  	memcpy(offset, prefix, prefix_len);
>  	offset += prefix_len;
> -	strncpy(offset, (char *)name, namelen);			/* real name */
> +	memcpy(offset, (char *)name, namelen);			/* real name */
>  	offset += namelen;
>  	*offset = '\0';

What difference does it make?


> 
> --
> 2.49.0
> 
