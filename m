Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9952E62B7
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 14:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788187566; cv=none; b=c8kftNST58ImJVxaE30FwM7WMbJ7spFwF+T+Xnk9QMONecGUdm/rZOjp0o8R6TzBoAP9AZErkDddF0uG5c3dluRb1mC7K0l9kHjjdxe+v7feQuJ+LkWw6GRRst4rF37wIjB9ewIWON+Xpc0MDxyk67tQ0aG5ikX6wsXbtC3RDlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788187566; c=relaxed/simple;
	bh=or93TXCSGhVx6alVVXi/2VugxHk2rHQ6JK21149AzD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnH6hBTrYIxRdnLjTTN+CkDu8XFKShP6F76Y3CiHLQ57wpOIkBlqVXMwwH7oSuAYkObiDcyPFxJWcUtjBLSBvHBRTBsWhCVyRxfkzwa6rhfaS7Sa4G11CwPGhtbQGIlRwztNAqEqPXIsj1ljfGntsczadq1vPkYklfA6Nhh3Ypk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jp4XpFeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jp4XpFeC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0687A1F000E9;
	Mon, 31 Aug 2026 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788187565;
	bh=gX73ROi5nkOdmV57iBeGFtm5Bbwqyfw6iqZj1PiP7dw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jp4XpFeC3degI1TU1AyTsl1jIz9iRqXdIljLOrheIJG1FY1C09cA/dH9lnm0GvcLa
	 Hr7v0k9f9Map7ay4B1EESHeOeKeXljN+zV5DA9g5vIJeoF31cRZ+7ZqLvboopjF2DN
	 yA4AT8Rys4Fpqab15g/CJOtD2HqMVoAdErJb6gJHRc58+DXeEov3hoEk1BWBnhz4lI
	 brPX8aOqxJVZ3CV+ev1P+KK8A+v/8ne3qiDZKqep53WCMRW99yZbWytTQmb1VAAgGW
	 YBVmIpjV2wYjScS9vNXTrb5j+slkMlx6xzLmH3WfCjSR79sLPaLuZq5Q6g6bf8kleQ
	 Gq/8Ssozl72ow==
Date: Mon, 31 Aug 2026 07:46:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: improve the fsmap man page entry
Message-ID: <20260831144604.GE6072@frogsfrogsfrogs>
References: <20260831071152.2580927-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831071152.2580927-1-hch@lst.de>

On Mon, Aug 31, 2026 at 10:11:52AM +0300, Christoph Hellwig wrote:
> Improve documentation of the flags and optional arguments, and fix up
> messed up formatting.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I wonder if it's worth documenting that fsmap -l shows external
log device mappings?

Looks better in any case so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  man/man8/xfs_db.8 | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index ba2a68211ef2..89db535d38c9 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -849,14 +849,24 @@ command to convert to and from this form. Block numbers given for file blocks
>  .B bmap
>  command) are in this form.
>  .TP
> -.BI "fsmap [ " start " ] [ " end " ]
> +.BI "fsmap [\-r] [" start " [" end ]]
>  Prints the mapping of disk blocks used by an XFS filesystem.  The map
>  lists each extent used by files, allocation group metadata,
>  journalling logs, and static filesystem metadata, as well as any
>  regions that are unused.  All blocks, offsets, and lengths are specified
>  in units of 512-byte blocks, no matter what the filesystem's block size is.
> -.BI "The optional " start " and " end " arguments can be used to constrain
> -the output to a particular range of disk blocks.
> +.IP
> +The optional
> +.I start
> +and
> +.I end
> +arguments can be used to constrain the output to a particular range of disk
> +blocks.
> +.IP
> +When the
> +.B \-r
> +option is specified, prints the reverse mapping for the real-time device
> +instead of the data device.
>  .TP
>  .BI "fuzz [\-c] [\-d] " "field action"
>  Write garbage into a specific structure field on disk.
> -- 
> 2.53.0
> 
> 
