Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A43879B61
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 18:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709145462; cv=none; b=NE2kYomFsyNAY5YRyshXcfq+jbDxyXxECLaS05yjVgrUY9k/Gcy/1VSWcU0YayG0dMY5beL5pdOBU6TLSfcXtO8+i+6tDdRyEsl7KxvMVlyRCn+zg33L4OZVzse9cUPS/AAFBcPsGPdBXg5/SyZZv0adsCJ4cz49S3LO16fP3hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709145462; c=relaxed/simple;
	bh=tjYEafQ0zgEXIIelahd9YryH5x++QSOa4Ay8KtGREp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pazR8U23gGOI00ftiybUYaJfgP9VBJo9ZSSeY/kh6hHLPLBUxMN6lFNdn3hPwEbhZ2wCEu5dCcB2SJplBOBBNVyvVTQgy7BpHx8XUmiDXXr/KSBf3JOvcPnK7orhWAuhdUyQfY93Ad0fbf1OifcUj4OiA7ocCsYEjGBs0Bh9Ydo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Apw/99pX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Apw/99pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91E4C433F1;
	Wed, 28 Feb 2024 18:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709145461;
	bh=tjYEafQ0zgEXIIelahd9YryH5x++QSOa4Ay8KtGREp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Apw/99pXcPZ9bzSu+5ogT6jzhD5dxmNJLVo/P3VhSBHF157MHwq36Ii6OcatQXir8
	 GfRkxklC2BxbrOpMuX3KvAA/+T/F6Mxp2mcCySzsDsarwQcUYua/olAv7c7rMDgqxd
	 Zy4XjqDARu+xQbgOMKBwzGLeTczWyAX4i9e4GzEQ/lvxn3zWuYqTIHqE3S+6VhPP1T
	 RFqGmZ4mSDqAHd5NfmnZIUiz6acTglT5hBCJQ15+j18LVKHr641wL3+0GU1sd3JB9h
	 Xd+8cSJxIm44XHiQyoJVhlqa/23+8rz5yG+cYecbA0blCxH11DotuiGSD43zbNMTSY
	 SXkh97XRB/PCA==
Date: Wed, 28 Feb 2024 10:37:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <20240228183740.GO1927156@frogsfrogsfrogs>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
 <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
 <Zd9sqALoZMOvHm8P@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9sqALoZMOvHm8P@infradead.org>

On Wed, Feb 28, 2024 at 09:26:00AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 26, 2024 at 06:32:51PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If a symbolic link target looks bad, try to sift through the rubble to
> > find as much of the target buffer that we can, and stage a new target
> > (short or remote format as needed) in a temporary file and use the
> > atomic extent swapping mechanism to commit the results.
> 
> So this basically injects new link paths, which looks really dangerous
> to me, as it creates odd attack vectors.  I'd much prefer to not
> "repair" the path, but mark the link bad so that any access but unlike
> returns -EIO.

Ah, you're worried about a symlink foo -> bar getting corrupted and
being repaired into foo -> b, especially if there's actually a "b".

Going back to [1] from last year, I finally /did/ find a magic symlink
target that actually does trip EIO.  That solution is to set the buffer
contents to a string that is so long that it exceeds NAME_MAX.
Userspace can readlink this string, but it will never resolve anywhere
in the directory tree.

What if this unconditionally set the link target to DUMMY_TARGET instead
of salvaging partial targets?

--D

[1] https://lore.kernel.org/linux-xfs/20231213013644.GC361584@frogsfrogsfrogs/
