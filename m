Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4AB17A2EA;
	Tue,  3 Jun 2025 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748961455; cv=none; b=YRCZ3MJsJG2vCBmoX5tf+oRmvS0UDNvIu4LbF4f8tUqPZ5PBN76VDQlwdQppccXpE8wyQk64q58uf6YTikSEaXb3VyjBc9MY27WIgkGQnAoGvgcbSZj5/PRi59Oydoz2IqDZuE4qwjVzyu1TK0CdMT3CxiYiBlHfuUDkVv9mWrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748961455; c=relaxed/simple;
	bh=v8MgY81h2h7TGYoVziq9R2YMILyRwiO5R/sKAx0wCyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iAnYif4ZtKCw5bG51u9s6VAWihpIQ54j2A1/oc4kIV8gc2OvwvjmwVGaiOuskvjJR1EB4Sm1G+WKDfcFGR0x2GPPgsFZwE//AboUNzbdRVXUW0gjJgAXSsHmWtvJqWyTtV3yW/4R9b2pQ93+3w7ADhedCIh/WJC8mJFC8+yLPJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KS48uB0b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KS48uB0b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XuCOR5Lsm15jbCe9fEPIonwTYuMHWUX7MLgVGfxwyPU=; b=KS48uB0blJB6a+WE43grQ7azoH
	qwiZTfGAYsjhpqvAYpl1uOQFyJUwZnz4x2+meoN16bECxoDSypcR4+FjcQTU6BpW4HUKLbEpUITVQ
	KvtU3TFiCvVZO8x8XtsiaOKINUsPPkNhmK+FYyP29hjWfmlJVZxbcZBFRtPTiMVRa1SQ2kPhX5/Bo
	7ecsbZaWmWto9tUuPioyfb9JwVIF3ksimmpPTWVcpIlMNl9TNa2lH/4zt5dG+6TVj8zNOZmwfqNDI
	xD5YpvqRoUpiuTRazyaljsH/y/TWF1eTqiPVmcS1fQ2ystgF+QCA0C6zmsIGhxc/QEgAZd2VaVVPZ
	Jq4jRThw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uMSlh-0000000BAu2-1W9y;
	Tue, 03 Jun 2025 14:37:33 +0000
Date: Tue, 3 Jun 2025 07:37:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/259: try to force loop device block size
Message-ID: <aD8IrUJGhuJUSaIi@infradead.org>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
 <174786719445.1398726.2165923649877733743.stgit@frogsfrogsfrogs>
 <aDAFRGWYESUaILZ6@infradead.org>
 <20250528222226.GB8303@frogsfrogsfrogs>
 <aD0xdHHKmfLmAOXb@infradead.org>
 <20250603143634.GG8303@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603143634.GG8303@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 03, 2025 at 07:36:34AM -0700, Darrick J. Wong wrote:
> I guess we could just modify _create_loop_device to set directio from
> creation and fall back to pagecache io if need be, instead of the weird
> "create it then try to change the mode" dance that we do now.  Does that
> sound better?

That's much better.
