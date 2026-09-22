Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B8A43B6DA;
	Tue, 22 Sep 2026 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790080177; cv=none; b=dmz2XXK8p4i7fZGHBIkNQikQzY//q2mkyU390CXVP9wusLzO0zMmIpP6Cc75oN51ERSbOthEOWb2BwpI8euLA9qF4OVZ1Jd9YrvpUFJJcFlj5MqNUk67GxnXJ6uj23tfZ1rVD2bdYjLDNKLi/D0L+L2jRAvovwObyDy07gUMurM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790080177; c=relaxed/simple;
	bh=yQ+U4XZCYy44+RkfZNVReW6Q63ZGKd1VRAiBXXQOG+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gyDXZqBrxWXXT38rFkdDULNM7RXpzVRPjA2SM4aymEdivUGlPV91LWoqSeEUrqfRd8rJD6sUMBiUfH0YucPDO39u5ZSLm51b55aKJbTEBfzTiLFaOZdpwqqzDVQG6LudtHKSFWYajffmk8d8n4BFA0C1GYfdoPjqcr46prWT+5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MF6G13Vo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MF6G13Vo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0I42Cxwy1gWdxihb7G1jRdQeFiN50ZxPBQZhSNRVuS0=; b=MF6G13VoSsYuEzodrQpQVxlqcs
	ukXcDXXfv1lL3PR4Kxs+5fA9CJlPiA2gnVQ4iVVijWZ6FmHm/kY0nvBwhizIhBco9UgvRsizvGeO5
	27bHioJjHlJlGNI51k5U3SJOFF45FMeFK1gbYfT2A7i0YA5Ucu/8+wXU8TEb6wErISrLdTxbkDoxR
	Cr+/6KD8IGe4AKBtfaB4px7Rdb7lxN+DC4M460Crty2yp2T5l5bpaS7gjTVG/doEXvhPDE1KTHTfH
	UYyDGC9+1es4GrLcZgrwuGERapTgAKGubeko41aW1YLWYYmf1mf35Nq04Ksu3DrQUOUipvg+Vcojc
	s6cN6t3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8zcn-00000005JCz-4799;
	Tue, 22 Sep 2026 12:29:29 +0000
Date: Tue, 22 Sep 2026 05:29:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: don't resubmit an ioend after
 ->writeback_submit() failed
Message-ID: <arJ0qe1KZoIaRCQk@infradead.org>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-2-parri.andrea@gmail.com>
 <arITIy2upsoN-DlW@infradead.org>
 <arJETViXYZbX8ckp@andreayoga.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJETViXYZbX8ckp@andreayoga.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 11:03:09AM +0200, Andrea Parri wrote:
> Yes.  xfs_reflink_convert_cow() is the only in-tree way
> xfs_writeback_submit() can fail, so I added a boot param that forces
> it to return -EIO, reflinked a file, dirtied several widely
> separated CoW regions so writeback has to submit more than one
> ioend, and let background writeback run under the fault injector.

Can you add an errortag in fs/xfs/libxfs/xfs_errortag.h to inject
such an error and write an xfstest that uses it?
