Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249EC493646;
	Mon, 24 Aug 2026 04:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787546841; cv=none; b=BO0bCRMxCCknU2ZyUPgYr7zSrqtCw/GnQlHhkJYIq6him0/eGX9yRgwKuFbFxpHpZrSloq76JsEMaWxFz6HN++9tIg/hgYoUnfMRUG0LP99DWD+XEoVrBFe4ZloTYOxBDrrg4j4Nj4pfj/z+ue7veNxikC5XDPViBCfcqc5zm5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787546841; c=relaxed/simple;
	bh=nr1FNp5q1npvUcSPF6pCwHOpaiRf5w1dL+8Wk3hQOLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUk3HAJKNiLQEZWtxxzvuq+AfRrQBR6pmLK9Vn/1kyR3zZNHxqPkLNRFRTcaVMW3OeWbzTY36B//w0h5D8EBTRZ7RQeyOKMMYD57J4AwKe2oUnXt1D6g9wxxEEMEwAOne2vUNa52XrjBSpZY8skyqMyXgr73tDHC+qv3tQvYx3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IUElEA6V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IUElEA6V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=42co/c57BS4N+byQNo8Ei/zqToLyAOVThp6dC+uxuU0=; b=IUElEA6VlExCp6gyt1KEcdoMDP
	ioDcqlz5bbXWGNBopseRQf9ddx82WE4wX2kLVtNhqJjZwQZ0lUyGc7XaqE/XcdNGKvOrI6mI85zht
	p+jKDIuEubpAefuVTXYijU98E8/jwgeran8V/jnPRp6794kM7rRtY8ywCGblYj+64AT3Oy9g2AqJz
	uBQlOpCziMFGQqO8dQm8xxvHAMwM0+IK08Uv/jT1AdNAQmz3hmzRYFzbnbiqYuhownQBaHjJmAjqQ
	CBq116nh56/o+xqUSRSfis2yg4JVtUXJf1Eq7qRa76YVo8leWS8u7Dsqplfy/3S4L6pstn01IXbK0
	zeNIYyEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyMaa-0000000Fuxb-2Kb0;
	Mon, 24 Aug 2026 04:47:16 +0000
Date: Sun, 23 Aug 2026 21:47:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: adjust datadev sector count to reflect internal
 rt volumes
Message-ID: <aovM1MZumYu3AsVB@infradead.org>
References: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
 <178659861593.833642.6889273918398598117.stgit@frogsfrogsfrogs>
 <aoVOIZqmmAI7FYlm@infradead.org>
 <20260819230839.GB6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819230839.GB6072@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 19, 2026 at 04:08:39PM -0700, Darrick J. Wong wrote:
> IOWS: 512M data volume, 3.1G internal rt section
> Now let's try some media verification:
> 
> # xfs_io -c 'verifymedia -d' -c 'verifymedia -r' /mnt
> verified 536870912/536870912 bytes at offset 0
> 512 MiB, 1 ops; 0.0496 sec (10.067 GiB/sec and 20.1345 ops/sec)
> verified 536870912/536870912 bytes at offset 0
> 512 MiB, 1 ops; 0.0409 sec (12.222 GiB/sec and 24.4439 ops/sec)
> 
> Notice how xfs_io says we only verified 512M of the rt volume?
> If you run btrace in the background you'll see that we read the first
> 512M of the volume (aka the data section) twice and never read anything
> from the rt section.
> 
> Ofc my solution does too /much/ work:

We should probably wire this up to xfstests..

