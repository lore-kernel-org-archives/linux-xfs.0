Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B389194C8F
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 23:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722383464; cv=none; b=nE9kcPOWi3/Rh80VQ1EJfQzxjXq7FBnZtiPeSeexg7TzKJjsZ2F0fMA5nJp4EIAFLFEHp6PfK4IPW8u/AphqT+8iaKlp/wii9AdpkIiBxMRuL/ZqtqPUerWKt6nLfTCvJZokrH37PsMUHVSFAX+R46wlDYh3+i2XEE9E2bUJTnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722383464; c=relaxed/simple;
	bh=8oCkfyUAQOKz2zlqpcqjy8HS3+za5kiIZreYkP5yO2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XVTIViEbL4StYjcamksj5Uf0KYuLBUY/Kdx0PH50so3/5sblXwZA//xAO8zNrWoCsRaFXdU1fhRvKOzYKs6kNTYLq8M12OW0ujCjvsLEnj39wgiw9P0d+ZwmwFn0D/7Klxae82G3q09NgAuJCF7oytfK96+fh3R8Ca3+0LYWOJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gOXbC2Tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gOXbC2Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47B8C4AF09;
	Tue, 30 Jul 2024 23:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722383463;
	bh=8oCkfyUAQOKz2zlqpcqjy8HS3+za5kiIZreYkP5yO2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gOXbC2TkaM9ycVNCi8jgsCwSeWGm+cHBjmMyhplHpHgSDBo4CBaNKomWQSR/pKFfA
	 FkDGUnu53GkIiYyceq8xIlMPrNXRVVkFl2M2IMsKaTlEBRKcAUbzrZhtjk3tYSQTQD
	 wFnR/S5PiUWrKiuQNdFO71aoHNbS8IfS5W2U08kMJhW4Z7sXbcgriHyAL+XRmMHte4
	 iPBACBr6mkF4wNVA6LKlueDa+YjPhXEV39yJ/vKp//XuICCLbfXCnBXDqFRmDaVKWG
	 oqqBhfNjJrNNDq5cOHrjxNW1ORukFghhYvVO2byEq6CsIr6s8NDDrvJNyPbvMp0nLz
	 3DWhwSebVc3yw==
Date: Tue, 30 Jul 2024 16:51:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libfrog: define a self_healing filesystem property
Message-ID: <20240730235103.GM6352@frogsfrogsfrogs>
References: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
 <172230941003.1544039.14396399914334113330.stgit@frogsfrogsfrogs>
 <ZqlhopUMJNAyxuSw@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqlhopUMJNAyxuSw@infradead.org>

On Tue, Jul 30, 2024 at 02:56:50PM -0700, Christoph Hellwig wrote:
> self-healing sounds a little imposterous :)

Do you have a better suggestion?

"auto_fsck"?

"auto_unf***"? ;)

"background_fsck"?

"background_scrub"?

"patrol_scrub"? <ugh>

> The code itself looks fine though.

--D
