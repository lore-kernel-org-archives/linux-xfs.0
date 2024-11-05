Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115E33D0D5;
	Tue,  5 Nov 2024 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730818948; cv=none; b=KXct+66D0W2WxE/WN0trKwx8WS5HXgpvXOIwhKoPWs5PjbCtqoQ8y7csJGcGetNTf2eYmAdQWiCot6VJmFKq2UtzT4hxbg5aQ1WU+894w7fZX7Jth5jZIg/gdK4IM7AV6kE/CGYKoU09Spizn+Eps762tKwIsorCojc/J+h0R9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730818948; c=relaxed/simple;
	bh=L0nfVfGTE3mOqlvfbvTAtkD1AJYX8MmlSVG+JFRnCQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4CW3DmXwZGXMcgwSOpVO/0GXEMvvie89deH1ZLdZxhNJc4P7+U6kxE5NqGcOggZvzUhM+GjQGMv08bRkBHnghbXgN6EBzd6JdElerv6ch9VjL/pfc6xnmNgS/KSDwfJi/HsDf3WFaGnKU/e7UlEwY71GcnOgNC7yYWZvcW1OXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p1U5oevs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p1U5oevs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NabW07OsHEM42k/fPqlC49deTcf5c8zuYrG9gNSTmkY=; b=p1U5oevs6Hi6Du//iOH1zhsfLb
	psqvdNcOcu6YsUPGe4fh/AC6IxNv+iFd67oPJDRNnVDmIFtfB8uqr4oS7owou0ZkWRivkwgjanriL
	jgZrmQXsTJX4RxDu308kZZ1YiaK4dTLmYwhDilMCImOf59XF+YCDXBZLmG+039Y0lw3UHYknOjUzd
	or9TzNra/P/ZUmruQm74E2tJAFtHQYE1bFL3QKrWdsjqmoR16QCuwjcdSGYiucwYhiTqYEAzfoQbH
	e48j2e2Q+aHHalD+9b3ItQrCzQ/OiPePGcgbYmjMq6jCsvlIwNwldnKEzRjy2YPz4i3x4yehHHnca
	rIh5u6Cg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t8L4c-0000000HMl9-1113;
	Tue, 05 Nov 2024 15:02:26 +0000
Date: Tue, 5 Nov 2024 07:02:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Zorro Lang <zlang@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <Zyozgri3aa5DoAEN@infradead.org>
References: <20241031193552.1171855-1-zlang@kernel.org>
 <20241031220821.GA2386201@frogsfrogsfrogs>
 <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241101214926.GW2578692@frogsfrogsfrogs>
 <Zyh8yP-FJUHKt2fK@infradead.org>
 <20241104130437.mutcy5mqzcqrbqf2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241104233426.GW21840@frogsfrogsfrogs>
 <ZynB+0hF1Bo6p0Df@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZynB+0hF1Bo6p0Df@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 05, 2024 at 05:58:03PM +1100, Dave Chinner wrote:
> When the two conflict, _scratch_mkfs drops the global MKFS_OPTIONS
> and uses only the local parameters so the filesystem is set up with
> the configuration the test expects.
> 
> In this case, MKFS_OPTIONS="-m rmapbt=1" which conflicts with the
> local RTDEV/USE_EXTERNAL test setup. Because the test icurrently
> overloads the global MKFS_OPTIONS with local test options, the local
> test parameters are dropped along with the global paramters when
> there is a conflict. Hence the mkfs_scratch call fails to set the
> filesystem up the way the test expects.

But the rmapbt can be default on, in which case it does not get
removed.  And then without the _sized we'll run into the problem that
Hans' patches fixed once again.

