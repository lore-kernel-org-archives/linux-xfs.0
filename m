Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF4A3234
	for <linux-xfs@vger.kernel.org>; Wed,  2 Apr 2025 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743604311; cv=none; b=VozhT0kKKjYiEVnqQ648rqNxu3MCKwJRYn+OeQu6cdySyf3SbW7w0gP6frAWog2Fb0VKOxHtwasMm1CQHqeamL7OiKeFwCTTV0o+GAYoWTgCPOyuW2hBS7nXag0kbwJUEnNrKvHGGgeKGC7woQS5QtfZS8WNi43eiWbRPIkUUbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743604311; c=relaxed/simple;
	bh=1E9ToJQ2EpRhmtqdOEs9HMli5OZ3I8Ooh2HS5To55vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/67uPdEW2CzQGc2Konri4aa8ltnRKmSueLCdQpAMGekGbKZ//RNLiWKOXpys0jIQ1uX6DD2jPUhSjaCgMTCfojnxChP4IJHlGz8XX8lo9DTl5LnsiEk/DOETIebvWyR+QcDywUxt278hVXHB96u2FxoGfd/M++DU2Z9zSNaeE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlOzGwmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlOzGwmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2E2C4CEDD;
	Wed,  2 Apr 2025 14:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743604310;
	bh=1E9ToJQ2EpRhmtqdOEs9HMli5OZ3I8Ooh2HS5To55vw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nlOzGwmoMYOjkqt9mkqdKNm4Xc0sKg+Zp+JgObJTgcM64hf/2zW7ARfAdG1sUucf2
	 fx+4qnx4IZ0gbv4k0cq/hA+GFYrHuTa8HnGkp86qFlUKwApTYRv+T188CUq9oiExKS
	 t57Z/TcqaXWcQmykGcpIUq9RHXlRH+COfKs/jfl4egizpFEKICHEISreFDgX4BNnBD
	 jw1LsO8H+l+7HnbrZEzmchRCsYwHE3mR05FQmErnKrK6RWylKu0RVmYGNOM3yNLkJu
	 8cAsTjRcYcPlXNZUcrRiY1FbMQY+fcnLhnkPAW84zWZ2HiGe+C3U/w9aQYa4ND4W5U
	 YhqKEXbwez6/Q==
Date: Wed, 2 Apr 2025 07:31:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Pavel Reichl <preichl@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: Fix mismatched return type of filesize()
Message-ID: <20250402143149.GA6190@frogsfrogsfrogs>
References: <20250402002233.GA2299061@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402002233.GA2299061@mit.edu>

On Tue, Apr 01, 2025 at 08:22:33PM -0400, Theodore Ts'o wrote:
> On Fri, Feb 21, 2025 at 07:57:57PM +0100, Pavel Reichl wrote:
> > The function filesize() was declared with a return type of 'long' but
> > defined with 'off_t'. This mismatch caused build issues due to type
> > incompatibility.
> > 
> > This commit updates the declaration to match the definition, ensuring
> > consistency and preventing potential compilation errors.
> > 
> > Fixes: 73fb78e5ee8 ("mkfs: support copying in large or sparse files")
> 
> I had run into this issue when building xfsprogs on i386, and had
> investigated the compilation failure before finding this commit in
> origin/for-next.  But in my fix, I also found that there was a missing
> long -> off_t conversion in setup_proto():
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 7f56a3d8..52ef64ff 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -61,7 +61,7 @@ setup_proto(
>  	char		*buf = NULL;
>  	static char	dflt[] = "d--755 0 0 $";
>  	int		fd;
> -	long		size;
> +	off_t		size;
>  
>  	if (!fname)
>  		return dflt;
> 
> ... since setup_proto() also calls filesize():
> 
> 	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
> 
> How important is it fix this up?  I can send a formal patch if that
> would be helpful, but commit a5466cee9874 is certainly enough to fix
> the build failure so maybe it's enough.

Yes, this is important -- off_t can be larger than long, and that can
result in incorrect truncations.  I hope that nobody will ever pass mkfs
a 5GB protofile on 32-bit, but at least the C type usage could be
correct.

--D

> 
> Cheers,
> 
> 					- Ted
> 
