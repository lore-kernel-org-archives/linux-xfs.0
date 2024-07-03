Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F328F40
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 01:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719971997; cv=none; b=ISC/nyqIUmQYzaDtshVAMyEE+jpBSFTUeczNP2XUWfdpwnxA3NSqBfUSnQv/CD4rq3I7w+Lw0/zi9x7MXg0fk1ulY+RPGiKPMCQxgwyqlNkbdXjATeFk+0RKetwTi2J2p7xL5aKdVC46nzYrn9e9BM4BkztmDgGaTKAhJ7lw5E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719971997; c=relaxed/simple;
	bh=ktU4K/sWvHg60FKDKGtBg1WUb74EN8BBU5gD1GvMdCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3l+HjbGIRvvVYDgWtEw4RL8kyBMQZcK15h3M6nK4DPerYgQ+2nu8kvw8DE71V4ksFsOgkB0Z3JZHzwowKgQ1dXYnrUNLPuvqrdgD8jUxdBUFgiFKngxJEdS5a13qRlQLEKe8TJuljhJsG1DpR1SvYCXF8IqH90kENzNFgZto+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enkHCN6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enkHCN6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232DCC116B1;
	Wed,  3 Jul 2024 01:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719971997;
	bh=ktU4K/sWvHg60FKDKGtBg1WUb74EN8BBU5gD1GvMdCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=enkHCN6Zx6GtAFo211Gkt3h6IU7vmm5jCL52aR8IY8+qDwG6htc+CNfs8AxtbfpNa
	 XeWXvVwxjVKkR1QOd8hu7I2c0xNTynEFywoGxpgerD5GFxjHR4ZoAUUPsfaCEC6cfs
	 EKyTZFVP/OJCJicVCgFxqoJUUbWTeHcK6j9dPlum+eZKuhDDWJoRojHL0t/JbyPBx/
	 UGTTTneJ5puAVs/1pPEslKTzmLmDykiNRrdKoGEER1G0zrZ58zOzjySrlzp0CHgfI3
	 LjsUmz1r3+Nkrp3KYp5CyvhJgdbXYY690CBCDoOdyjgp3MVHCpgIWEO2bEplJydYYj
	 H3mDaXmpn5kog==
Date: Tue, 2 Jul 2024 18:59:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs_scrub: add a couple of omitted invisible code
 points
Message-ID: <20240703015956.GS612460@frogsfrogsfrogs>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
 <171988117657.2007123.5376979485947307326.stgit@frogsfrogsfrogs>
 <20240702052225.GF22536@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702052225.GF22536@lst.de>

On Tue, Jul 02, 2024 at 07:22:25AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 01, 2024 at 05:58:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > I missed a few non-rendering code points in the "zero width"
> > classification code.  Add them now, and sort the list.
> > 
> > $ wget https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
> > $ grep -E '(zero width|invisible|joiner|application)' -i UnicodeData.txt
> 
> Should this be automated?

That will require a bit more thought -- many distro build systems these
days operate in a sealed box with no network access, so you can't really
automate this.  libicu (the last time I looked) didn't have a predicate
to tell you if a particular code point was one of the invisible ones.

Here's what I get from running the commands right now:

009F;<control>;Cc;0;BN;;;;;N;APPLICATION PROGRAM COMMAND;;;;
034F;COMBINING GRAPHEME JOINER;Mn;0;NSM;;;;;N;;;;;
200B;ZERO WIDTH SPACE;Cf;0;BN;;;;;N;;;;;
200C;ZERO WIDTH NON-JOINER;Cf;0;BN;;;;;N;;;;;
200D;ZERO WIDTH JOINER;Cf;0;BN;;;;;N;;;;;
2060;WORD JOINER;Cf;0;BN;;;;;N;;;;;
2061;FUNCTION APPLICATION;Cf;0;BN;;;;;N;;;;;
2062;INVISIBLE TIMES;Cf;0;BN;;;;;N;;;;;
2063;INVISIBLE SEPARATOR;Cf;0;BN;;;;;N;;;;;
2064;INVISIBLE PLUS;Cf;0;BN;;;;;N;;;;;
2D7F;TIFINAGH CONSONANT JOINER;Mn;9;NSM;;;;;N;;;;;
FEFF;ZERO WIDTH NO-BREAK SPACE;Cf;0;BN;;;;;N;BYTE ORDER MARK;;;;
1107F;BRAHMI NUMBER JOINER;Mn;9;NSM;;;;;N;;;;;
11A47;ZANABAZAR SQUARE SUBJOINER;Mn;9;NSM;;;;;N;;;;;
11A99;SOYOMBO SUBJOINER;Mn;9;NSM;;;;;N;;;;;
11F42;KAWI CONJOINER;Mn;9;NSM;;;;;N;;;;;
13430;EGYPTIAN HIEROGLYPH VERTICAL JOINER;Cf;0;L;;;;;N;;;;;
13431;EGYPTIAN HIEROGLYPH HORIZONTAL JOINER;Cf;0;L;;;;;N;;;;;

The five-digit ones are new to me; I'll go have a look at how the
noto(fu) fonts render those.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
