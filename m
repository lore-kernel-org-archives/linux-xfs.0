Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2DC2DE6F9;
	Fri,  5 Dec 2025 08:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764922116; cv=none; b=ipr8veyS4FU/fVbFFFnR8/BrZFuZ4KnHTjk8+OhqhR8lSPzyl5EX3V1UFA2EBrBgYBirutyTJOIluai7i21WTpKhtXlzmXRwGQxj3Ys0d/DVXpKl1r8pV63CKPkGEnh49i8QR5ODHAZa6GTPHhikFoyQCCIYAJMAq5MWCQC0/8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764922116; c=relaxed/simple;
	bh=X9YJVrXg/E8Y8xk7YxVFe1E/gPNuCMMcA0eK2LiLYuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2B4QA+4Ck0acfvwhe/1y58vSGvaKHISsAuzviWXBk+GSMV+9r12mWEIr6NSgj1OPvX+gdIq2pxUv0y42tmj9neRWdi8d1ZOIovWifSdy+rfn8/z0sq6x9XoWqwVlf/wZQthxT0XgR28fgO6n1uvndjhyFFLvZUAM2ScBgy/tn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CB9C567373; Fri,  5 Dec 2025 09:08:11 +0100 (CET)
Date: Fri, 5 Dec 2025 09:08:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/158: _notrun when the file system can't be
 created
Message-ID: <20251205080811.GA21212@lst.de>
References: <20251121071013.93927-1-hch@lst.de> <20251121071013.93927-4-hch@lst.de> <20251205073125.tddypzbg7lyrzwna@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205073125.tddypzbg7lyrzwna@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 05, 2025 at 03:31:25PM +0800, Zorro Lang wrote:
> > +_scratch_mkfs -m crc=1,inobtcount=0 || \
> > +	_notrun "invalid feature combination" >> $seqres.full
> 
> Hi Christoph,
> 
> BTW, shouldn't we do ">> $seqres.full" behind the _scratch_mkfs, why does that
> for _notrun?
> 
> Two patches of this patchset have been acked. As this patchset is a random fix,
> so I'd like to merge those 2 "acked" patches at first, then you can re-send
> the 3rd patch with other patches later. Is that good to you?

Please drop it.  I have some ideas to attack the whole set of issues with
combining flags in a more systematic way, but I'll need some time to try
and test them.

