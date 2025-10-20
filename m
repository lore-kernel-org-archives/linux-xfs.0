Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A892D9496;
	Mon, 20 Oct 2025 06:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760943560; cv=none; b=SGhRVs3IRcV66+AWdu3lnP/ixGsgKd+sWJheDID/TjrIDHO9UtdW8DM+3kEtqMIcf38Be4bpGH/FbkgOhXTLNGxrbyqVWhuBpLi93x5S2D8UcSNUoM8NvA5Fgsx2sMTfH4aDhFLneUPhGy53vNp6IEIQSc11L0+/XLiujnKUhSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760943560; c=relaxed/simple;
	bh=mlSmk1Nig1XHSdkdzecDyoAVZRWzvRPj9t4S9trrpKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5aG4wvvsPnQ8rQ3SZY62VBUQR+nfLh+uX5nsHPVsPGngo+xRtrc7UFnMZhv5jeRpfXfHhrWrMXWQ1WdzLGGTOk2pUE0XV8q6LLsWu5dLO2iR2OfGw8snZ0AK9EOsVJyvGAXr13U0vhCq0Be8rBZWjwS3W/nAo0Hk1O/q+Lq5tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ACYIby9f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ACYIby9f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Rgw2PN4C1rbPI+8qcTJYKFjyZx8rovQXrmqmxG3cE1A=; b=ACYIby9fP00NPnPp8j/cYZAqoH
	d05EWuAEZuUa/mNht5BRCj4pZCNt+F4maE824zfnNo3gs7DCTbJrRcjRVdwuDmMeg1ch42WXkvP/a
	GdNXhl/iiviIYWgYfBWAAW9z6L33H42MxlALxJTcqSbWbAieJvA8/QTD0ZMp9i3s6sO8Zk4Te2Jkg
	sZo4hAA3+9FLQGetBoa/tjj+KUBEhOYguZqA6ku7LXNB7HRP4jaotL1Fp7BC5ysc7ksXojqdlroaS
	RRIB67tLK1E4RR+lORgAf6rzvRZ65fDD0a6LmdWy00vTgkCZtuzxjU0t4+9/jjbmrs27eJSl+Nf79
	Y4w/BNWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAjrS-0000000C7fe-0TGU;
	Mon, 20 Oct 2025 06:59:18 +0000
Date: Sun, 19 Oct 2025 23:59:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] generic/{482,757}: skip test if there are no FUA
 writes
Message-ID: <aPXdxkOGe453zAc6@infradead.org>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617970.2391029.13902894502531643815.stgit@frogsfrogsfrogs>
 <aPHEmXmseASGsj9h@infradead.org>
 <20251017162426.GE6178@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017162426.GE6178@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 17, 2025 at 09:24:26AM -0700, Darrick J. Wong wrote:
> > The only reason I'm asking is because if we did this for every write
> > we'd kinda defeat the purpose of the test.  But we're only doing it
> > to see if any FUA writes exists as far as I can tell, so we should
> > be ok.  But it might be worth changing the messages.
> 
> "could not locate any FUA write" ?

Sounds good.

