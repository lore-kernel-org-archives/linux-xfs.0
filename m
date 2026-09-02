Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B6930AAD8
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328801; cv=none; b=kpj0RhmjEBYJzrt5AdgLzxSCafgDnUCl4eeQu5nYMlA34sfwwZ34MVyYGcRpM6/2+INWYiPC4Fb1GAyjbBN2LvQbVAXQV9NIINTLdnP1oO/cBAAbxUkTKYVp7k61E+VA4QHXYbYCPSqHxcJccMKRir/9Gd6yz9e82ttPECQVU2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328801; c=relaxed/simple;
	bh=fDFo/Xfi3kPNQK2VppyqgVDgSIUuu6HFem7H6e/Q9M4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzFzFDqjVFl1uq/mz7i740OC6SvwCqArkY2sxF06OQk8ZVd0EPFPSSEc9ZppSNPFOwALFsLpc0OOmyYbEnnEcsFfnp0+igKTfiixK6B1ppXYkoKWgzcDt39s0SaosWtD7yf6YT5W1MHgw/Pd8epRo47jIdy0r/QYZ9r05ONOj2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E7C2868AFE; Wed,  2 Sep 2026 07:59:54 +0200 (CEST)
Date: Wed, 2 Sep 2026 07:59:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org
Subject: Re: [PATCH] libxfs: report device open errors during topology
 probing
Message-ID: <20260902055954.GA24431@lst.de>
References: <20260827112855.70037-1-hans.holmberg@wdc.com> <20260831071039.GA25070@lst.de> <32e910c2-28b1-4df5-99aa-8bf13801ca1e@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32e910c2-28b1-4df5-99aa-8bf13801ca1e@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 10:46:27AM +0200, Hans Holmberg wrote:
> > I wonder if there are any valid failures from blkid_new_probe_from_filename
> > where we'd want to continue?  Probably not as it doesn't really have an
> > obvious failure path, but so far we continue here.  So the print is useful
> > for sure, but I wonder if failing here might cause regressions in some
> > really odd use case (containers without sysfs?  Although we'd run into
> > trouble with that quickly in other places).
> 
> 
> Yeah, it might be safer to just print the warning, and that would solve
> my problem (no instructive error message),
> 
> On the other hand it's nice to fail early - but not if it causes regressions
> of course.

Yeah, failing early is nice, but I'm a bit fearful we might break
existing (but really weird setups).

