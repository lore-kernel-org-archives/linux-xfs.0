Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89091E7C0B
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 10:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740998538; cv=none; b=SKMIUlh4C6Tt3kopDl9SNcV1CLquXjsRydM3BVTs11DroS5mXcL0Iv/daET8mT2TSTUPuFCjEdgtAM0hZ4NvZ0ScKz9EA4ur+s4KNooIwIkNppy4FxqetSkUHnUncLb6c6nqyq9082zRiDFao3Pi1ktNHkJDbBJy9NotQjsrpZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740998538; c=relaxed/simple;
	bh=rUeRqckwLhW+vkeYa42e4qyWru/JFPgfj4MIFET+PCU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EBMaJCQ2fTGzw5tQsquxVWxoIAJJ57TLbgDPpky6FONk2ciS6JFSDtiAwp5m35xVzgfRRhxEiMiY5sOWlyQQXZ+BREqd08JMxgVZWWgzEmIxEeV3h7TKprVI2zVpmqFcrxJ+6eV4Ezvp6mL9sB6N3SBEFUrdAV4CT3IHRs+YiAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EAV52D0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EAV52D0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F33EC4CED6;
	Mon,  3 Mar 2025 10:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740998538;
	bh=rUeRqckwLhW+vkeYa42e4qyWru/JFPgfj4MIFET+PCU=;
	h=Date:From:To:Cc:Subject:From;
	b=EAV52D0d/282pVetgI23w0L7lsVV2uNvZnkU6+wsGg7yfFzV0LQe66C4g91hxnnRq
	 k1CA9gIekkBRes6RL6oLxrXgmmfRNr2sEEemn3/II0b2JW/dSFnf2mLmwaMlUGFtSP
	 pCJomqAiSMkGm3IHrcA60IB9OKi95WQn6UMjifor6YRomxdMTtb5p9qu2keH9kxPuM
	 +aXiuZjLTDcqAUbLCpFsLh3fiW+U08jE5TCCTDXCeGokooBACPrLzZ8Y7VBQZVk7IK
	 lH26byTdoaWSPCYoXhYJMqf4yE0bJHwCLX7jEvki+WbH+2GVRLEmWZo5FZ0OHbCa36
	 aXAtY3O/O5t2A==
Date: Mon, 3 Mar 2025 11:42:12 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de, david@fromorbit.com, djwong@kernel.org, sandeen@redhat.com, 
	bfoster@redhat.com, aalbersh@kernel.org, axboe@kernel.dk
Subject: Changes to XFS patch integration process
Message-ID: <m6movx2b6yeygut6ow5hjkkfyyu32brsfzjcwydqge5gimz5z3@sw5hrcsah3ga>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Following recent events, I decided to improve (hopefully it will be an
imporvement), how XFS integration flows.

For a while, XFS integration follows a process where we stack patches on
for-next for a few days (in a good moment a couple weeks), and let them cook
there before sending them to Linus.

This works but has a big down side. Patches for the next merge window are
kept in my trees locally, and although I test them from time to time, they
only hit linux-next late in the cycle, also, it's hard for others to know what
is queued or not (and to develop work on top of that).

The main change I'm going to do, is in for-next branch.

Currently I push patches there only when I've selected which patches
I'm going to send to Linus on the next batch, whether it's a -RC or
the next merge window.

I'll change it, by pushing to for-next everything that has been reviewed
and smoke tested, whether it's for a -RC or next merge window. This will
enable xfs patches to stay in linux-next as much as possible before they
get sent to Linus.

The biggest change here is that for-next will likely need to be rebased
more often than today. But also patches will spend more time under testings
in linux-next and everybody will have a more updated tree to work on.

Also, I'm still thinking how to handle pull requests I receive. I try
hard to not change the commit hashes from the PRs, so I'm still not sure
how feasible it will be to keep the same hash ids from PRs giving more often
than not I'll need to rebase the next merge tree on the top of fixes for the
current -RC and in some cases, on top of other trees with dependencies.

I'm sending this information now as if you have any concern, please let me know.

By now, I'm creating a new branch named xfs-6.15-merge to aggregate everything
I already have for 6.15, and later this week I'll be merging it into for-next

Hopefully, for the majority of xfs tree users, this should be mostly transparent.
Only those who watch the development really close may notice differences.

Cheers,
Carlos
