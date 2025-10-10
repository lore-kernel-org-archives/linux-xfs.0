Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F71846F
	for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 05:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760072925; cv=none; b=U868+ImHE14Z9ycU6RFspUjeQj84VXN0kxtVVlkjGGigl67YrdLpfHWxUnSrQRE5lb51S+meM0/+kDXcirA6AkcxINGo9Ul6V5Dbo8IHdgLfstv5da5YJIC75jiXo8+f6YNItPQVRcB/qOE6I8m8+V2qjiB0ht1OTqetT2ZtfdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760072925; c=relaxed/simple;
	bh=IIMAADQOTgljkxNfbSZwAGZ+0ENvGO7KFtIOK3rjq/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fKuQXLh2hydK+MOWQsR4IefRWvm0FD1IQ+zdMo6hxHgkgnRri0MDaQi7GY9fICaa7BflIvtPKSS34NsamPAL+TELrNA+1lj3tEXo6u6Hgk1WEb2hCAxHeVk49UKbNA3F/HScGdHjeyHb+8fIQCDagS3tKRMWlZdeOCqlnQQzd1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1C9CD227AAD; Fri, 10 Oct 2025 07:08:32 +0200 (CEST)
Date: Fri, 10 Oct 2025 07:08:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org,
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de,
	pchelkin@ispras.ru, pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: Re: [PATCH v2 0/12] xfsprogs: libxfs sync v6.17
Message-ID: <20251010050832.GA15629@lst.de>
References: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760011614.patch-series@thinky>
User-Agent: Mutt/1.5.17 (2007-11-01)

The patches look good,

but the way you mailed them out is seriously broken, all the mails showed
up as pretending to be the original authors.  I'm kinda surprised this
even made it past mail server s:)

On Thu, Oct 09, 2025 at 02:08:24PM +0200, Andrey Albershteyn wrote:
> Hey all,
> 
> This is libxfs sync with v6.17.
> ---
>  0 files changed, 0 insertions(+), 0 deletions(-)

Also this looks wrong.
