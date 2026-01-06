Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5672433AD89;
	Tue,  6 Jan 2026 13:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767706544; cv=none; b=a7mPn529kuir4MZHU4BPFtxHMHmYbvtcZ6eTbFImEOTdUR3O7EbMBCsJFI9hVoPFVAurVk30BrRbnbi2NZQ9B9rKrc0WwL35fmWUORLOyGAisumw6ZOHXGz5zwy0inlOsux8zFZKCTyZ0yWP9VtG/AxsGs+GL2h26i9fx9T+42g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767706544; c=relaxed/simple;
	bh=PeAGXWuQnI2vt/C9EMlk0McnTwrtIkMh0sA1zCHeCjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pmObL1evqWLQZW4bYOLxcaiGOCTZQvKwJIBCRZbKVZkolcVctLAfauA5vWy3yrgskkriHoeh54Eq65YhXr2IszDjDd7AqFtqSxSk18Zt7B9o3HH1wxKTJF2GtQlbPqkGnk6h3EEsPowArM5sjIL4w31+QWK6/r/kcUq06rjo4LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3nn3szM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3nn3szM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FA8C116C6;
	Tue,  6 Jan 2026 13:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767706543;
	bh=PeAGXWuQnI2vt/C9EMlk0McnTwrtIkMh0sA1zCHeCjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z3nn3szMJezSR7sbuK501JW+RcnjkHy8sNSuiUncBwdqDfQaJJNbrCNRP4z5Dmsf8
	 0uiqx1zKXPmmb8TOwSweZgHQ/GjFjD/g9wd//TPtSAjuoMtvzDKRT1Dz5rr+yN9HuC
	 BnqW0QNkAho36W28HEj8yRS9EhmnNCPos6ATk4yYIC5j01KM88+e0qsnqrzFwHLMJO
	 PAVnoz35yKLdd3dNUOcShm9mKAyw4OGvCF6/NJwUt6aLhDrwUv9xNa+PoQG9gTWoJZ
	 +S9x4YAXmoZEfGrM9E9z4yB+vCDtGbbOeqi0K+DPdMlQuVz3WcZp6hxBRIj9Ed2h2a
	 cB/zvwnIk0Zeg==
Date: Tue, 6 Jan 2026 14:35:39 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	syzbot <syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_ilock (4)
Message-ID: <aV0OE0PBhxjuPU8p@nidhogg.toxiclabs.cc>
References: <695b2495.050a0220.1c9965.0020.GAE@google.com>
 <aVxGFP1GJLPremdy@dread.disaster.area>
 <aVzDj2OEa_R9bJyW@infradead.org>
 <aVzb3ZHsC6XXUV8i@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVzb3ZHsC6XXUV8i@dread.disaster.area>

On Tue, Jan 06, 2026 at 08:54:37PM +1100, Dave Chinner wrote:
> On Tue, Jan 06, 2026 at 12:10:55AM -0800, Christoph Hellwig wrote:
> > On Tue, Jan 06, 2026 at 10:15:32AM +1100, Dave Chinner wrote:
> > > iomap: use mapping_gfp_mask() for iomap_fill_dirty_folios()
> > 
> > This looks good, but didn't we queue up Brian's fix to remove
> > the allocation entirely by now?
> 
> No idea - I didn't see a fix in the XFS for-next or the VFS
> 7.20-iomap branches.  I've been on holidays for the past couple of
> weeks so I'd kinda forgotten that we'd been through this a month
> ago.

FWIW iomap patches don't go through xfs tree.

Patch is here, in linux-next since next-20251216
https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?id=ed61378b4dc63efe76cb8c23a36b228043332da3

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
