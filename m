Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931323ADB99;
	Mon, 15 Jun 2026 20:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781555046; cv=none; b=mELvpKZC6E2u/MI/7Ud6m4LtFulpfVGCPq/+nEG0q9lmKJeERhYAw16uskKFirKFkCJmsXmAfAaeNvVE3/zHZUd+QkKw1hUZdDDKntLDQ6ucr5Z109LhQ/C38zzZt11Mym+TXCnIfvbtilqHOuOCFfdXamYYCqUkZMyec+BWfWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781555046; c=relaxed/simple;
	bh=AZ2hxJNpZNpYXO2ZD1Js32DQROGiL7EDChUVSBdEkQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PM/Cb+fK5RhyORpEdQUAAMo9v5AbVI1RSsO9jxgVLs6E3hkNcfuQDAO50YfR/esg+XXMCfgEcfv9bOSo08M0YJdWuWiWKKtJqGMcctyjHOCwC3tBlv5Q4idXSHMCJFOo82Djp6kPgVi1lKiPJPTB63dUymwUUT0Nn1uFDZnKaaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6+JqCKs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6+JqCKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071DC1F000E9;
	Mon, 15 Jun 2026 20:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781555045;
	bh=47HjhO+2W+DRbNUl+AajlbvGfHCCzqt+CKIXgCBiT+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S6+JqCKsZYhI1pFpraxi/mVkaifZN/YUsrjbukfBL0RdASlGa8J4/ErBZoG9KEhVZ
	 LwIMYfc57jYoRJGM8r21V8frLgQozI41PXABzLU9QigZmDerbbaDkrt3PbLO5ZvgWo
	 q+sMeHZ0dnf3NUh5aM2nVLZrsNWPH6eVDaqMBMYnd3+keUSEAnzhDQMsTO8ygj41Zj
	 5q964AwNWxTyiLk/7P6QdmakQVo3d2PF4+8RKhisVpU2MKP+kfcT0JjspYGQaT0OOJ
	 jInvTUkIFHLXVc7GhMWzWT5yKkqUNFbqawx/7jHTQ7mB/MxnySXs032n7WIXqceZhc
	 5XzY54lEsgesw==
Date: Tue, 16 Jun 2026 04:23:59 +0800
From: Zorro Lang <zlang@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: fstests@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, 
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs/013: fix ENOSPC handling
Message-ID: <ajBeyp604Dou6FTh@zlang-mailbox>
Mail-Followup-To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
	fstests@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>
References: <20260615121257.512060-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615121257.512060-1-shinichiro.kawasaki@wdc.com>

On Mon, Jun 15, 2026 at 09:12:57PM +0900, Shin'ichiro Kawasaki wrote:
> Commit 000813899afb ("fstests: scale some tests for high CPU count
> sanity") replaced "touch" with "echo -n >" to speed up file creation by
> using a shell builtin redirection instead of forking and execing an
> external binary. However, this broke the ENOSPC filtering the test
> relies on.
> 
> When the scratch filesystem fills up, the shell redirection "> $dir/$i"
> fails instead of the "touch" command. The shell applies redirections
> left-to-right, so "> $dir/$i" is attempted before "2>&1". Because
> opening the file fails immediately with ENOSPC, the command never runs
> and the shell writes the error message "No space left on device" to the
> stderr instead of the pipe. Then the error message is not passed to
> "filter_enospc" and leaks into the test output, causing the test case
> failure. The failure is recreated by running the test case with rather
> small size of block devices, such as 128MiB null_blk:
> 
> xfs/013            - output mismatch (see /home/test/xfstests/results//xfs/013.out.bad)
>     --- tests/xfs/013.out	2026-05-28 16:52:16.881159200 +0900
>     +++ /home/test/xfstests/results//xfs/013.out.bad	2026-06-11 17:20:36.269003467 +0900
>     @@ -5,3 +5,12305 @@
>      naming   =VERN bsize=XXX
>      log      =LDEV bsize=XXX blocks=XXX
>      realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>     +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/19013: No space left on device
>     +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/6452: No space left on device
>     +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/14964: No space left on device
>     +/home/test/xfstests/tests/xfs/013: line 45: /var/scratch/dir2/10051: No space left on device
>     ...
>     (Run 'diff -u /home/test/xfstests/tests/xfs/013.out /home/test/xfstests/results//xfs/013.out.bad'  to see the entire diff)
> 
> To fix the ENOSPC handling, wrap the redirection in a brace group so
> that "2>&1" is applied to the group before the inner redirection is
> attempted. The redirection failure is then written to the group's
> stderr, which is piped into "filter_enospc". This keeps the faster
> builtin file creation than the "touch" command as the trigger commit
> intended.
> 
> Fixes: 000813899afb ("fstests: scale some tests for high CPU count sanity")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  tests/xfs/013 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/013 b/tests/xfs/013
> index fd011445..2e9b9850 100755
> --- a/tests/xfs/013
> +++ b/tests/xfs/013
> @@ -28,7 +28,7 @@ _create()
>  	mkdir -p $dir
>  	for i in $(seq 0 $count)
>  	do
> -		echo -n > $dir/$i 2>&1 | filter_enospc
> +		{ echo -n > $dir/$i ; } 2>&1 | filter_enospc
>  	done
>  }
>  
> @@ -42,7 +42,7 @@ _rand_replace()
>  	do
>  		file=$((RANDOM % count))
>  		rm -f $dir/$file
> -		echo -n > $dir/$file 2>&1 | filter_enospc
> +		{ echo -n > $dir/$file ; } 2>&1 | filter_enospc

Although I always use `(echo -n > $dir/$file) 2>&1` to deal with this kind of
problem, this *Command Grouping* way is good to me too :)

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  	done
>  }
>  
> -- 
> 2.54.0
> 
