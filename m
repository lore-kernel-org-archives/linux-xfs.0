Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AC43E0C42;
	Tue, 19 May 2026 08:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179440; cv=none; b=mK97xfcdm2WCc9D4nNwR4PKn7w/XwslUj5EFH1mrZoPVjO833URFKeiJH+bFRDrII73T4IydSzBSOd+vy1J4pqxh+A91w/Y+EX3vK82pHZ6ZGds4+aOlH9CaB8v+0XY/YfgY6CzujI6xSqLhFKfnOZlTZ32sg+HQoVM9i7pLcoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179440; c=relaxed/simple;
	bh=ApfMHM/UeL/+5cxIDBJP3WVuBV4Z4eWGriekjkD05us=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CbWc6GVwyeGTUzuQk2+3T8ycck9Y2aRc87N4hb0PMx9Bd/YQmHrDhc0bj8m8lbrTBWio86zNMf6WD2UxYjo5jYthUm9UBBqxQ8sSNVkHmzPhwxmO6HSJqFKK0UfqnccKbfY4cjhDHco6MtJez3dqI9mpmN9YcA4NN7V/0x0Q0Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R9Ae0pmg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R9Ae0pmg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fTe1xNg1u9PkESThm+0+NqCmWFNcClHfzijFUUYSFxU=; b=R9Ae0pmgh7TT+1NqvvfXflX1HY
	9euT0DTIkXqU7qZHT1bGPgtmU+eNx7BiLKTL+V2QomgQXW3gliD1jvOoleZBgq0i43JEH/ISjxipN
	gW2tumyMP5KqKem00+7tsicuRlO6Q/+xXCA8/JhCekbyQtH99I2CsALdC8ANYXoCA2p8INk6gXNlo
	HjyHD23V7Pm50og1c4toUC3Ut/kkdNdMHiwlVcpmHDzcQWt69u9F/00Rv99i8RJBYDxGUAFkEefhv
	Wk6JZcnLM8ICRbdkB5VmKsBFnxuvc++NTVpz+OMV1/eVuGNtlZPMwiBUFIrjqhMkD//LDbNWQQEbL
	RTcAIqVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPFqX-00000000gLj-0bjt;
	Tue, 19 May 2026 08:30:37 +0000
Date: Tue, 19 May 2026 01:30:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Michael Bommarito <michael.bommarito@gmail.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: detect cycles in recovered unlinked inode lists
Message-ID: <agwfrZAchLLFX7c7@infradead.org>
References: <20260518013143.1532327-1-michael.bommarito@gmail.com>
 <20260519050235.GI9568@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519050235.GI9568@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 18, 2026 at 10:02:35PM -0700, Darrick J. Wong wrote:
> (Does xfs_repair fix the problem if the mount fails?)

More importantly, what are we trying to fix here?  What is the
motivation?  And how are we going to test this code, as right now
we trade a potential issue with a crafted malicious image (which isn't
our usual threat model) against adding new code run at mountime without
any test coverage.

