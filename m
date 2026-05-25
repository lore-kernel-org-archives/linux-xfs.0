Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40133BFE50;
	Mon, 25 May 2026 07:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779693113; cv=none; b=dp55kBJfnKAeO7cRqFaYA7WE+qc3w+mc3BZlJWVh1h4k6H4xg1fRp/Tgn4sDSmVSaI+bBG/lNPfA7NV/uRlooirlPSF/AYLL5Fpwb8QtOeF+uTTU5mejwrUM+HnvH4Hzw+TXstcqeeOD6EgpaF1enrwYkNM8siGFg07fuf2GaIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779693113; c=relaxed/simple;
	bh=FouUt+dGBKmvdfU7CrVUd7euP+mnCDRi7EIxc8h4a3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQNvMgCLSxN5DjTE2jQ75pq1gK3kCiJRCWNAuQCdu27WGZfFGElOdhTmmHUhZxw2OEj0drCDnMjHiMGYDLAIZnzKCXDT+9ycQy9rD8aLAbT6D0gTraHug0ewOxjRPww3a4A+UFyUfIabKAz0gwjARYJpEwrn1bqY30tcu1JjKOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1A9EkQLr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1A9EkQLr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xqcxhYP71Y45aA5yA9zJWnZB6u8t86CEsBFptEY8fj0=; b=1A9EkQLrKBcFUFwj6aS6K6lXCJ
	ASmNZPmU+odZG3FRd6nhizJsMn238rFOAmrMbyf6mh/Zd7gVSeIrbyChFhXyTGI+ljzOG1XhfnnE+
	bqgfAztY/aWKqN/VYg8zggDZtoLbjAyK1fpTU5k8toSkjDaasnhmyKrDvBdtP0jbgLJsdHNQ3NWUG
	KYZ0Yenu2dOFGi2LI8GOdhijZCjLuDa9N8c9aCPlf/jvwKlX8O4AUunr3xL6tbDeDsLnUa9qthr9G
	cyxpnxPXKUlFM8ZQ6VorUqmo/I1fOy8MskuKMcVTq26JZTM6zL86ZXYFl/jx/b9tP99f7BEAPm33M
	dbEmNyGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPTc-0000000GVCw-0Mn5;
	Mon, 25 May 2026 07:11:52 +0000
Date: Mon, 25 May 2026 00:11:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, amir73il@gmail.com,
	zlang@redhat.com, hch@infradead.org
Subject: Re: [PATCH v5 04/10] fstests: verify fanotify isolation on cloned
 filesystems
Message-ID: <ahP2OOXmwsM87j9D@infradead.org>
References: <cover.1779367627.git.asj@kernel.org>
 <bfc0c92a33bf5a129dad4c3e4c76973e7a6cec74.1779367627.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfc0c92a33bf5a129dad4c3e4c76973e7a6cec74.1779367627.git.asj@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"

Same comment about adding new common bits outside of test cases applies,
but why use both inotify and fsnotify?

> +[[ "$fsid1" == "$fsid2" ]] && \
> +	_notrun "Require clone filesystem with unique f_fsid"

Please add a comment why this happens.  I also have to say I find
the if syntax easier to follow then && with a line continuation.

