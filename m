Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2759216396;
	Wed, 30 Apr 2025 08:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746001656; cv=none; b=I2TVjHSw3NRC49eH6fFxoIMIgOrhn3+3hEyT8TgVeLzFFOI11R8ouoVEJaG507/joVBtqDesdXRecFy1NgDhxZtQNiUp/5AQbbMyw8IN3XTue8Mf6RejCreY1PhVPlQsM9CePFONFM63JliSA/bePm+BdFjOFnGQ9goVm/7JtW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746001656; c=relaxed/simple;
	bh=LqgULXMn2OyWwJLPaUxW4p+pmAtTcodjOr6gIWycDbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQPYlPzem3NPu6L8GPX3qEGfoHDXc+K7SgE7Z9+k3AQdu/UD5Fdnk07GSDLTVDvoqOpc9Rmc9UFWPCc+tr+kjqMGgBSMStTO092fMs1XGfMbzSVI/CP0SC0hzBdHXQ/x3fjCEOlhjPONrAxFGcoFSkpAtOy3wtpczaDmB1TnLC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rpa15Cv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rpa15Cv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41046C4CEEA;
	Wed, 30 Apr 2025 08:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746001654;
	bh=LqgULXMn2OyWwJLPaUxW4p+pmAtTcodjOr6gIWycDbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rpa15Cv1sCbu2xoxGPHppbxoSLDA8kNuFTUwv46xpaKvcgLZn1UMAvK0qQQK61XSw
	 beEXZMF1er+tMT0mxtRKYwVehz9un+tP0kgugJOOnFuZpdiqB4F3m+INLfBqiN5f7e
	 jZF1QiYK6uksqcLEe6AjpTHC/HhDD70EZNJs7x2I7/kTJwzMJWcMsaEvHZueC/ATFE
	 oSq7arl/q/VoO3C/991+EadMx3pju1a2GPqwNsWytNPlpfcQJKGjTqlxer/RusH5uG
	 7dQscE5lKIAVnCW/s4eolz8bBl4m0dBZKNgCEih1dRwh9pcZz/4h4SirUhoFUtf2Hi
	 oKwaKBjXhIYbA==
Date: Wed, 30 Apr 2025 10:27:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-xfs@vger.kernel.org, Chandan Babu R <chandanbabu@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	kernel-janitors@vger.kernel.org, Qasim Ijaz <qasdev00@gmail.com>, 
	Natalie Vock <natalie.vock@gmx.de>
Subject: Re: [PATCH] xfs: Simplify maximum determination in
 xrep_calc_ag_resblks()
Message-ID: <wv2ygjx2ste2hfusgp7apsp76wufeegrd26kdkzqmergwhwfqd@spof2npy32p5>
References: <oL08RYG1VC2E9huS2ixv9tI5xAJxx88B60-95yE-8PIDHIdkDkYdqKhA9T_qDEoFzv4qGpCn0M0WtI3JV3f5EA==@protonmail.internalid>
 <2b6b0608-136b-4328-a42f-eb5ca77688a0@web.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b6b0608-136b-4328-a42f-eb5ca77688a0@web.de>

On Sat, Mar 01, 2025 at 11:30:52AM +0100, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 1 Mar 2025 11:24:52 +0100
> 
> Reduce nested max() calls by a single max3() call in this
> function implementation.
> 
> The source code was transformed by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/xfs/scrub/repair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 3b5288d3ef4e..6b23a3943907 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -382,7 +382,7 @@ xrep_calc_ag_resblks(
>  			refcbt_sz);
>  	xfs_perag_put(pag);
> 
> -	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
> +	return max3(bnobt_sz, inobt_sz, max(rmapbt_sz, refcbt_sz));

I have nothing against the patch itself, but honestly I don't see how it
improves anything. It boils down to nesting comparison instructions too, and
doesn't make the code more clear IMHO.
So, unless somebody else has a stronger reason to have this change, NAK from my
side.

Carlos

>  }
> 
>  #ifdef CONFIG_XFS_RT
> --
> 2.48.1
> 
