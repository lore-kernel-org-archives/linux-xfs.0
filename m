Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F72723D7DD
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 09:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764840558; cv=none; b=NZa92vUVjjbUm7uvmyvP7qNZ8PVABB/J+1AtNj4K/9psjFHgLa20koLbwk2EIEmUjL77GrasyYpj7kH68Nx0pbW2YcbgwzBW9RAg7TqnQUAKVT/3xtMATlxw95m86oSO1i4c9DaqcoEzfeDSFzhYDiKoffAwEUCZrmgtaNyYG38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764840558; c=relaxed/simple;
	bh=s1pl+n9Ng0k+pDS31/mhxVHrU9J4x9sOqjf6rMXgxXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKqqRQ8AfIqEd96ELmOcELecFtSL26jq6lzbIbVhsQ7IxvzGbRVdZhFYOyxuq34aMXaBkbQ9eW7OaMJw+zGf42D4XSoJJs/TYz9g3TPHD2wlTBC9yTn3DM6X27fSkOmxc3OMkPTjobxtiuCeElb3UBwmHeg9KKC00uqGHiVKeeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8C6A1227AAE; Thu,  4 Dec 2025 10:29:13 +0100 (CET)
Date: Thu, 4 Dec 2025 10:29:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org,
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org,
	hans.holmberg@wdc.com, hch@lst.de, preichl@redhat.com
Subject: Re: [PATCH 3/33] xfs: remove the xlog_op_header_t typedef
Message-ID: <20251204092913.GB19971@lst.de>
References: <cover.1764788517.patch-series@thinky> <imvre7eff2sz5qqwjcrf3u5lliifj5bv2jb777o46llkofgluq@k5himtjdist4>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <imvre7eff2sz5qqwjcrf3u5lliifj5bv2jb777o46llkofgluq@k5himtjdist4>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 03, 2025 at 08:04:35PM +0100, Andrey Albershteyn wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Source kernel commit: eff8668607888988cad7b31528ff08d8883c5d7e
> 
> There are almost no users of the typedef left, kill it and switch the
> remaining users to use the underlying struct.

Hmm, at this state this is still used in libxfs and logprint.  How
is this series structured?

