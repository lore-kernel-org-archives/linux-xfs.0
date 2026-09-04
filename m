Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE164EC678;
	Fri,  4 Sep 2026 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534697; cv=none; b=mWUHmDgwFhdxGgScIavZpH6+s4nxh4x/z9Y6g1hGv4LNkTAAhjommhyweT+YAeC4aw+ZzlNlHyeA8rpIUQFFwDAG6d5PdGuzJgvg62P7XaAOE7x8ZLTWb5HNKkySH7K7Uxt53UIHdHQlKlwZYCjWaFdp+W1SY+bdCBfHSqL93Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534697; c=relaxed/simple;
	bh=csa0OdTbnGbh51ofXxa4fQi9gmVfebBHNdu+VgNJDHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOsO5pQbIbbUB1y4mg+LZ1WMeaGYVu2N+lY/lBB3n5USBOddF20Rv65ent7XL6bHmo+UCqw85ZI7l4zNHYGbgNe132toOoHRuIqKNA4Qjr+LnEBAXYWbwdXFsceS6TlPN9Hc9/+DrGMZ9514DpESMAxVz23xCYpiEv98efVSfK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Haw8q+Xp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Haw8q+Xp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 370461F00A3D;
	Fri,  4 Sep 2026 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788534695;
	bh=xKOFreXhVUInnVZE8rtqVF5ePjGsIj08ThXNbHBicOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Haw8q+XpTnkPnsUksnOsbsRcuhtlJxJlY3Vg3c4liEJZcL+lFz4zPPq2eFOdGjeOM
	 2mNxeBYHEWxlCrCAQFUDYIRq56shiqXtNiqf7Cl7CosPAfTPIV5g95GFXmi8OJ2H5d
	 POUTksnq8BYLnPA0o4nF1eYRGXWftkb90REDUCta5fk41/yRCNb5L7ecTDzEBfjtnm
	 cRG38X5LylP3WI/ULEp8r2YUmpbslI+IJ4nwl4YAnVsnHIGJ85LFy+TMMMwuvdH0C1
	 SFqFmm3p5Y/qLLuEkT87Mf+nbe0jOA4HZp45J4sf3QU2NrK+OcdElq8xpdMedXcNAM
	 ImfOy1aaaxzVw==
Date: Fri, 4 Sep 2026 08:11:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: fix repeated word 'the' in comment
Message-ID: <20260904151134.GI6047@frogsfrogsfrogs>
References: <20260904103825.8752-1-hemanth.selam@gmail.com>
 <20260904103825.8752-3-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904103825.8752-3-hemanth.selam@gmail.com>

On Fri, Sep 04, 2026 at 04:08:23PM +0530, Hemanth Selam wrote:
> Drop the second 'the', reported by checkpatch.pl as a possible repeated
> word.  Only touches a comment, no code changes.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 0a5ebfda90f1..d42751d6f5ff 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1708,7 +1708,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>   * @iomap_flags: Flags to set on the associated iomap to track the batch.
>   *
>   * Returns the folio count directly. Also returns the associated control flag if
> - * the the batch lookup is performed and the expected offset of a subsequent
> + * the batch lookup is performed and the expected offset of a subsequent
>   * lookup via out params. The caller is responsible to set the flag on the
>   * associated iomap.
>   */
> -- 
> 2.48.1
> 
> 
