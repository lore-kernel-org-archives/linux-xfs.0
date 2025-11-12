Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB6830C34A
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 13:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762953916; cv=none; b=VM1VcNipN9selYU8cqhZtM04ZogJtLc7YsHR3+HIGaY2U8a8zUWn1fZhx8IkmTkEf8sHwwu5b9TfWHRikqqfWvtILBW2LOzVWC6N9/eIMOu63cjAqGH/OnWKWGf8OGbkWhPxLqn0c8znJD/S5cmTMm5CXfOU27kGG5M5Ey3nIo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762953916; c=relaxed/simple;
	bh=DcHIHxYMjQz1+Gfu1m4+L6r/cl/3yTGyo90qEHLB68g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUpdnSRLL9e9N5S7euQ3YwHdOcVl1VHigMFTxpHoc2yaNLhRkYnEQW1v0FDh7ubKvk6rmM7/cIEv2LPYemT8rZwB8YqeZ0QLRp1xHfgcmbSNpDuPe/yJZyqdBJMBwOmYY420yB7yKKN1PgjV4a/v6sMtMwHHH2sBQYOoboK2ecI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJHexCRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJHexCRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6A6C19421;
	Wed, 12 Nov 2025 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762953915;
	bh=DcHIHxYMjQz1+Gfu1m4+L6r/cl/3yTGyo90qEHLB68g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JJHexCRsOP9OrUNo9F0a6iE3GFcbz5SqbKUGKkd8C8qK4EkzKNl/uN6RycE1BMFEn
	 X7XG6BaUL0Qb9EfC2tNmVbjvlDDHRrKltHdoYNHgmPVi3f86tB1wJWFbCx97KtMRmI
	 VsnbwEvfggohjTZ2n9Styg28Ph9gSMxCA9qWT/FLB7pxTdpouYTfLt0xn7y2dWJmtR
	 /AIdjx46RQFsrXxvn9f4WNJHX4UCkOhbSk3CS8yDjqwuVTQ1S4h6O80+ywdF8+GVFT
	 T+ZmWEl1ovl1yhlFx1W/Q/XfdJmpgto1wib2/d/XYinN30qTXzbNnE2uC8husR1p7X
	 NzZnG2yf7m23A==
Date: Wed, 12 Nov 2025 14:25:11 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: fix zone capacity check for sequential zones
Message-ID: <na5s5f2afoc3w5sijoq4xqni3oex7ivxqkrqfz5pt7dtf5aivr@3xvsap3qzpcw>
References: <20251112123356.701593-1-cem@kernel.org>
 <uUmqo8OzhTSa5OB27aq49lemNQh91fH_TCYzB5kvOcruOsQHbBfzrdozvkQ3xIWvFb_iB9od-8CjKaC8vQGP2Q==@protonmail.internalid>
 <20251112125056.GA27028@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112125056.GA27028@lst.de>

On Wed, Nov 12, 2025 at 01:50:56PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 12, 2025 at 01:33:16PM +0100, cem@kernel.org wrote:
> > FWIS, writing the patch description I'm assuming that the conventional zones
> > always come first and we can't have a zoned device starting with
> > sequential zones followed by conventional zones.
> 
> XFS kinda assumes this by not counting counting conventional zones found
> after sequential zones, so we'll error out due to the lack of conventional
> space later unless a separate device is used.
> 
> > +static void
> > +zone_validate_capacity(
> > +	struct zone_info	*zi,
> > +	__u64			capacity,
> > +	bool			conventional)
> > +{
> > +	if (conventional && (zi->zone_capacity != zi->zone_size)) {
> 
> No need for the inner braces.
> 
> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Note that we should also verify that if a device is used purely as
> RT device (aka no internal RT device), that there are either no
> conventional zones, or zone capacity == zone_size.  I can look into
> that as an incremental patch.

Your call. I can add it to the V2, giving I'll rewrite the above to
remove the unneeded braces.

Couldn't we leverage this check in validate_zoned() for that?

if (cli->xi->rt.name && !cli->xi->rt.isfile) {
	[...]

I'm not sure though if just detecting a rtdev was passed on the CLI
would suffice to cover what you proposed.



> 
