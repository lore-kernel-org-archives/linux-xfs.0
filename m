Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87853D6CB8;
	Wed, 20 May 2026 12:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779279557; cv=none; b=jpBOVvIrv7r820EfDUv+SvjGhDUcw8brwtlY7RYvC8sZr6GnoeSD2l0zfAScYh6keR3QQQW3XatH+sMGo8HI7JKygKDF++qIq3PxcKGVBF/LlukCCLq/rWSJggCvqnXVFATX/11saIQydljDrzxfQkq8Ik6LiI/xHiOYAY66V00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779279557; c=relaxed/simple;
	bh=6NQLD1ZRS0Ek0oRbGl9ZsW2VgE6/ahwsEqedBtQcclA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ISPdVdhR08l7fPPBAGXRnIuaF1CONdaKqp61Dz0L9S+NwZK2usiD9Fr/Uo+j0AaVc4hUu9l/qRdOPpYHyOBO19LzTD2LrBZ19ovIStKxClBYmcpvpVZd7+eOI+FFe/lgMihjOPo6gaxt58199gEJUcVkXeKpP6a1JvUAGRJgu+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OrIqIr6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OrIqIr6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E111E1F000E9;
	Wed, 20 May 2026 12:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779279555;
	bh=I4MGNKhzrJ2omRvYsu3oYy+YyJRCfB211QtO9Xwjt7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OrIqIr6AYuGLCm+EXKbc/QaB26vVr4wzwsw6gXF0uN1kNvfHvbW1It05tWf9md++F
	 /G3NVe/el4r3MY2uP2g36Cn6ayj5RMTTyMhk+N1gXhYt2+TKIi9N1CXRe9clQ5T+pq
	 6nkZag4RuyUTWpBwKuNydYEPROul9pE6W0O6wuzjdXoJhrcrc6X+iQwc9z2rrDG3ko
	 kkPWi5HRf3l75DsHWG19J5Rg0FMxq1WXCrVbNOY5XbRz9lMrOLufY4bVSfVEy99+Rn
	 gZ32aQ6adzM2Dt5pHVpjaAqSgbqIS4OkBarbyewnC7DEuSdrJJ3i5Uz1BKOZZFvplZ
	 PmbWti+78FXtQ==
Date: Wed, 20 May 2026 14:19:10 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: detect cycles in recovered unlinked inode lists
Message-ID: <ag2kHyI7IzzyWC1z@nidhogg.toxiclabs.cc>
References: <20260518013143.1532327-1-michael.bommarito@gmail.com>
 <20260519050235.GI9568@frogsfrogsfrogs>
 <agwfrZAchLLFX7c7@infradead.org>
 <20260519124833.2020871-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519124833.2020871-1-michael.bommarito@gmail.com>

Please leave the message you're replying to quoted in your email...

On Tue, May 19, 2026 at 08:48:33AM -0400, Michael Bommarito wrote:
> Hi Christoph,
> 
> This research agenda and patch comes from a hardening project
> focused on automount filesystems in major modern distros.
> Maybe the USB stick threat model isn't worth the patch for
> just DoS impact, but that's at least why I thought it worth
> submitting in the first place.

The patch ain't completely invalid, but by the time you've somebody
untrusted with physical access to the system to put a USB stick on,
your security is already gone.
Automounting filesystems (a thing we've been fighting against for
years) just adds on top of it.

> 
> I looked more closely at current xfsprogs for-next
> to answer Darrick's repair question.  Plain xfs_repair refuses
> the reproducer because the log is dirty and needs replay; that
> replay is the mount-time path that hangs on the vulnerable kernel.
> 
> xfs_repair -n diagnoses the AGI unlinked bucket and inode
> next_unlinked damage, and xfs_repair -L clears the bucket /
> next_unlinked state and repairs the image, with the usual log-loss
> caveat.
> 
> I also found a narrower userspace diagnostic issue: xfs_db
> dump_iunlinked follows di_next_unlinked until NULLAGINO and will
> spin on the same self-cycle.  xfs_repair itself does not appear to
> use that unbounded walker in the tested repair path, and xfs_scrub
> userspace is mostly driving the kernel scrub ioctls.
> 
> To be fully safe from automount attacks, I think both sides would
> need to be addressed.
> 
> Your bigger point about regressions and test coverage is still
> valid though.  FWIW, I have been talking with some other fs
> maintainers about adding test/ fuzzing coverage either in-tree
> or external.  I would be happy to help with add XFS coverage
> as part of that project, although I'd defer to your preference
> about where those tests should actually live.

I don't think such tests belongs neither in-tree nor in xfstests, but
this seems a good idea to start a project related to test filesystems
resiliency against those issues. syscaller already does a lot of fuzzing
but mostly random and not containing a bunch of carefully crafted
filesystems to triggers specific issues.

> All that said, just let me know if you still want a v2 based
> on the threat model.

I don't think this is something we want to have without having a
reliable way to test this code to fix a theoretical attack vector, but,
if by any chance it comes to a v2, there are a lot of duplicated code
that should probably belong into its own helper.

Cheers,
Carlos
