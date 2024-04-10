Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BD4181CE4
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 22:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712787554; cv=none; b=kUH5Kg4GLy3NMJVDICaWQsp22bDeftW4yZc5MPS/yWRlmhB4Ha7Iih4YZVhfoYr1wOFKXWPjVEtf1lsWehyBPXuUB3K5Z4qea7t9TmSQWLq+6yX4dN9jfkn1bgi6ykNJmfwrvGy6Y+tSx1f+HWtqC9QeBownHIRJIw4kYgVQIZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712787554; c=relaxed/simple;
	bh=5M2y3BnWXyTWWnWdN2PQGi5Q7tpMME06sSosRNUlX3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hJ/aQAIFt4NDkBhz1kWG7QAX2NeLNg8z7hU4B/RsDbEDnQpEylkWcQ6xBb0PClfeii7f5Iuqv5YqDL4TWT4SUaTQpwm0IACk7YndXCMXO9JVa0DgbTGjNdfHTKCbYhNtZ1KuecttXvdWV2tIdkEyT6xrTNhD7pmW7A0NznLYRi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7Xy2jnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7Xy2jnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B72C433C7;
	Wed, 10 Apr 2024 22:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712787553;
	bh=5M2y3BnWXyTWWnWdN2PQGi5Q7tpMME06sSosRNUlX3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o7Xy2jnK78WNVzch2RsgbsehkHT8zC4Lzvq8g1lb6Tt4jdrbmjeTOFNErKe7jt2rD
	 Xao7EMpbP9MKfRepp8WW6YQu8tvwTuAKah1f+opfz7OEVIe/uJbyCiHQVC7o5GOxpL
	 yJWLYUouMysV7wexhwSWngxXvkeic6sDq7OOLmsEgNlHCMv27YI5w+J4AaTtTLx6k4
	 U1j1VakQI+XuEMoJZVejWhnes+zLhfiecXQsqlBqUhD7Krbp36F3eg9R4RPBmZvfdD
	 NM4t5SINrb7cGKdQIU/bcN3Em1ZQOKDSTtfwiuITSDtw+/ucZZiu3Vlr/vct11s6AW
	 KSQur01O+rB1Q==
Date: Wed, 10 Apr 2024 15:19:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: reduce the rate of cond_resched calls inside
 scrub
Message-ID: <20240410221913.GM6390@frogsfrogsfrogs>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972034.3634974.9974180590154996582.stgit@frogsfrogsfrogs>
 <ZhaoZ3NefVUXXx0b@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhaoZ3NefVUXXx0b@infradead.org>

On Wed, Apr 10, 2024 at 07:55:35AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 06:08:38PM -0700, Darrick J. Wong wrote:
> > Surprisingly, this reduces scrub-only fstests runtime by about 2%.  I
> > used the bmapinflate xfs_db command to produce a billion-extent file and
> > this stupid gadget reduced the scrub runtime by about 4%.
> 
> I wish the scheduler maintainers would just finish sorting out the
> preemption models mess and kill cond_resched() and we wouldn't need this.

Yeah, I heard that might not happen or ... something.

> But until then:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
