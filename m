Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AC03148A3
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774021494; cv=none; b=KmNTNnq/C8UydA8O0BY1bOlACPu8udY0zxJazXQWUKBrt72lmakkRjFhmcuxuPM/hQZL0Qf+2vtnj47e5QRFlQ0iX83SEfXuAPOAn5WJdhrw6FCQRje27GwMdkMLgp2RF+kNTo2Wc0VTCbbB32z/6ueN+zyrK2DUrF90DsipWOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774021494; c=relaxed/simple;
	bh=HHyurZ1LW6oAOwIF7F7SAtgz7qc9h3mZRFUSrlU28cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heTvsKQxwDPQlQcQboQoKHGOB0Xu0ocPmCq8eqW9nA6ng8ahQfWyPpuhBNEJ25RoAAsNHAFJhujjSUYNRDYSTKHsSjPmHtScK5510O94FVb9Gg10rxpgZaB5avlCCJw5k6yKSmgJNTSeqoccK2gm4xov8Y3GG0DPmJOqXDP6H3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qHy6eARv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qHy6eARv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB8FC4CEF7;
	Fri, 20 Mar 2026 15:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774021494;
	bh=HHyurZ1LW6oAOwIF7F7SAtgz7qc9h3mZRFUSrlU28cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qHy6eARvkkQRwhdrLNCHZ3a46LduqA4MF/Yzs8lxAsbin4tMv0cxxHIIfN6OE1RVg
	 Wm0YiuCKV9USM8b9cjfcKdtxZb6wR2z58ib2Vxj2AymW1PApVPUgM0O4kYBOQ7PJ18
	 O3DR/mdW3PmusTOjUAqxzPJGuBLJAsnxNekDipuwghzzfTLSJr0QFC45Hx5TS16wku
	 uhqZwWbAljRxXFHrm/UcpOra7HryXyCuK/eVIfj4wlkBy/OE7w5s9gqD1jA5raL55d
	 +MiqZpcBS6j/Oen7Sj4D27mpOq5D+RbJzMWnxOsFtS/i6AXS8b9uwRHIP4F00jlbM8
	 VGMXce+JiYe6A==
Date: Fri, 20 Mar 2026 08:44:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/22] xfs_scrub: allow overrides of the media
 verification IO limits
Message-ID: <20260320154453.GC6223@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507344.3681140.4424251568194204096.stgit@frogsfrogsfrogs>
 <abz0jpxjiVBe0hEQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abz0jpxjiVBe0hEQ@infradead.org>

On Fri, Mar 20, 2026 at 12:17:34AM -0700, Christoph Hellwig wrote:
> On Wed, Mar 18, 2026 at 09:51:16PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Allow power users to override the media verification IO size limits via
> > magic environment variables.  For the background service, this can be
> > done via:
> > 
> > [Service]
> > Environment=XFS_SCRUB_VERIFY_MAX_SIZE=128M
> 
> So you'll need to hack the systemd unit files?  How could we set this
> on a per-file system basis?
> 
> Not really arguing against this, but we might end up needing more
> flexbility in the end.

I'd do per-fs tweaks by defining an xfs_property and telling users to
set it, e.g.

# xfs_property /home set scrub_verify_max_size=128M

I don't think we need to define the property right now, that can wait
until someone has time to do a more in depth analysis of what settings
adjustments are needed for modern hardware.  I'm keener on figuring out
something that'd work more automagically because sysadmins are lazy. :)

--D
