Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6D43AE1BD;
	Mon, 21 Sep 2026 07:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974659; cv=none; b=DSotJ6hcoHwhQg7sZlmYh5ebb55z/ljcgo2ZtzYhyGs65uARhyZ4ntr4QH3Eixcbb81dqG2k88qi7Kkgo6d74KsyubZ5nQkQeKO2LkdfDGQmO3iz/BbYYocRXry/ha5DZLcI41eYAjngqHMv4MGN2MBN76fcShTkCPHNC7s9DOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974659; c=relaxed/simple;
	bh=N8cZnZCKytopLHm1s/MR5SCVYudpCEl7zW+nDZYooCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gE88r/9du2f65xj0JkR8QB+nnZr6nAM7J+OEvByCJeVffepppEMw/61ClAFjuLzPcIG+4eRHBMudUAxWXTtZl5NlH3OBDNkr2272sXg9rcjKj6gEEUQoYhcvN2Quw4aRLBA4rFbaOKPvmm2eQyE6HUWnHbwOLxerbVECjRGa0FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4965268B05; Mon, 21 Sep 2026 09:10:53 +0200 (CEST)
Date: Mon, 21 Sep 2026 09:10:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, 0wnerD1ed <l7z@0b1t.tech>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/16] xfs: add support for lazy direct read bounce
 buffering
Message-ID: <20260921071052.GA14940@lst.de>
References: <20260909060924.1102037-1-hch@lst.de> <20260909060924.1102037-14-hch@lst.de> <arDN1UdZIydNLUjz@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arDN1UdZIydNLUjz@shinmob>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 21, 2026 at 03:40:00PM +0900, Shin'ichiro Kawasaki wrote:
> I found that recent blktests CI trial runs started reporting the failure of
> the test case block/046 [1]. I confirmed that it is observed with the kernel at
> the linux-block for-next branch. I bisected and found the this commit triggers
> the failure. The error message "preadv returned -1 (errno 22)" was printed at
> src/bio-bounce-read.c line 121 [2].
> 
> AFAIU, the test case does direct read to a null_blk with bounce buffer, and the
> kernel side introduced some new requirements to use bounce buffer for direct
> I/Os. Then, I guess the test case requires some refinements to meet the new
> requirements.
> 
> 0wnerD1ed, may I ask your help to fix this failure? At this moment, I don't have
> much time to dig into this.

From my head the lazy bounce probably means we are not using
the bounce buffer but instead now doing lazy bouncing.  I'll see
what causes this.

