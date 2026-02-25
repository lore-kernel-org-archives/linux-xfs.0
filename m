Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAD12288D5;
	Wed, 25 Feb 2026 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772040346; cv=none; b=rCrUmD8iBVSj66OPwdtb1ARvMiycomkTR0Y3Mabs1sclmQ2mnyTND5wyq07YQZBE/jxvMtFIMmbBBAn7ZMy22UHsnAWK6wiG/MmY4jukBhaGGhWr/tTyQtQoYSMFEvp8T70jXiH6wQ3pMWo70JdiF1i8NeEwFkAqv3uPyvBkMTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772040346; c=relaxed/simple;
	bh=p8R4Ww7RFY21q9W0pD5Z41a8JeTSb7gaD3dfnl0Tpe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6d9UFwIBWAckypZsGzMMNuUCVwYb5Uwsne95Fz+dXsT+rMbek3dmhnPCYogSIbS1liYRfNTYdbcMsGaKFD65Vebdk44e4Y2vTQQB9ZMtCNnOdEuGrkxEhJGUkRUwv9L+ebXAPnT3e/kv2rDL4mTH/FjBqCMV1FO1c2diB6LuNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLYTnb2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLYTnb2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB2EC116D0;
	Wed, 25 Feb 2026 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772040346;
	bh=p8R4Ww7RFY21q9W0pD5Z41a8JeTSb7gaD3dfnl0Tpe4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OLYTnb2nyp1wzhIjvx8nElbGFYLuQAaHQLSuPanuGheKUbcbI9fEZJOgPYBFbY3yZ
	 XiZz82ABBJRwz/wHcqKEYHDMB7kbAGcvYTK8W7vSuUkMRDoBOWnBzb+udWOk/P71aB
	 sNjrRku8lbID3bfDyyg5XJVbWP2z/cfjBuT8VYhdm77jOvBL9HqNyusqoI/voC0emm
	 XOHnIuk41ZS2ynj4LZacCU7ZZ9hOJLVeI5U59AwRfh86uGg6rE8uccC3HjKvvnkQ4O
	 gkHTRMcHj8EsziXuQ1pjxxhh97zCZgWqlfXGSURLYtxtt1K3SqP7m+zMVxPp3fj1GU
	 9HBF+DwMWxbQA==
Date: Wed, 25 Feb 2026 18:25:41 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Missing signoff in the xfs tree
Message-ID: <aZ8wf3k2-A8XlPoI@nidhogg.toxiclabs.cc>
References: <aZ7axQdS829sxNtl@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ7axQdS829sxNtl@sirena.org.uk>

On Wed, Feb 25, 2026 at 11:19:33AM +0000, Mark Brown wrote:
> Commits
> 
>   d412c65646d37 ("xfs: don't report half-built inodes to fserror")
>   d33f104ea40e7 ("xfs: don't report metadata inodes to fserror")
>   253b1a2ac9db6 ("xfs: fix potential pointer access race in xfs_healthmon_get")
>   fd992a409aef6 ("xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure")
>   61a02d38303fa ("xfs: fix xfs_group release bug in xfs_verify_report_losses")
>   9ee0cb71de74b ("xfs: fix copy-paste error in previous fix")
> 
> are missing a Signed-off-by from their committers

This should be fixed in xfs-linux/for-next, thanks for the heads up!
