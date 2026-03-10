Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCF543CEFB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134925; cv=none; b=DH+KDJtpiYkYyObM1eEIsPRLLg1gecm1sUBdOcOQ3WbLJn4ECG6QlXZbLZIabpo0C9u9l7mq8lvbEjOdG1YUfNq8EgLpwte+rpj/nuuDFCirFWeYjVuUH1Go7wNJTyA6Seqg3vo9AFGJNNhY61VhBDc1dc/ZzB03DL+IIML2jtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134925; c=relaxed/simple;
	bh=FA1kg+SWCngXG5s8byAMSwuqu0grJ22WutTbyUiRMHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fr7uYksiarKN6RdUPu+w1/mddu2+cvUbB19sgjSkCMLQm2PtYLbfjiMoMz+o5ZdrMvCPVHEyRvrVbHZ/gRskqv++YsTQsvvHwFmWRzANvvKSvlWPcMEPRCVZHuDIsgFKe7uuNPSyZNpboy8ke3n2ICmf9j9Javl0KszftQDIJk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dUwA/8F4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dUwA/8F4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tORaVsHCTsPZeZkMVc5pga4eVkqsP91DnQk2PoUe0dE=; b=dUwA/8F4SfhykkKiXMHXP3zPJX
	ZBxS+lYKbXxlYDZoKQfcHUj0DvRcMUuRD2gErxrddCXrfDx1uEi7rhHaLh2KyT/yfY4LGYnN4qODm
	41SaC8YZl5IPHWuw9XslF7KzOOf6qqrJrw6bvkFd2/2wtObK3l2fLQoYk9Y8IovndSD79sQpIqzT8
	J+KOlGYLG71dgu+C4RknwHoLX+o885DHu0yhPwTe1XeEqedb9ZiXxO6J/vM9mfsL9Ox8oaayeF98H
	GtPMVxFnE7ofPeer73Bd1VG74cEc18Daj690QoA2Z8HHvJzXRs94QiO/Xaz9ZrCNPnEuGcDucelF/
	059RnETw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztON-000000095Wt-1ydF;
	Tue, 10 Mar 2026 09:28:43 +0000
Date: Tue, 10 Mar 2026 02:28:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/28] xfs_healer: use statmount to find moved
 filesystems even faster
Message-ID: <aa_kSzpFeT7nuJeW@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401806.1183235.3840165745930552108.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401806.1183235.3840165745930552108.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> 
> However, this is really slow if there are a lot of filesystems because
> we end up wading through a lot of irrelevant information.  However,
> statmount() can help us here because as of Linux 7.0 we can open the
> passed-in path at startup, call statmount() on it to retrieve the
> mnt_id, and then call it again later with that same mnt_id to find the
> mountpoint.  Luckily xfs_healthmon didn't get merged until 7.0 so it's
> more or less guaranteed to be there if XFS_IOC_HEALTH_MONITOR succeeds.
> 
> Obviously if this doesn't work, we can fall back to the slow walk.

Can we kill the fallback and instead just have a good error message
if someone messes up their backports?

