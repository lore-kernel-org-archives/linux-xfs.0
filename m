Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C9E171CA
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 01:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lto469fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42636C433C7;
	Wed,  3 Jan 2024 01:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704244068;
	bh=QQ4xNsdc9Y8Od2jkFfon89To/WCr62mT1jnWCKuwNVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lto469fmst6MOmGiJCwsbAdOWA33tZxVv60q0UNv/xOZxWc+c8lyXGHCZK429+iwa
	 kw46kRHEsF3kUC10voc/fBcA+DwDISMG4xQFxI5MJKufVW+7nE7ZtQLKMbxDreBbVo
	 FsGSK2odlucl2TgrSxVI/jBiurgDmlRBNFKtVKBBZZDZ8Cn+EIpM8YP8tKDQRK7ehX
	 I6ET+35Ja1PpPtuGg8PrEnRqI1wt2OYTaLFF1J/cEaHcFny0CU419eprnuAomBrJGm
	 QyJh/PVJcUPJ22TIJE+SywckHCvHdDOaZ8zcoYswTPS97MYwbPzoTBxVF6SXfkVm+I
	 WSmOfz32Lo7Sw==
Date: Tue, 2 Jan 2024 17:07:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: allow blocking notifier chains with filesystem
 hooks
Message-ID: <20240103010747.GB241128@frogsfrogsfrogs>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826571.1747630.2096311818934079737.stgit@frogsfrogsfrogs>
 <ZZPlNOFEfG7KnEk6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZPlNOFEfG7KnEk6@infradead.org>

On Tue, Jan 02, 2024 at 02:28:04AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:05:29PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make it so that we can switch between notifier chain implementations for
> > testing purposes.  On the author's test system, calling an empty srcu
> > notifier chain cost about 19ns per call, vs. 4ns for a blocking notifier
> > chain.  Hm.  Might we actually want regular blocking notifiers?
> 
> Sounds like it.  But what is important is that we really shouldn't
> provide both and punt the decision to the user..

How about this for a commit message:

"Originally, I selected srcu notifiers to implement live hooks because
they seemed to have fewer impacts to scalability.  The per-call cost of
srcu_notifier_call_chain is lower (19ns) than blocking_notifier_ (4ns),
but the latter takes an rwsem.  IIRC, rwsems have scalability problems
when the cpu count gets high due to all the cacheline bouncing and
atomic operations.  I didn't want regular xfs operations to suffer
memory contention on the blocking notifiers for the sake of something
that won't be running most of the time.

"Therefore, I stuck with srcu notifiers, despite trading off single
threaded performance for multithreaded performance.  I wasn't thrilled
with the very high teardown time for srcu notifiers, since the caller
has to wait for the next rcu grace period.

"Then I discovered static branches.

"Now suddenly I had a tool to reduce the pain of a high-contention rwsem
to zero except in the case where scrub is running.  This seemed a lot
better to me -- zero runtime overhead when scrub is not running; low
setup and teardown overhead for scrub; and cacheline bouncing problems
only when there are a lot of threads running through the notifier call
code *and* scrub is running.

"This seems perfect, but static branches aren't supported on all the
architectures that Linux supports.  Further, I haven't really tested the
impacts of scrub on big iron.  This makes me hesitant to get rid of the
SRCU notifier implementation while online fsck is still experimental.

"Note that Kconfig automatically selects the best option for a
particular architecture.  Kernel builders should take the defaults."

I dunno.  Do you want me to rip out the srcu implementation and only
provide the blocking notifiers?  That's easy to do, though hard to undo
once I've done it.

Hmm.  How many arches support static branches today?

$ grep HAVE_ARCH_JUMP_LABEL arch/
arch/arc/Kconfig:52:    select HAVE_ARCH_JUMP_LABEL if ISA_ARCV2 && !CPU_ENDIAN_BE32
arch/arm/Kconfig:77:    select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
arch/arm64/Kconfig:163: select HAVE_ARCH_JUMP_LABEL
arch/arm64/Kconfig:164: select HAVE_ARCH_JUMP_LABEL_RELATIVE
arch/csky/Kconfig:71:   select HAVE_ARCH_JUMP_LABEL if !CPU_CK610
arch/csky/Kconfig:72:   select HAVE_ARCH_JUMP_LABEL_RELATIVE
arch/mips/Kconfig:53:   select HAVE_ARCH_JUMP_LABEL
arch/parisc/Kconfig:60: select HAVE_ARCH_JUMP_LABEL
arch/parisc/Kconfig:61: select HAVE_ARCH_JUMP_LABEL_RELATIVE
arch/powerpc/Kconfig:212:       select HAVE_ARCH_JUMP_LABEL
arch/powerpc/Kconfig:213:       select HAVE_ARCH_JUMP_LABEL_RELATIVE
arch/riscv/Kconfig:96:  select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
arch/riscv/Kconfig:97:  select HAVE_ARCH_JUMP_LABEL_RELATIVE if !XIP_KERNEL
arch/s390/Kconfig:151:  select HAVE_ARCH_JUMP_LABEL
arch/s390/Kconfig:152:  select HAVE_ARCH_JUMP_LABEL_RELATIVE
arch/sparc/Kconfig:31:  select HAVE_ARCH_JUMP_LABEL if SPARC64
arch/x86/Kconfig:176:   select HAVE_ARCH_JUMP_LABEL
arch/x86/Kconfig:177:   select HAVE_ARCH_JUMP_LABEL_RELATIVE
arch/xtensa/Kconfig:33: select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
arch/loongarch/Kconfig:94:      select HAVE_ARCH_JUMP_LABEL
arch/loongarch/Kconfig:95:      select HAVE_ARCH_JUMP_LABEL_RELATIVE

The main arches that xfs really cares about are arm64, ppc64, riscv,
s390x, and x86_64, right?  Perhaps there's a stronger case for only
providing blocking notifiers and jump labels since there aren't many
m68k xfs users, right?

--D
