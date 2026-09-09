Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2B569F04;
	Wed,  9 Sep 2026 16:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788970424; cv=none; b=bcJP8+4C/D7sW1vBJWJ5jr1ZTMlQ9krA2OnChW3BKNl75Pb6Z2DZgCaPxmrfx7187JnjJtZeJlTY53Ai3vI3Z32zxqouwpCVLlZYXxSnERDV6++cVzzXFZsxXDUJLlecW7/ZuntLCv3e0q9WhD2Gv3S9lt7fnqYXWsdgQ45hIHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788970424; c=relaxed/simple;
	bh=RBJxlg/idykcuwi3HDJDLPf7t991+IfOkI0IzHDwDN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQJI9tUU4Zmq8RxcVzme1dPPl6xgBxYcyu/ISOBFlSsXdUPxGNclfEUw5xfc6FR0wWPbQA7fxHTxW/y47irocicOoWSQ+G7teSmcg2JrYlkiS+pEty2cN2kBiHz5tfYhjV5jF+u+opAio2rBad5VSnIQtZkCe3cvMHNx42PMV4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIOzgYYJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIOzgYYJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D0D381F00A3A;
	Wed,  9 Sep 2026 16:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788970422;
	bh=9R6n5gAut7J0vGQO3tV0Eu91YgLXk3i204riuAduC7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JIOzgYYJf7ydObpr+295j/CRPFkQFFADV+Ly/dnEZKE84U9LyQlCFRJZ8wjlNMUFu
	 bzk8eNhiMGhm2xTAAXrDc1PULzuwncWdbej6HyMHoZxta2LNRfir98IhM/b1+Vuy+r
	 VtO3DYMehjPlwOdFtctDpItoXnm6wy+47cpGo9Fus5nDmJ06ehTacjjHLMfpWl04+7
	 7u1b4ywO+ZfwyCErQK1tWmIpQCvi7rgyQ8Oo5dIVbmJmjV/wDhFaV0trzmJ4mjF2Ax
	 PtJEKVuO+QPj7EufEGaPjS6jIqu43BvoE+TEj89LgI5IL6hikDwKAv6KdToTRnYeUn
	 8sroh8oOa4BoQ==
Date: Wed, 9 Sep 2026 09:13:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, zlang@kernel.org, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, jack@suse.cz, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] common/nfs: add management helpers
Message-ID: <20260909161342.GM839663@frogsfrogsfrogs>
References: <20260907164054.111393-1-cem@kernel.org>
 <20260907164054.111393-2-cem@kernel.org>
 <20260908142226.GL839663@frogsfrogsfrogs>
 <aqD4zBD06P1LJKM2@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqD4zBD06P1LJKM2@infradead.org>

On Tue, Sep 08, 2026 at 11:12:28PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 08, 2026 at 07:22:26AM -0700, Darrick J. Wong wrote:
> > > +# Start rpcbind if it is not already running.
> > > +_start_rpcbind()
> > > +{
> > > +	rpcinfo -p localhost > /dev/null 2>&1 && return 0
> > > +	rpcbind 2>> $seqres.full || _notrun "Cannot start rpcbind"
> > > +	/usr/sbin/rpc.statd 2>> $seqres.full || _notrun "Cannot start rpc.statd"
> > > +	/usr/sbin/rpc.idmapd 2>> $seqres.full || _notrun "Cannot start rpc.idmapd"
> > > +	/usr/sbin/nfsdcld 2>> $seqres.full || _notrun "Cannot start nfsdcld"
> > 
> > Aren't these daemons usually configured as system services?
> > 
> > # service rpcbind start
> > 
> > etc?
> 
> They usually are, but doing that as part of a test feels wrong.
> Adding the relevant maintainers and list.

<nod> I guess for this test we actually want to launch our own nfs
daemons in a separate pid / network namespace so that they don't
interfere with nfs operations outside of the test (e.g. testing nfs
itself, nfsboot, etc)

> > 
> > > +}
> > > +
> > > +# Stop rpcbind.
> > > +_stop_rpcbind()
> > > +{
> > > +	pkill rpcbind 2>/dev/null
> > > +}
> > > +
> > > +# Start the NFS server if not already running.
> > > +_start_nfsd()
> > > +{
> > > +	rpcinfo -p localhost 2>/dev/null | grep -q nfs && return 0
> > > +	rpc.nfsd 2>> $seqres.full || _notrun "Cannot start rpc.nfsd"
> > > +	rpc.mountd 2>> $seqres.full || _notrun "Cannot start rpc.mountd"
> > > +}
> > > +
> > > +# Stop the NFS server.
> > > +_stop_nfsd()
> > > +{
> > > +	rpc.nfsd 0 2>/dev/null
> > > +	pkill rpc.mountd 2>/dev/null
> > 
> > If the system under test has nfs filesystems mounted, won't killing
> > those daemons also break the mounts?
> > 
> > I think that might break testing of nfs itself, and nfs-booted testing
> > nodes as well?
> 
> Possibly.  I guess if we want to save we need to launch a container
> or at least a network namespace this is bound too. 

Agreed, some isolation from the main system is necessary.

--D
