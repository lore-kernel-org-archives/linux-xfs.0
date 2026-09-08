Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19EC552946;
	Tue,  8 Sep 2026 14:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788877359; cv=none; b=JjT+RNd5HLmCP9rOXsiF9GOxYG3Ks7rPMyag0JEQItqu9t6BkgcF62tML4JKe7+TYOl9WkRitDU9MZP9r49oQOjHMxN6jb5WSPzkuGRgoKTpWRr3UOxac3q37qOopZUrorGjb0/skpi3jSYecsBvcZazydqg3grl8WhUQAgYZ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788877359; c=relaxed/simple;
	bh=FJk7cBetOOQEGZBxxCqam4eq3tuzeMNt5x32kVyeRiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LyhBtzcBYMR4jT+bmR4GW60v36et2UA/IFulFG9LsGr1O89UAXiX0eSniCGlZZn9yxMOwuJPitrtORxc3afyQqyt0FdVto7+zb4ySxWAZ83tHR/L/fYNiuj64a3AydHX0y2NQaAuAKQyXqT+5dA8RcODSGUARxJcwl8odW5yIAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOgJ3vy+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOgJ3vy+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 55C1D1F00A3A;
	Tue,  8 Sep 2026 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788877347;
	bh=YoCH8bBX02uieHIqiHGxMAN+zhpjPN8DaTdamO8H2CE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iOgJ3vy+RsZZ27/pxjRvpexuYNxIIagrGODCYVJKpBVtJiZZ8jgk3rCYq8Bs9CvkU
	 QFjk1H/td4qT1bwxxDYHStLLebVxGEX5EMuPUV6olRZKicPrB3phX/Y+JxFP663a0o
	 ukyWoOG3vxYNeR+tBF1o3w7mWMqGFZyJ9NNqqcI3Q7lEn8dEa/l8kf67SNmWbcUZ5b
	 b0i925A/4r+F72qUJttu7uIUSuDoAGtMZspke453paE6aUXfoDsY5Kx3z1yfGQGhcx
	 hZsjnPRE06ZwWZ2uxppRF+ptENFx/cyLsHzrHyaKJPqTgordheP2s2tjd/s+0IEEeQ
	 QyUNI64WFeP6w==
Date: Tue, 8 Sep 2026 07:22:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: zlang@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, jack@suse.cz
Subject: Re: [RFC PATCH 1/2] common/nfs: add management helpers
Message-ID: <20260908142226.GL839663@frogsfrogsfrogs>
References: <20260907164054.111393-1-cem@kernel.org>
 <20260907164054.111393-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907164054.111393-2-cem@kernel.org>

On Mon, Sep 07, 2026 at 06:40:47PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This adds a few new helpers to manage local nfs client/servers. These
> can be used to exercise bugs which happens through a nfs share.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  common/nfs | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/common/nfs b/common/nfs
> index a03eaf48e1c0..4508a8a2e494 100644
> --- a/common/nfs
> +++ b/common/nfs
> @@ -33,3 +33,58 @@ _require_scratch_nfs_version()
>  	fi
>  	_scratch_unmount
>  }
> +
> +# Start rpcbind if it is not already running.
> +_start_rpcbind()
> +{
> +	rpcinfo -p localhost > /dev/null 2>&1 && return 0
> +	rpcbind 2>> $seqres.full || _notrun "Cannot start rpcbind"
> +	/usr/sbin/rpc.statd 2>> $seqres.full || _notrun "Cannot start rpc.statd"
> +	/usr/sbin/rpc.idmapd 2>> $seqres.full || _notrun "Cannot start rpc.idmapd"
> +	/usr/sbin/nfsdcld 2>> $seqres.full || _notrun "Cannot start nfsdcld"

Aren't these daemons usually configured as system services?

# service rpcbind start

etc?

> +}
> +
> +# Stop rpcbind.
> +_stop_rpcbind()
> +{
> +	pkill rpcbind 2>/dev/null
> +}
> +
> +# Start the NFS server if not already running.
> +_start_nfsd()
> +{
> +	rpcinfo -p localhost 2>/dev/null | grep -q nfs && return 0
> +	rpc.nfsd 2>> $seqres.full || _notrun "Cannot start rpc.nfsd"
> +	rpc.mountd 2>> $seqres.full || _notrun "Cannot start rpc.mountd"
> +}
> +
> +# Stop the NFS server.
> +_stop_nfsd()
> +{
> +	rpc.nfsd 0 2>/dev/null
> +	pkill rpc.mountd 2>/dev/null

If the system under test has nfs filesystems mounted, won't killing
those daemons also break the mounts?

I think that might break testing of nfs itself, and nfs-booted testing
nodes as well?

--D

> +}
> +
> +# Require a NFS server to be available and start rpcbind and nfsd if they are
> +# not already running.
> +_require_nfs_server()
> +{
> +	type -P exportfs > /dev/null 2>&1 || \
> +		_notrun "exportfs utility required, skipped this test"
> +	type -P rpc.nfsd > /dev/null 2>&1 || \
> +		_notrun "rpc.nfsd utility required, skipped this test"
> +	type -P rpc.mountd > /dev/null 2>&1 || \
> +		_notrun "rpc.mountd utility required, skipped this test"
> +	_start_rpcbind
> +	_start_nfsd
> +}
> +
> +# Require a NFS client to be available.
> +_require_nfs_client()
> +{
> +	grep -q nfs /proc/filesystems 2>/dev/null || \
> +		_notrun "Kernel does not support NFS client"
> +	type -P mount.nfs > /dev/null 2>&1 || \
> +		_notrun "mount.nfs utility required, skipped this test"
> +}
> -- 
> 2.55.0
> 
> 
