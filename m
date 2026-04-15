Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785102C3757;
	Wed, 15 Apr 2026 06:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776233452; cv=none; b=UK+fsv7ARNeAMPJGATXwl6kZOPsCoTHdEOorZXIwDM0+Yx3rYLUbcTP4JsoDZSI2yVTs/ED9xo8C6fgLcOfk/o2yd4NItm19YcdkfT4YIE74IUHVltCDhcYTR92a6A2e/oal1v9z+b4hgRSMNbXp6GqPK5jWJYbEOxe47JlUbtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776233452; c=relaxed/simple;
	bh=fWQw3DLSMlnGlCAEdvPdGfCpHCJ5msFf0w7S8NxH2FI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eu4YxNTFZ5aFuCat5A+2+zOMmLu8LQ9UUa6iTIAdqE2dr2A6gI+BdeD5F2s0yJIFgnNR4qAm/oYD/0SICrAZEWj7ZMif3PrIAogYjcIXL9D+QxJWKdBGff0ZCyy47qT9RZSvvoo+F+X3Q3CtYvBjlNpJpOlw3hX9b5irzZwwg7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Wwlu1nDv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wwlu1nDv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7aKAAKsTYoxSoqNfxwE2AztxBRZIup6mF9UIRFkQkpg=; b=Wwlu1nDvkuxF0JLEyPMWI6/78x
	sRW2f/J7mqr2jRUICnnn53a00TfzBdd24MgcENfRMxEsTz33uGwP0NZ51O8rcPsNyi9b8DFyPAvhS
	KnTODEavAruBEZiUDnXXY6Eld6BkmwGcMYQCNlTds0txOh+uAFPGnOdbjn8pm7P7fSt1J7741+bAT
	BmsASonS0UFSepXlXdvmCva4GT9Rzo8Lal9lotlhWCy2F7FygwS6ejQ1GUHOryOx81M0MOBdYfMxq
	jLNTPPRwjZD2nlWaQyua3b9Fq2gNsuY2XO8htreLIGUWGKujRz6A/yWXEUjCW+TSCw78sUVaNBIlo
	9vnUJo1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCtSZ-00000000dJj-1yV5;
	Wed, 15 Apr 2026 06:10:47 +0000
Date: Tue, 14 Apr 2026 23:10:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <ad8r53AmTxjcvTLg@infradead.org>
References: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
 <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
 <7e468bd2-e52b-4165-95c6-3f04e1dca21e@columbia.edu>
 <fb64ba71-7284-4768-979b-84919f2aa5f0@kernel.dk>
 <fd94b108-22c1-4eb6-8fb4-b009214976dc@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd94b108-22c1-4eb6-8fb4-b009214976dc@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 14, 2026 at 04:29:29PM -0400, Tal Zussman wrote:
> No problem, thanks!
> 
> >> (Although Christoph seems to have proposed moving away from llist again)
> > 
> > I think that's a good idea, not a fan of using llist for this, in case
> > that wasn't clear. These are per-cpu lists anyway, and having a constant
> > overhead is better than needing to reverse an llist. IMHO.
> 
> Will change it back for the next version.

FYI, the prime reason I switched away form the llist is to make sure
we can atomically check the list emptyness vs the wakeup decision
in the kthread version.  But if Jens prefers it for other versions as
well, that's fine.

