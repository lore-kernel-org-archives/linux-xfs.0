Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC97439336;
	Tue, 21 Jul 2026 23:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784676350; cv=none; b=eM9zw4PoIOsn3MtZgV75aQgCFPBBRyMv/NIMJZlo9QIvYA50a1a5lpWhdsmXp9k6JaLM/cZrslZcqEz/KH8y6nX/DKZ8cuZ7D+JkS77EP78e0GR7SxNACC9h33r6OZMSkSVaiv9sLAJ+Yh/lq1iVJm/LT6b+B59lzi/o/vBtbmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784676350; c=relaxed/simple;
	bh=k9+DgVgH1vKEc5Jud/TiYzNSd6WnvSyzwZxrFj1VtTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qg8oSHWUutPknqW1qy3KTIW9E/yPiurwljhks8gfH9muDz2icTv+A0BQOKsOglyMKztGeUhMyykKsfieGETiJaD2pRbFJGcNS+UdNEFf4xvUpxV3PGgx2arUcuWR5GWqar8CrnUrA1mAlrKU99RnTifOTSevwhIr5TywmmAaqaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1AtmymN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1AtmymN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 67A981F000E9;
	Tue, 21 Jul 2026 23:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784676349;
	bh=PShLnoDa/Diacqu8FRfVhJ48Cf46bFdlZ3c0z+aO0xE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f1AtmymN0KKxYQZ5C3Ji/is5GsAWWp7NB5QBUVi8Es75mtRQTvFZK3rNiC3yCPkQQ
	 tpg1CslKLMO6jI7jrGlASb1dpbg85F0YrbtFkYxCQWob+NcaS7bUijnZGlMMD985/8
	 AJefso5AsWY+ADoy+APqsUwS9KFZSB20WIhoI4Av3oyYTd5xp53gJDPiHM66SaVAlO
	 EWFIEsZJsN3SciJ9gp3i0cQaZkxUpLteaBsio1r1arGbNlRUORAU//pU9Z2L77+MXg
	 YIGxz/cSJs2yVKP7ipp9qmdYsd3M3PgCycyl46oa5zOJGjLgIZ39Iz1ighy0GMT7Ps
	 z7Ch9KAxAEG8Q==
Date: Tue, 21 Jul 2026 16:25:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Suveer Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v7 06/11] fstests: verify f_fsid for cloned filesystems
Message-ID: <20260721232548.GU7398@frogsfrogsfrogs>
References: <cover.1781694879.git.asj@kernel.org>
 <2ac5fb22fd6b51973d11082a1ee8fe354926c63c.1781694879.git.asj@kernel.org>
 <20260701173314.GH6517@frogsfrogsfrogs>
 <328de723-6f9c-4f09-a68a-da24d49300d5@kernel.org>
 <20260721225703.GZ7380@frogsfrogsfrogs>
 <18d569b9-dbea-448c-8b3d-56de32c0d6ef@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18d569b9-dbea-448c-8b3d-56de32c0d6ef@kernel.org>

On Wed, Jul 22, 2026 at 07:21:15AM +0800, Anand Suveer Jain wrote:
> 
> 
> >>> just in case there *are* programs foolish enough to
> >>> use (fsid,ino) as a uniqueness check.
> >>
> >> On the other hand, if a program needs a unique ID, do we currently have
> >> any way to get one?
> > 
> > I don't think there is a way to get a globally unique identifier for a
> > filesystem image except for the meta_uuid filesystems, and even then
> > only if the volume manager resets the user-visible uuid every time it
> > makes a clone and nobody runs a duplicator.
> 
> Yeah, interesting problem to solve though.
> Do you have any further code review comments on this test case?

Not really, no.

--D
