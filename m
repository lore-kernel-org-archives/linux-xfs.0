Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795458597;
	b=c/c5/BHasGjKW2UzRZOAxgcE6qY7YF1xVEzugOuoHeeKGT18MVAjpjB+lU9AtPjgS47a
	 45EwitIxhVAhtQglLGJ7azW+qJdeXnf+gwq3hc2xK7xRHO2LGhS/HXLAV2viznpAJwLC3
	 Tvc1ZB75FqHPPKA/7crT5aii1qXcpQ43BkrHjqwCkXjkTQn4+yXCkA54a00cOOgiB1l1S
	 jcTLt8xmAHpM5pbe4Ezax1AdbvZbuhihNQumtyomdGvADt2dNMNb6bvcltuvQHT00VgVy
	 95NI/9RGB5YBf/76sdW3ZRZzkO/WC4QlrpIj/NZa/YQ+vvuIUHxqmkWTTiMg7F2Pp0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795458597;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=BdHWMmm06jZBjgiCOkE0+gowwPvFKGIFxAD8X66Ewlk=;
	b=tB/9dWlFg0XjYx1Q45RCDPaiQRA02WGbU+qQybP0q+gVyfbxRqqEXdGqlPPKufx59dGQ
	 rmsEkYZuTo1Gb9gvs3ZjzM/9OpAABFLaMpN9bgPSNqHmH92YOHiVCAyS7wyPdOPm5Xz6l
	 5LoccW8zSOjW2OUYYfyvNZvZ0m00KvRntFDXG1oUiZwK2W5BlSCfgb9UXsdugFXgzY2H/
	 IJbrzSqmklJP3r07yLipMhoUgD2gVHzLg1INUYE8XlO45MmfF5PXO2xj9hgI1cTxB/fgW
	 ID43nuXO0SPgGrCKbGigfuBL0yDCBPUb4ZtBpK5LnL/AcQvSzijr8W6Met2DQSAxNig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ehF+5Cte;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981BF606A31A;
	Mon, 23 Nov 2026 18:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ehF+5Cte
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCCA1F000D8;
	Mon, 23 Nov 2026 18:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795458597;
	bh=BdHWMmm06jZBjgiCOkE0+gowwPvFKGIFxAD8X66Ewlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ehF+5CteBAZrpbmmiJ+LzV6QK8hBub3oSEJAy7k7nIFipUkXXd81cRQ4J/BRXAfBi
	 gFeLbTbGOhNF9wua5HRsbiEtDeuv/JOXGlTC0jsFNtYbMRnIaUaE9PZT5M+pXoz5JP
	 /pcoTbHdwYdfPCnjPR1BoAq+MM8rZcrY0v/5c1A2oDUUe0grn88JEcOzEVtkNPUk/0
	 dGdB0ldo60hc5Wqk9Al75YAd9doF2pGews4frgqa6ebwirm8lf7q4WpmSbb3Utmbzo
	 l/No0+2AdvrVZ2f/YOjMb1x7ETkANMrzE9Vx1UDt88AgRq6zLnO9TbLKDcVGH2fwST
	 DbNYjbEsuR+ug==
Date: Tue, 24 Nov 2026 02:29:48 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 07/21] fstests: add SEMANAGE_PROG
Message-ID: <awSGEn5Oa3IQxzw2@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <8900633faf8103fe992514d07d69efc9d38e8241.1791272793.git.asj@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8900633faf8103fe992514d07d69efc9d38e8241.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:33PM +0800, Anand Jain wrote:
> Define `SEMANAGE_PROG` for an upcoming test case that uses `semanage(8)`.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/config | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/common/config b/common/config
> index 76b43b8c6ad9..e8fecc168e5a 100644
> --- a/common/config
> +++ b/common/config
> @@ -243,6 +243,7 @@ export PARTED_PROG="$(type -P parted)"
>  export XFS_PROPERTY_PROG="$(type -P xfs_property)"
>  export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
>  export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"
> +export SEMANAGE_PROG="$(type -P semanage)"
>  
>  # udev wait functions.
>  #
> -- 
> 2.43.0
> 
