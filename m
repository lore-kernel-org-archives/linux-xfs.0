Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9357835EDC9
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769532134; cv=none; b=bv1nn+tohkxK3LiLE+yOFS7i317hoyJUgAMqxdP2tI5kA+C0+M/3p9XIrxYSTGXUx0z42Fj7Cxn0/kF/9vkKDhwBAUYNu5OsaznuM4/QLbmmaf3zpzqHPGhG11aL7naF3wCrMx+TfALQHGf/8F7liDabM70orwWq1r/MYyI3/KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769532134; c=relaxed/simple;
	bh=TmbzlUcuat7oVxMU8X7UFn3KDk2Tgls7t2uN2f+GyMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxYwjkM8+9fibLxJTssjgyt4hSjXVv5XINRuHYJ5P3VUnCyfLygEU9BlDflqZi7Idyu4s+SWEq+q1fO8fJGCLzG0Xc67ratfAN3P019SK1Beaxlngi5kFP00LXDkp10PGNcVfv1pG96XlTBPIJ2QeXm4TQvXRS+aiWHpwm14Zx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 450EA6732A; Tue, 27 Jan 2026 17:42:09 +0100 (CET)
Date: Tue, 27 Jan 2026 17:42:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] xfs: don't keep a reference for buffers on the LRU
Message-ID: <20260127164208.GA8761@lst.de>
References: <20260126053825.1420158-1-hch@lst.de> <20260126053825.1420158-2-hch@lst.de> <aXe-EkVrEB-UhNy2@bfoster> <20260127052050.GB24364@lst.de> <aXjc2gsNToSSANmn@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXjc2gsNToSSANmn@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 10:42:18AM -0500, Brian Foster wrote:
> IOW, I'm not arguing for or against a change in buffer lifetime behavior
> here, just that it should probably be done separately with some more
> careful analysis. The secondary advantage is that if this behavior does
> somehow uncover something problematic, we can bisect/revert back to
> historical lifetime behavior without having to walk back these
> functional changes.

Allright, I'll see if I can split it out.
