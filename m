Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D65A1DED72;
	Wed,  7 May 2025 05:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594732; cv=none; b=b/ShKoL+2VQxL12rVSwRQEtirIUOmUi5poojqHnEs6CjH8lwH7hux92BT5nhYvbKDd3kg+/VPGKR4wld34cU4OORu+wkIq4codvK0z+i7lhUCqYGARIJJGFDKuVyNa7J2j7C6+kverGsRMswRzfGMXYD3/sLYLjGdP4LZa9pL74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594732; c=relaxed/simple;
	bh=QIyjQ68XVxKn0oH63NVUGqRL94g7O9zHTo0sEFTsRjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=evijyuVdeWOHBD4vXIqmUCjw5zh0NtwShjcVvW/DzRGKZm0e6hdPJ0ByGhGs9Mw6kmxE9tSBq8iY+JVAr7YblIbTg/A/tdSTLZdjWhIkggMPIDLylY4e3UjEX2j5tEs1A6NFuVQ52S4qR/xueaGj9aWx06yisUWUr8QJpcOupyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 87DB568B05; Wed,  7 May 2025 07:12:06 +0200 (CEST)
Date: Wed, 7 May 2025 07:12:06 +0200
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Zorro Lang <zlang@kernel.org>, "djwong@kernel.org" <djwong@kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>
Subject: Re: [PATCH v2 15/15] xfs: test that we can handle spurious zone wp
 advancements
Message-ID: <20250507051206.GA28948@lst.de>
References: <20250501134302.2881773-16-hch@lst.de> <20250505095054.16030-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505095054.16030-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

While testing the updates for the comments from Zorro, it turns out
that this doesn't handle internal RT devices correctly.  Can you
fix it up to handle that as well?

