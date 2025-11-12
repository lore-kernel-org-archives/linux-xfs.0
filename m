Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE8F1482E8
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 19:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975103; cv=none; b=fbzZ9SyJCAxd1Q6gz3k4vtdQdb5TN7azqE0TzsEaAw1SmH0k4FvTg39SXfYujeiama6MQzDwSaqS/HdqrisSL6+WZjVzQg4VbAzX/lcBFY9QLCqB958ncQhDHE4ew2r0lnalylNZK7aZ9wC6gjU/NNOGe4RKgXMCf9Z04jXVxjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975103; c=relaxed/simple;
	bh=CaYbPwoGa5C1x4n86PmIOOYJHdM/bL0O2ntWhBcimtA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=swRhFotlK8LuOxACcUesFDA8NbAh+keSQpd8QBo7WJRwGLbocwOdplzblcVZam2zbNx8bwtTjAYvoCQYwf9wd5tOjQyVBJy7C/G5wICQNtcjPYU7hbFuIigbnptc/qMT3YxMnwVclT59A7/0gkrrpstEjLtUpEgZNFIELxwFhzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=XkNUkI12; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="XkNUkI12"
Received: from monopod.intra.ispras.ru (unknown [10.10.3.121])
	by mail.ispras.ru (Postfix) with ESMTPSA id A27DA4076729;
	Wed, 12 Nov 2025 19:18:17 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru A27DA4076729
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1762975097;
	bh=L0SYB2931HHXffsGUXXmJpUxn/WgMHI2NzGvCv9ncuQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=XkNUkI12SF9akE5o3/ETcTiF05EvHt8Zmtjk7n60Bm1AECRqplAScgjkHg70QcTrM
	 4NwDjnJH0xbkUiAblbchERdwseIymLBWJGpDBqnE0TN8E6KLXzZh2ehK00p2iHx5VG
	 iTBMKCl6TJgVqVRke4Gka4f+Y2eJSNoUCTycMrtY=
Date: Wed, 12 Nov 2025 22:18:14 +0300 (MSK)
From: Alexander Monakov <amonakov@ispras.ru>
To: "Darrick J. Wong" <djwong@kernel.org>
cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: use push_cur_and_set_type more
In-Reply-To: <20251112185939.GC196370@frogsfrogsfrogs>
Message-ID: <2b02b2a0-036a-c171-4515-068acb2f330b@ispras.ru>
References: <20251112151932.12141-1-amonakov@ispras.ru> <20251112151932.12141-3-amonakov@ispras.ru> <20251112185939.GC196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wed, 12 Nov 2025, Darrick J. Wong wrote:

> On Wed, Nov 12, 2025 at 06:19:32PM +0300, Alexander Monakov wrote:
> > Since push_cur unsets cur_typ, 'ls' and 'rdump' with paths relative to
> > current address do not work with a mysterious diagnostic (claiming that
> > the supplied name is not a directory). Use push_cur_and_set_type
> > instead.
> 
> IOWs, you're trying to fix this, correct?

Mostly correct, but with 'path /' in place of initial 'ls /' so that
current address is set to the root inode.

> # xfs_db /dev/sdf
> xfs_db> ls /
> /:
> 8          128                directory      0x0000002e   1 . (good)
> 10         128                directory      0x0000172e   2 .. (good)
> 314        50337826           directory      0x0a152956   5 PPTRS (good)
> xfs_db> ls ./PPTRS
> ./PPTRS: Not a directory
> 
> If so, then
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks.
Alexander
