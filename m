Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFE32F5A29
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768978181; cv=none; b=Uo4sLxrQy6ofwqF5CSO0j2W7xSA8QP8txNDu7ijSqvZ4PnOI6N0D9IDqxeNBe6ZmJsTAWPjvfICf6mqXE8vb06WkOME3IjNS/0GOpSZvVymLvIecAgapCcQO8sQyhvHVTE9DhtyZ2+euTb/82aAZUQVTnf2cIa9rGtF7uy1WvRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768978181; c=relaxed/simple;
	bh=qHLEPrHWnOr5ly3YTNNWjSNWygad3O23HIHo7/nFRIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pf1ZFB7JEufYYFJb6Se18WR47BeeqCtvRLIbVAlkpJGLD86zOxa79LitrX0yi2wx0XNhCs0Ia9+CEwrkOBDeeeSKYG72haDMeWy6kBzQ1ZAyi0gcO0iLN88mqBNwN358J59qXT80PtZigQkj2rupEQAcH/jJ4GzarXk7G5d7GOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1DEFA227AAA; Wed, 21 Jan 2026 07:49:25 +0100 (CET)
Date: Wed, 21 Jan 2026 07:49:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] xfs: use blkdev_report_zones_cached()
Message-ID: <20260121064924.GA11068@lst.de>
References: <20260109162324.2386829-1-hch@lst.de> <20260109162324.2386829-2-hch@lst.de> <yw6bc76kuh56avbb5nxlvdkrattk57s5z65defzbdoohp5wtvt@h346oio32jdk> <20260120173119.GS15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260120173119.GS15551@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 20, 2026 at 09:31:19AM -0800, Darrick J. Wong wrote:
> > > +#ifndef BLK_ZONE_COND_ACTIVE /* added in Linux 6.19 */
> > > +#define BLK_ZONE_COND_ACTIVE	0xff
> > 
> > hmm I think #ifndef doesn't work for enum member. Compiling against
> > linux 6.19-rc6: 
> > 
> > ../include/platform_defs.h:311:33: error: expected identifier before numeric constant
> >   311 | #define BLK_ZONE_COND_ACTIVE    0xff
> >       |                                 ^~~~
> > /linux-headers-v6.19-rc6/include/linux/blkzoned.h:84:9: note: in expansion of macro ‘BLK_ZONE_COND_ACTIVE’
> >    84 |         BLK_ZONE_COND_ACTIVE    = 0xFF,
> >       |         ^~~~~~~~~~~~~~~~~~~~
> 
> I hacked around this very crudely:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=djwong-wtf&id=d5d9b4bd2da95c7b9429112f1c1098a62f155270

Urgg.  That's why we should not use enums in uapi headers..

Damien, I guess we could do a:

#define BLK_ZONE_COND_ACTIVE	BLK_ZONE_COND_ACTIVE

as the usual trick to fix that in the blkzoned.h header, and given
that 6.19 hasn't been released still get it to Linus in time.

> Though I think one of hch's fix patches fixed that.  I cannot post a
> lore link because the #@!%)*&!%!!! anubis b@%#%!!! is completely broken
> and will not let me in.  But we did the review for the kernel-side fixes
> within the last couple of weeks.

I don't think I fixed it.  Not intentionally, and not unintentionally
in a way I'd actually understand at least :)

