Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A101BBBE6
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 15:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722440562; cv=none; b=NtbZGXcCUuaKgJUgWHUg0SS/9CiQkOGsF4ZBuc3cBmrkB+RQflrujSO37vya7VgiBcO7Gd+pUrd82nWp9yIrkWjqRN3CO3inkP9ld7fRNCgGxK4IZh2Z+HcH7UMHJoaTmbhUIa775lbzXFj0Qyem5fuak7YFCb/xkYp/dY9K5AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722440562; c=relaxed/simple;
	bh=dvd2MOwnNArGK6b/7/p8Qy/r2TWRXWMbOir8kCb6O/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Li3Zu0rOyeX5y/8rwM8i/DqByMExJDFH1g720KRE423dTdEbIl2opDET9JoK+u0eWdMxbagTX51IqjBdpNa+N3zDhcvJTG5gX+c0F4h4jea+HxKjQg6HYcDr49ZsffrqoK44Qxz0MYDhVuFLacxvjomEUmnS9s6M5Y/KVzxG3UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nsyLTbbr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nsyLTbbr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uGgzrssViMUu/stYW4d2VWihd7grMJVf2BvUSb7GhxI=; b=nsyLTbbrsWQdg4buD+h0P99/Yq
	Y6FVSej5IddXTnx+RfdOSf9+KRfg0ZM0KJysnhaL1/rfZJ9NSvfdhYwFjzUKicBy1O00++nayvzd1
	RCILc8XHgdXSV+JVKtmGvxwkw2L9oIf0v6s6u8x7LtBHKUlCrOCHq15B7QEEx5bFZ/kj2Li2tfFX6
	tOpswtPblQbLfWW70ARUfA7iUCXCD8Xlvvzl0DVt5XHQnio1D29LliXBZlhkXFG0kpvqZ0q0A6tTQ
	y5+oDSU8JEhedZE6bR3FXb1f91awD5i18AHKVIumaRWSHsVQ1BXxpQt8e9NDdnSjt2qrPQkKmWgik
	B0M7QmOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sZBTN-00000001lBP-0Fm5;
	Wed, 31 Jul 2024 15:42:41 +0000
Date: Wed, 31 Jul 2024 08:42:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_property: add a new tool to administer fs
 properties
Message-ID: <ZqpbcQyqlXI7fVme@infradead.org>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940678.1543753.11215656166264361855.stgit@frogsfrogsfrogs>
 <ZqlegsIRSwlccyX8@infradead.org>
 <20240730222815.GK6352@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730222815.GK6352@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 30, 2024 at 03:28:15PM -0700, Darrick J. Wong wrote:
> I think you're asking if I could make xfs_spaceman expose the
> {list,get,set}fsprops commands and db expose the -Z flag to
> attr_{get,set,list} when someone starts them up with -p xfs_property ?

I was mostly concerned about spaceman.  I don't think it actually is so
bad, just a bit confusing.  But if we do xfs_io and xfs_db that's not
really an issue anyway.

