Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6DA280CEE;
	Wed, 11 Jun 2025 12:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749646216; cv=none; b=tq4AxPMLg0DHDR3cOAnTy5Eutp42DcUI3EprDLMnZIaAqeCVIyIPusTy4MxMFeY1r08JfdRa0PGVHNWWlkyyqBfvAqSc+Ww5+N1MZmEttlNfYijvjElDPiGwDGGPgtGFEejk6v2Kj95UZpCtJCxB7+zipMeiNrl57fluJGsepE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749646216; c=relaxed/simple;
	bh=ST5Pb1tkdVY/SbEP4kMGzVB/GqxbMS6QoL/Qkzew9C4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e69MCKJd0NW2uc2qjdxwxG2XlTlckEgskbjOXli6MfQvpP0yW8lvU46gTohlByqe0mRUk9Ma8FCUqYOsIMjSoadxL0OXBXLMD+G2EDhFEvOeLbW6UCL65IEFGbO7HAY9QPcANymnbVEhYpGWbrCQyY3U2rOSiNE9l3K6W0y66/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AcMVP55i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AcMVP55i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B2FC4CEEE;
	Wed, 11 Jun 2025 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749646215;
	bh=ST5Pb1tkdVY/SbEP4kMGzVB/GqxbMS6QoL/Qkzew9C4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AcMVP55it+Z12b/8DDf4AX3ChAioqhGcRaRdPIQqSyKW4gd5uZt9jpUvt0B/LPceO
	 yWiEwZ1bs78oKGtMJO+fwynNUdOS3YKxMT55gDAIH3BuSkMHlx7YpApFoM9Im5k6j/
	 qFGUqxl7VYxuF8Jx4qYtQL5JuhFq3kpuqHFl7jSfPcktiY+V0adA1fbgg+hHg4odCH
	 KuRd3hkGrKuWrqSNwZg+HQbWsw5ANYOnWSXq5aDM2YLsevCaGCfYiSpaU0wQd/W/yD
	 yOkMl8MnnH7xEQ0eTKuZHvAUwGxwQeIwII7q7rsaApzVvzVKXJ0vPekusuuxrBNT8r
	 fdUzK5LcteEbA==
Date: Wed, 11 Jun 2025 14:50:11 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ma Xinjian <maxj.fnst@fujitsu.com>, zlang@kernel.org, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/603: add _require_scrub
Message-ID: <a3lsfm4pyryspt257eprspy6zapgkai5xubtcpxpw3edygurrn@7wfi73j2sbqt>
References: <20250610091134.152557-1-maxj.fnst@fujitsu.com>
 <TFkjtpdcmBChUeSsNRmVqz65HKT2J13UyIyaxbRu8CFBo8VPvXETVgIR6QZLuGK5BLpZOgS_1KQaE27kWB5PMQ==@protonmail.internalid>
 <20250610144600.GD6143@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610144600.GD6143@frogsfrogsfrogs>

On Tue, Jun 10, 2025 at 07:46:00AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 10, 2025 at 05:11:34PM +0800, Ma Xinjian wrote:
> > From: Xinjian Ma <maxj.fnst@fujitsu.com>
> >
> > This test uses xfs_scrub which is an EXPERIMENTAL and unstable feature.
> > Add _require_scrub to check if the system supports it.
> >
> > Signed-off-by: Xinjian Ma <maxj.fnst@fujitsu.com>
> 
> Oops, thanks for the correction.
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Experimental has meen removed from scrub in 6.16, is this still needed?

> 
> --D
> 
> > ---
> >  tests/xfs/603 | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tests/xfs/603 b/tests/xfs/603
> > index 04122b55..d6058a3e 100755
> > --- a/tests/xfs/603
> > +++ b/tests/xfs/603
> > @@ -20,6 +20,7 @@ _require_xfs_db_command iunlink
> >  # until after the directory repair code was merged
> >  _require_xfs_io_command repair -R directory
> >  _require_scratch_nocheck	# repair doesn't like single-AG fs
> > +_require_scrub
> >
> >  # From the AGI definition
> >  XFS_AGI_UNLINKED_BUCKETS=64
> > --
> > 2.49.0
> >
> >
> 
