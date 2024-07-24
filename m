Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13241581FD
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 13:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721827115; cv=none; b=FTN7Ee1GuC9x35UwLkfyxg0UdFako2eLe2VvLxG/7rHIhTD1jeIxoPLzcNwiVRMakQ9VBUArmROg41bvt6qNoR88SDu+4IEMke2YueAzBCRzXLyS93qxhVAwvtjAAlzJ71dl2C9Zyz0R7IXgwgHLvWX8YIbY+LsGVw15qp0RcOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721827115; c=relaxed/simple;
	bh=I03qkRSddsJM5fp8FsdbVbmbE2J2+XhshVqLHPAYO74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCNrWwngmW1ommH60lKY7XMVlzzd51KDvcXnSgRNSrtz/rNaH2MvpXVihKJgf2cGxS+x8Dr7hZx14E2dJWCkHHwWUZ65PcBktZYkXcdDyvAffR0ab0xf23jXDn4GziDZrCefidn7AJAJJpmIJX+lX+FEhL0YalmwrlzFqoKGglc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 304A168CFE; Wed, 24 Jul 2024 15:18:26 +0200 (CEST)
Date: Wed, 24 Jul 2024 15:18:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer
 services by default
Message-ID: <20240724131825.GA12250@lst.de>
References: <20240703050154.GB612460@frogsfrogsfrogs> <20240709225306.GE612460@frogsfrogsfrogs> <20240710061838.GA25875@lst.de> <20240716164629.GB612460@frogsfrogsfrogs> <20240717045904.GA8579@lst.de> <20240717161546.GH612460@frogsfrogsfrogs> <20240717164544.GA21436@lst.de> <20240722041229.GM612460@frogsfrogsfrogs> <20240722123449.GB12518@lst.de> <20240723232951.GT612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723232951.GT612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 23, 2024 at 04:29:51PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 22, 2024 at 02:34:49PM +0200, Christoph Hellwig wrote:
> > On Sun, Jul 21, 2024 at 09:12:29PM -0700, Darrick J. Wong wrote:
> > > You could also do:
> > > 
> > > for x in <ephemeral mountpoints>; do
> > > 	systemctl mask xfs_scrub@$(systemd-escape --path $x)
> > > done
> > 
> > That assumes I actually know about them.
> 
> True.  So, do we want a compat flag to opt in to online fsck?  Or one to
> opt out?  Or perhaps filesystems without rmap or pptrs aren't worth
> autoscrubbing?

I think an explicit flag is definitively the right interface, and it
seems like a compat flag is so far the least bad variant.  Note that
the flag should just be about automatic online fsck - any explicit
user call to xfs_scrub should not be affected.

> 
