Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509ED3128D9;
	Fri, 24 Jul 2026 05:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784870848; cv=none; b=l9hgdmR99a8fic0lKUVqemCYqg0qWRJTkkoOHyVNZ+8lPq9gZ+CU2ipihgqJwBdY9Zr1KSAtLsf/OBWlY1Y1td/STXgRSurvyHQROMP5aGe4XA98b0mOhhNecKwZjERg6Vs8kbAoFAeAQ1h96hSWE3VXRTUXtsIxsC7I77fI4YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784870848; c=relaxed/simple;
	bh=MJEa+f28juVQtDX5TyZ/Sp9zsWaJyBAcNZ2XBvSQjFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ptZQb/yNDAWu0lNkyNgwlQveS2YGAoThXPOzv2nJYZOMQbEgNJQFX44z9NfiSk54BWK5MH8s/NlOEhE9gOQn2MV5DVILZUHSrxVhi4I/E0GZvV1zwtweIRePtqbDms2ioJm9VE3JeAjpVc7iXFcZofEpgBGNNPwr82FGyONwg5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E4E6A68BEB; Fri, 24 Jul 2026 07:27:15 +0200 (CEST)
Date: Fri, 24 Jul 2026 07:27:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, djwong@kernel.org,
	willy@infradead.org, akpm@linux-foundation.org, hwenwur@gmail.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <20260724052715.GA4181@lst.de>
References: <20260719095732.1813590-1-yun.zhou@windriver.com> <20260719095732.1813590-3-yun.zhou@windriver.com> <20260720083940.GA21000@lst.de> <f7e7b1f9-ddee-4668-9cea-830264f984f5@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7e7b1f9-ddee-4668-9cea-830264f984f5@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 12:08:33PM +0800, Zhou, Yun wrote:
>> Having a maze of single or two caller magic macros that modify global
>> (or rather global-ish as it's per thread) state makes hairy bits like
>> this really error prone as seen by the bugs now found.
>
> It's been a few days since the last discussion. I'm planning to
> respin as v3 following Christoph's suggestion (drop the helper,
> re-save directly in xfs_trans_roll). Any other suggestions?

Sounds good to me.

