Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30751212D7C;
	Tue, 21 Apr 2026 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776783852; cv=none; b=RWL26aAovjqi3/LZc8faMNX2wQWRxPhCcVDV6TDsjYFc0QP6nQUVCmoH9CSMmEYx41Pu8lmxJculOmnPEmhb+3umUhXLJCmA/SJXz5quvEAYTRnwugabJYQYJrTKlVUp8MyPKnEbHcwrjrv8jVS6f6BQJhK31WkMU/CE8ld6S1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776783852; c=relaxed/simple;
	bh=iodPNTVqOt+4HU9IU7Wcchfl2Sqeuw7NlY+wOvnhkpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUZncuUOV9hw47U1MROrh06P687nKlA0kSNczDkljy6G/AHJrPLKVh2N12CpVmWmdy37xWRtrfUatzObpKRujfjQC/ne0PBqQlRR2QqVqwa91GlnEqz1yKsHu6RF+C04Ga29qE58oBNzM1hCYaIe/xOsbcoXTBtAYY00+frCHes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBvHOK/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBvHOK/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C134C2BCB0;
	Tue, 21 Apr 2026 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776783852;
	bh=iodPNTVqOt+4HU9IU7Wcchfl2Sqeuw7NlY+wOvnhkpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OBvHOK/YDeNfusN383/Yum1RvhJi1cPwHzURDvqwEa9F371ADiwpIEoqpRpvJcr1V
	 1VLwy178i22J1q9dEKmGsjeltKzFwVuyLosufsAZlsPstWnFZ5ojZGceM9ieBDhzIg
	 gtpy7+1ObY/xQJco6CkBfFbTVZKozUaUTgQZXK8ONxqS/K3ZFRIyb/TL7f3pYOZi0P
	 BpdSM5rJCSJ7ITwKNVsTr9XtNu8nSVcLmhmGJAq/saccsuGKuSg20nJWbglHKaRYt5
	 Rp7yoIOG2bqZgaCHO05+RYW5+WImDivYetkKVQpZX/XzYPNHKQIbttqnNXKb1aYpsm
	 mvLs7ctQHmVhQ==
Date: Tue, 21 Apr 2026 08:04:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dgc@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: sanitize da node pad field on write
Message-ID: <20260421150411.GB7751@frogsfrogsfrogs>
References: <20260421054311.25301-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421054311.25301-2-ytohnuki@amazon.com>

On Tue, Apr 21, 2026 at 06:43:12AM +0100, Yuto Ohnuki wrote:
> The DA node block header (xfs_da3_node_hdr) contains a __pad32 field
> that should always be zero. Prior to commit a45086e27dfa21 ("xfs:
> validate metadata LSNs against log on v5 superblocks"),
> xfs_da3_node_create() did not zero the full header, so __pad32 could
> contain stale data on older filesystems.
> 
> Clear this field in the write verifier to ensure it is corrected
> whenever the block is next written to disk.
> 
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index ad801b7bd2dd..f6054a47d24c 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -318,6 +318,8 @@ xfs_da3_node_write_verify(
>  	if (bip)
>  		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
>  
> +	hdr3->__pad32 = 0;

Looks good to me, thanks for clearing this todo :)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
>  	xfs_buf_update_cksum(bp, XFS_DA3_NODE_CRC_OFF);
>  }
>  
> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
> 
> 
> 
> 
