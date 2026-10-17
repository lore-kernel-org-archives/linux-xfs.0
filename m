Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC4B387585;
	Sat, 17 Oct 2026 06:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792220318; cv=none; b=W4V+YxEmk0J3TuHyG64ufQ+V676IhfoSLjhTf++rvHXO1KGnLON1kSkfUSfTt1P4aCOk2NTg1524V295vWCtbuQLgBFhj2bythCFHwBDii+ucx2T38OvX8zmzh243mqN4bYfE+eeLJVJjDZQqjBvHh/McYIyh16yg4NmrSAkVJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792220318; c=relaxed/simple;
	bh=nNrxdpC1RYE46gNjJClSxUXx92PhQ8w/FYFLd3ZBIz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJOANjAMXq9IVZb4+QiuftcYGj4I5+6qPvogNemPOld721woJZqSEADuZlRj1ixgG4vy6vhZfnoXhJ5Xe+d1VyxNlm2c0csCYM1aQBLN1u6KqkutYHLbbyUP2ciFOlLRQVRvE2DLbdmUp360f/MLzkrI1sRB9N11SS6oivLHM04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtWHYp6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtWHYp6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEC71F000C4;
	Sat, 17 Oct 2026 06:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792220317;
	bh=TTHPpIXRu4Ckk1sfPjs1uyCtE3BkU0tetlLETfkTw7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VtWHYp6hp4ReH531epjxStz+U+G9QU+IV9qwuWDOGUXENR5Rz98aZEcFrBub/ewlj
	 AzOT0HwlZaT29nDiRxekEOj2HyGyQtDZTYoFhSKauAPTgM0ifLhPUKnIbJlvQdpy76
	 UuQetkyvMuZie5HDBDfbwg6rA978qmLm+DI5DNUBrFjEsM0c7wfHBFaeEnOQVLDE7O
	 Xrbs7qHj9L6bnaALtMCWtg706eRBTOgp+uRKg943VfXk6nCsdfg6eQGhZa/V1W3dVo
	 n6myNfFgsIdR+aHch4fe7icrY598xq0dKhZjwUes+xAOOINApbVjEOU/1q4pvD1Cew
	 FG1yJobXa9Vjw==
Date: Sat, 17 Oct 2026 08:58:31 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	fuse-devel <fuse-devel@lists.linux.dev>, fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
Message-ID: <atMb74jop2vrPJxv@nidhogg.toxiclabs.cc>
References: <20261016160037.GA107919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>

On Fri, Oct 16, 2026 at 09:00:37AM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.
> 
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
> 
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!

Please make sure to always carry your towel and have a pack of salted
peanuts with you...

So long and thank you for all the fish my friend.

> 
> --Darrick
> 
