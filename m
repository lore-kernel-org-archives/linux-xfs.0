Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE433194C95;
	Wed, 18 Feb 2026 06:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771397265; cv=none; b=gjtzpzvW8MytAaKucve90uhopYlTcBJZ5ALTpRa4ZB6iuPyfRoMMFDXZXEWIYvovZe7vuifWTbiY1bfay2hxYWKClv9z0DCQIBhPnza6euB4bPRP4v8LyyEdHU8Xharj8Vd97Qb96PE0bGt3TpXYYm3Pk9SnrSSGFr00Hh+0xdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771397265; c=relaxed/simple;
	bh=eRkqorGo9PgPXsivRXPC8Kkd+ClfZQ7gporvAWYGEbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnfyLUgSppKuhGwP0o09MO5xTSzcp7rISyhq46s22zenf1VpFikZPz9tzknEAsohAFGT4fP2u2gUnGqH0PGzwUzuzzetFJNbjCMI2FjYuVWO0ET6ywJ7jpHj8f80e+hIvYMvYqkg3VPHsnGvS9LzIUU1sx+bA22FwJO419WyUkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 664F568B05; Wed, 18 Feb 2026 07:47:39 +0100 (CET)
Date: Wed, 18 Feb 2026 07:47:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Andres Freund <andres@anarazel.de>,
	Pankaj Raghav <pankaj.raghav@linux.dev>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
	vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260218064739.GA8881@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev> <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s> <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v> <4627056f-2ab9-4ff1-bca0-5d80f8f0bbab@linux.dev> <ignmsoluhway2yllepl2djcjjaukjijq3ejrlf4uuvh57ru7ur@njkzymuvzfqf> <aZUQKx_C3-qyU4PJ@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZUQKx_C3-qyU4PJ@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 18, 2026 at 12:04:43PM +1100, Dave Chinner wrote:
> > > > I'd call it RWF_WRITETHROUGH but otherwise it makes sense.
> > > > 
> > > 
> > > One naive question: semantically what will be the difference between
> > > RWF_DSYNC and RWF_WRITETHROUGH?
> 
> None, except that RWF_DSYNC provides data integrity guarantees.

Which boils down to RWF_DSYNC still writing out the inode and flushing
the cache.

> > Which
> > wouldn't be needed for RWF_WRITETHROUGH, right?
> 
> Correct, there shouldn't be any data integrity guarantees associated
> with plain RWF_WRITETHROUGH.

Which makes me curious if the plain RWF_WRITETHROUGH would be all
that useful.

