Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAF624168E;
	Thu, 13 Mar 2025 07:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741851087; cv=none; b=NR4C/nBVJRe+xQxYgagImN4+pb3r4kSiy0OrSEtrleNgy9j9+cgWsDEBUpzF3uZ38fE+eyQqDj4b8Le2UNLeSY44MJsty7J5oxD4peNRl/FxWYqsxSMcJocHXKWYu8OT09kkHMg7+/weqPZFwheStygan3YVmQngRFkixWcKHfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741851087; c=relaxed/simple;
	bh=af/iPdRlaVAslPQFNQ9SNcQLODJWMuc9eXGDyA5GCq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ptytwo8BqmNgn7riONixQTgijbbS+qkanrKmG+T1FJdChJvG29kiYvcU160HkzoFxeHuU4OJkRDeA83P+hOf3L0QzVAt/tGVc8/Jse+l79yFrrxxhlWqPF9wjLK+zyrG1Ga1PGCLOg0uFNeCRSsggiMvDmWG5x/RY1h3Fo/YSO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7E72C68C4E; Thu, 13 Mar 2025 08:31:22 +0100 (CET)
Date: Thu, 13 Mar 2025 08:31:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs: skip filestreams tests on internal RT
 devices
Message-ID: <20250313073122.GG11310@lst.de>
References: <20250312064541.664334-1-hch@lst.de> <20250312064541.664334-15-hch@lst.de> <20250312202603.GO2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312202603.GO2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 12, 2025 at 01:26:03PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 12, 2025 at 07:45:06AM +0100, Christoph Hellwig wrote:
> > The filestreams tests using _test_streams force a run on the data
> > section, but for internal RT zoned devices the data section can be tiny
> > and might not provide enough space.  Skip these tests as they aren't
> > really useful when testing a zoned config anyway.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok, assuming you don't just want to kill filestreams entirely :)

Hans and I are in fact looking into ways to repurpose it for zone
placement.  But that might just end up reusing the mru cache and look
a bit different to the user.

