Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1050CA6B
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 06:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734242605; cv=none; b=ux85QDHAUho9vQeTcFhpv1pQ3j/M9fSu/L1HWKG8/NIzvnsxMI4UHbUbCdYtwRefnjyIzhCXRs5T2BkijG6K0epGEqxp0ZiqnZj976CQstnrnP3siNX/pjUTmF6bzV6GNkAEOLBiFG4HkcLCgshFh93A1ZWKG7JmA6RUIrtpUVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734242605; c=relaxed/simple;
	bh=1Fs6+MvUdgl2u6SblmtsTS3CsnJ6Zj/nr8atfYmEYlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckceIKbVjJvy6fcHqZnfP6cHT6eZlDLenBMYhEj7sIMG1QUDfNfgIfXK4j8KtDAOy+yAIgfYY2daazBR9wWK+OQEx2EeGFtVznZIBR0KgLR9exgTpuucMejdp1k2kUS2FUdzXbcIfMU4tqLdk455toP5AVFT62rh/36pQvn5trA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 936AB68C7B; Sun, 15 Dec 2024 07:03:19 +0100 (CET)
Date: Sun, 15 Dec 2024 07:03:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/43] xfs: hide reserved RT blocks from statfs
Message-ID: <20241215060318.GG10051@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-31-hch@lst.de> <20241213224358.GT6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213224358.GT6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 02:43:58PM -0800, Darrick J. Wong wrote:
> > -	st->f_blocks = mp->m_sb.sb_rblocks;
> > +	st->f_blocks = mp->m_sb.sb_rblocks -
> > +		xfs_rtbxlen_to_blen(mp, mp->m_resblks[XC_FREE_RTEXTENTS].total);
> 
> I wonder, is mp->m_resblks[XC_FREE_RTEXTENTS].total considered
> "unavailable"?  Should that be added to xfs_freecounter_unavailable?

That messed up the set_aside calculation in xfs_dec_freecounter and
I think also xfs_reserve_blocks.  I tried this early on in the project
and it made a complete mess of the free block accounting.

