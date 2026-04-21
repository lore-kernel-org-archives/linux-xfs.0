Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A787829CB24;
	Tue, 21 Apr 2026 21:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776808368; cv=none; b=hjacU21NFuTbYVOBfrqfkoYl9ihAne81n3FjIH0wawj7s5QEpapA68QSXWUmo+acHUfgLtaMo/RhYJdxOgamTV5AyYNU5PahrjX77J9vuFrcVZMYY0ph047B9S8eEBmA8owBOdAgtXxnkvLiWo5PXnQ1E4U2eKxkLA14Rl99R8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776808368; c=relaxed/simple;
	bh=pPYVY13b5UKs6h2AzyA11tlbuM4rVHBqxkOuPc/uK5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lj/uy+AuSF+r+2NbyspdGtlUMfYusd074lSQgHgqImjFzc9+i6XnH3pIt5o5ALt4iXYpcI+paypegdScpPNtnedhUdKbFhKOQdu4/iBnEmaas2vdKBhkYUbMd004Pr340TgdDgMoyxkCsbR9HG+v0NwAtHDr63QgCkm0eHeJY4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EcnuCsKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EcnuCsKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32E1C2BCB0;
	Tue, 21 Apr 2026 21:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776808367;
	bh=pPYVY13b5UKs6h2AzyA11tlbuM4rVHBqxkOuPc/uK5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EcnuCsKTlarOTgKF7pVdwiIIu2O5xYbOBRJ+e1sTprIdGipxfot2SpatPYBFKd2Nc
	 Cg7LVvoMI/bFeP21ikl1Yl7NMGgqydr/1Dbqlam/6XMZcGo/lALkvOTll6uTMQ2vPD
	 rp9ObV4BBaGiFesrCR6K0XE9LkwSqhfqX2HLTXup8Zx9V/6tHzfXsiOIvc0sGOT9mj
	 f+mcGHadJz7b1lAs6itwjYe3mzyfrqjHWnSeXgH/+YiXEKocBAB6583x4JRR1J8KZy
	 keUt7qe1QWH6ERh+4oa3ffA/RFgMbjWcUPLEkT7sziPRUlmK1KI18fym3QLE0paT5C
	 44WgbYKaQrG8w==
Date: Wed, 22 Apr 2026 07:52:39 +1000
From: Dave Chinner <dgc@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: sanitize da node pad field on write
Message-ID: <aefxp5uMg43RQqtr@dread>
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
> +

Please add a comment explaining why the padding is being written
unconditionally here. By itself like this it makes no sense at all.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
