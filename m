Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5512113B2A0;
	Tue,  9 Apr 2024 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712678249; cv=none; b=RmaKumXQRn9QWfPXPqgQouGAViQy0oNnJqPelR/EesDoerf9oXzetRyIoJ3cGAKuCWd2Dkq8/eIrLmkGEO2oGuBD8WTy1xg2N5z4kKFSVOrqNzwEnvoQ8G2wzUTQFicEvNtj9NuMbWqmnXZFvwcqCft/bjR114A2Wp2ANKYquqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712678249; c=relaxed/simple;
	bh=Uh6NixN/2vdQmlhG192hyhAD2e6JMcn+x92KdjHGB3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JK+MMFbr24ud+8o+9bPF6dISfXw8om1kz4uxdhQ1zDtMNMQg0oUdHc5dtjuvRoipcGHsb0vjrxMiZhSywXj3XGPXeusJTNg1gbAZ9fsLuUeUTJjXbxk3sRNukAZIgsBLBLp2pmdm0jjPvRvPwY4hjZBWBIa8ndRYZKKxoYkObSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WcXWyLWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcXWyLWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6D6C433C7;
	Tue,  9 Apr 2024 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712678248;
	bh=Uh6NixN/2vdQmlhG192hyhAD2e6JMcn+x92KdjHGB3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WcXWyLWFFs/BB1YYiDLejMgDxqzQsu7gvOFND0hoBsraNiSahJhzIwRMC4V014fJF
	 D3aCDmJL3766JlxKBDNKq3WKdWPyR0Zz0Z6rHVEne3M9jAJJ4iICHjp1b0y1dy6caV
	 zSjNha/Z3Ki3Hh7hThAtACt1jSqTrsjrBMauwlDxUeGNdjiLAZQ2Tjb9VQajQQTac7
	 /I/zEqW9amKrEqGcLTJrqIpvAKmY4VpQJI1+3Q37fo+tkhkFKdGiANboCI1L+btpc6
	 SHfvIYKwmQrwmKDrTtWQyxG3YmmhnuGPI10IF1B+8Kxex4U0kOZ6+YJoGoYN5a7mcN
	 9qwW3CrPun67Q==
Date: Tue, 9 Apr 2024 08:57:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs/263: remove the nocrc sub-test
Message-ID: <20240409155728.GG634366@frogsfrogsfrogs>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408133243.694134-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408133243.694134-5-hch@lst.de>

On Mon, Apr 08, 2024 at 03:32:41PM +0200, Christoph Hellwig wrote:
> Remove the test on nocrc file systems as v5 has been the default for 10
> years and the kernel has made v4 support optional, which would fail this
> sub-case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/263     |  5 ---
>  tests/xfs/263.out | 85 -----------------------------------------------
>  2 files changed, 90 deletions(-)
> 
> diff --git a/tests/xfs/263 b/tests/xfs/263
> index bd30dab11..54e9355aa 100755
> --- a/tests/xfs/263
> +++ b/tests/xfs/263
> @@ -66,11 +66,6 @@ function test_all_state()
>  	done
>  }
>  
> -echo "==== NO CRC ===="
> -_scratch_mkfs_xfs "-m crc=0 -n ftype=0" >> $seqres.full
> -test_all_state

I think we should continue testing V4 quota options all the way to the
end of support (~2030) by splitting these into two tests, one of which
can use the _require_xfs_nocrc predicate introduced in the next patch.
Thoughts?

--D

> -
> -echo "==== CRC ===="
>  _scratch_mkfs_xfs "-m crc=1" >>$seqres.full
>  test_all_state
>  
> diff --git a/tests/xfs/263.out b/tests/xfs/263.out
> index 531d45de5..64c1a5876 100644
> --- a/tests/xfs/263.out
> +++ b/tests/xfs/263.out
> @@ -1,89 +1,4 @@
>  QA output created by 263
> -==== NO CRC ====
> -== Options: rw ==
> -== Options: usrquota,rw ==
> -User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Blocks grace time: [7 days]
> -Inodes grace time: [7 days]
> -Realtime Blocks grace time: [7 days]
> -== Options: grpquota,rw ==
> -User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode #XXX (1 blocks, 1 extents)
> -Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Blocks grace time: [7 days]
> -Inodes grace time: [7 days]
> -Realtime Blocks grace time: [7 days]
> -== Options: usrquota,grpquota,rw ==
> -User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Blocks grace time: [7 days]
> -Inodes grace time: [7 days]
> -Realtime Blocks grace time: [7 days]
> -== Options: prjquota,rw ==
> -User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode #XXX (1 blocks, 1 extents)
> -Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Blocks grace time: [7 days]
> -Inodes grace time: [7 days]
> -Realtime Blocks grace time: [7 days]
> -== Options: usrquota,prjquota,rw ==
> -User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Blocks grace time: [7 days]
> -Inodes grace time: [7 days]
> -Realtime Blocks grace time: [7 days]
> -== Options: grpquota,prjquota,rw ==
> -== Options: usrquota,grpquota,prjquota,rw ==
> -==== CRC ====
>  == Options: rw ==
>  == Options: usrquota,rw ==
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -- 
> 2.39.2
> 
> 
