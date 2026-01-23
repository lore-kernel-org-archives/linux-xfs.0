Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6E035A95F;
	Fri, 23 Jan 2026 07:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152174; cv=none; b=AzgzJwy1Ixezim4Xv0scPHWCl+P8PzRabAtxxiUsCPFe++3YfmHzE/zAZ2YdS9XbefdQbuaqx/W8HoT8fS+aipQMmgUoHo1c+ZyUS7tAtU6oUcQGURKM+/gEbZVY0JduEk6eIp+mdGC/6RbX8ll9/PfFbr/G6KAYLP56Xd3q4is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152174; c=relaxed/simple;
	bh=ofnkU/zHlsoyC2sM3ZLTfx0zSZXoPY0968HprSgh0yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KxZSIBk/Bbh1LXRRUSaiHYpgKjXrj0QQus8ouVeQe65vaYMyXd0svDHiMAyt1mwPjqrM+RvwvznLcdzE+Eb3IQkAPFD7rDOU4MmWYqF2DiPQPkuadFaYZp5C1ayDzsfqsiLSJMFCLbym9Ox8pBLDCK1XOavOJ6XahPtg6bXrl7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZW9BEiiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZW9BEiiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5649C4CEF1;
	Fri, 23 Jan 2026 07:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769152173;
	bh=ofnkU/zHlsoyC2sM3ZLTfx0zSZXoPY0968HprSgh0yA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZW9BEiiMW8h5cUEK3gX1n0aWcyMdKN05+pBrf5Gfq/FVYHBoYhGpNQiAlOaFzjTiQ
	 kbZgKK5w0KPaTIY2pPSfQoRehgWOkajYgmXz//kSoSVwv8qwS2EAxLXbbeTs3KGQLy
	 hv+Fxv0ebJ3JF7+BcO8dbHBOYiJZrrVijqEah/QD+XB8cgGt0wIYNw2RhpomdPnbh8
	 o9rbJWk25n1tbTg3Uo0H0pR6pZf+4q4WKgEFkGHgphNmaqnbiYoYs85n/G6omtsQbs
	 f+drXsU9IQFpjfBKhOZRGZMrs8OXamz1J9WdCFSuaeOEdoofVJokEejwO01HZSxCIA
	 Td+AHFGnfGq7A==
Date: Thu, 22 Jan 2026 23:09:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/14] iov_iter: extract a iov_iter_extract_bvecs helper
 from bio code
Message-ID: <20260123070933.GS5945@frogsfrogsfrogs>
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-4-hch@lst.de>
 <20260122174703.GX5945@frogsfrogsfrogs>
 <20260123054448.GB24902@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123054448.GB24902@lst.de>

On Fri, Jan 23, 2026 at 06:44:48AM +0100, Christoph Hellwig wrote:
> On Thu, Jan 22, 2026 at 09:47:03AM -0800, Darrick J. Wong wrote:
> > > -	struct page **pages = (struct page **)bv;
> > 
> > Huh.  We type-abuse an array of bio_vec's as an array of struct page
> > pointers??
> > 
> > As a straight hoist the patch looks correct but I'm confused about this.
> 
> Yes.  This uses the larger space allocated for bio_vecs to first
> place the pages at the end, and then filling in the bio_vecs from the
> beginning.  I think the comments describe it pretty well, but if you
> have ideas for enhancement, this might be a good time to update them.

I'm not sure, since the alternative is to wrap the whole mess in a
union, which makes the type-abuse more explicit but then is still pretty
ugly.  The only improvement I can really think of would be a huge
comment wherever we start this, which I think Kent's original code from
2011 had ("deep magic", etc).

--D
