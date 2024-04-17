Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1A13C68C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713331366; cv=none; b=THuFonZKXg3wUp/mrYMpQSPMocoaPx172O3hE4iIj3I7WsAKMAWbrjl4BBhwVgayWy+zG6SkVx7/DYiPm0kyuD5cTwPXNwzm0+J9mn/KvwFCdJmVxk9r+dOYcXLcR12S/WlU44NkuTQ//TryVg3CSMnpWcTgoi36nj2bZhLu27c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713331366; c=relaxed/simple;
	bh=Xmp+16IqvKpGb6pmUreDv3PHmO7l6IfuGLMlycG+tbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMX+lXPF65tvNcv07bHVNygCvkmlaNooKqINDGVYA4fccMT9/pcM0qzu3U7PLOsXDyMbIst+HugeJVn0YvZPFIgGUx7b5RWWczdCwk67+sjJVXHhq+oHsfJQy9ZqEL17n50kce1uqwCKGxHyjiBxmB4ZSTmyhwIpOXLNajAGTG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWL2hkdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWL2hkdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10889C072AA;
	Wed, 17 Apr 2024 05:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713331366;
	bh=Xmp+16IqvKpGb6pmUreDv3PHmO7l6IfuGLMlycG+tbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iWL2hkdzpHUAiLJ/UtRDQTSf+cuAV9cR0Hwex6q+NEb6xE5k7gRTLS+40JxW3WYYZ
	 Nh0sMMCgBavkdROxuSYl6saarQ/QUewcld0t2a4gPr6AQtbt46RJraZUhb+bacrspC
	 Z6pRXdDL9TLtGloRVkrzZKcJ6IwZLVoa2gOpka8WhUL0qUQxBggSRLKm7poDiZ2UXN
	 JNNr5eFw52x/voOcNiGKbriw57dpR879vj4tc6jyMJ/9opp/jV1kmXn7cmPkYybuEG
	 prqM7HUsppAfbIyD9F/xXxjvFtoW+6vk6tbF0qMnBSr8lb0FGN9OL5IAYDjeFloXoy
	 qRT3oq6tjb0fQ==
Date: Tue, 16 Apr 2024 22:22:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240417052245.GP11948@frogsfrogsfrogs>
References: <20240412173957.GB11948@frogsfrogsfrogs>
 <20240414051816.GA1323@lst.de>
 <20240415194036.GD11948@frogsfrogsfrogs>
 <20240416044716.GA23062@lst.de>
 <20240416165056.GO11948@frogsfrogsfrogs>
 <Zh6tNvXga6bGwOSg@infradead.org>
 <20240416185209.GZ11948@frogsfrogsfrogs>
 <Zh7LIMHXwuqVeCdG@infradead.org>
 <20240416190733.GC11948@frogsfrogsfrogs>
 <Zh7OENwAEADcrcvr@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh7OENwAEADcrcvr@infradead.org>

On Tue, Apr 16, 2024 at 12:14:24PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 16, 2024 at 12:07:33PM -0700, Darrick J. Wong wrote:
> > Ohhhh, does that happens outside of XFS then?  No wonder I couldn't find
> > what you were talking about.  Ok I'll go look some more.
> 
> Yes. get_name() in fs/exportfs/expfs.c.

Hmm.  Implementing a custom ->get_name for pptrs would work well for
child files with low hardlink counts.  Certainly there are probably a
lot more large directories than files that are hardlinked many many
times.  At what point does it become cheaper to scan the directory?

--D
