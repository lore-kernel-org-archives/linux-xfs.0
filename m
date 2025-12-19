Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7340189906;
	Fri, 19 Dec 2025 05:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766121979; cv=none; b=a5jkT64RaJKghnhlfuNtE8GpRQu30iE8bMxBOKXVGQOpAW+WJQDXl7Qtg8BhjyA9le65VqbVrgRRkrKcVq4jdYHbiAKP7fV1ZYxl+N/IlgYyGLDYd+QfduvHkBCUlmLY3tcAQLWMppQ5kevjCnlnk1z9HFx2owKAPd4wGtZWw30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766121979; c=relaxed/simple;
	bh=sb08HbaJFT5pD8T19LSl8fRd530yorQEgFEInA+xv1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bp8e/ScTyTjQPaC1IBsRMU6qz4poDGEuatY9lGCg9oDOC5qoVfs4ILbjbRukPUoG7qDZbKtlQzE0kHkU0yqaorJqAt6P63p6WyCfDt0uQnp0v/o6EWAgSE6sQ5MsZpBHu7JijC1e/0dOjgk9i5f13DfuXCGaqevhlXlKmF0pIJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 860C9227A88; Fri, 19 Dec 2025 06:26:14 +0100 (CET)
Date: Fri, 19 Dec 2025 06:26:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a test that zoned file systems with rump
 RTG can't be mounted
Message-ID: <20251219052614.GA29760@lst.de>
References: <20251218161045.1652741-1-hch@lst.de> <20251218161045.1652741-2-hch@lst.de> <20251219021234.GB7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219021234.GB7725@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 18, 2025 at 06:12:34PM -0800, Darrick J. Wong wrote:
> In theory this should be in an else clause, but as extra lines in the
> golden output is enough to fail the test, this code flow is correct.

The else seems saner, I'll respin.

