Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C806E4582EF;
	Thu, 10 Sep 2026 11:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789040451; cv=none; b=c6j64ahsrBJAhyYMzqJVd6mXPypaR04bWYNOZ8nhWOoGin3q4K9p22X2AgrZprbN3Zkj71Mv8pxS0TvkRZ9YNJcS3w/A3bLxA1cZN1EQTL61HqbE52xJqkIbGujK3u0UHmkrqsmL8KlqjzCOnDFkZH5scf+rl9d1n2XzYiIYmX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789040451; c=relaxed/simple;
	bh=KklE+Hr9lHrkfqKr55b1pyQCo4ZNcE9E/mqsaG6l5OM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nc1ry0gjaL/Yve9uxj+zXXUD+EZUVt6rGt6/CEbkKorLgnuXTZkcPpIFJtuYlQnpSe3B7EX+WWIEVZFu3ODcypGmlbnosMblw5X0AFFDpmJwpZFvL+bNXIYBnRpndBzdkGKnpr8wCZ9Kj2kw7tuISlxfpmG3Men/O2XwjYbdWRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPnC12SU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPnC12SU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C771F000FF;
	Thu, 10 Sep 2026 11:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789040449;
	bh=xlMMqsd9T4BDh+CHmkrIy8z//a0wpFijF41uVmhuA2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PPnC12SUioGBK3aax90C0EH+oL/LQlOLFjjkZ2ZAbvHWtFvcvlEUN/1M0SXf4y3pz
	 OP1Y09vwE4zELSxvVc2mmcGL1JwNMSzSlVvX+P1guug02pRrm/PlSsWZ2llNnXW9Jm
	 2nWWuj8snvTIbeUfbiBvYeeY3rrJCLw3Tts7iV2bF+82F/fIXTL23aG6zv+GMWWvvc
	 pnhzZCFhVMkzp2aWzKgN47qrN3WCuMUvjHZtxBh/fMR7Q9eca/LVkqpSiw8FIHSST/
	 +4ynmhOCl64mfUgI1lwOGyDH+FegtYfz9OhFbVH7PsuvJp9Mp+MlTVxIeUiXO2+8Kg
	 ez7ZppGvAYyag==
Date: Thu, 10 Sep 2026 13:40:44 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, zlang@kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org, jack@suse.cz, Chuck Lever <cel@kernel.org>, 
	linux-nfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] common/nfs: add management helpers
Message-ID: <aqKWMY5yebKmUE6_@andromeda.toxiclabs.cc>
References: <20260907164054.111393-1-cem@kernel.org>
 <20260907164054.111393-2-cem@kernel.org>
 <20260908142226.GL839663@frogsfrogsfrogs>
 <aqD4zBD06P1LJKM2@infradead.org>
 <208df4dabcb9db9c6c7d00f4cf2f63fa3be815e1.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <208df4dabcb9db9c6c7d00f4cf2f63fa3be815e1.camel@kernel.org>

On Thu, Sep 10, 2026 at 07:30:46AM -0400, Jeff Layton wrote:
> On Tue, 2026-09-08 at 23:12 -0700, Christoph Hellwig wrote:
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
> > 
> > 
> 
> I don't see a problem with using the normal systemd services as long as
> you're just doing a "start" instead of an "enable". That would be a lot
> less likely to bitrot than these scripts.

My only concern regarding using systemd services is portability. I tried
to keep the test agnostic to the init system being used, but it indeed
would be way easier to put this into xfstests if we just accept this
will be a __not_run on systemd-less distros. Giving the majority of
people I know frequently running xfstests (including me) uses
systemd-based distros, this wouldn't be a problem for me personally...

> 
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
> Doing this in a container would be better and less likely to interfere
> with other stuff running on the box. Our container isolation is still
> not 100% perfect with nfsd (there is still a global mutex, etc.), but
> we're getting closer.
> 
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
