Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CDE21CC44
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 06:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765346936; cv=none; b=VLVXj/Io6caUGofSzWyBUa8G5+oUC+4jL9nSIDPd22JqSzE42XpG6yHKEv6QFZmdYvPJ7a89nE8WhOMq3IZ6+/I+KggTg6Jn+Sx9Azf3hbmvs3TWfHfhyi02YiUVron+//RWuJlHIgfwGdw1m7QYJ8DlADeO6uGFWl9kpzAlLAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765346936; c=relaxed/simple;
	bh=EWo1y0wXUfs1HRJVbah0ybPBzAyWrGjWQbUuec3kjWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gMA+uo+4GGSuO3Cn6IoqvMyRpCWFn/idMhEDlwmvUoLfDcQeL5QOUHjr9OV9BjJJSsSBR3rEWrp2/4s5nrVK2ftbtiogRcg7Lf0JBgPL/gyZSQT+QGv3HM4Afy/KL8EFTBk+DAhQ1JaG2PyBz6qdhUEtg8J6+6uI4kTVZrc8REQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9929B227AA8; Wed, 10 Dec 2025 07:08:48 +0100 (CET)
Date: Wed, 10 Dec 2025 07:08:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Good name for xfs.h/libxfs_priv.h in libxfs
Message-ID: <20251210060848.GA31741@lst.de>
References: <20251202133723.1928059-1-hch@lst.de> <aTFOsmgaPOhtaDeL@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTFOsmgaPOhtaDeL@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

Trying to bring this up again.  I want a common name for
xfs.h/libxfs_priv.h so that sharing libxfs code is easier.

My initial proposal was xfs_priv.h, which Dave didn't like for a valid
reason.  His counter proposal was to just use xfs_linux.h, which is
fine with me.  Another option would be xfs_plaform.h to be more system
independent.  Both are fine with me, as is any other reasonable option.

I've added our regulars to ask if there are any strong preferences
or dislikes for any of the names, or a suggestion for an even better
one.
