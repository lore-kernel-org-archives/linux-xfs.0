Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6FB3C3F56;
	Thu, 10 Sep 2026 09:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033555; cv=none; b=s4Wdov0YcLeOIbENo5g3g+uwmEBrjfzJlme9QsFB+HWmCFf2vHZPn4dPPycOeHzqCJdJleM81FLhtoG+CvPx+grFZ9nuG1Nbcbt4xBB+fw0lbU2SqJYLx1mGcs220UbE1I6dmY25lxrARBiIcq2S5CE/WtxPSJZ00GMactChKGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033555; c=relaxed/simple;
	bh=csESozxErtQjNOPRbAd1+0bBzb9dIpicyIwuiqnP10A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lp6CR1IUpmYfwDJ61qOjGFwxwIzU6oiIsk3RwD6JgIr1J2IFq0vP3FRFpVBHMjFfWir4ZVqidODH/k9/GTS30y4fUuktSYj1Kzbt5ITQKS2G0sW/PKgR5dK+WqGjp3g/fNY3w562C1Y4CgXE85/KoXBHJ19jJDx6VzBA2RJGg/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UEYdSSOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UEYdSSOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0131F000FF;
	Thu, 10 Sep 2026 09:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789033552;
	bh=VyWNnrPW/HP25ItR9KF1992mjUCoCMkFMvf3FwtLiI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UEYdSSOsH+1gdsAvcElFZKtXkZho4L7TCrJ1zGphMgNcst3uLprux2fCTW6r+nTZY
	 z86AB9LyV8ZCIsTNw9ttNVgCRvJvZ923wRKYOBhw27XWdtj5VGGFjVNStdCjNSrvR3
	 Ow/CBUaqli9kbYDv+Mw57xf2Qe6uP9uD/D2LmppOlYCnL1PavAtIu8VPh/mEMfRRDC
	 Y92JNrEHG4uliV73f5J9RoWER9F6TumKag0ng7NwCtXpIIYYmkSansW/T4NGxmXnq8
	 i/Szf/njGyC7CWm6IVKEsRvDeIVyKXj1ZmRGyMSak7BXwygckYt6Bf9QButrhVZwAP
	 xSpGsLEQBu8/Q==
Date: Thu, 10 Sep 2026 11:45:47 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@kernel.org, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, jack@suse.cz, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] common/nfs: add management helpers
Message-ID: <aqJ8BdzSlasSNXRd@andromeda.toxiclabs.cc>
References: <20260907164054.111393-1-cem@kernel.org>
 <20260907164054.111393-2-cem@kernel.org>
 <20260908142226.GL839663@frogsfrogsfrogs>
 <aqD4zBD06P1LJKM2@infradead.org>
 <20260909161342.GM839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909161342.GM839663@frogsfrogsfrogs>

On Wed, Sep 09, 2026 at 09:13:42AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 08, 2026 at 11:12:28PM -0700, Christoph Hellwig wrote:
> > On Tue, Sep 08, 2026 at 07:22:26AM -0700, Darrick J. Wong wrote:
> > > > +# Start rpcbind if it is not already running.
> > > > +_start_rpcbind()
> > > > +{
> > > > +	rpcinfo -p localhost > /dev/null 2>&1 && return 0
> > > > +	rpcbind 2>> $seqres.full || _notrun "Cannot start rpcbind"
> > > > +	/usr/sbin/rpc.statd 2>> $seqres.full || _notrun "Cannot start rpc.statd"
> > > > +	/usr/sbin/rpc.idmapd 2>> $seqres.full || _notrun "Cannot start rpc.idmapd"
> > > > +	/usr/sbin/nfsdcld 2>> $seqres.full || _notrun "Cannot start nfsdcld"
> > > 
> > > Aren't these daemons usually configured as system services?
> > > 
> > > # service rpcbind start
> > > 
> > > etc?
> > 
> > They usually are, but doing that as part of a test feels wrong.
> > Adding the relevant maintainers and list.
> 
> <nod> I guess for this test we actually want to launch our own nfs
> daemons in a separate pid / network namespace so that they don't
> interfere with nfs operations outside of the test (e.g. testing nfs
> itself, nfsboot, etc)
> 
> > > 
> > > > +}
> > > > +
> > > > +# Stop rpcbind.
> > > > +_stop_rpcbind()
> > > > +{
> > > > +	pkill rpcbind 2>/dev/null
> > > > +}
> > > > +
> > > > +# Start the NFS server if not already running.
> > > > +_start_nfsd()
> > > > +{
> > > > +	rpcinfo -p localhost 2>/dev/null | grep -q nfs && return 0
> > > > +	rpc.nfsd 2>> $seqres.full || _notrun "Cannot start rpc.nfsd"
> > > > +	rpc.mountd 2>> $seqres.full || _notrun "Cannot start rpc.mountd"
> > > > +}
> > > > +
> > > > +# Stop the NFS server.
> > > > +_stop_nfsd()
> > > > +{
> > > > +	rpc.nfsd 0 2>/dev/null
> > > > +	pkill rpc.mountd 2>/dev/null
> > > 
> > > If the system under test has nfs filesystems mounted, won't killing
> > > those daemons also break the mounts?
> > > 
> > > I think that might break testing of nfs itself, and nfs-booted testing
> > > nodes as well?
> > 
> > Possibly.  I guess if we want to save we need to launch a container
> > or at least a network namespace this is bound too. 
> 
> Agreed, some isolation from the main system is necessary.

Perhaps couldn't we just:
	- start nfs server if not started
	- only stop nfs server if we started it

And just take advantage of the server running if one is already there?

> 
> --D
> 
