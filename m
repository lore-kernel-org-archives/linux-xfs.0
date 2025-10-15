Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60A41D47B4
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 04:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760503070; cv=none; b=ocVqzy57w6WUJMuVV1C37FizWi1XvQKDyCrscmH6tGn8FeXgv9LkMIp+kE0qpPHolEZWQV/o77jNs16ZK8RPPRhoDOPgc7dxMhzfowcmJHvjwfeh3/WPcZ8aN7CYyHLrh6lY6+EVF1jjkv5OCatEoaa697+bSBNKt02s/+tCSiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760503070; c=relaxed/simple;
	bh=LuX2W4xkDafm0tkf8q367mdZdS/TsNkG3CXuqUAEJ6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZxjUUsP0uJMYqWeLF5MZhgA95VFu00VcSk2KplawPBvlwbtz2ncDXAHKJKkI9DK6xN/Hbz6Sl93kMGdeMM6/drCHjcrYSNguVYqyv3OnhqH5T6uxOZLPurBql1zyg7XVzci3UP7wRkTmP7u5MTpMGTQFPH7jOcoeZ7JUE396k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C2FAB227A87; Wed, 15 Oct 2025 06:37:44 +0200 (CEST)
Date: Wed, 15 Oct 2025 06:37:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: remove a very outdated comment from
 xlog_alloc_log
Message-ID: <20251015043744.GC7253@lst.de>
References: <20251013024228.4109032-1-hch@lst.de> <20251013024228.4109032-6-hch@lst.de> <20251014215226.GK6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014215226.GK6188@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 14, 2025 at 02:52:26PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 13, 2025 at 11:42:09AM +0900, Christoph Hellwig wrote:
> > The xlog_iclog definition has been pretty standard for a while, so drop
> > this now rather misleading comment.
> 
> The iclog structure's size scales proportionately to the log buffer
> size, right?  AFAICT it's the iclog header itself plus enough bio_vecs
> to map every page of the log buffer.  So there's really nothing weird
> about that, right?

Yes.

(it might be worth to look into just using high order folios for
the on-disk log, that way we'd always need exactly two bio_vecs and
make the bio building simpler, but that's a separate discussion)

