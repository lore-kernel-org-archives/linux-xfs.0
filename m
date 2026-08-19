Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDBF25D53B;
	Wed, 19 Aug 2026 06:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787121188; cv=none; b=qVMvQCnwmszj8p20EY5tt+1AYsQy86PKBwaA+474Y/EL2bh2eB/Vqv8A4qXIi1a9b6DYgpQOMx7O1XhcYYvKmaLQMMyisoAzJHuAVGh6aPkwzEBjOvvkX04kM/EuwwdD9/o9qxENSR1jlVizVaMDGanjwf/KnrUNdf/dFP+Aq9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787121188; c=relaxed/simple;
	bh=GkhdoA3GF8GRaB1drCXSfTmywe9JA0HEe+6i2N2zIeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rLAfwjbrwP1blCqsqiPu8on6fHfuGJ5v0AR110h8EkoWLS4wULGgispU179cOBaIEhpD38xSQ3gl6xCC+GHbHxjFvXj6xEiSl0pqrPPrgDsShPbB9H5aSvAPzD/EBYZ8YMHDrBBeFK5AOOXQkq3CYsVa5QCBrGoYTZPvAYH110s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lTTW0fad; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lTTW0fad"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vp/cB2HMjc5Sw9FbFEOd6bGPDO5KXHhMXqFz6OOCWr4=; b=lTTW0fadlGZFkOk2QA2YlGVKHN
	rUXlGjN8a+DRhAlq0kRa772EC2FsTX5WitWK0bb9ZJH1Mj1si6J7xoeXdGefd5Wi4Y1p25370xNiA
	PT1XnPBMBbqwgoheOEu7egTDXA/1Aj7JTmzU1rWNUmdVpSv6RIVRWGAcEx7b3hbk4gt6hk30NVK6x
	JAEpPS855Q3S8pWFNvdu33OOrDe32lG6RdOV7cx0RkoU191QwsIA9QEtl0BNC+zzmwh8J9cHN2Fli
	szxg+yoJvnE8I+Yja4ZXWJ11xdiAchwmBuWzlMxWHX+hAZ0zvr1QUut3X1oHWG5Jc6HOwVfUuJNqf
	qAohj+kQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwZrF-000000096V3-3NNo;
	Wed, 19 Aug 2026 06:33:05 +0000
Date: Tue, 18 Aug 2026 23:33:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: adjust datadev sector count to reflect internal
 rt volumes
Message-ID: <aoVOIZqmmAI7FYlm@infradead.org>
References: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
 <178659861593.833642.6889273918398598117.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178659861593.833642.6889273918398598117.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 12, 2026 at 10:25:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A media scan of a filesystem containing an internal rt volume produced
> an error in xfs_scrub phase 6 complaining about a truncated realtime
> device.  The rt device wasn't truncated, but the media scan code thought
> we were trying to start a scan past the end of m_rtdev_targp.  That in
> turn is an alias for m_ddev_targp, but in xfs_configure_buftarg we set
> nr_sectors to the size of the data section.  Oops.

Can you share your reproducer for this?

> 
> On these filesystems, the internal rt section comes immediately after
> the data section.  We need to set the sector count for the data device
> buftarg to the size of both sections.  Without this, media scans don't
> work and media failure notifications from the kernel will be discarded
> silently.
> 
> We also need to fix the superblock buffer recovery code to do the same.

I still think messing with the kernel buftarg nr_sectors is wrong for
this.  The kernel view of the buftarg should be correct and just include
the part of the device that matters.  So I think the right fix in the
kernel is changing xfs_verify_media to add the internal RT device offset
before sending the bios.   We might need additional userland fixes,
but from a quick look I think it should be fine (famous last words)
