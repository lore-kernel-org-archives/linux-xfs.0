Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530643911AB;
	Thu,  2 Jul 2026 10:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988516; cv=none; b=rtjImxE3bVMs6QyThZ6qKltVvCDSi0xLm4lnRKuDPIMJ7tBhSLzA3+LmUBvMmDzDms+Dm1tSz2uHntgfk5Ta/GB1HEcdQtXFrozM3cQwEb0ygdP5D1uYW+oVB7yTIjmp7h8+zQWCTSPwvByB7Z/6VLRPQLoOmcJE1cwJMw9AkEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988516; c=relaxed/simple;
	bh=UQe1zVjf6AOY/g1XORuBt5rHrTHZC573emdl/AomUj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JFnExe3rzul+BOqcQP8W2SPxX6QZv/B5R8u4P3hZgqbirWp7VZ43MHSnaeML//Sx/VZ19Y+/xQnQwjHkO9/1H9G56lyiXaooZU27GZIQHPuroBRmmoLerg/Ym+RWMu7bV4uOPYG5McCGnq8N+qaGp5RValWYlE3V/KbwWeQrruo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EE2C168BEB; Thu,  2 Jul 2026 12:35:04 +0200 (CEST)
Date: Thu, 2 Jul 2026 12:35:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Yao Sang <sangyao@kylinos.cn>
Subject: Re: [PATCH 1/2] xfs/656: rearrange directio pread/pwrite for zoned
 filesystems
Message-ID: <20260702103504.GB6816@lst.de>
References: <20260702035523.GA9381@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702035523.GA9381@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 01, 2026 at 08:55:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On zoned filesystems, a write failure shuts down the filesystem, which
> makes this test fail with:

Looks good an increases the test coverage.  This also makes half of
"common: skip data write EIO survival tests on fatal configs" obsolete.

Darrick, Yao, Zorro:  I think we need to arrange all the tests in
this area into a coherent series.  Should I do that?
