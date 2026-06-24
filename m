Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B741F4C96;
	Wed, 24 Jun 2026 13:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308444; cv=none; b=PQBU5Po2rEeCRWB4kWbCxdw+2AaHc7YUeT+ZXD+UEsJ8MfetTux2K08hNgb+3UwFvD+/ew3TV7arI7WOdn8hnZk+gI2UxDQ0zMQ5cAywh8eZ7YdDplylg6h0U4obX/etqtPJOCsqchLlo+lJhTRaIciUEjYvgmuqQoTwLsrdO6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308444; c=relaxed/simple;
	bh=I8OzF5ucG5cy5yK/yi1L9HMqVYLuGARpoBRv1k/nvjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDG2AeLKZGhakPHfsyOYaKVXSHmPcxv4SrHfZkYttVAc+2kZlZt7c1+C46STjZFr1mcR047cdOrzsl4iJ9qkc7lubWJcvFssNBO8BZNoGERraxrkoP7pfoegWDP6NEeaj+H0kqKtlyRUtnkUpZix5SE9n1OOqYNXRTlYscZwsXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7BF8B68B05; Wed, 24 Jun 2026 15:40:39 +0200 (CEST)
Date: Wed, 24 Jun 2026 15:40:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] xfs: fix capabily check in xfs_setattr_nonsize
Message-ID: <20260624134039.GB5649@lst.de>
References: <20260624101436.362533-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624101436.362533-1-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Adding Jan and Christian for quota and user_ns knowledge.

On Wed, Jun 24, 2026 at 12:14:29PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> An user reported a bug where he managed to evade group's quota
> by changing a file's gid to a different group id the same user
> belonged to, even though quotas were enforced on both gids and the
> file's size was big enough to exceed the quota's hardlimit.
> 
> Commit eba0549bc7d1 replaced a capable() call by a
> has_capability_noaudit() to prevent unnecessary selinux audit messages.
> Turns out that both calls have slightly different semantics even though
> their documentation seems similar. Where in a nutshell:
> 
> capable() - Tests the task's effective credentials
> has_ns_capability_noaudit() - Tests the task's real credentials

Eww..

> This most of the time has no practical difference but in some cases like
> changing attrs (specifically group id in this case) through a NFS client
> this will allow the quota code to use XFS_QMOPT_FORCE_RES, effectively
> bypassing quota accounting checks.

Yeah, this does look wrong.  Do the other conversion in the above commit
have tthe same issue?

> Using instead ns_capable_noaudit() should fix this issue and prevent
> selinux audit messages.

The generic quota code manages to do without either has_capability_noaudit
or ns_capable_noaudit.  I think this might be hidden behind
inode_owner_or_capable calls.  Any idea why we're different?

> +	bool			force = ns_capable_noaudit(&init_user_ns,
> +							   CAP_FOWNER);

I'd do away with the local variable here.

