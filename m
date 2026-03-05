Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAB2189BB6
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772733306; cv=none; b=RZ2kbYTrng/K53Ny286vDi1wCEoKzvmtV3E0sMPGHnBIYsyZn68Wl0v/jf1ij/xUHAPuCsAHGOpta/OSawjWo5u38ib2KXCMLz/y1FwD/ykIMMK/LQJPMGMc3IeYiTZU4yGVzXtDtWE+km7vdm3EkrxXCZ0RrByIAV8bHzIp3ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772733306; c=relaxed/simple;
	bh=ktfxD+w7ytrUEQzaLkeYINazKnX2U49G2KdE0SIXnmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nq9gkRiJyz4PkDO8K6zR8QlssfKyQNRpqIb96vd2itXgvnX3Crj9a2ojcVozNYovyA3lJYR6nE9SO1Yc9uIR0eyuuyYnSUasCIxWIGSoV8oWJV8RMaritiMEzSWkTWzAKIaI18ghCfeVT4+MkCt/Y/t4Td+lOJhJ0Y0YQIQ3Q44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uYJLCzp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uYJLCzp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CB3C116C6;
	Thu,  5 Mar 2026 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772733305;
	bh=ktfxD+w7ytrUEQzaLkeYINazKnX2U49G2KdE0SIXnmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uYJLCzp6c2vbIP7EBfWIeOaWL9Gvl3GNXrC2KWShm1gIX0hV7AisQ8NlQE5jFQFsj
	 dfYPT9/begxI72QB4RKEblH29Lxje8zGIBAxd5/UYDVCFH/wSdzDh3dfUL3eRXgzqH
	 Xxd06ku4ElJjA1tC7xSfwjDIg0KSO/OHb8VXGN9dGIlNglIbgJPo8Kw4uaVivOad7r
	 p79cG47u18B0Tr+GztdsPZTAzv6oeVUC8PuJZKQc0cb4iijkkc0bkJz0KxlmqblT/7
	 kUIcdRZ4TOozqRkh2RLDxzk0f+YlBYHpcM4Hww6EMxeIzwNTOSNrxE358d3wAXPPOL
	 3uX2wxqpqM33A==
Date: Thu, 5 Mar 2026 09:55:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs_healer: use getmntent to find moved filesystems
Message-ID: <20260305175505.GF57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783601.482027.9121579371607325115.stgit@frogsfrogsfrogs>
 <aacDkSiRLgD1k3Tg@infradead.org>
 <20260303172654.GQ57948@frogsfrogsfrogs>
 <aagtnm0-z3ldfFqd@infradead.org>
 <20260304163020.GU57948@frogsfrogsfrogs>
 <aamMgR3n4LULfgT1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aamMgR3n4LULfgT1@infradead.org>

On Thu, Mar 05, 2026 at 06:00:33AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 04, 2026 at 08:30:20AM -0800, Darrick J. Wong wrote:
> > Yeah.  I tried creating a(nother) anon_inode that has the same sort of
> > weak link to the xfs_mount that the healthmon fd has, for the purpose of
> > forwarding scrub ioctls.  That got twisty fast because the scrub code
> > wants to be able to call things like mnt_want_write_file and file_inode,
> > but the file doesn't point to an xfs inode and abusing the anon inode
> > file to make that work just became too gross to stomach. :/
> 
> Yeah, don't see how that work.  I guess IFF we wanted that it would
> have to be a VFS-level weak FD concept, and that seems out of scope for
> this at the moment unfortunately.

<nod> I'll add a comment summarizing this part of the discussion to the
commit message for adding repair functionality, so that we record the
justification for all the getmntent trickery.

/me observes that 7.0 adds a STATMOUNT_BY_FD flag to statmount() that
enables us to get the statmount data (and hence mnt_id) for an open
file.  We could record that (in addition to the datadev path) to try to
reconnect after a mount --move without having to parse /proc/mtab like
getmntent does.

--D
