Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7FB8528F
	for <linux-xfs@vger.kernel.org>; Sun, 14 Jul 2024 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720972690; cv=none; b=QMzrcYxi1KcsJHfl8etFUxRIhwXcDyWS0bBnDIiZQyTd6c2LBdlk7nm2wgfe25B98qvyeE5N9Vckt/2TXNWSI+Z40eIlt9q2fj8GcgVfRx8q5Cw5D7h9GUxKC/dcU90ila6sHPClYFEm3sxOmRQoTNBXhprI+gIcdagwL39Updk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720972690; c=relaxed/simple;
	bh=dV5nzCcAd/fdw8c23QNtbYqmMkxlUt5hYKKDA59RRUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H88xmEZ1FDS6Ov07/p2Io9IwxGS55n/yq+FY9F1GD9G/YFLfW+KmmBzs2eEpYQeP6XDC7JL/BDTTsWnZIK3fI25lX+pliEs7SzV0io7UHVRPOluBC/7DG/Mid3+GaYoT+bgH71zVOYA737v7d7zBcWn4Nq/bURr/UnulC2Uw6tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D4E268B05; Sun, 14 Jul 2024 17:57:58 +0200 (CEST)
Date: Sun, 14 Jul 2024 17:57:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: kernel test robot <oliver.sang@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, Linux Memory Management List <linux-mm@kvack.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [linux-next:master] [xfs]  c1220522ef: xfstests.xfs.011.fail
Message-ID: <20240714155757.GA19089@lst.de>
References: <202407142151.a0d44fbb-oliver.sang@intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202407142151.a0d44fbb-oliver.sang@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Yes, this is a known change the log internals exposed through sysfs.
We have a patch for xfstests for it, that I'll resend tomorrow.
