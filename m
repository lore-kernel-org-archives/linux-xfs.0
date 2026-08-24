Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076E63161A2;
	Mon, 24 Aug 2026 04:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787547067; cv=none; b=LndWEYMsgquRZlIBBV6WOWOW6ATbR81yamVikAMkpj3q3C5mQsc+GcwdCbyQTKKcinfddlrhCinmuJSp397qw1I/mg/bdbAxqrYIO/j1Sa8mKEZS7iITBt7q66uKTyM79C98I3rCDyVSciPP/1gg06pl4cq1W++Z1ZkPj5Faezo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787547067; c=relaxed/simple;
	bh=8pvZnkWP7ATVle8LnmbEbQYIOQPUrMlAgqnu0a+Pcjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=he0y3JpHr9080/jGSLAqpoTETlKrioEQsXxs8agEHgio91DvYehqUvC0/k7mz/8w+M02CkvjVfcC+W1BWA5pxiJwtV3Qbn6zb8bTBgheKTWCPgHhI6MgDsklTuqLoHOB1HMCxjFVVJPp/ROkA594DJoo0wZHwJSYsZg0ZQCHUKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C6C068BFE; Mon, 24 Aug 2026 06:50:54 +0200 (CEST)
Date: Mon, 24 Aug 2026 06:50:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix media verification ioctl for internal rt
 volumes
Message-ID: <20260824045053.GA29508@lst.de>
References: <20260821035806.GJ6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821035806.GJ6072@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I'm starting to wonder if operating on FSBs instead of BBs in the media
verification ioctl would clean up much of this.  But I guess we care about
being able to pinpoint media errors to sub-FSB ranges?

