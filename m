Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D350423DE
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 21:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746653448; cv=none; b=Ez7NqH1pp6XrR6B6B6+vQ/yUQ1EgpDg8ea9qUqQxgpwo1vLN2fZHIs9/mMxcScIFAC2TsA2xBuzFdHZiTRVOHD5Doc1C2cuh/EMIMVVHrTGh5mGoLCnbHWlsg2VmOS7Jg+HLoZ9Kwih6/GTDBtYhpM2mbM0POr+nu210vesUQRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746653448; c=relaxed/simple;
	bh=eLiVqUzuDoTUNHtBs0ACawkeOg5rohLOVcUjDV/kmMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNhqZm4VjsYOMIR/nJYVPr2tHuNPcNvZjTTphzXT1nZei8jfFxd2/AymTBHfw5G2mi20sKrxy23Qfa/kvf9VOFMa8q5WWnbwIGdIB23vWJAXKVQ2iaNaKqAJ9l588UhtSjUBk8exHjXYj64NoWWsKiBuBz7z8zE5gORa5p9QRN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGRrHBKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGRrHBKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391A1C4CEE2;
	Wed,  7 May 2025 21:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746653448;
	bh=eLiVqUzuDoTUNHtBs0ACawkeOg5rohLOVcUjDV/kmMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WGRrHBKN7W8NylrGKPSUJuQjpU8giv34XyM6CBpRTkHlYuCmTpz5FBW8/aE2UbpfU
	 HzAb2kyvdG29t+aGc9VV6ARbKOeluCi5mcfT0XJN74FkScWiREx5o25ksPMSRiUD8S
	 z28iS+prFAsXk8KT1XRVlNcKK9uhrZBfPPjgRejukTlh1QEfnc3FJVmvb7U3Iq/Kzy
	 I2EkR0Wb0eoliKrLqaSufpNUpgvKm4ryG8HuLwn/L6PhhrKfEnDQKcrBOUQKt0JMy4
	 XfnFQUrCURgEZ4s6T4GeEksTh+yPmIuFx64Diqh6Vh5JrySe/L869139l1MlxOImJF
	 zkl+9saC37zPw==
Date: Wed, 7 May 2025 14:30:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] large atomic writes for xfs
Message-ID: <20250507213047.GK25675@frogsfrogsfrogs>
References: <Na27AkD0pwxtDXufbKHmtlQIDLpo1dVCpyqoca91pszUTNuR1GqASOvLkmMZysL1IsA7vt-xoCFsf50SlGYzGg==@protonmail.internalid>
 <3c385c09-ef36-4ad0-8bb2-c9beeced9cd7@oracle.com>
 <cxcr4rodmdf3m7whanyqp73eflnc5i2s5jbknbdicq7x2vjlz3@m3ya63yenfzm>
 <431a837e-b8e2-4901-96e7-9173ce9e58a3@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <431a837e-b8e2-4901-96e7-9173ce9e58a3@oracle.com>

On Wed, May 07, 2025 at 01:23:51PM +0100, John Garry wrote:
> On 07/05/2025 13:14, Carlos Maiolino wrote:
> > On Wed, May 07, 2025 at 01:00:00PM +0100, John Garry wrote:
> > > Hi Carlos,
> > > 
> > > Please pull the large atomic writes series for xfs.
> > > 
> > > The following changes since commit bfecc4091e07a47696ac922783216d9e9ea46c97:
> > > 
> > >      xfs: allow ro mounts if rtdev or logdev are read-only (2025-04-30
> > > 20:53:52 +0200)
> > > 
> > > are available in the Git repository at:
> > > 
> > >      https://urldefense.com/v3/__https://github.com/johnpgarry/
> > > linux.git__;!!ACWV5N9M2RV99hQ!
> > > IVDUFMxfAfmMgnyhV150ZyTdmIuE2vm93RuY0_z92SeHSsReFAeP5gbh3DA-
> > > iow80_ciEVx3MhZ7gA$  tags/large-atomic-writes-xfs
> > > 
> > > for you to fetch changes up to 2c465e8bf4fd45e913a51506d58bd8906e5de0ca:
> > The last commit has no Reviews into it.
> 
> I'll add it.

Not sure why John wants me to create a PR, but I'll do that, and with
the two RVB tags received since V12 was posted.

--D

> Thanks
> 
