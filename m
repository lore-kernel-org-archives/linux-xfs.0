Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F764A02
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 00:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732147627; cv=none; b=AflUFanqBtYo0TLyL1LUCBiWQbr9jA3cRXbGCCOn3nH0CYoCMJOA40LtjlTykpDKLLj4N9bLDSJETIqjk7Ijc5vuDlfyAi9Do+h4D2lHSvrHA9tSXKCZkk2+iVrF8ixPk2RA7TuALyBxXvZvsrKXhEtRojppNjajT0Q+3JcpwTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732147627; c=relaxed/simple;
	bh=hvCRxZLWsrg0EHwB4StcBNuG58f9d9qaeEBBYjlUq+k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YwFJLnIZAzdqCROvjfAV/SAfPS7znvZHg3eBUuxN3D+cLJDdDm8XSTpkzMBev/x3Eot/HRDOwCt22nnhb6j2/vMUt+5ja/TFa7BEGswZO/u5VH9JrOwB6nrvS7NNnq9MP9Fx4Q13G/but+axh8A38JVf2OwM/4IsLWGp4zeXu18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDp2eo4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDp2eo4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA9BC4CECD;
	Thu, 21 Nov 2024 00:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732147625;
	bh=hvCRxZLWsrg0EHwB4StcBNuG58f9d9qaeEBBYjlUq+k=;
	h=Date:From:To:Cc:Subject:From;
	b=eDp2eo4I2lvv43mlT9246dycz7U7QTl7tNx5qa944w7OeVwtVBXhJA6kMQqz+jRiq
	 hfvQTyxYkC7Vre+D0uby/iBrrCn2/trHZpebDP0dLJ2uMz/ip5zdSGB20sR42ZZP12
	 5tOUtHQ8XJOPF9+fXWcekMuufEJhw/zd/vliw9BMEAKHYgFth72rdZl0t5Os38G+PE
	 FPgRQVY9mHFpWd1ZSJlXi5UMoTNTh/vA7/H+8ylqVn1GZc8cdxGKStxSKqFsjM+OPS
	 krP8im1PbRs0bz/ZJIgxOni/WyQQhBsKHPbjYcc6StAr0Z42iiyx1ew9rbuJCH0cUV
	 YrULMSst7+SpQ==
Date: Wed, 20 Nov 2024 16:07:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB v4] xfsprogs: (more) everything I have for 6.12
Message-ID: <20241121000705.GE9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey,

My newest xfs_repair fixes for xfsprogs 6.12 have completed review, and
there was a late libxfs change that Carlos merged.  I'm about to send
you pull requests for all of those branches.  However, I'm first
resending all those patches to the list so that they are archived in
their final form.

With these patches pulled, I'm done with 6.12.  On to 6.13!

(You might have already pulled these three patches, in which case
disregard them and the pull requests.)

--D
