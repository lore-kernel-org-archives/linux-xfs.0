Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF96E484250;
	Mon,  5 Oct 2026 13:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206241; cv=none; b=r2h+I8IknCLjVJbYtU4dY+cOOLewTt/f3mctLKYVEua19/n8b9zeYjBjim5DnAowqQrFJEb+9ECThXc9ADUXExVw9dJGMPEu0X1s+UZxhxFwcBPXoYG8H6sImNsAHJaIX6/WarWqZWPqtRlIHlStHbIzoW9LI93drxx+VS2qJ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206241; c=relaxed/simple;
	bh=0seYcxoXkRoQkb1AQZ3v8FeRal9z3G5Tn8ySUmAebug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gPYmGMg12Gb5t3fRDNfL7tTG9j5EjUCjw6j4D8Jlp/wmhly//TRu5XyVyknzotwo1ChxXTb+lPMCNecQ/JpJTNcKVwSd0i19c3cwSWf+ghM1i73bSFf4j7nDJvD/2ImF94Yy02AfEH+dTaLYBDYGRhf8zwvwcyPJICTc/wfGFKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1A5BE68AFE; Mon,  5 Oct 2026 15:17:12 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:17:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/13] add a "datacsum" group
Message-ID: <20261005131711.GH26805@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-2-hch@lst.de> <20260929013121.GD2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929013121.GD2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:31:21PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 12:07:42PM +0200, Christoph Hellwig wrote:
> > Add a group for test exercising data checksum functionality.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  doc/group-names.txt | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > index ef6b8f51cf87..101c72688c02 100644
> > --- a/doc/group-names.txt
> > +++ b/doc/group-names.txt
> > @@ -34,6 +34,7 @@ dangerous		dangerous test that can crash the system
> >  dangerous_fuzzers	fuzzers that can crash your computer
> >  dangerous_selftest	selftests that crash/hang
> >  data			data loss checkers
> > +datacsum		data checksumming
> 
> Seems like a reasonable addition to me.  That said ... I bet at least
> btrfs/282 is a data checksum test that's incorrectly in the (metadata)
> scrub group.

I didn't really add any existing btrfs tests, but there's probably
a few.  Maybe the btrfs maintainers can help to populate the list?

