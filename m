Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C743AD531;
	Mon,  7 Sep 2026 06:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762566; cv=none; b=ZU5zsJmEZqP6y6WbSH0QMRlCjCG2cO7uHO1oGM8GuZnrACB+kJWf5vXDs5Xe5TnQD1gxCmSebB8A6f1d+yHSmm8Rc2WGEnTu9isgxiglc8Uqb1iiAaJByIAb4TUU4yI/AM1c8BTiYTQE6M5USlxAesA1wmNvS/xMOo7I/pAVbJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762566; c=relaxed/simple;
	bh=ZJh6OV7uA6pWNNftr6CrNNevaRyx5ofzvKVW/gAVwHE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NjlUsufV9KKFMgnSjMgmnb3SCuwOctzJHgGwnk61pdlQrrqk4vtVDyGsK8pcxMYcM8b0miVmj2lZ1/mEtQnNehhu65Z/nBB7NDDbXwuRcgu+eNevOA34lh3aVFAhCErBQKUVKSd33tv8igvwy7XQ1Pise4kBF8sg3+pq4BqMQ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBQZxzIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBQZxzIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7961F00A3A;
	Mon,  7 Sep 2026 06:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762563;
	bh=VnwCTTIdHmXQ09a458CYtbe7/MLL5WUUEb3rsxqquxM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=jBQZxzIzOKrJwZUp6tVFGQgfhUmsrBaNQzldzewQ4VpAF+sAbyEnHc9ZOxRs5QbzZ
	 BuRwBN77S4khinlGNyVqC9FnMA6mUkBKnm/5Lb/Bl4I2jkWLmoTHejp5911OQjnZMp
	 SNLZTs7gKFEbN1SoyOfpeMDkDGzbxyjHVBZvQxCgEEhbPRm8ZdIOL/pV08Ud97Mxqb
	 r3FBYyieqeCzWiJ0gyECCSR/kVLCYrHNZOICGfoJZgTgF8KSGfjMdBSfBa313JEJnV
	 k8XYN2IbgIU0k7MN+L3yq24WFtIUUXaq8nER5PzlQpMnWV6MmWP1/oDEo6QuVNvcF3
	 AZpdepYJ4Caqg==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178832750794.3508131.17764052841526629326.stgit@frogsfrogsfrogs>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
 <178832750794.3508131.17764052841526629326.stgit@frogsfrogsfrogs>
Subject: Re: [PATCH 4/5] xfs: fix backwards skipping logic in
 xrep_quota_block
Message-Id: <178876256229.14422.18249767825353755664.b4-ty@kernel.org>
Date: Mon, 07 Sep 2026 08:29:22 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 01 Sep 2026 22:49:32 -0700, Darrick J. Wong wrote:
> LOLLM complains about the logic in xrep_quota_block that skips
> reinitializing the ondisk dquot if there aren't any problems that would
> impede a dqiterate walk later.  I got the type checking logic backwards,
> which is the source of the problem.  Fix that.
> 
> 

Applied to for-next, thanks!

[4/5] xfs: fix backwards skipping logic in xrep_quota_block
      commit: d7f97be48cbe3751e44a45373c0e91e93b976f98

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

