Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155A029D270
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 13:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959781; cv=none; b=F4RfwBZOKjWqtYSWoTZxGEgJ6/1Jv7M6df9A8S9LE0NMA5HpWSZEz3PTG8jmVt8bG9iWIYvjcmz42zkuHz2VgDlATVxXq7C23kstbk4AZskcvGiuxc+PDbKmCmOYnxjPrMX6w7RcgWJvajdtYvl0iW0/l2TDxfggIUVdhgU/sbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959781; c=relaxed/simple;
	bh=X2Hsw6AcPVdUnIvJreuTDDw/6AOigIvAVkfNCIXcGg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=clKlGdFUh/GqjN8uxJj26vY9pLbXXAAdTfWDWirkJdAAcRVCeLEWBviDMOx9ZjJs5hWBiPMD2PYJaVvEZG42ZEWLV20aIqGOpk7mNLU2zgsKroAlRirmKi4kXyFogBFBgjDm/V6GZrZsX3BebAVdNBST0SHJHChvu6HNyBYE0C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlBgLprc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlBgLprc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FDE1F00AC4;
	Wed,  9 Sep 2026 13:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788959779;
	bh=EigBMY6tIhrtx/31FUuMNU4CHAYTof0B2elLPM31B2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nlBgLprcic8Fb7zjqkdF3D/+v7YFbECeqLYhw5RjZT2BNOSrVBbJd8UVbDa1zshR1
	 sP5XqRaJGj3nvAi1v9s08svy4+tbEPYPwG/jMz6rUhUQ1kSrfzhMdZEFWMU7GBjjUA
	 mmgE359yiyvWwgDx1mbgPaEH3DfcNtAhryjvkOgUQ3Sa2gyHiLexii2PQ1w01SuqjA
	 uM2GjV2FgTdylH3ZXFyOaaz3OwQZw0XTwAoM+pCFx/MI+NpwE/LsvrPnEpIC1nHBIC
	 Aig1A3TAz7UojylWTeO8P61VAT2h4WX8NM8xY7l/LvZvPb9hfnW6h9LaFkdntWavJ4
	 k7/LwjJbJxM5w==
Date: Wed, 9 Sep 2026 15:16:15 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] makecfg: add a few more file related options
Message-ID: <aqFcDL8BAdkOqSo8@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910659.4047311.5368828900056094997.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910659.4047311.5368828900056094997.stgit@frogsfrogsfrogs>

On 2026-09-08 23:02:04, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a few more configuration options for directory and inode related
> options that might cause user-observable behavior changes.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
