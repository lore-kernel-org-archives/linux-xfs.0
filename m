Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5B91E1C11;
	Tue, 14 Jul 2026 16:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784047224; cv=none; b=DM2W7PNE6eWWpw3xKcK84hyZ6NRbJ9Ltt/abM0808gE01PKnlik2Mcg+YheffQ+anjQ3e0UOjKbagvK1CmHDyt+i9zqV/UmxatsCC1AmAgPblFI4pBpF/ea62eHJl8KvnO6gmWd3UatrTsLJmQmR+3ifsPl33cnhZhGbN7czxdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784047224; c=relaxed/simple;
	bh=3SwB5hyURQDw9vSSZawoayeUlCXH+BdU7R6jgc+R89g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6oYeJ0sggCmZ2wM/bf9D/t3J5MSPApF714TjpxkVyDCazZgFEaTAPZHRH1Mo1uCBMNAYIMhevuoQyyDW6Nq+JxMwwrDiKkQCUk38XqWS4rDWPC/kZIvtI6JojxZSQqvyLjGfLXxCiY38N6QGse9S/sxhRNIKIYyMjB/EeQQLak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQNTDeHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQNTDeHv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A3C791F000E9;
	Tue, 14 Jul 2026 16:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784047222;
	bh=gg603RQYeW5vAGQiWgQctR3lMlGy5oigDzyr2KUGrYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QQNTDeHvuvX4qn3WnKMbzCidEdpjUE2aBk2vvPliQeLUB6o1brKcsnCdigdOHLLEf
	 lfFqNGFTFHnyfwOHSynEMXOC01ClkmY2sHepFJjS/GdIBJTijeFEYJAOkChdcQ+Uyb
	 HktWCNzhFg4GcFLQqFDmBSuZhu+AhvVAYGW6BjWINpywze1qtJCZ6DuA6ZfmjAeH1H
	 oFwnWqvkUNYFza4yPl5TOVxPAYxiZuvkFDd4TpzUD4QgUfvZJzYGe/zCKwUJOSkDAv
	 TaHut5P62GKPbCRR1RDkpyZIvWk+hzWoOlE2qSPsigmApdodrF21EoRFXZfctbXSla
	 8dBk7RxkGHoLg==
Date: Tue, 14 Jul 2026 09:40:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: don't zap bmbt forks if they are MAXLEVELS tall
Message-ID: <20260714164019.GE7398@frogsfrogsfrogs>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
 <178400716946.268162.18317924649043454437.stgit@frogsfrogsfrogs>
 <20260714061652.GG1072@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714061652.GG1072@lst.de>

On Tue, Jul 14, 2026 at 08:16:52AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 13, 2026 at 11:07:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed a discrepancy between the bmbt level checks in the libxfs
> > bmbt code vs. the inode repair code.  We do actually allow a bmbt root
> > that proclaims to have a height of XFS_BM_MAXLEVELS.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I guess we need a test that actually creates such a deep tree.  But
> we'll probably run out space / extents before..

The bmapinflate command in xfs_db does this by writing a new bmap btree
with as many mappings pointing to the same "reflinked" block as you ask.
The only problem is that to hit maxlevels, you need to create a 1k
fsblock filesystem and then bmapinflate 2^54 records, which will take a
long time and require much memory.  Back in the day when Chandan was
working on nrext64 I tried this and it took 2 days and 400G of RAM to
write the huge bmap btree out to disk and generate the appropriate
rmap/reflink btrees.

--D
