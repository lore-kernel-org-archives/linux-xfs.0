Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9D61EB1BA
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 16:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744303642; cv=none; b=mS66k2QO7/ZsOS/r3M9t8mHmcMiXgB817wwdeuYczMkh7zwPqWXlGgZxJ3DEpThn+r/xudVPLFBvvGswnkrEUt9qAeIxOFXU1LPbF2pCxaqoTGyQcIw0QY3Dm170GIaQ7nnxV67P3YLK0dLrfXUC6ICXQG12YEm4HaxnPkLX4MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744303642; c=relaxed/simple;
	bh=s3RT6PW7I0yH6cPB5dghLP2D+Zy6UHDyI7ow2kg04eE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vF1sVX/L9j/FWzM8UiUymocTeA0TmuCk2NLAnsr1ASJTnJ2cLig205CumUdJWieiFMLEpE2gKQ1puEgZn7Izg8s0L60S/QNiu29ofVEgrfpRypcCwxw/g/U9LI1ktzZqdWbHU3/meHTV9/aXMc6HM3OSgqklQhuDqyAEML0qRwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SjufzcD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SjufzcD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2006C4CEDD;
	Thu, 10 Apr 2025 16:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744303641;
	bh=s3RT6PW7I0yH6cPB5dghLP2D+Zy6UHDyI7ow2kg04eE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SjufzcD+CItodKn/XQVLedpV5s7HaG9LkT1Sn7CQNXAdJ6FZMl65HH2d1YZYi+z83
	 AIMHGcZ37JAcWd+7rFpuayVrxkHpAOTqTUWF8s2+7U4iEfmUDosaK3iuRCI5UU7F3R
	 pr92+t6nXzgGQ8ZYqYvQsl0miOAaBgVspWnj5wu2ZECWgOnKBCjYux50t9Z/n7/9uX
	 xslBB/DMfhIFV+ihuEUjsSV1Uk3OaSJaizbNMdBHbTie8YZJi4gnAdrZlX0AGV6PO9
	 XYwnMFRKyibJKphomJGDfiHceSn5DBpPzgpdvFTAkD8gZYeAZcR0xn/ynEpognqHJW
	 qjW4/8J2BfkdQ==
Date: Thu, 10 Apr 2025 09:47:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/45] xfs_mkfs: reflink conflicts with zoned file
 systems for now
Message-ID: <20250410164721.GC6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-34-hch@lst.de>
 <20250409190000.GH6283@frogsfrogsfrogs>
 <20250410064631.GG31075@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410064631.GG31075@lst.de>

On Thu, Apr 10, 2025 at 08:46:31AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 09, 2025 at 12:00:00PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 09, 2025 at 09:55:36AM +0200, Christoph Hellwig wrote:
> > > Until GC is enhanced to not unshared reflinked blocks we better prohibit
> > > this combination.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > ...or gc figures out how to do reflinked moves.  Either way,
> 
> That's what I mean with not unsharing.  I can adjust the wording
> if mine was too confusing, though.

"Don't allow reflink until zonegc learns how to deal with shared
extents." ?

--D
