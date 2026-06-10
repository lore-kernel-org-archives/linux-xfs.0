Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F685377541;
	Wed, 10 Jun 2026 06:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781073043; cv=none; b=AUHMJ1zHYdL+w8GDcBynIZLueXHVOPBJ2JEkYPLC4cfqVDge5J0k/f8F7FwYBQLPUlRY17BhuZXevsFScYaCOim9nFd9bUsIInAoX/+DqlM9N7Sgce6DosDpcJlP2nEs8Svngh7TAGxVmEO3vF9vKCs1oqP8ArHjHjg1/3MBjwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781073043; c=relaxed/simple;
	bh=uDKUPjWbLie9Ha6THyvnHCJ6AFIKmBktxnKriRll5CI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZyhrQ+dbP1UAOSSii2eeeXu4FngmbXS02kdGgs5dSCZW8LqdU32bq7s8bVb6OtgrMfCogp2urDvE2VodTnl87r3zub8KvpS1N2gUvmPXQ5uriPaB2VTC2YcYxyFGVNvLMq/NebqyH/bx+PfDS30ObTCdXRlf/Be+C9Bw6SqkFQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GqxGQkQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GqxGQkQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B1B1F00893;
	Wed, 10 Jun 2026 06:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781073038;
	bh=Zzg6g9gR1TTKMtYlvsMpqmomqBnLRSMkplbSpIkrY5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GqxGQkQDxIwIrG8Qr+9aqrdzTt2kHwdbco9lLQJU4WAJC+W8dIt5c0THiDTk7uisw
	 jlI29DMN36YaJweE4SVKZ9F0u9f8FY+RnDiRl5jcAriSOmfRpJLXsSyIXE6IckWQQC
	 v2D0JXhmrOeFn9ml/CaZvs9mEKjH3w9pxZ9V1G72sGZ0Ewln/41z/RRa/OQLxoNlu3
	 kfSbTMQSt3duCdfOnlQWgL4sklqsttcTEmpQ1NT2fGIb0e8dVg8gQbFBnvX0WnQcL4
	 lvQVavLyKbLnAMRZmKdljvNZlfcEncxT93nKSHsruUdnIl/7FA8TcP8A4g729q4ACH
	 8WqmALpSsWnlg==
Date: Wed, 10 Jun 2026 08:30:32 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] xfs: fix inode leak and clean up attr intent
 recovery
Message-ID: <aikEYaj5E-JXHhBS@nidhogg.toxiclabs.cc>
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
 <20260610022028.79846-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610022028.79846-1-gaoyingjie@uniontech.com>

On Wed, Jun 10, 2026 at 10:20:26AM +0800, Yingjie Gao wrote:
> Hi all,
> 
> The first patch fixes a leaked inode reference in
> xfs_attr_recover_work() when transaction allocation fails after the
> recovered attr work item has been attached to the defer pending list.
> 
> The second patch cleans up the same function's exit paths so they follow
> the same linear cleanup style as the neighboring bmap and exchmaps
> recovery helpers, and initializes the local error variable in the same
> style.
> 
> Changes since v1:
> - route the transaction allocation failure through out_rele in patch 1,
>   as Darrick suggested;
> - keep patch 2 focused on the remaining cleanup-path reshaping and the
>   local error initialization.

Please avoid sending new versions in-reply-to the previous version. Send
them as a new thread.

> 
> Thanks,
> Yingjie
> 
> Yingjie Gao (2):
>   xfs: fix inode ref leak in attr intent recovery
>   xfs: clean up attr intent recovery error paths
> 
>  fs/xfs/xfs_attr_item.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> -- 
> 2.20.1
> 
