Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A18331ECC;
	Wed, 24 Jun 2026 19:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782327603; cv=none; b=DdN9nUxC4Lhwy4A8qv5ic/sCou8Pp7IKjdYveAkMu7WexYmGNbpBByYOAQ6S70qdOHAfBUwNNwF4rfgpM31dBRsave52mrVsejWBT4pZMcob7surf3HbFfWz7XeyoAkcMojAX5Dmp2fEuUwvB1QyGkUeqgj07V4R3vHGxIUDqcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782327603; c=relaxed/simple;
	bh=gsKknPXDEb/3DdrUYJvZcSqOvaZeJQOOIaLrxwMgc/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AtnxLL9B0oh+50zq9LYJSI4eUoftH+od7oBfi850bUI3g9DMPeV+bKKseTYYhw63oALN+Vs436DqJDSUmIdq27HuucbR9afC/IiHQg79APublKWFMUOCUiof6FozSV570owSustrRIGF2fMK0/DGBxXGeO0QSvpwUmT1JbcnYkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKPRZBAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKPRZBAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F3D1F000E9;
	Wed, 24 Jun 2026 18:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782327602;
	bh=8FiWRP2V41IjzmZEaRI8BMSrUtnpa9SMyoEalLrCkkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BKPRZBAN95hMmCRJ4JM/x/Vgn/c3Y7/5c5oi2Qoc56JeuEOcECc/b/8U/TnaxCIB4
	 Bkc46r+bbFNdaNCecaha4RxEEyKH/MhJ/3WaPyWjScZof8KCKAV7uwzWt3dx+FiGC+
	 0qyrB4TM2Pq4JrZeCs2E/1ebub6HELqC8CrBlE7NTlGmfvVr0Xf5m5RdWgIQc5Voqq
	 gxKlwxGPLomT3Z3WlV/cuEry1lc6VkGDkrAnI6966F58bP8FHGbLJYvL9pGe3Cmado
	 apHK1RV2OeckJzr8qhyTpMpWv34NNzioHlm/lUuvQE2S6e+J3kXtJDmz4gjHSdPmUK
	 04b+9Lk37k7Rg==
Date: Wed, 24 Jun 2026 20:59:56 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Eric Sandeen <sandeen@redhat.com>, "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] xfs: fix capabily check in xfs_setattr_nonsize
Message-ID: <ajwnRzjvTYiUs1ms@nidhogg.toxiclabs.cc>
References: <20260624101436.362533-1-cem@kernel.org>
 <20260624134039.GB5649@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624134039.GB5649@lst.de>

On Wed, Jun 24, 2026 at 03:40:39PM +0200, Christoph Hellwig wrote:
> Adding Jan and Christian for quota and user_ns knowledge.
> 
> On Wed, Jun 24, 2026 at 12:14:29PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > An user reported a bug where he managed to evade group's quota
> > by changing a file's gid to a different group id the same user
> > belonged to, even though quotas were enforced on both gids and the
> > file's size was big enough to exceed the quota's hardlimit.
> > 
> > Commit eba0549bc7d1 replaced a capable() call by a
> > has_capability_noaudit() to prevent unnecessary selinux audit messages.
> > Turns out that both calls have slightly different semantics even though
> > their documentation seems similar. Where in a nutshell:
> > 
> > capable() - Tests the task's effective credentials
> > has_ns_capability_noaudit() - Tests the task's real credentials
> 
> Eww..
> 
> > This most of the time has no practical difference but in some cases like
> > changing attrs (specifically group id in this case) through a NFS client
> > this will allow the quota code to use XFS_QMOPT_FORCE_RES, effectively
> > bypassing quota accounting checks.
> 
> Yeah, this does look wrong.  Do the other conversion in the above commit
> have tthe same issue?

I don't know yet, but I do hope to be able to convert everything back to
a capable_noaudit() helper. I need some time to look at the other
conversions, but giving the different credentials likely the are all
victim of the same issue.

> 
> > Using instead ns_capable_noaudit() should fix this issue and prevent
> > selinux audit messages.
> 
> The generic quota code manages to do without either has_capability_noaudit
> or ns_capable_noaudit.  I think this might be hidden behind
> inode_owner_or_capable calls.  Any idea why we're different?

Yes, I looked into that to check the feasibility to use the generic
code. This specific path goes through __dquot_transfer() which uses
ignore_hardlimit() helper to decide between bypassing quota enforcement
or not.
The later though uses capable(CAP_SYS_RESOURCE) which would trigger
selinux audit messages too at least for our case.

This though made me wonder if we shouldn't be using CAP_SYS_RESOURCE in
lieu of CAP_FOWNER in this path which seems more appropriate to bypass
quota enforcement. Either way though, I think we should at least have an
initial simple to backport patch to older releases.


> 
> > +	bool			force = ns_capable_noaudit(&init_user_ns,
> > +							   CAP_FOWNER);
> 
> I'd do away with the local variable here.

Sounds find to me. I wanted to avoid the function call with two arguments
as an argument. But I honestly have no strong preference.

Cheers!
