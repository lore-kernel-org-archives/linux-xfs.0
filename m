Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC143451A9
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 10:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790849814; cv=none; b=AwV/RKFEExBzc30r0Xx345UqB5+x3J+Ysg9xPr0ZhxfTBbTYkhztq5plFAOiInO3SmFmL4DrLCS7RV4pTGbmmK8bd7tkBbxWh9X9H3Rb4rTMvxbAZDp+CqOgqTlvNEozKXxyusyn+xpaRdGURXM+3ISy8IUYK0bf/vyO/hCvRug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790849814; c=relaxed/simple;
	bh=ZpsLuuUeKj2F85h6y2d13Cmn3mFDWyiZM7UpDm4orfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rqbRh8lb7xAGdnJaoN8Q13fcVJqC1+IUV1T3Sclbh+aoZeVFsU2U+q6hZZn6U8Pasn/SmsnWX9NAN+T14nFh0w33X1cY9CI7ZQPqwXKcmHibrs8ITJQZMA8PoaIoBZx1W82SlPCjg7xgfgbj7UphSHUZQpKIhicTkQX2s9Jx7JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aClguoYX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aClguoYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E222C1F00898;
	Thu,  1 Oct 2026 10:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790849812;
	bh=cWbQ6e7kZ4n0K1zT8Ys6dIsVOhcP52QifVyU91/FFLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aClguoYXiBDXk6+0g5bCULieJs2AoGwt3j8qwdTwQDhj4i2vNOhD9VB0ofIJoQKY7
	 vacdoeebI9EwSNpEySMPX6FXfuVxnUdgJxoFdledYyCFZOquBSDgPJ5P6Et+9vfmQr
	 pLdFohutM9EYMUz6wDXW5Z5uU1lH6rUs7TF+id3b+m8epsilarU/o2U4nax/4WsDWY
	 brZa/4xCaq+jNzXvVJzvKbt789Ttsgf3ME029Z7DqXbewEais6SFSdWO2fxOAc5wvf
	 aQTpj8q+EPbx7Cqxye/GZNCInF5SZ6yDfwTocCh+RlFUjls9ulslIRjIve4Zqsds7z
	 OLRAQlYJf3k0A==
Date: Thu, 1 Oct 2026 12:16:49 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-xfs@vger.kernel.org
Subject: Re: running "make clean" in xfsprogs doesn't wipe mkfs/*.o files
Message-ID: <ar4yieNNgClK4g_P@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <arnTiMxkxgR7oRYb@mit.edu>
 <arn-smyk5m2gCkYT@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arn-smyk5m2gCkYT@infradead.org>

On 2026-09-27 22:44:18, Christoph Hellwig wrote:
> I don't have an answer either, and haven't seen this one in particular,
> but the xfsprogs build system is special at best or broken if you want
> to be frank.  A while ago I started on a ninja + meson port as that
> seems to be build system of choice for many low-level tools.  I didn't
> really have time to do more than a minimal demo, buf if someone wants
> to move to a less broken build system I'd be 100% supportive.

Yeah, ninja+meson would be nice, whole probing system would be much
simpler.

-- 
- Andrey
