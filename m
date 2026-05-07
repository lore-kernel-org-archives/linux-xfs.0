Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B21918050;
	Thu,  7 May 2026 18:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778179556; cv=none; b=IpZMiQs7Ut8HwkCMFulZztRA/KeM7GYr0uNAeY8vbrKmqGqoeu/anhAKBE/5R6XVGrVn374Co5Hz30SEkoU5g5VmRBUzqv9ulD5vwEQR8SNMXqxVFMKlch0Fxezx0D38OKlyQeetWPdgQ2W20svGYa0iTzbqEG48vgvn3uos3es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778179556; c=relaxed/simple;
	bh=xODJt3kT5G8TLC9mn4j20YekxNnn4c/8rEQj1l2HUTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyRVLofLv9hzfECAWNuVQyentsXOW/kzOyixAJDadmIppLHzydMk78HdOeRSP3h+d8Jx+HMQkm/nfG7iCUNSmuq5/nBtG9q6caj5SdP6kh9jQRJnYb/ty3tHkvyUj1ub+nvsGOl83XfNIF6j1cBCUg3Re+08JFEQCr50X59353c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBGYLsPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBGYLsPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB12DC2BCB2;
	Thu,  7 May 2026 18:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778179555;
	bh=xODJt3kT5G8TLC9mn4j20YekxNnn4c/8rEQj1l2HUTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZBGYLsPVf0ZdRMPfF0iRVgNSnmruLVmhW5kAoFf9jQFnEZIv6omYNNP6XrtTL4kBu
	 jP9rr1Wdn3tCVXCJNY48yEgztaqs40GNBO1fdVvp5Bk4tJHr5Y9UPJHRIMBjbd1MZA
	 dqf4OK7p37hGOyuY8qJZGZq+19C+dnT0IQypboSCO+ucWH8qsD32EdsN2Bw57+G1rh
	 7P27cWsYzJEXDdK+vbgXiQISxaI04dr60goeymyFbT3G2nA/QA92cDIDCRdONcwM6F
	 H3z8NsOm+AgiLY7TcjE3tUeS8UqQiCaCmDeG/d8nQbWANJixnMprmwVzIgkKvtTVyl
	 AUtCTMDa706JQ==
Date: Fri, 8 May 2026 02:45:45 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/216: pass -t xfs to _mount
Message-ID: <afzdcdQ-t8gzlRyY@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, djwong@kernel.org, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20260507050950.1300316-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507050950.1300316-1-hch@lst.de>

On Thu, May 07, 2026 at 07:09:49AM +0200, Christoph Hellwig wrote:
> Without this, mount probes different file system type, which ended up
> exposing kernel bugs in blocksize > PAGE_SIZE bugs in tons of
> legacy file systems.  Bypass that by forcing XFS and making the
> mount a little more efficient.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

This change makes sense to me, thanks for fixing one more lbs testing
failure.

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/xfs/216 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/216 b/tests/xfs/216
> index 091c11d08642..2096dd9b53d9 100755
> --- a/tests/xfs/216
> +++ b/tests/xfs/216
> @@ -57,7 +57,7 @@ _do_mkfs()
>  		echo -n "fssize=${i}g "
>  		$MKFS_XFS_PROG -f -b size=4096 -l version=2 \
>  			-d size=${i}g $loop_mkfs_opts $loop_dev |grep log
> -		_mount $loop_dev $LOOP_MNT
> +		_mount -t xfs $loop_dev $LOOP_MNT
>  		echo "test write" > $LOOP_MNT/test
>  		_unmount $LOOP_MNT > /dev/null 2>&1
>  	done
> -- 
> 2.53.0
> 
