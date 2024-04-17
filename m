Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DE4147C89
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367115; cv=none; b=IuHBvvwEHzFgpFHl7BjRGrKXNCP4QwXmZJgANG+IUqKnc4W3/P0PBiJSeVs5dS6e4/IYIss0Ti2x0X4Olr0tamXQVB1k4T2E7JbAMXwUAyXf03IBu8fKHUHaFSTX8hfV3dGjnH4/8ap8LNCf/k746FsRzH8a7OoZGPMtFuX6OVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367115; c=relaxed/simple;
	bh=Lnk9LKLKcpd+4BW/nZNuMKoOxiRT0aHaj5x2VZGXuMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bTIM/R0roQ2IgDWuibhBaRH/U6v4EunabnRXR8RhW5TYG1IqikxTXzyTzNtUHYrrT1TV0AIakSSiR1P2wM+RuN5UokY+ghyoh4tW98AUYtiyobSB/1wNK2ufgmH2/4eNte9UdYhUnUognyp0eB02rqbLZdR/aE6uXpNppHBJcEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hd8678U9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hd8678U9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED86DC32782;
	Wed, 17 Apr 2024 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713367115;
	bh=Lnk9LKLKcpd+4BW/nZNuMKoOxiRT0aHaj5x2VZGXuMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hd8678U9vMIitUXK6/+M4G+GzJJ1ldSleWz6r9DBIM4/ODOou6KAVOq2dkNEJVFYU
	 Nq3gA7hPwsJSvcgcquSGmQ1AohnPHdOrtVMlea+Wt37VBi7E8NTU0spLKAED/JgKUw
	 gb0k/SViYdskIGlEGldOEvwQ//6EcLC+770J0pW9OKTYXboEeDAMJ2XEG+E0qCB0Pz
	 p5b7ZuL1yveSPWCp062FCt7qIIeWXHF8Yk5Etg2FZFt1qpZVstnZrombFgg4Fk2kVq
	 +D1+3S4NQooKSqcyQINmMUEXDsnuVVyiNMgP5ZIdpDcPzOhEUQqBj4REweiAz9bDmD
	 z3ZdI7AxZ2SeA==
Date: Wed, 17 Apr 2024 08:18:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs v6.7.0 released
Message-ID: <20240417151834.GR11948@frogsfrogsfrogs>
References: <fcm36zohx5vbvsd2houwjsmln4kc4grkazbgn6qlsjjglyozep@knvfxshr2bmy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcm36zohx5vbvsd2houwjsmln4kc4grkazbgn6qlsjjglyozep@knvfxshr2bmy>

On Wed, Apr 17, 2024 at 10:13:52AM +0200, Carlos Maiolino wrote:
> Hi folks,
> 
> The xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> Patches often get missed, so if your outstanding patches are properly reviewed
> on the list and not included in this update, please let me know.

Ah well, I was hoping to get
https://lore.kernel.org/linux-xfs/171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs/
and
https://lore.kernel.org/linux-xfs/20240326192448.GI6414@frogsfrogsfrogs/
in for 6.7.

--D

> 
> The for-next branch has also been updated to match the state of master.
> 
> The new head of the master branch is commit:
> 
> 09ba6420a1ee2ca4bfc763e498b4ee6be415b131
> 
> -- 
> Carlos
> 
