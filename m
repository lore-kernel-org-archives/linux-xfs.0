Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50051E87C
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 16:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716308652; cv=none; b=IFY6t26+jaRcFycht0Z+QqtXkmyzCDHBFbPe8KnRwpr9aVh548O7O4uNjpakqKmFX10IhflRcLMkuVKzCK3tCP3cqJ4efdJQHEujRCiQGkB/yiziIWG0XE4HJsQFJPBGRywr+0iuIQNdDDUTCHCuoKit4tbDgJGoAKjZzUziKec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716308652; c=relaxed/simple;
	bh=N45HVgmrFyXGgMFA0yqVV3USYjN+ZTz4nhNx8DsOrfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1Pqxo5yF+8E9JAZb4LPvkXda+6gGAd1YXKfM9pNQLYan5Pi+jlZxRAqLjlthQgXcatovj7dyhvq55ZCrcNQhY4QwiNNVbzm9UB4U4PX951O5g98cRo+OIOrPiVJiXGfc1R6OwGz0FHYIHd55EKRX4hV8+m4py6M3YEfMXoh/kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ohNucQ0Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ohNucQ0Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mI7Zddmx0KIJFfPBcrODk1IHD4H6I/0nE3fXal4NppA=; b=ohNucQ0Q6Hu2HcxO4BJ1duoxub
	9ZHxblBcuYsZ8B3BgD8dC5L89WEMinH8GqEUg/EOst4opWJnXHQgL7DsFtkOcvmIbpVs/ldzyuraI
	+kQ0zk3bn0lIeoA3H6/VHAniZHsngU8ft/ipXqZ4xj7J1WmKh9uEFCq1VqFcVmHN1hbMCqS/Pj/Mm
	OkOyLo3WsyPk0bhWCKjOeTziRXGYS1fvtYgavAkrqTF1rsmSLsI51d5KdLEyVcS4B+hrQtvoWEbZ9
	UfOJizEySHbnVyZxps6Eulnd+PnlW+i6sb4pUg1428PJ8K+9p80UGarXKqDDhvrsMr3VLphgRJBuD
	vjXjTGIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9SHa-00000000Uft-1xmo;
	Tue, 21 May 2024 16:24:10 +0000
Date: Tue, 21 May 2024 09:24:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't open-code u64_to_user_ptr
Message-ID: <ZkzKqqBK9LcS3UuR@infradead.org>
References: <20240521150222.GO25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521150222.GO25518@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 21, 2024 at 08:02:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't open-code what the kernel already provides.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I was actually looking for this in a few places and didn't find it
before suggesting the u64 as pointer API, but I couldn't find it.

