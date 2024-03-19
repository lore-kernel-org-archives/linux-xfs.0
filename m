Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D1C57874
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 23:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710890240; cv=none; b=StOHNc+QDVGKofWbYtqqjm5iC/cxyPnrLAYSLe/XnC7Y6Ttq0rgQAlLb42iqRK7c02W/IeF8DksjpZKUQCq8mYQFFw/OApPSxERLK90/oSCByhVGXuVo3i8RrIPFwFxXLTwGEX0k8ZJ15/tN4jRaW7rB7mNmO0mwbY5/fHfPv3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710890240; c=relaxed/simple;
	bh=0gF1aHBoJ7sfbKMIXG7bz8oFoxTFuZobhIU+TxZr0uM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knPi3DQj/52eQS/bAxAibyM7uNnSTkcuEkOnm0yMoVC6yjLwVEBQNbKrEntUa5/GruIU9W4IIVd+ewUF3Tv8q9Tv8FBt70+Pa2lI0TazkO3JHWrjyFD+JV6HgSzgALwu4V5V+EKlRNALX8aJEINjSaGMoji84i3NdTx7p9WIBuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXAR8QSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXAR8QSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BF4C433C7;
	Tue, 19 Mar 2024 23:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710890240;
	bh=0gF1aHBoJ7sfbKMIXG7bz8oFoxTFuZobhIU+TxZr0uM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BXAR8QSnPdrm7eZPKjhzWzII8di2cQ1037B+NArF53KB1I3GZ+MTTFOFrgHo5pAXR
	 tgdfZtQ6uTrm/kj0AkUhJyOwESv9cnWiyimRtPAFvcndX3llVyq+4YsPoUUUkz/5hd
	 B/AkeVy4VjfXVpml3hcK/t3utP55NBQzcT7b99UQudVs4xZvUCJpu9pwG6OHQAdmP9
	 kMyL4k9hjL8xN1vYtOWPO6aAa25DKhmLd+RNQKSgXZVUu+rje7NohosUw0+/M4BxAK
	 MmQ7Zg/nKpmp1nyuszlO20f3sQxsweL7gwnjtcn3UfOw8qJhV+rNzwUB94KLVlH4EP
	 +uWdQBKLSlmzg==
Date: Tue, 19 Mar 2024 16:17:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: internalise all remaining i_version support
Message-ID: <20240319231719.GT1927156@frogsfrogsfrogs>
References: <20240318225406.3378998-1-david@fromorbit.com>
 <20240318225406.3378998-3-david@fromorbit.com>
 <20240319175411.GW1927156@frogsfrogsfrogs>
 <ZfoadKGgatGjTM_5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfoadKGgatGjTM_5@infradead.org>

On Tue, Mar 19, 2024 at 04:06:28PM -0700, Christoph Hellwig wrote:
> Is there much of a good reason to do this now vs oing it whenverer
> we actually sort out i_version semantics?  It adds size to the inode
> and I don't see how the atomics actually cost us much.  The patch
> itself does looks good, though.

I /think/ it's safe because all the callers I found gated their
inode*inc_iversion calls on IS_I_VERSION(), but as di_changecount is now
a totally internal inode attribute, I don't think it should be out where
the VFS can mess with it.

--D
