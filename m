Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7807313BAD2
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 03:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712806109; cv=none; b=gvGBYESlPQvuIk0crUGc/j+EDCTvZxbMLeT7fnqAxt1wlVh8lGSeP6+VA/FBq+Th2iZ/oaLpUNjW9cRi7qP6o2IDKyH9Gi8cLW3rONUjV6hZcIS9UKTyZFR+j4ucPZiB0YeGOHZFq4kpUQc6i4w9W64ffOpg9a56sg9NkfaJ8Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712806109; c=relaxed/simple;
	bh=FRa2CpncCAsV5okbKi4Eo0DuqEwHQqhQtcWQYqjI3aE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYlWXIogCu9LwhIkzFXWQExW0nErMl/5M074u7KkZSR7DJeiF93v29n90ki7qtStJSiAe2ZdoOa+RgoWzY5tsZysp0LeUEnonV1GZkerEkEjs3ITDTLw8Ez+AqkPrEXC3e8oXV6z30v3Z1qAD+uyXFsk8WDEODUsJrBNmZgj16s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sghQRbAl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sghQRbAl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vTLUSxV/dmg/1dW+1dufmtai4TnzYlL/aXfviJVR1nA=; b=sghQRbAlDKtA/tOvF56IltZPkL
	UrzssvYOYMdi2vBrT3ptRIlZtJ4EV7fTG7VNq9TIkkbYkYatHZi81yxz4tEnjY29WisipBzTePRaf
	VrJskQOJbLZ+ErHI23lJtiUIHCfHnRFi6ApFEfJMTEy8sKJoktEaGnmIXRQqDe88/1C4sbcCSVdGN
	aCqqiJD7nnSjiZgU5WUUdx+z/bwzR6cMgHJRTWTa5nDaxLYvAUZN0FqbfAasqysgy/DIWlSn6PBej
	/JxWFwuMpwHh7IfyPB7+ioP66uHOHYMuj1PbVJgZqxEYwpNIq0it4ZjuJdnlXy41YZB4mA1qar3E2
	N7dMc0oA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rul6w-0000000A9i8-3GfO;
	Thu, 11 Apr 2024 03:28:26 +0000
Date: Wed, 10 Apr 2024 20:28:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, catherine.hoang@oracle.com,
	hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/32] xfs: allow xattr matching on name and value for
 local/sf attrs
Message-ID: <ZhdY2oszAa_SJjj_@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969674.3631889.16669894985199358307.stgit@frogsfrogsfrogs>
 <ZhYgylDdpjtxHdvY@infradead.org>
 <20240410211310.GD6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410211310.GD6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 02:13:10PM -0700, Darrick J. Wong wrote:
> How about:
> 
> "xfs: allow xattr matching on name and value for local/sf pptr attrs

How about: "match on the attr value as well for parent pointers"

for the subject?

The commit message body looks good to me.

