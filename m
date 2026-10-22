Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792654994;
	b=46Rfg4+0Gmy244CLQ54SpIAZQOiYmq9gNTphcUTmnPiOnRtzMknNOYAWy1Mw2aJqdvCe
	 f7AMB0SgEcA24AC0LyE3Jre8mCE/4W+Od975jJnbLJTHzfnATY61bUIEjZJKDAkufccM2
	 mHFTdEuMII5kw9NrRNtvUHJHqX+RDMrTHYP6QAIHmbYSzQwUzWM5qXW5j9wFNJh64oL+s
	 05W13QYJ5i7GTMHfkzgF62xsYzU+WPfQhizCT4+/ySj2D0LkMiQwomfJJkOFA0oPJ6Xlc
	 x8T40Vnt97MjEd3CgV78iUZRaoTWTNDZWd5q42X+gyiA3YHP5i/O6be3IkXgts41duw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792654994;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=eQ6Drp5QsHhwVvQEfY15vaz+GeI+2Rvj+QWq36GulsA=;
	b=mz3aBDXmjy/SzxXCt5jGVE2n8h4oMePKtC9D4Nmq2cDR7uZV2NR1rJ+saBU+jOhct5Fl
	 aTaFpAQsKo2oBHjFK5hOcHma4oJ9z+/J2KCaEeEgELSIvRxu1XXMpEcn2v8On/8UQb+jK
	 1oNjGavv7UHM27lGLvt40KzIrZt+uLCHBc4a8Myz+eEM7k3pTEzboo0Ub7bxpvOG8wjcC
	 IgAIdPqUaiUWkn2A9qhY85YNTN0IochRnjwD+kFtGGbKfAR6JgP0T5E7kL3GrKz8v8Dfg
	 QtS2S8BWqVZ5U6WlxDGbH/JtqiT9dkQrW7AWwBM3Y5iKJw3KzsMkUVCf62S/2VyTF+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZtcJKWH1;
	arc=none smtp.remote-ip=95.215.58.110
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A01606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2026 07:43:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4A01606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZtcJKWH1
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yXAjUDHjjJ9kbBxcNqyNIROEyV5rUPWDf2Nuozb3V/4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792654990; v=1; x=1793259790;
 b=ZtcJKWH1BYUsWxXRi3X5ZTAvNc/g2MupiUHDCYua7TmHGszq7HJZBbEXjmcxk3Sx/i18sI0u
 tNo8iCUoXsiSwPyFuXR56Nw3Haxxcay/irG56uu8OniDZzWpOrY3sycMkivyNY1BXwqfOssol7E
 7WCEW0HtoRB7Vod9aDXYzX2w=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5a31a46c7ae6e228;
	Thu, 22 Oct 2026 07:43:10 +0000
X-Mizu-Trace-ID: 5a31a46c7ae6e228
X-Migadu-Flow: FLOW_OUT
Date: Thu, 22 Oct 2026 09:42:57 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Anthony Iliopoulos <ailiop@suse.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: skip iunlock with empty iolock flags in
 xfs_file_dio_write_aligned
Message-ID: <atm9R4iXS7vP-cBz@quentin>
References: <20261021210032.14001-1-ailiop@suse.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021210032.14001-1-ailiop@suse.com>

On Wed, Oct 21, 2026 at 11:00:32PM +0200, Anthony Iliopoulos wrote:
> When using RWF_NOWAIT, xfs_file_write_checks may fail to acquire an
> exclusive lock upgrade and return -EAGAIN for aligned DIO, setting
> iolock to 0.
> 
> In XFS_DEBUG kernels, passing no lock flags to xfs_iunlock triggers an
> assertion failure. Fix this by unlocking the iolock only when there are
> any flags set.
> 
> Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Looks good.

Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

> ---
>  fs/xfs/xfs_file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7d0c8a197575..1eab6dbb4c5f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -766,7 +766,8 @@ xfs_file_dio_write_aligned(
>  	trace_xfs_file_direct_write(iocb, from);
>  	ret = iomap_dio_rw(iocb, from, ops, dops, dio_flags, ac, 0);
>  out_unlock:
> -	xfs_iunlock(ip, iolock);
> +	if (iolock)
> +		xfs_iunlock(ip, iolock);
>  	return ret;
>  }
>  
> -- 
> 2.56.0
> 

-- 
Pankaj
