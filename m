Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171B11F80A0
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 19:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729019225; cv=none; b=X1cjts0PErvdmJsaQMFkFPPceaRenjfnTvzydwHRyE4Q7A7n+Tlbc9GuztDMdYcB/Yoh3CPJ56xcRWmZdtrh23N1yK7sDldRv7dSjwjAAYKhTyYS9wGBFu920z/8vgkGjLyGIcDRA3nBS6ni243Sdpn006FBPVqQC/jimY1AYto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729019225; c=relaxed/simple;
	bh=oV9f6FaFcsNsQRwQwKsqsiQVLqlChwQ+OaH9wi5jAdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQV0pa8ztDucxqf9Bx0+jwzbEX9lKd5AiDRm3/qMm1X6tN86qZXahGht6TO66MqjtjIGpkjEKdJbPrx1xucmTXpTt1nKf3tf8f3LM07X82CK5Kv/Yce3nSERqE2xBgh2q56BZ1DQexPpMIYshcEZqTF4Li0640jeKFayDYc+Uq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LzZ2N4lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzZ2N4lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7188C4CEC6;
	Tue, 15 Oct 2024 19:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729019224;
	bh=oV9f6FaFcsNsQRwQwKsqsiQVLqlChwQ+OaH9wi5jAdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LzZ2N4lc/H965Hq2T2NPZohkVjqc0iH3CKqivtUQ7wETmpgx77FIKQ10Eo38Excm+
	 QYF3j9z9WYUBsJWivuKqHAf3Ir4PlajjtYxZiZvFP2lEEh7ugrzdayzNlbnVqEX+8q
	 2Z5HTYMWPbG5ld3Fo0s1eDBgmiKFEaF5Nm6mjnNapnsDmorCLzkQTI7nkJ3hmHcUFU
	 qZWryxaleni8qQJRaag0WLhuOcKk141oIyG/FLLpDkZeXVsqJ6N9qthAdf9Sr34sUR
	 KWAkC0NiesQyevOgoqyAo42PCoTSAMBBkOUjYfIQ/fgbGJFohyCrMcEj9k0OHnzp7V
	 VoeFFstOUupEA==
Date: Tue, 15 Oct 2024 12:07:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 30/36] xfs: move the group geometry into struct xfs_groups
Message-ID: <20241015190704.GJ21853@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644760.4178701.13593967456112695233.stgit@frogsfrogsfrogs>
 <ZwzRn1fEt0xHdel-@infradead.org>
 <20241015013315.GS21853@frogsfrogsfrogs>
 <Zw3hFOr3C2eiYOlx@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw3hFOr3C2eiYOlx@infradead.org>

On Mon, Oct 14, 2024 at 08:27:16PM -0700, Christoph Hellwig wrote:
> On Mon, Oct 14, 2024 at 06:33:15PM -0700, Darrick J. Wong wrote:
> > Grrrrr crap tools.  Sorry about that.  I probably force-imported this
> > patch at some point and it tripped over all the free form text in a
> > patch that looks like headers.
> 
> At least for me, the problem is usually git-rebase as it strips
> authorship after conflict resultion, and I keep forgetting the manual
> fixup.

For me it's most likely my stg-force-import program that works around
stg import's pickiness (no fuzz allowed at all!) by creating a new patch
with the commit message and then using a regular patch(1) apply the
changes.

--D
