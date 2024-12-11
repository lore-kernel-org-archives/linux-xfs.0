Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230531A841F
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 22:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733955756; cv=none; b=ejZdQIGh5PX7Z2svxfkGjlrTAqXV2KfVQJesVPsgw9JtGZvuWni9siZpOhdwnFM4J4nqCsecKKpmpL/rC+CohsPtqGVcENt/KjH+SHWMwrndpcU56JYBdsIYTegmlFSXk3FnklkZwcb7rubDrnhLprvDzLoxMR50pP4q1llM5G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733955756; c=relaxed/simple;
	bh=0knRzWEYZSJxgEgC8rSCIxEcVVnCpYZ8vITvE5GLmEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sN4Vewcuv3vj6w+JkNUGHDcix48f0JbkN60drZURKHddf0Qy1/W1gAOuzhvpLtIcUT/31JgUb9jvva9ISLP7pghwk5brggmXLaJ0rDr0bfRODBxdTMtil3zIcK+J3C0A3Ok3Ms98ajThtWz2l6H9oh4J0UYF5lQb6Txuy/dEIpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vrod3Rnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vrod3Rnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9183FC4CED2;
	Wed, 11 Dec 2024 22:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733955755;
	bh=0knRzWEYZSJxgEgC8rSCIxEcVVnCpYZ8vITvE5GLmEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vrod3Rnu6KqQLWX0G6HE/EHwoam7+5Z6zQnG8/9ZQq07RaEDjbHsYrPseEpQ1dk4F
	 v7u1zwoHN39EMJ2oWZHo4gHLHu7Mg5ZfiLl03eGfaCRw2sY07AxBF34roQkcJb2oY9
	 zZND+d+wOEjrkuiiRAN1V0L2CL5uKLfMPRwdscqqS6wvS8tb9PtmySz1Wk29vNimsN
	 u0ilD3jNzWuo08U6Vk4oxmU8cHdqPI+K2+DoaUVv6Eb0RSwDoc8baCGTZ0eEjytmS6
	 0yqjFW1WCrF8nR6ftvmh3ZojIscWlTjdKGZFSOoIFjyyC5Q1KbyWkVjf6d5DUAj9Jb
	 L/g4647RK2Mtw==
Date: Wed, 11 Dec 2024 14:22:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs_repair: support quota inodes in the metadata
 directory
Message-ID: <20241211222235.GA6678@frogsfrogsfrogs>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
 <173352753310.129683.8156547641009207395.stgit@frogsfrogsfrogs>
 <Z1fc9W4pd8lUIWEe@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fc9W4pd8lUIWEe@infradead.org>

On Mon, Dec 09, 2024 at 10:17:25PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2024 at 04:19:17PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Handle quota inodes on metadir filesystems.
> 
> Maybe write a slightly longer commit log to explain what this means?

I now have:

"xfs_repair: support quota inodes in the metadata directory

"Handle quota inodes on metadir filesystems.  This means that we have to
discover whatever quota inodes exist by looking in /quotas instead of
the superblock, and mend any broken metadir tree links might exist."

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for all your help getting the metadir/rtgroups userspace changes
reviewed!

--D
