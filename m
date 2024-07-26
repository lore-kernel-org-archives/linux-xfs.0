Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FA31B5A4
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jul 2024 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722006906; cv=none; b=azJRUY7HqXAmDRoxa4sd9M5VV4PoMHM6BNtDAQkXTie43LZm/KYF+qxkIq1Rqn1pyWI84L+QL6a8MOVPDNkbQRmm5NCviHcCbl8hm9yxI9TzUlsUGlq6LIBY0E4i3qJ8Ex+a+JvzIQTc3As3/0NJPKfn15H2DEDTI6Vfr1xWNd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722006906; c=relaxed/simple;
	bh=wgObQ+2Q477W9Cstpfp+ZL6UxGZAgoaR5ReKy9Lpuw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMC48yJtgaiN7K8LGzGLq9AzLXfnPh/X43TJNkEI6FGAp2r9P5EfCVk33B4pHY0uJyCmLt4j9bkGFEreCHQhn8xY5Q22/BRCk5GNp4T0f8tWwk7mT0gZGK4RrtkCrmkEtH1emTma/BAZbQ0o+yn3d6u7a913iSJiPHdIzYiPwhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+qblEMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+qblEMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA14C32786;
	Fri, 26 Jul 2024 15:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722006905;
	bh=wgObQ+2Q477W9Cstpfp+ZL6UxGZAgoaR5ReKy9Lpuw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F+qblEMSkXlQdqhjxbXmfcR6BzNDbu0mJ0n5cTp4S6mrwNQNCvK81YOa28kXGVa6+
	 mgh2l7jXffRVk3JnJNOik1QIPBMLkOimb27yiRsLCrfQeWDubBPYQTkt5OxRPpf7bl
	 GLhMZ1Ks4pTx4uevrtn7WPL5pMxtKazF/OG96i6hEw6PKql+S0K7MLxzbbQUhETVML
	 l3v0I+ILTs+1/V6my+mH96lEOJpnvObCIRlr44t5OO+856HdnocWyWA4X24vjnDHET
	 NtqkRsN3UsoW9L0awDPIvAkFvwPJh9T5qy8DyBRNMQj808gSPZmM1HAO1DBT7z2Mb9
	 cKgcOyYg2hrGg==
Date: Fri, 26 Jul 2024 08:15:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [RFC] xfs: opting in or out of online repair
Message-ID: <20240726151505.GJ1646003@frogsfrogsfrogs>
References: <20240724213852.GA612460@frogsfrogsfrogs>
 <ZqGy5qcZAbHtY61r@dread.disaster.area>
 <20240725141413.GA27725@lst.de>
 <ZqLSni/5VREgrCkA@dread.disaster.area>
 <20240726004154.GD612460@frogsfrogsfrogs>
 <20240726135948.GA14758@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726135948.GA14758@lst.de>

On Fri, Jul 26, 2024 at 03:59:48PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 25, 2024 at 05:41:54PM -0700, Darrick J. Wong wrote:
> > > requirements that have been presented so far...
> > 
> > <nod> Ok, how about an ATTR_ROOT xattr "xfs.self_healing" that can be
> > one of "none", "check", or "repair".  No xattr means "check".
> 
> Fine with me.

I will also add "optimize" for -p.

--D
