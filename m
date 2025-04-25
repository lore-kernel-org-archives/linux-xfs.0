Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00F5215160
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 18:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745604100; cv=none; b=HubD+sjO+UQlIZdq0blom3k1hva028GwwdtRXgUEk2JUjJ4QG8ZS3nlyQLPFYVM1NfR/1ISKlXly73Qs3Vf+BPDxKBCgRuCDFroB1VRF3MdlOPBUGS5A9HfMjX7UbT69agVQfagPcBqqvnqBBHkMHi38ll4b8olkF5hCOyVNxW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745604100; c=relaxed/simple;
	bh=VebynHEvBi7tvSz4xwts4hNcbh1iAjMRJMYOYTuUXac=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ffVLSNuW07bqlC+nB12iUke3qFFr+jf4XydlOVN/0Kl4lIzdZ3aYjflGq1CmVtI2qd6zIc04EjwhhSE7sBoozNYSI89VmNOR2pU9S6seFcMOy4Mcc0UMALTud7QBd1j2LMUNrKdmAJtSQsmmwKjN7H72OnvuCNJ8DQ6O5oZB6TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjTT9PxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjTT9PxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8306CC4CEE9;
	Fri, 25 Apr 2025 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745604100;
	bh=VebynHEvBi7tvSz4xwts4hNcbh1iAjMRJMYOYTuUXac=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QjTT9PxC6VrAdhGOrh+SocsRIpAvkfK8ZC7PKFQmWryH8tZJIdzl1z00D0AMhSpKf
	 9efo4wHMYGngOYlYQYbrQ4SmSirIN01847PO1DKcpTvpXoUZMbzqV2Q961+NnOdSkv
	 ZajmfS4uafcCqJQGj7p7zytuu/HLtqtfHZSCYCDAWwbN5Z25tRkplr9VGj5KPqBtZ6
	 8ESRiitTEEHI3jcPQjUOCOPBjUxZDDNb/FBggnUdHEKqrXL626PzAcysvhI99FnABp
	 EDIaDpEF8Cpw1iCePQCSGwq1S8u3jnQBE7WLlj0jcN31C6xb+l8SdWQbfSbVOxSEX+
	 QvWee9m8Kv3CA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70DD6380CFD7;
	Fri, 25 Apr 2025 18:02:20 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for v6.15-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <gohn2hjkdz2mm4nwedb5lc7djyitnv2h3mna6s55hg2qeafjff@lmd6u77nii2v>
References: <gohn2hjkdz2mm4nwedb5lc7djyitnv2h3mna6s55hg2qeafjff@lmd6u77nii2v>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <gohn2hjkdz2mm4nwedb5lc7djyitnv2h3mna6s55hg2qeafjff@lmd6u77nii2v>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.15-rc4
X-PR-Tracked-Commit-Id: f0447f80aec83f1699d599c94618bb5c323963e6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b22a194c52b2c146d57b6c291e8a37329a8d08a1
Message-Id: <174560413907.3790119.9120095117584642571.pr-tracker-bot@kernel.org>
Date: Fri, 25 Apr 2025 18:02:19 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 25 Apr 2025 13:46:36 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.15-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b22a194c52b2c146d57b6c291e8a37329a8d08a1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
