Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A453C5523;
	Thu,  3 Sep 2026 06:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415694; cv=none; b=SeSeIezcmFkF0ZdUfQ7eg/9i0ZoH7q9YsH7Xry6FEJmEP1CfWH+xAxUlteGX9A215hjFen0LAhKDlvSYVVPuYZyaFp1/Bh40EPIeQlPTwE+sKsAz7YUYZFGK3ahW9DyyJ02197d25E0KtoV0ZUN0/+J84udvuXSZd3bpn8Fv/so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415694; c=relaxed/simple;
	bh=PwO3/YbduDeEWuCewOCmEfUDMr9WCXQ0I+kyq+ILcfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VFLkarwgdkvK6HTzkU9det8xpqgT2aUGjwtuko30h9VN3qTiWFGeV8AtP57g3XP3PqR/HDgKl3ElTRLEbqypjIJtFwgKrKkMNo5ldky4EcZD+xiy/vBl1yukWzQMjLqL1iev2LbIpUBG+HHn4nlDePy7s4tIxI5vzEtH0Ij63ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F1A086732A; Thu,  3 Sep 2026 08:08:09 +0200 (CEST)
Date: Thu, 3 Sep 2026 08:08:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: strengthen the "is cow staging" helpers in
 scrub
Message-ID: <20260903060809.GC17233@lst.de>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs> <178840969892.484660.6073163246909319479.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178840969892.484660.6073163246909319479.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 02, 2026 at 10:51:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM pointed out a bug in both of the refcount scrub predicates that
> determine if a range of blocks is marked as CoW staging in the btree.
> While it compares blockcount < len, this isn't enough to determine that
> the CoW staging record is at least as large as the range passed into the
> helper.  Fix both of them.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

