Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BDC47DFB2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2026 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786032150; cv=none; b=TTj89A/mRvFW/EywrZ0EjeV3koBGWa6ee6gC9hh0h3T7AUjZL79xMTuHNyxwsuLUOnVCv8IWaGJU0vKBB607d2aymb6p8/8fAP5fsqyOLn6NlFN/T/+lgMfTgT70RP41urcnsWPVUse5c8j7VLxKwqMOcpjRSp9Db4B64/L3TKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786032150; c=relaxed/simple;
	bh=476WVO5m9prWF7oXYCy93neYBlIPeUEtpsgqZ3ZaTyA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Qn5ThaCXAHHkKlydNT0pr2wTh28s+7UKaKiqlWdN78rruiiNt99SEK9vS08Zips1vadVo7whCuJIil+dMOckgQv5h9YdbnRz2rO3Qg9R+Z+hwzq3QdaPY28jTYp+1iH7N4IlPvvQtMC7rEaKEySnvK9lqKjNiFQuSYH/3gvnTMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLI7AqXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLI7AqXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C961A1F000E9;
	Thu,  6 Aug 2026 16:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786032149;
	bh=WgxU8V8iydce0hSsBpTs13ggaxyxBiHo59xcMQvVyUQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ZLI7AqXJRKfC6UH3Y/pgglsRqGdKCvvKNiOnFL/zRt7djETMNbO4d9yaRIHsF9qKA
	 zQiUzOcuU5VLtwKLcvhrgLbM2JGe3+KyVUzRCyM66mNp6f/Fjngry0+ebv5Ae+/LEp
	 g0vKJgE/uuF88/FeXV9+7SCJ6DO53NXclgyWaRy/gWE7znWWkFhr4dXbz1JjRKpO/+
	 OAg/9hkbLVDWSTFysIb8poFJ05YgQLeuw3BFuGNhsd5IbSwwtAI0Wu0Kao2oqHIycH
	 IL8MwSh9Y8j9mhJSjCKNKsUuzz0+J8QuRb9TRXUiHQZGGGSgnKjN6Kz71TlTHTAB6c
	 gSseoUOmdJ8nw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56876380820D;
	Thu,  6 Aug 2026 16:01:50 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.2-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <anRAZ3k7id6zqYh-@andromeda.toxiclabs.cc>
References: <anRAZ3k7id6zqYh-@andromeda.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <anRAZ3k7id6zqYh-@andromeda.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.2-rc7
X-PR-Tracked-Commit-Id: eb6b2cc1fc8ad566d746d128a559989ff0bba5cc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ad7d48f1fb6599a51fcf51472439a555e6b802be
Message-Id: <178603210903.1354700.15263236889332345377.pr-tracker-bot@kernel.org>
Date: Thu, 06 Aug 2026 16:01:49 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 6 Aug 2026 11:18:11 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.2-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ad7d48f1fb6599a51fcf51472439a555e6b802be

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
