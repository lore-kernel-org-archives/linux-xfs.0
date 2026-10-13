Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321764F052A
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 13:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897770; cv=none; b=LhDnJxnokWq0MKR+jKrd9ns9KMX7jEiJZ61p7WF2z/oX3jCCuOUlDigwSBUzZrDZ8YDXEYWWssohUfmWIIH/7DOF57pW2xes3kjS7Twirh9odoZA6PNiVMRNIUrAoaTM8fQIwe8bnue23WqVNwL2sXkcax1m+2ON2EAf3T8AXAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897770; c=relaxed/simple;
	bh=J+rJmCrGdNs6v7pN4eygkI1vND6BvnnP32hEknujnZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFDeDK8fB4b1Xg4rUfWaPa2cm2yEDhSGP+7oSv28XO/oV4Zce33rEVhse9hQpSUBZ4Es013Mhll8D0Xw+eUAihGTq0o2H4HQbLcbs1tJ/qb+23IRkJs+puIvFgTJc2ZfQYdt7D61s5+2P7HlyklGICgWXEU2yCgX7ILEvhNk66I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ds1XrWP/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ds1XrWP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAB51F00893;
	Tue, 13 Oct 2026 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791897768;
	bh=E8foNkdcoetWoCFJfILPf+OOD2Yfhhgqg6/rxIRmuiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ds1XrWP/c5WOShV4lfwTebuafTzXfi5HSh+af4gjsxmwFKyw6227CirbT4Wx7ZyCY
	 z/pnrJQyEP+Ji79kPgxvVrLGzhnsy/9Xc7UXr4UcPhLJ2Z22247ucQIorz/9NHU+J+
	 AFSL3uPKo8J1IcqgEvGdB7MA6qpQ+8eD0Gwiu7Wwyj1VqTo62j50g1cR1Bv0PZV1Pv
	 qpLtC5FOKG7N65Iav7d6EIPlMSn12eKXszE80o61NMQaMcwTl05FZi429f073tjED/
	 /RoMy3jg1u1qvKMusyMChGt/xTKXA37KQfmmoW7+krEeOWGwWj+ltvnqkknQXm/0oQ
	 xAC9/5I1CCN/g==
Date: Tue, 13 Oct 2026 15:22:44 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: hans.holmberg@wdc.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: handle NULL open_zone for merged ioends in
 xfs_end_ioend_write_zoned
Message-ID: <as4wVDBSbwcYNyHf@nidhogg.toxiclabs.cc>
References: <20261013115755.1473496-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013115755.1473496-1-hch@lst.de>

On Tue, Oct 13, 2026 at 01:57:55PM +0200, Christoph Hellwig wrote:
> The NULL checks on the merged ioends added in commit ae285611891f ("xfs:
> handle NULL open_zone for merged ioends in xfs_ioend_put_open_zones") got
> lost when the code was moved to a new file.  Reinstate the check, and
> also update the comments to be a little more coherent.
> 
> Fixes: 6b855256eb9e ("xfs: split ioend handling into a separate source file")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioend.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index f0e01ac34de8..26b996a52d8b 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -182,15 +182,15 @@ xfs_end_ioend_write_zoned(
>  		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
>  done:
>  	/*
> -	 * Put the open zone for all ioends merged into this one (if any).
> -	 */
> -	list_for_each_entry(tmp, &ioend->io_list, io_list)
> -		xfs_open_zone_put(tmp->io_private);
> -
> -	/*
> -	 * The main ioend might not have an open zone if the submission failed
> -	 * before xfs_zone_alloc_and_submit got called.
> +	 * Put the open zone references for all ioends merged into this one in
> +	 * addition to the main one they were merged into.  If the submission
> +	 * failed before xfs_zone_alloc_and_submit got called, there is open
> +	 * zone and at least in theory that could also happen for merged ioends.
>  	 */
> +	list_for_each_entry(tmp, &ioend->io_list, io_list) {
> +		if (tmp->io_private)
> +			xfs_open_zone_put(tmp->io_private);
> +	}
>  	if (oz)
>  		xfs_open_zone_put(oz);
>  	iomap_finish_ioends(ioend, error);

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> -- 
> 2.53.0
> 
> 
