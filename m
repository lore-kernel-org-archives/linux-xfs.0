Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1591FA5F;
	Thu, 29 Feb 2024 19:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709235731; cv=none; b=qWDzLV0G9sDf5ngKo3vHldPzaANUbgzBOwR5GKDeJTUysnvA9g1TCpdhegWW9JL/G1VUt1ZPd+tmS9j0xabumxILtBw7orWAAcDrARlpZKs5CI0ZaL9gIScVRh9SGjpZ4ybtmCVlpsfo2SkOb0npKd18fs5Dbh4zGSp8tNdBf8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709235731; c=relaxed/simple;
	bh=81pbUP25KTPTJV/Xt4ztnDK7ffiY5mivEFdNzR9yiME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkgxHVe4HYeEB5pVJcA+dropcubXrnknNnIhSEFR/f3Y4Y3J30ZziZVDNxF7unO89JbOrjch/zj0aN8ttIMlw29F1tWLXzixcxbOEZ4QY7PjiQX42e3yaj6eHRm4u+pAlQih/CifEPNN4kqUqY9cNk3aM/KgvtgWU4iFS8Yi5gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mIuADXdW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mIuADXdW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0HQHJ2cjnC88WrSRtBJTCGPIAGa/sVI40Pca+KUbJnc=; b=mIuADXdWYg1RiKaLLBxutrVTtw
	Xi1IV1LNgOwWQGtDdEZ5z5FgUYJOz0mU5dRfvr9YLBZAAQYEiwnsEV65PLvea5xS2uEs6ALilhuFJ
	P4uEUTJh0cRXrQmS1IU5axwwVc2nahLoZa1EMHrvwGSlMyEh0dffXlUaCfZI7M4DrAVtamoDpjl9k
	UurCwffom2yt0l20xVynNXxCYiWgRo6NTcGIQDXNibwaAQO9uQjidAKYLMifxvfb5N+imB90Mtb8x
	GfPswDgzXB1KNQ9LVQyB36T+3PGNcsJjN6rOMZTT56d1mifa50mQGispXtbi0ZPCVwNoxdnCQbA2X
	WG3MKJMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfmIB-0000000Evn5-2EW1;
	Thu, 29 Feb 2024 19:42:07 +0000
Date: Thu, 29 Feb 2024 11:42:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo
 ondisk unions
Message-ID: <ZeDeD9v9m8C0PsvG@infradead.org>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
 <Zd33sVBc4GSA5y1I@infradead.org>
 <20240228012704.GU6188@frogsfrogsfrogs>
 <Zd9TsVxjRTXu8sa5@infradead.org>
 <20240229174831.GB1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229174831.GB1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 29, 2024 at 09:48:31AM -0800, Darrick J. Wong wrote:
> It turns out that xfs/122 also captures ioctl structure sizes, and those
> are /not/ captured by xfs_ondisk.h.  I think we should add those before
> we kill xfs/122.

Sure, I can look into that.

