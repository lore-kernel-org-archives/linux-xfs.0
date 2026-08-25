Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFC22AE78
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 23:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787701203; cv=none; b=KHkfg+Afzq9kofiLS4D9lyiOwIjcQynOn2fo94VatU56u4k40xXLNuxBvUdPjFv24fDI4xuqNsL+t/9TgPP4Q1P0S0p06+6GbdSUzz7zGbnxAQ6Q9R9uNRFJW9TIJaDJyc+yh0HmiGkKdUTCgrWFM6nzWdu6IhUf7p1gf9RDacE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787701203; c=relaxed/simple;
	bh=gCA4KZFApEu56BqXpYgpFD8qgtVQp7y2JmQYLrL/CEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JV4Gchaj8UwtQ3UjsmMEpB5PPinzuXEpIb5rauSJxLdfXKTNe3nbMunE+HSlsXbu8fAsDR7QeEan96ramgzUVgTkVYHeYUb1rlGnqL/6AyZ316xpgbZ2oZ3I2ZiIL1KhpZkXRwSgeSfrKWhiFUg0qE8h30wSsIEqw5slBOWSlag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/VoXmpL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/VoXmpL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DD7901F000E9;
	Tue, 25 Aug 2026 23:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787701201;
	bh=RQYG/oLvKA8H3ySF/yBVSCLJi7Lbq6GojRSRf03iX+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T/VoXmpLzbELansfWXvn4qLeGGcSLKEDeDI8gSO4KzWkgauJBCuZpO78xyb+YQLAt
	 OhPQLz2Qk+0BVKjxY1COylUwbwcegXMe2q1iPJsM5DhghQ9D8vOmUAwZDtOd/s+3Ht
	 msxczD5ZFZIurXc0QkxgotCHFz+XPQsbYFk7mCMN8MKGIPUmUee9CSYIW6+ysrmkKc
	 6MbHmnmIpzVrxtY1Ca+HKWLlcO7+jCqR2ezHLLCl812yEkIMvr1fLNR6PPvdto3FXH
	 Ub4BV1GL1DgrSeR3qVSOv939VvkEOtqgOeaoYXW8pKkNfJzMCLK7Qnwul6LCEo92PK
	 MizkELSqwUA1w==
Date: Tue, 25 Aug 2026 16:40:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
Message-ID: <20260825234001.GY6072@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
 <178760940784.944084.16150563988327141422.stgit@frogsfrogsfrogs>
 <20260825063214.GE24324@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825063214.GE24324@lst.de>

On Tue, Aug 25, 2026 at 08:32:14AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 24, 2026 at 10:35:41PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > A longstanding weakness of the metapath repair code is that it can only
> > reattach non-directories to the metadata directory tree.  Let's fix that
> 
> Why was this not done before?  Why is it possible now?  Testcase?

I straight up forgot to implement it.  And right now there's no way to
mount a filesystem with a broken subdirectory (your choices are
/rtgroups or /quota) so it didn't stand out.

Some day there might be a need to handle deeper metadata directory
trees, so I figured that I should perhaps go implement that now.

Still working on how to make a testcase work though. :/

--D
