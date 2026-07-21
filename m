Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FE540926D;
	Tue, 21 Jul 2026 22:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674625; cv=none; b=oCYpsnNnfxg2EVLDenbJ09W5X6wpYUCVUK4iFwg8DZ6ngKyhjK8SqPs3wTYI7+anzQpNN5f91Qtj+Zij8Aa5TE0FofSKOIEXUCiL6970KQr2M/nOiao0twJwgS3TbBuAdGk+qbIKjNEcRhXgwFXqC3FiaqwOO4DBVwvyIBKVXwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674625; c=relaxed/simple;
	bh=ilvc7Ca8xEGa2WSnjI4f+orqR6jvzGj8Jd35B1wuuiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yxpm8D8a0Wyl8Ta6PPGNe5NDR+k33faPvUwCAVfLnAdmgOi4rnVWbr1MR0dgmLXj7OeEVRNwFq1rk9ZODRoq0uM2rL958TDRSLQO/RL+ag4YhrXGCTw4DDaab3ZmjeOOKm881/twq2pZsePechA4u+ZDDQI9v6OtFTFL3vnkpns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QN8EBaaA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QN8EBaaA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 450331F00A3A;
	Tue, 21 Jul 2026 22:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784674624;
	bh=0hkPjTUdaj568jeuea2sBw3RB9UhtApfx4Bt0GOlMcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QN8EBaaAr15H560q2O9dzU7JbBf/AeEDJ3RakO1jVJ388FxNQeG5h2nKy9Lk4ELA7
	 lM08UvIGQDWe+zu1kOwoKDfzp1dsirgxIh8oN9lZTMAHL/alDOJARUQu4j1FyF7PiV
	 10MM4rMXOovaqC5NA9u9sRK+epsZlFuwcrflfYFR9O1S2PzD0TA3VztxfZY0F5aDHw
	 +6A9ewWquWzzB9IZY5AuOJOuggi9qzueluDAveUIBvie6rz6MAKKUd6IP6vpgP+Cto
	 B1y80olZX3NljqRBbmbry+cAQuUgWf3rLXdagWjbEIYAfBcfq6KSiWB+Izo62if78x
	 uD0RYeu9rW+Fw==
Date: Tue, 21 Jul 2026 15:57:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Suveer Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v7 06/11] fstests: verify f_fsid for cloned filesystems
Message-ID: <20260721225703.GZ7380@frogsfrogsfrogs>
References: <cover.1781694879.git.asj@kernel.org>
 <2ac5fb22fd6b51973d11082a1ee8fe354926c63c.1781694879.git.asj@kernel.org>
 <20260701173314.GH6517@frogsfrogsfrogs>
 <328de723-6f9c-4f09-a68a-da24d49300d5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <328de723-6f9c-4f09-a68a-da24d49300d5@kernel.org>

On Wed, Jul 22, 2026 at 06:36:13AM +0800, Anand Suveer Jain wrote:
> 
> 
> > This is where I continue getting stuck on this patchset -- fsid is so
> > poorly defined that I don't think the rest of these fsid tests make
> > sense at all.  Nobody mandates that fsid is persistent or stable across
> > remounts.  Nobody even mandates that two cloned filesystems don't have
> > the same fsid value.
> > 
> > The statfs manpage says:
> > 
> > "Nobody knows what f_fsid is supposed to contain (but see below)"
> > 
> > and then:
> > 
> > "The general idea is that f_fsid contains some random stuff such that
> > the pair (f_fsid,ino) uniquely determines a file."
> 
> Which is exactly why we need fstests guardrails.
> Keeps filesystem's implementation consistent across kernel versions.
> Embarrassingly, I introduced a bug around this that is now fixed.
> The commit IDs are in the test cases.
> Thus motivation for this fstests patch.
> 
> > Based on that very weak statement, at most it might make sense to check
> > that two separate and simultaneously mounted filesystems don't end up
> > with the same fsid 
> 
> Yes, for xfs, btrfs and f2fs. However for ext4 cloned filesystems can
> share the same fsid and ino because the images are identical.
> It is then up to the usecase to change the UUID for either filesystem if
> it gets modified.
> Commit ("fstests: add _require_unique_f_fsid() helper") captures this,
> and the link in that commit includes the discussion.
> 
> > just in case there *are* programs foolish enough to
> > use (fsid,ino) as a uniqueness check.
> 
> On the other hand, if a program needs a unique ID, do we currently have
> any way to get one?

I don't think there is a way to get a globally unique identifier for a
filesystem image except for the meta_uuid filesystems, and even then
only if the volume manager resets the user-visible uuid every time it
makes a clone and nobody runs a duplicator.

--D

> Thanks, Anand
> 
> 
> 
