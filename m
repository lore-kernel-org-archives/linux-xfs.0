Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF22254B03;
	Mon,  9 Feb 2026 06:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770618868; cv=none; b=Ma/DaLAxtqXJRAQZWETmtZF7LGQSPxUsD6fNKzdSziXuBkX1N7vnfW2QgXd94pIsaKVbQwX/Ww9GS62R1TXhY/Irv05IXrzcj9U2v2ICfBBVsHPT96gRFxSDnRSebmLg2GWKJR5AQF8k8gvPh0rz4p2GRxHHjgYCBRI+AQQuBNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770618868; c=relaxed/simple;
	bh=jC/DbfFivLb09eva0oVsPEhlx7EESZiJzFfwVUDc914=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJpAZMWHm6BQ9CTRagSJyGA+kx4Bp52skLv6RhIYrcavLENTINYvOSWrvfCZYIt2oQH9I/tSPP4GYGNGZOxWnh/6Q6MdBDAeaTjVND6LNeTMl3HDURKf4tGnOvxinzs7AU0GBcK5qwrx1VepaX7xlY0QzB5fjdvhQh9X2o5OuEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9BA7C68BEB; Mon,  9 Feb 2026 07:34:22 +0100 (CET)
Date: Mon, 9 Feb 2026 07:34:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, cem@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	p.raghav@samsung.com
Subject: Re: [PATCH 02/11] xfs: start creating infrastructure for health
 monitoring
Message-ID: <20260209063421.GA9202@lst.de>
References: <176852588473.2137143.1604994842772101197.stgit@frogsfrogsfrogs> <176852588582.2137143.1283636639551788931.stgit@frogsfrogsfrogs> <tq3nyswm72gackesz6v476qqvin5eaa67f4hf6lg52exzv7k7p@tczjh5n777tc> <20260206174742.GI7693@frogsfrogsfrogs> <37e584d1-1256-46ad-9ddf-0c4b8186db08@linux.dev> <20260206204135.GA7712@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206204135.GA7712@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 06, 2026 at 12:41:35PM -0800, Darrick J. Wong wrote:
> > So just a barrier() call in rcu_read_lock is enough to make sure this
> > doesn't happen and probably adding a READ_ONCE() is not needed?
> 
> Nope.  You're right, we do need READ_ONCE here.

The right thing is to use rcu_dereference / rcu_assign_pointer and add a
__rcu annotation to m_healthmon.

