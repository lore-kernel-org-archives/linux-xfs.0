Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276519;
	b=UzjhUtHcQvG4XNJxZS30M+b8xxQxlLc3+MwS8lpV4X2VG91XCKFeEewpvvZ/ti3IU+x6
	 zECOGypZEKCLKrheQhsV6uhwLAJ+4t+VvkN4YzwXfQ8IjAWhAXpUqMQmJZGvOboBKyfMe
	 l5/0NNkzuhv6LV3rc2mBFXVtOA+0QgtfOA4BV+Mm1djjBZawPf3It5wZpsK2mWqO+qmC0
	 faSaA0avhtRQK9mwzLuyQ3712e0Mp+NhxneVGt8OJTqJlOqiFL9TrryDKszuSUdb8lX1M
	 0eMNRgXUlPafwFuWjIx5fOrB4prhDrx7oAQJkOLXE/xCAfhiXfMS3UKDHCtb3N56Eng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276519;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=FEPg0IBYjJwtMvKdVK/6nCY/XVULRmnng6fnH4Yf8Do=;
	b=TJnfNy9uyPPoaf/f4qRTtDlGwC4gzOeShrwBalIXbp9YiBtQ4J/Of83cxtBMbpR78TDG
	 uT0Goaayx4TFWjFjDgzWvgxOA6gfczc0eezoTU19qyh9x8aYqwtSh5N/kIsGNjWoY+a/d
	 98Z93xeNQ/+5xj2/ZAQv7Oo+l0lZk9wLFCSkwMWO+FK/rU/EVAoVPN9cVwwFTfKGQoqJl
	 F2xGOORmIGIeR66O8/TVfxD+ks7O6wHhWmaVqHdp/jYrD6qIJkfKWWbvvyCGlqAKIYVku
	 9NxQdCw7BTCG5zm0cZmJI56wYfCN/WimRfQkH1IiswAmVPPVsfIBlQtTe9/I59pcgNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E09606A31C;
	Thu, 29 Oct 2026 12:21:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2E09606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 770EF68BFE; Thu, 29 Oct 2026 13:21:55 +0100 (CET)
Date: Thu, 29 Oct 2026 13:21:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	Chris Mason <clm@meta.com>, Josef Bacik <josef@toxicpanda.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: don't mark unwritten parts of a folio
 uptodate
Message-ID: <20261029122155.GB24811@lst.de>
References: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org> <20261029-work-iomap-ai-fixes-v1-1-7eda63bc1b13@kernel.org> <20261029121220.GA24197@lst.de> <20261029-betuchte-unzeit-heimcomputer-392ff6bd4772@brauner>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-betuchte-unzeit-heimcomputer-392ff6bd4772@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 29, 2026 at 01:20:09PM +0100, Christian Brauner wrote:
> > Can we wire this up to xfstests, please?
> 
> I have an endless queue of additional bugs to go through so I can say
> yes but I can't commit to any timeframe nor the ability to remember.
> 
> > > Willy reported this back in 2024 (cf. [1]) and Zhang Yi posted the same
> > > fix (cf. [2]) but it never got merged.
> > 
> > Should we credit the original submission then?
> 
> It's references in the commit message already. Tell me what you think we
> need to see there and I'll amend in-tree.

Usually that just means taking the older patch instead of the newer one.
Although chances are that this one might not apply anymore, in which
case taking the new one should be ok.
