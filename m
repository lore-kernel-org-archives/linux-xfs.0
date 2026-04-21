Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36971298CAF
	for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 05:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776750529; cv=none; b=eWXZExCDh6rHzCopF0IkLHdOvTV6HR1sxB7jzkdT6J/82SW4Z9n32MEkbJRS3P+rrhZMdpcI0UzaHGVpraPqImx++T3mEWgVywVmHKRkk78pk0OppWVeOhC4ceEZy89xb31WiW2m0dkgOX9F3NlI2PSK6+X8fxEw5PyWAHlAzXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776750529; c=relaxed/simple;
	bh=Tm4u4t5I7La81uWnh/FzUycsOUIhMdAss1Of6mtszUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJZqqhTn+XToqUhoj5U+hr8P+tt13hJmLytMvZjDGOw0prTtQ2wgOoN8Hfpp9dLBsvcI5j/s5NgxT3GrvJEi6NsnQDqSWtyDGgVyGfgbS9KvnHqrPvj25tT3ziTwAxNckW2FkCai4VXLD9grp7mR1Gld1eqbig05Tnk16yU9IpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XKK8JGDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKK8JGDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257F0C2BCB0;
	Tue, 21 Apr 2026 05:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776750528;
	bh=Tm4u4t5I7La81uWnh/FzUycsOUIhMdAss1Of6mtszUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XKK8JGDKyBHBRNSfuWZSIC5vTJ0Q0bM0JigVXHbo8XOPoTZSzhf7+QY7GKj7r+ic/
	 9KayWVjTxKkwJ1xAoYQ6V3b56levZCD4brepLvDU7AH4Tz/5gIMezZkrnzG2gnqOLl
	 HLby7IbobP92BWjnBsv6xKHcgLO7YlpdACnPLv3ScibVLKIC3Fo2arJ5LvvnddZs4u
	 X79kj2UZ1yxDVh9u9+Hq3yQdoDstE02tQbTjCXG+6EBCepO6S2bsqKU+HyM/KWya6Z
	 XUqg3/w1jCnkeAzZ9ozK8qZ+25Feg8HPGy66tPt7DAKt6Ltt7kp4MAEpAskPZhZVgn
	 9SNiaQR1uvpww==
Date: Tue, 21 Apr 2026 07:48:45 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: 4K inode support on 4Kn device
Message-ID: <aecPgylJ-WutR-VU@nidhogg.toxiclabs.cc>
References: <20260421094204.A743.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421094204.A743.409509F4@e16-tech.com>

On Tue, Apr 21, 2026 at 09:42:05AM +0800, Wang Yugui wrote:
> Hi,
> 
> I want to support 4K inode on 4Kn device.
> 
> 1,  change the size of XFS_DINODE_MAX_SIZE/XFS_DINODE_MAX_LOG
>      to 4096/12 from 2048/11.
> 
> 2, do we need to keep the following restriction in man mkfs.xfs?
>     the inode size cannot exceed one half of the filesystem block size.

Can you please better detail what are you trying to achieve with 4KiB
inodes?


> 
> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2026/04/21
> 
> 
> 
