Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615723B2BA;
	Thu, 26 Mar 2026 06:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774505409; cv=none; b=FRpZYeypJihw1ymckyKOkouJBhfKdPr+PJ7SMyt1aey3jV4n4B+sMOjC3mW8YIf16dnxwwJ+toMdVzfTc353VKuvKAo4fKvy4angPBbcK1uyziPqkzeug32bzenjTukLfne64+BK2zhggDoDdmVpBamPApVEKbGSO1UAmAjY+o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774505409; c=relaxed/simple;
	bh=nSQXt+nvernvLwXs7EdMydPQ1upuSUIBjKImE1jvI24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jbi3PWEiZCr5qKB8mrKaws3iG4zSkicdrRjBg1s1fk3iGCz8jsVSZq106mx1tgSfVvE4IUrrnJZDKqBthO+yUwqF5XTgXV5KJMJA8z0OxJ99JpUpCfL9yTgAhxV65O2DeRls+tJrLEKSTypA6qhTVZBo3UqEgJk1fW3loYUltCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DCA7168B05; Thu, 26 Mar 2026 07:10:05 +0100 (CET)
Date: Thu, 26 Mar 2026 07:10:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: start gc on zonegc_low_space attribute updates
Message-ID: <20260326061005.GB23733@lst.de>
References: <20260325124312.26349-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325124312.26349-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 25, 2026 at 01:43:12PM +0100, Hans Holmberg wrote:
> - Added protection against races with unmounts as sysfs gets torn down
>   after the zone info struct is freed. This also avoids unneded
>   wakeups during remount.

Independent of this patch we really should tear down sysfs early in
unmount, otherwise we'll run into issues with data structures torn
down first eventually.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

