Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0BE302CC1;
	Wed,  9 Sep 2026 06:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934350; cv=none; b=UwOaPIXTx2NIxCiwX0Oel1tqBFJ/kZmIM63Pxd91UZ/WaKBfBU09YqWnEaZSM53eYiN8vsnk7FnJFM6Fm1ee2Qm7olvrkpyZCkam1nEBxYRJ2k67vH6Baoma5AnmmjEau5MFx9Ogw8myEi3Geu7Fx0dHm9HkFiT2GYOPmd0VNyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934350; c=relaxed/simple;
	bh=/HSGzhhCGfAKOr0ksyK5rCyWeTHFO6fV07hOmKs+MHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5XbZ8NQl2fleRe8S5cxpPh1WNdYhHjh3nA4hHm9D1CgXj6/gwWX6C39bwb5Pj2yN5Ch71xzXYhQlkICOVSaKSPKGwCBffpMKmw+862TRkOFDkdH69KdQ5dZ1GturNYzcj71QznvCqQdO54kD8ZntoBHB1n5LuUznYFFmng7tDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZCII80jm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZCII80jm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5RTlTTuTGuZI8S4XM7VIrtv7XQ6b3ZOyGtBEq4+Q7N4=; b=ZCII80jmHC7kLXJW6qYVWEJheg
	zTqXpVZj2uq8lJZqB63d/VyG/nMkP+allHu+cqis6iUT7aG5WK2WH+l2nduz09BByCjayA5zXh8YJ
	C/hb1xWuS99ItmAYRLtCfLKVRAbeeMoBapRB7SfF/6Hk27D3f4COXmmwxfGioZq5R7wPAQMTN3/RM
	qdZptBpyRn7bNBKbka3+5HibDZPnilBD6DExQzzkSMeDPmfECI5nNrgPWJL3QB3juqjLg6lS6iNDJ
	EbWQEAbKG3sKs2kntplY+k/w/qdmaPst2elzRaemYHzTCkqILyspaW9egHrH0ug9NZtthROHyh77B
	ivgAjf4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BXo-0000000ArD8-3vsN;
	Wed, 09 Sep 2026 06:12:28 +0000
Date: Tue, 8 Sep 2026 23:12:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, zlang@kernel.org, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, jack@suse.cz, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] common/nfs: add management helpers
Message-ID: <aqD4zBD06P1LJKM2@infradead.org>
References: <20260907164054.111393-1-cem@kernel.org>
 <20260907164054.111393-2-cem@kernel.org>
 <20260908142226.GL839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908142226.GL839663@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 08, 2026 at 07:22:26AM -0700, Darrick J. Wong wrote:
> > +# Start rpcbind if it is not already running.
> > +_start_rpcbind()
> > +{
> > +	rpcinfo -p localhost > /dev/null 2>&1 && return 0
> > +	rpcbind 2>> $seqres.full || _notrun "Cannot start rpcbind"
> > +	/usr/sbin/rpc.statd 2>> $seqres.full || _notrun "Cannot start rpc.statd"
> > +	/usr/sbin/rpc.idmapd 2>> $seqres.full || _notrun "Cannot start rpc.idmapd"
> > +	/usr/sbin/nfsdcld 2>> $seqres.full || _notrun "Cannot start nfsdcld"
> 
> Aren't these daemons usually configured as system services?
> 
> # service rpcbind start
> 
> etc?

They usually are, but doing that as part of a test feels wrong.
Adding the relevant maintainers and list.

> 
> > +}
> > +
> > +# Stop rpcbind.
> > +_stop_rpcbind()
> > +{
> > +	pkill rpcbind 2>/dev/null
> > +}
> > +
> > +# Start the NFS server if not already running.
> > +_start_nfsd()
> > +{
> > +	rpcinfo -p localhost 2>/dev/null | grep -q nfs && return 0
> > +	rpc.nfsd 2>> $seqres.full || _notrun "Cannot start rpc.nfsd"
> > +	rpc.mountd 2>> $seqres.full || _notrun "Cannot start rpc.mountd"
> > +}
> > +
> > +# Stop the NFS server.
> > +_stop_nfsd()
> > +{
> > +	rpc.nfsd 0 2>/dev/null
> > +	pkill rpc.mountd 2>/dev/null
> 
> If the system under test has nfs filesystems mounted, won't killing
> those daemons also break the mounts?
> 
> I think that might break testing of nfs itself, and nfs-booted testing
> nodes as well?

Possibly.  I guess if we want to save we need to launch a container
or at least a network namespace this is bound too. 
