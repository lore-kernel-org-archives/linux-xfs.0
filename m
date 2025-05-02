Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34658288DA
	for <linux-xfs@vger.kernel.org>; Fri,  2 May 2025 07:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746169487; cv=none; b=CpN6Pl+VWg9Yv8BlErSL9O3alkGn+qv6GNg8r5zNj5anVvGILIR+T81G/x+kYMBlcu/Y12K39Sg/nQzGq8/xTB4uqUDvoiyYt0Ww7zXgTp3hqwGjwaNj6eLOjc58mszNJunPgoJzENmo3lyF60yL8MfllN5ox8dRfQFiHGAyQaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746169487; c=relaxed/simple;
	bh=++Crb43hyLXEdASEW41wxqa8g5tWbNkEnYgLUQF2wBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KaTQXlsiPxe5mS4VEQFTBI2kOIjGHYwzXTHwklOVY5AwT2k7ImbcNBTsmLc0PWVwz45htCkW/pQliyFI0Ea8FC2bWaD3z66bqRmrt4CHlhWRfJQKG1m/fllf7eGPZMumzlEm1N35Q+9H2O9OYkBNLsAHSvS3WgeJgosJik/Y6jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g6G5gVUY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g6G5gVUY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/ArDzszNO+9d3gwAPifiC2FLkIa1vFNmOQwTx+BQBRE=; b=g6G5gVUY/w7E+TpC19vBalrF7p
	LDQZkqplR1N9t5LE57Kq1HO+RzHiwSg4j+pUccOQXcaeUTy8E+rEsaf4s3ByJGU28lX4iZsXq4S4e
	BU+PMilxl97weAFtlhCgLz49jPsYNqVnPTw5+2BfGu5wUKrCwYvOaBxw/Z1uMBEgS7xkWtqtQ4DoN
	5rYDmJVjezFfxvc6wbWDFr8Ex4L0Ur2wNRTAPIUpLEfZMExA3GIP6QZMPcRZwuhMbbGV2mD93+ymD
	QSD7OZ2WhVd/QOvEsJZpuZmQqaJXAPwdkD8wIMf5UFkS4cpJb7RgCwVjsDxxBlB8RT6a6+pS3TKxL
	ojyvQOjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAkRx-000000013TN-3Fi3;
	Fri, 02 May 2025 07:04:45 +0000
Date: Fri, 2 May 2025 00:04:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	dimitri.ledkov@chainguard.dev, smoser@chainguard.dev,
	hch@infradead.org
Subject: Re: [PATCH v7 1/2] proto: add ability to populate a filesystem from
 a directory
Message-ID: <aBRujXLgmGn5Ywq7@infradead.org>
References: <20250426135535.1904972-1-luca.dimaio1@gmail.com>
 <20250426135535.1904972-2-luca.dimaio1@gmail.com>
 <20250428171606.GS25675@frogsfrogsfrogs>
 <47tgriadcj4a6zfrqhpzf3qgz3qfi5rzed4kofpobkrqkvhihn@4okusqlxnfxp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47tgriadcj4a6zfrqhpzf3qgz3qfi5rzed4kofpobkrqkvhihn@4okusqlxnfxp>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On the way back from meetings and long distance travel,
so just chiming in with a few points.

One is that the patch split still doesn't make sense to me.  Patch 1 adds
all the infrastructure which remains unused, and then patch 2 trivially
wires it up.  Please merge the two.

> > Urk, linear search.  Oh well, I guess we can switch to a hashtable if
> > we get complaints about issues.
> 
> Yea, if it's a problem I can implement an hashtable, from my local
> testing using larger source directories (1.3mln inodes, ~400k hardlinks)
> the difference was actually just a few seconds (given that most of the
> time is doing i/o)

Please add this to the commit log, it's always good to know about the
trade offs and the data supporting it when later looking at the commit
history.

