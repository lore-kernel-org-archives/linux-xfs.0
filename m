Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D433DBB6;
	Thu, 21 Nov 2024 10:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732183560; cv=none; b=LCsQUpeWd4iUxD1cBG3MvdYoEXkpBe1QHnw/1KeD/Ffg01rpXNPX3kzMryQtfkCXGrLJrnpYKB9N7l+zGgtOfFnloMFF233tnOCD3x7vOE8jymZxna/mq1j1hTg1Rvm3XjNE+37uFOQiH012UIcdJES42f4mvYlrNeD+osQEcjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732183560; c=relaxed/simple;
	bh=k5pEBxZmLK9chqB1BIral9I47Ad7ucWSlWZ7mfoPJ2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQRj+INOMnxNvriLsLca1qbtz+aUXSMhBANQpVXQqUgoLML3EBG1cD4z4Iy7kB4CykN8ZbarFBj2SbA5bHYln09NfArhEKSYENxZTcomZlEfo0GQ5uR3ydloAdB9C5V6gbLuqd525aqFMAs9LoT/d7EasE379/yKelRXCk6qLmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 738E668C4E; Thu, 21 Nov 2024 11:05:55 +0100 (CET)
Date: Thu, 21 Nov 2024 11:05:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241121100555.GA4176@lst.de>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs> <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs> <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 21, 2024 at 05:56:24PM +0800, Zorro Lang wrote:
> I didn't merge this patch last week, due to we were still talking
> about the "discards" things:
> 
> https://lore.kernel.org/fstests/20241115182821.s3pt4wmkueyjggx3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/T/#u
> 
> Do you think we need to do a force discards at here, or change the
> SCRATCH_DEV to dmthin to support discards?

FYI, I'm seeing regular failures with generic/757 when using Darrick's
not yet merged RT rmap support, but only with that.

But the whole discard thing leaves me really confused, and the commit
log in the patch references by the above link doesn't clear that up
either.

Why does dmlogwrites require discard for XFS (and apprently XFS only)?
Note that discard is not required and often does not zero data.  So
if we need data to be zeroed we need to do that explicitly, and
preferably in a way that is obvious.

