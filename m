Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13780171088;
	Fri, 22 Nov 2024 12:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732278698; cv=none; b=Dc1PrpVMs3nR8haVGJjSYKilE7PrH3mBH4h2vsmewoR6ZdKUwE2uyCHaJ9Wl8Zxp/1B0/r6nW8wMRgtG0RAZ2kw7ukUn6StV1LWfZrDNbM/EY88PLawIQY2GKMibZxbue7RN7rDazneafgwd7qZJJ5mvMt4C4V4BSvTdLSqgqkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732278698; c=relaxed/simple;
	bh=nz61W1Az50gSxuLNnjLopDTWKimJoUYu8hxw1ShnitU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQDdTumoWIy+btZFHyhVyB3nbgxMalMutnDPA6eGlV/cC9g5+UMDYghpvZ3d1ChSmNg2cloT42rLEVwAYNfcvGQ+SWbmksxAhj4pu6OLLF6WJirfJXMluNeWgsrcmt8r9CKXfGHuipbAe9MD3Dp9nmL+/0fcZNYrUgUNdnBTndg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9ABA068D0A; Fri, 22 Nov 2024 13:31:33 +0100 (CET)
Date: Fri, 22 Nov 2024 13:31:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241122123133.GA26198@lst.de>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs> <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs> <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20241121100555.GA4176@lst.de> <Zz8nWa1xGm7c2FHt@bfoster> <20241121131239.GA28064@lst.de> <Zz8_rFRio0vp07rd@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz8_rFRio0vp07rd@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 21, 2024 at 09:11:56AM -0500, Brian Foster wrote:
> > I'm all for speeding up tests.  But relying on a unspecified side effect
> > of an operation and then requiring a driver that implements that side
> > effect without documenting that isn't really good practice.
> > 
> 
> It's a hack to facilitate test coverage. It would obviously need to be
> revisited if behavior changed sufficiently to break the test.
> 
> I'm not really sure what you're asking for wrt documentation. A quick
> scan of the git history shows the first such commit is 65cc9a235919
> ("generic/482: use thin volume as data device"), the commit log for
> which seems to explain the reasoning.

A comment on _log_writes_init that it must only be used by dm-thin
because it relies on the undocumented behavior that dm-trim zeroes
all blocks discarded.

Or even better my moving the dm-think setup boilerplate into the log
writes helpers, so that it gets done automatically.

