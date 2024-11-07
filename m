Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD0A19B5B1
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 23:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731021864; cv=none; b=t3VmJwenhZRSFyXsHPEV20j+L40acu1KFyWn/vCVC6r1esVSaCFeJmw9Cyf+UamASWPdN1BNWl1bjy8rv2zdUexuhH+WW4QBfFXGdjFYc+FQhR2JFIG/9REAvljct6O/PSAW0ATapc55CGa0q9nGqi13GIqIM1YtNKY/qhUtuI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731021864; c=relaxed/simple;
	bh=po+AVMlIUGakje2K2kxlRcxIsVXZZb+wVPkBN6dCO0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FRZvI5+Q5LNswnzqHYJA/3uu+2RpZmOSTD7EDhgA1o948070THAdEDEK55t8B8DwJnVZzCiByx3rWefwinGmXww/Nj8Bm6x7+vfBur8ibcdS1gGXkjWjJOC5qWfXxCBp7K1HEjb8sAFAglbU2AW6ho0OVuW15zjq2TwHQQBudBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D3Q01lY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D3Q01lY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7444AC4CECC;
	Thu,  7 Nov 2024 23:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731021864;
	bh=po+AVMlIUGakje2K2kxlRcxIsVXZZb+wVPkBN6dCO0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D3Q01lY22mtDIg7v1TTkkeIKOSzoU74RniRL2p4VKaTzmz9MQ0aRHtHIuAhzSNkA+
	 Ageq2GtUtHhmIcvun1v3cP0vIY4LRy2gQSYjDZN/puBTeFmogeCQNcLAMgf65iItv0
	 VCLlHDNPfigNfH3akSYdxjwsUqjvLcAhgtcDpiLGknad4WCHNDbDCLfoixHUNpxrKD
	 8U9Qz/tblQDG0BauT91GrOmp1RC16D32fFUw8jV14Tn1YnkBdGYfl+RCfO9QON18cn
	 67JgaSuADeOR2TKo2g216vJUugRAbajLMX0w8FfJ8IHurLHlp5spCgPaeRyqcNc1nA
	 KEZ/ZM8SlvWpQ==
Date: Thu, 7 Nov 2024 15:24:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCHBOMB 6.13 v5.6] xfs-docs: metadata directories and
 realtime groups
Message-ID: <20241107232423.GT2386201@frogsfrogsfrogs>
References: <20241107232131.GS2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107232131.GS2386201@frogsfrogsfrogs>

On Thu, Nov 07, 2024 at 03:21:31PM -0800, Darrick J. Wong wrote:
> Hi everyone,
> 
> Here's a minor revision to yesterday's metadir/rtgroups ondisk format
> documentation updates to move the superblock docs to a separate file,
> and to remove a few feature flag bits that were removed before the final
> release.  The last bits of online fsck haven't changed, so I've left
> them out for brevity.
> 
> Nobody likes asciidoc, so if you want an easy to read version of the
> ondisk documentation, try either:
> http://djwong.org/docs/xfs_filesystem_structure.pdf
> http://djwong.org/docs/xfs_filesystem_structure.html
> 
> Please have a look at the git tree links for code changes:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-groups_2024-11-07

Forgot to mention that these are the unreviewed patches:

[PATCHSET v5.6 1/2] xfs-documentation: document metadata directories
  [PATCH 1/3] design: move superblock documentation to a separate file
  [PATCH 2/3] design: document the actual ondisk superblock
[PATCHSET v5.6 2/2] xfs-documentation: shard the realtime section
  [PATCH 2/4] design: document realtime groups

--D
