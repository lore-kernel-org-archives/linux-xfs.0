Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A446B4D37BE;
	Thu,  8 Oct 2026 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791470850; cv=none; b=ul5pIu6QG6l3kzYVaglTojTxcCLkBZqszxA/8Wz2SH24x6oZ184lYC17/CoVbQ/8b3dBSZ31QYbpZ3Z7C8SRyh1KpvgLJWQRPB2Ma8UQkMQN9UjWH135ocUtUn6yse0KCidRzcInHthH7GXFoPgZS9WYvBQwRaU5LK4q308sqdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791470850; c=relaxed/simple;
	bh=lAauYL+l11S9K3GzHRBsDd5P/phcHKRv1cApD5uJC4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLK1U/upsChCfzMksW0vHT2+0OjZ/GvzK+w9OYvYm3kNQ66Hhl4WelET9eXiqN8fI1ASuXyAWjR3v9YX8IUQ5RaXfrlaSp2G/S6+dUfwAjY/X+VCktrJo8TQxCDz0fpcalHWerxIE707nORCCTc+ZNgSBQuwsAm7J52iLRst1+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IEZL0n3E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IEZL0n3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3B41F00893;
	Thu,  8 Oct 2026 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791470844;
	bh=/R0BmBD3FiRhcGJos7pzOhr3R16YlnWKVAHWOffyqow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IEZL0n3Ecubs+Le2WnxJTPo4mjq8KOo2YOJEMlGpTsCpbm6TQAiLQohsRdW+oc3gm
	 JipXVjKT//IDwRsHjb2gZQQFkMi/+N8VDEVjwwtWbxvNoowInjRz3FbogU7p5frDqB
	 puvHR971J5NduN6Dw5pt4a0fNXlRENa/IwAfeLlhT4PDUJ9d0xMCyvPF3v32CEnKhW
	 ho5rHdMARw8onaSTBYVgYvY94yW4YMgDtxJgMueTbGl/WS36ivm4pa9rlHI0ZMcWui
	 zhvztYVLanvWdlr5twlBEevCUUg7lZx/SlLz8gu51sB0J1xRol/GV3BWONozbl5U+/
	 fiD0wsugTtbTA==
Date: Thu, 8 Oct 2026 22:47:19 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] common/xfs: add zoned/rtstart info to mkfs filter
 output
Message-ID: <ases1bGt9Hx5UT10@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <179060965752.790984.3511820348115861306.stgit@frogsfrogsfrogs>
 <179060965805.790984.4333974916537243304.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179060965805.790984.4333974916537243304.stgit@frogsfrogsfrogs>

On Mon, Sep 28, 2026 at 08:36:27AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A subsequent patch will want to be able to extract the start of an
> internal rt volume from the xfs_info output, so add the necessary lines
> to _xfs_filter_mkfs to transform the output into bash variables.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Makes sense,

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/xfs |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 98981e624ddade..318b1a3b245ae6 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1787,6 +1787,9 @@ _xfs_filter_mkfs()
>  	}
>  	if (/^\s+=\s+rgcount=(\d+)\s+rgsize=(\d+) extents/) {
>  		print STDERR "rgcount=$1\nrgextents=$2\n";
> +	}
> +	if (/^\s+=\s+zoned=(\d+)\s+start=(\d+) reserved=(\d+)/) {
> +		print STDERR "zoned=$1\nrtstart=$2\nrtreserved=$3\n";
>  	}'
>  }
>  
> 
