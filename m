Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD55643DA5B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773135033; cv=none; b=PPpcZBozaTbxjFSRF5lIeYxrvXyBletmBuH5E27iuTTKSN9OTpvzXVrSqKUVGMJhnwlsKVLePqz5lYVJC/4bmhpqsSrOGg77NE7GlWgYqaqnIpwbkOeo2VXQkGromu4Xymw2C8toOK1NOLSfpZ5YKZhVzy0x4urZ2II7IajjDWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773135033; c=relaxed/simple;
	bh=SDLh4dqmK2ulB7JuC+lXr4Zin4MX+a+1Sw6ZXdt7j3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p8hLCIPUn9ZvvlNxIyhgJXmWtODnjjYfFpCcKMDzvLCBTER0YRyxxS0vD/HL9xXJ+gUVkdnIjDcUJZECtBRpA0K2vwhm1sPUdghbUn+BO+ZnH4BkKkNfdqqMQ3opgbgZuaGD2EglCxtAJUT862MVhSuvf/4IQQ8DQrUdySc/7M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Cy1qn2Bl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cy1qn2Bl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V1TLSiQb+lXgbumL3ZhJSozUAYRYq9gTFUIZM5x6yg0=; b=Cy1qn2BlXgTv+cTdrPqRm/7PuK
	XeeIvHoz37xxad6UM28Ne2RWKtsjKZ8aAgIWrrHuwHng7h6tnmEy64uSTEhxXiX1BaXcgd5o1Gew4
	tol8Ufhn/64rtt+B1em1EaPRuG6v8sZhIlXavIjwKKvLhZj2tNdiGYAg7ufMNsqn4/d7yixApGwt/
	S3LxhdbyaAyFSKp+3Yfg3lAI8A5ghO78KEAVdJUrAeT9zo0XpyTUagZAW9wVVRd+3dbUxPT3iBD1v
	QiDdTbKCkfS0mHDLzWapFbVXzJhu1wWUADEsY39ey6K194U/qH4nKTiak3WdwAFDq6k7jHqEamrm/
	UJmOEHdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztQ8-000000095zg-1Gzg;
	Tue, 10 Mar 2026 09:30:32 +0000
Date: Tue, 10 Mar 2026 02:30:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/28] debian/control: listify the build dependencies
Message-ID: <aa_kuBxUoJjfQ0jc@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401948.1183235.9806339034108921343.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401948.1183235.9806339034108921343.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 09, 2026 at 08:49:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This will make it less gross to add more build deps later.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

