Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478723B14D1;
	Thu, 30 Jul 2026 08:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785399618; cv=none; b=gZijKMvaPoOI1LWWBOxUxaHP40XdtyrlxSrNdkOLfdF2aD3SY4zLD9NQa9Y4XkDQbYorzGsM1hK4LU9jR7N3nXdbp+XFzxEc2vhfUMfdXMOSNbSDlk8z77v66fEQ9GRCDU+bvorQhA30aUzCdD3DHF0wRvbBE8sOjQjnI80TTUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785399618; c=relaxed/simple;
	bh=1WvmyxoiFKvL65v+qVpkU4ttviYi1CD9nOU1ro6wmmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7ryl/8DaDm4fewfTBzw4CjQJqO+CEZrnQOMOwPS8dywcWxzbido9FCKP8/z3QAvNkIjlBSDpYWJRgltsGWSg4tL3bk++U4OB5QyncQ+dDHgVjZTbAQi4End/PNeBLiyg+74vh73andmlO7JnCvSKa6+PKbd3wDcoEtFfn/gCuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E602268BFE; Thu, 30 Jul 2026 10:20:08 +0200 (CEST)
Date: Thu, 30 Jul 2026 10:20:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: don't leak dqacct if rhashtable insertion
 fails
Message-ID: <20260730082008.GD10558@lst.de>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs> <178538912965.4070956.18121841188530798974.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178538912965.4070956.18121841188530798974.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 10:27:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observes that xqcheck_mod_live_ino_dqtrx doesn't free the newly
> allocated dqa object if rhashtable insertion fails.  Fix this leak.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

