Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FF71C6AE
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYInklBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FC8C433C8;
	Wed,  3 Jan 2024 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704307217;
	bh=waabBS/CPmUr/MI7JIeZ8MPlu1dV/Bksak23nZH38C8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gYInklBIOXZ8lN503DVOwdzaPuYDHlfwqSrPUoCFd7z43U0qxYxF/b4/rzuPyQEi9
	 Z5sVrSRGGsrPM605ZKdeV7B9UoSfArDXjCajc+JDdrJOuBnJkORpoVji2vlpR91WSf
	 3urvAiWycoQadjOTJyTIrRp7Od+puYn+Mga5/aur7ZXy/LAQ9wbjwIJAvAlrqwA3gO
	 f6p0n1Qlc0fLwkxsn3191VdJ6TgOe2iffPsqulvE9crD7nAnqEHuRRqZbkaM3GDS1g
	 FpKlHPhJsJHeCP2p3UxRuW6YFjKcjXdq+xso6I0Sa9xAdyvCQrex5UzPhIRR3SNnl6
	 vznifLLifnG6w==
Date: Wed, 3 Jan 2024 10:40:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: allow blocking notifier chains with filesystem
 hooks
Message-ID: <20240103184016.GQ361584@frogsfrogsfrogs>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826571.1747630.2096311818934079737.stgit@frogsfrogsfrogs>
 <ZZPlNOFEfG7KnEk6@infradead.org>
 <20240103010747.GB241128@frogsfrogsfrogs>
 <ZZUOxQHqt7WFV8/O@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZUOxQHqt7WFV8/O@infradead.org>

On Tue, Jan 02, 2024 at 11:37:41PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 02, 2024 at 05:07:47PM -0800, Darrick J. Wong wrote:
> > The main arches that xfs really cares about are arm64, ppc64, riscv,
> > s390x, and x86_64, right?  Perhaps there's a stronger case for only
> > providing blocking notifiers and jump labels since there aren't many
> > m68k xfs users, right?
> 
> Yes.  And if there are m68k xfs users, they are even more unlikely to run
> with online repair enabled as they'd be very memory constrained.
> 
> So I suspect always using blocking notifiers would be best to keep
> the complexity down.  In fact I suspect we should simply make online
> repair depend on jump labels instead of selecting it when available
> to remove anoher rarely tested build combination.

Later on in the online fsck patch series, scrub will start using
LIVE_HOOKS for some of its scanning functionality.  I don't know that
anyone will really want to use online fsck on weird old systems like you
said, but while it's EXPERIMENTAL I don't want to lose the option
entirely.

That said, static branches do have a fallback for !HAVE_ARCH_JUMP_LABEL
case, which is raw_atomic_read.

I'll get rid of the srcu notifier chain xfs_hook implementation to
reduce the complexity within xfs.  Online fsck will always use static
branches + blocking rwsem notifiers.  For modern arches like x64 there
will be almost zero runtime cost due to the nop sled.  For m68k and
friends, they can kick the tires on xfs_scrub, but if the performance
sucks due to the READ_ONCE then oh well.

--D
