Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59AD64A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709407; cv=none; b=HAUbVyM6fShEth6a830KSBFWygbDbWkEl2yIcXjJSub5Xjo7G/416QRh6RGBFnx06EwxR4DaeXijoVf9nknxD/Y220t8kg/3Gehx5maVFfA4ayUO2+9msv1JEoEUPBiSDkbq58kP0nXif94UaC5ofQbh+oeFsTV5gMb8CyJbA2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709407; c=relaxed/simple;
	bh=Bvk4VVEiAdolK+ePcxobr/ywoVnPKFfyOFzXMED7tww=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VwB7r3J2oVqTCZ5kA5w+1f/PN8swT1/Jqzs8QRc73LXpwSsC5QiwadCPHK1Vqab5GwaWzynI3OmeTv3f8g0VYFbkGvl2A2NoDm936gNWrYfkp86vBZHMG4iFz/ryJa5TpQyGFfvI3KRYf/ksgsMmmX7VuoFaGvyJWhEw6ojazKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TM94aPbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TM94aPbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F32AC43390;
	Wed, 10 Apr 2024 00:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712709407;
	bh=Bvk4VVEiAdolK+ePcxobr/ywoVnPKFfyOFzXMED7tww=;
	h=Date:From:To:Cc:Subject:From;
	b=TM94aPbfoK+pi6YJy8TyCxYyntYwqy2n1MaGfO0r7e8iG8a4b0jzYO7btPscOddwR
	 lE5ucShS8O+/P8+FQJwIQP8clXp3HkHcsmi1VrEeUyrhm7XeXlrDe5HsmLs7in0LSh
	 c7qoloG475e67t+ue4H9t2vbZHR4f4K/QdVCKuqZl13YThxY6DT4ahGmsNGUhpyKBa
	 jG2crzUXjO1w4GMeaP9YtwvxU5S5RuYoqblkHqvS1lxO/Xk7keUM4eSaV9wVkPZXN2
	 bbGICgK4qQx+qk++eIHTnZEyJ7gG5Jsoai+orm4EWxcUnxhKJbaiVUWmu9ovPZUKZw
	 lBk6VZ9JKpw5g==
Date: Tue, 9 Apr 2024 17:36:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCHBOMB v13.1] xfs: directory parent pointers
Message-ID: <20240410003646.GS6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Christoph and I have been working to get the directory parent pointers
patchset into shape for merging in the next kernel cycle.  This v13
release contains what I hope are the last ondisk format changes -- we've
gone back to parent pointers being xattrs attached to the child, wherein
the attr name is the dirent name, and the attr value is a handle to the
parent directory.

We've solved the pptr lookup uniqueness problem by forcing all
XFS_ATTR_PARENT attr lookups to be done on the name and value; avoided
namehash collisions on container farms by adjusting the hash function
slightly; and avoided the entire log incompat feature flag mess by
defining a permanent incompat feature for parent pointers and using
totally separate attr log item opcodes.

With that, I think this is finally ready to go.

Full versions are here:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

--D


