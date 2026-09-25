Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D941356779;
	Fri, 25 Sep 2026 06:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790316079; cv=none; b=gaSxHFyzZ1vjb2AIHjtPGzqDoMth9rMA+IwfBQkM+X3os99j+BBmjHSL0L6fSrHR0Ed5JBXmn/XsYHdWRlnc9ps/5QG6xCo1+cn4k9ODFiFZ76orhCbI1DDsKz1cBBrZC0vMCnmMAHEShgQYWVTvbz+cizKrTQj1n572VL7MqBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790316079; c=relaxed/simple;
	bh=F41OCUSMR533xmpYkqrLhxNs8wo6q3bLa2P/pJYD1nE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cb0xNILrGV8O24mDD9vrlYks8AeTwTZtPnhrsEviTzSyqHPN6b8RCDGrnP//jBTe1STvGHn6/HCx8vUj8dnuak7S2UFe96cJkCpbBwEX/tJviqQcqMwKWpTL8YTb/Z4Zht2ihlYjZV7e1XE+BNYz/uLt+r5wyxL7mg6+qPe85qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2697568D07; Fri, 25 Sep 2026 08:01:11 +0200 (CEST)
Date: Fri, 25 Sep 2026 08:01:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/21] xfs: define the RT data checksum on-disk format
Message-ID: <20260925060109.GE3193@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-9-hch@lst.de> <20260924221359.GI2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924221359.GI2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 03:13:59PM -0700, Darrick J. Wong wrote:
> And just to play the peanut gallery here, xxhash? <duck>

Way too slow, and doesn't provided the nice properties of CRCs.

With the diff below that adds xxh32/xxh64 to the crc benchmark, the
numbers do not look good (AMD Zen5 mobile in my laptop), all in MB/s:

		4k              16k
crc32c          69027           77384
crc64_nvme      65164           71290
xxh32           13822           13695
xxh64           26820           28194

Note that given how the crc kunit is designed, nvme64 even does two
extra inversion per cycle, although that probably doesn't show up
in the numbers.
