Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9844F55C28
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538193; cv=none; b=M7J6A1vtO9pb26Dx3ovtvVoKHKNW3G2vi4L/LYaE5Obwq5GPtPViEHx7U2c1W8Y+ZDO3m+z9JjS59LkMsDCJJxr+/ZM8J5yEB8pTjb/FlqcpVajjnyyEqtSbuKZEyGdsXEQiDxd25NXEnestihJa8RiajlpmxKC9ZJ3xvw9dIgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538193; c=relaxed/simple;
	bh=C+aoSie+D9yP55dmxSjwLetvBzUoFbqAbcTfBI1Ol5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xbi7XyKp2Kr4KDe2joMMPZPDJkcpHDOTXjEDr0H3/r8Ou8vKlw88yZZLIynIaV42DolCo5GLv58gZDIkEUkhCvCeTZxw+3fSTtACW8tm66GJiDGsf5I0rfGVERYGd0ZIoUDdvKQeBO6a/20vOHK9nhyznxkDaOFkjlAnGSURR1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AZByI+Qd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AZByI+Qd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BqEimOBuaLmpq19tElT57Ukqc6dsY90MUs+MkS8Dh7Q=; b=AZByI+QdaOsLvVjS+UkIJ+mS8E
	MlSvcDx3bf7O5JKmUeIf2bIUrxzaVDb/Yw3lo7IrMuhUUEtx7cJWYqhkZNtJ+AN7MngaYlRkBbJek
	Zlz0iPUiqi10DsvgKsjMjlJ6ns9Q9L2eOsJQgz+I3Dh9C8UzKm01lff438sflkoKzYa728qoniN0k
	d/DVaJ+5yETA14blv7zXOktJ5Knb/+vycSoZU5QgIp503u+aN5oj/hZRICoYyJQJB24qF+DgMP7tZ
	OMYKNqx9aEbhZAgwYYkv5xTvYSVuxQS4dXsK7c903FsA+npW0s6Id2oTAlM2J+iBY4qIYrFkrm0Wg
	7ruYx1Qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpRGh-00000008ZlC-0hdy;
	Wed, 27 Mar 2024 11:16:31 +0000
Date: Wed, 27 Mar 2024 04:16:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: ask the dentry cache if it knows the parent of
 a directory
Message-ID: <ZgQADzOH_0UsGQcB@infradead.org>
References: <171150383515.3217994.11426825010369201405.stgit@frogsfrogsfrogs>
 <171150383612.3217994.12957852450843135792.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150383612.3217994.12957852450843135792.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 26, 2024 at 07:04:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's possible that the dentry cache can tell us the parent of a
> directory.  Therefore, when repairing directory dot dot entries, query
> the dcache as a last resort before scanning the entire filesystem.

The code looks fine, but how high is the chance that we actually have
a valid dcache entry for a file in a corrupted directory?

