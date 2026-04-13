Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442AE2BE03B
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 10:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776076645; cv=none; b=lf6Ewvqhk5gPJaBo3OZmhzrm6hYzMTTRywBA8Rpn0+DaH3TDDwJcMG0aK5MLzMXqcRp/6HCjFTczBAS8PIK6ADmNJ7p89oarrfRwopZyqnOcI9epDGVSpL2DhxbjOoGroXqWlmNE9uKrSDdVeFh6TejRRcOrRTUcwGcst4MnkIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776076645; c=relaxed/simple;
	bh=RqRO2taQltFB57bdaUhVeYUYVxQNIXHfZ90ZrP4+tjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2bo8xf36xa3OYfLP4x3Q6etJ/n7rVU6dbtIu8fb5axjATeq31cRgheVRptU3OUFFq7d96QI964xMizMDltEau7uLZndihL8PXjYhqToT65qnBYoTmoD2yd2pdw7UnoEfu/SneoyGPb13hSt27G/WhFwerEvTCrtKYvoPY9WMUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kf+Hl79t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kf+Hl79t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFA9C116C6;
	Mon, 13 Apr 2026 10:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776076644;
	bh=RqRO2taQltFB57bdaUhVeYUYVxQNIXHfZ90ZrP4+tjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kf+Hl79tvMjUNhckgd0mh/y2vvmSCf1Iki5592ThzFj7DfZoIwtNzdTAYyIrHM07g
	 1+tarR0wAZ4ZhVVV6WleD10KeaJNyGvsW05eVSa3beNJA002vRi4UOhUhOwTtjZbUf
	 QNN0YYjH/nXs4Sbb3Rj2WotP+8SHq/1CM62BAuQxp8a+nI2+IvTLC82/xxLqvFa0uS
	 86qz4A6iJXcxr2WMm5oCjHTDSt9ueL/fuNxMvJxmtlknVxubXGaiwXt2RzHitUBeEu
	 bZ730d9IYcfdUYJg8zopdwOJbwUrEAVOOK33aMbwjoNez7QipxNz79atbFBBPXWQqA
	 IMnOvyXul1Seg==
Date: Mon, 13 Apr 2026 12:37:20 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Andreas Tille <tille@debian.org>
Cc: XFS Development Team <linux-xfs@vger.kernel.org>, 
	Anibal Monsalve Salazar <anibal@debian.org>, Nathan Scott <nathans@debian.org>
Subject: Re: Please migrate xfsdump and xfsprogs Debian packaging to Salsa
Message-ID: <adzGdfbByADzoXWr@nidhogg.toxiclabs.cc>
References: <ads96yii8bij-UQQ@an3as.eu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ads96yii8bij-UQQ@an3as.eu>

Hi Andreas.

On Sun, Apr 12, 2026 at 08:38:35AM +0200, Andreas Tille wrote:
> Hi XFS Development Team,
> 
> I'm currently reviewing team-maintained packages that are not exposing
> Vcs fields.  I assume for some efficient team work you are maintaining
> 
>   xfsdump
>   xfsprogs 
> 
> in some Git repository, but the Vcs fields are not set and I could not
> find corresponding repositories on Salsa.  I'm not even sure whether you
> might have some team space there or whether the Debian team might
> sufficiently fulfill your needs.
> 
> I'd be happy if these packages could be maintained in a publicly visible
> Git repository on Salsa, with appropriate Vcs fields set.
> 
> If there are specific reasons why this is currently not the case, I
> would be interested to understand them as well.
> 
> If you need any help with creating some Git repository I can happily
> do so since I have developed some training in doing this.
> 
> Thanks for your work on XFS in Debian, and best regards,
>    Andreas.

I'm not sure what Salsa is, nor what Vcs fields are, I'm assuming this
is a Debian specific thing and I'm not that familiar with Debian
ecosystem...

I'm assuming this is something debian-specific? Perhaps Nathan can chime
in here, because this does not think something related to xfsprogs
upstream development?!

I'm not the xfsprogs maintainer though, but this doesn't seem to be
concerning with xfsprogs upstream development.

> 
> -- 
> https://fam-tille.de
> 
