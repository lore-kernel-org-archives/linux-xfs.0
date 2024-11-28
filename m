Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356B4146018
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 08:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732781329; cv=none; b=KknscgcFd2Ji8b3R0t9rq4lcc1ITchem1DldirNI0WYi+o4ifQM5Pd6sd0kv0F6kUZ1xhQ/dE7kM0II6peMA8e58NKwGh6HYBFi4hNapjTFSMKADhp0svh3pmYj0bXV0J+wh7cpxodghlze7o7O4WFmE2DQ2YA7hUkbTkRyVCdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732781329; c=relaxed/simple;
	bh=/+47+pAv8XympYr8QMmlPPOcMI78TQiNSczyP9F4y+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HroSRLPo+Z3hUNSldVgoZV+ouFVHKpzkpENSB+cBxc4j/91hwwUEVraTaSbJX6t2A0hrvsKxCUCwIWEVdyl8I0mD+bnU/50OVCSciLReSNHhPTvP1E6grsG74ZiuAIdSfidw+nONnhHOcw/mfUu8q9Rg3UlsGYxkmkIWxB0rVpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NPN7utJB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPN7utJB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732781327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yTyZrNty13HfB92whv/J/oy5HLzumRrZlHfnuX1n1vg=;
	b=NPN7utJBLG3o18Nxq9nuDS/ANefuJvs9iX+q0K+STdMrF3nlt2bhlnaQkrgAVI9DqaGTac
	dJctUbW/h961Vx+xrbZ7c4fZppNl6E0Z8uNToPJGmgYfOkT2hkPYTrAh+bv44FLLMejTm0
	NWUzjQK0rDSqycEjWKXLsz2uSIe7kLY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-CEDswkjtNfamVlBL-kwwQg-1; Thu, 28 Nov 2024 03:08:45 -0500
X-MC-Unique: CEDswkjtNfamVlBL-kwwQg-1
X-Mimecast-MFC-AGG-ID: CEDswkjtNfamVlBL-kwwQg
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-21519a8c2c6so6527765ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 00:08:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732781324; x=1733386124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTyZrNty13HfB92whv/J/oy5HLzumRrZlHfnuX1n1vg=;
        b=rM2bZCMnl4QuMA+CUt+ysnIlt4iWoMh83et0gjeIGIDXopTQE9zHZNR13mdH0bwE6f
         rb45iGzz5VpnQiA58M/5DGqIzM3cX7S+Tg8p9d6TW9Gu5Uhla5bvMNdwxNGAnMWc6DPL
         HXpAK55aEB+fzFq+L/1M+6lAJ51II2QUoTyYRkxSDXP+aYOnqHtVIfuF9CRNcMvGRG+/
         flyqfS4QADtD8UuVCFyzK7NC/eJDhPF1iwsaNmKc79CxYYkxYOGsG01tot/pDykzRlng
         v304sRF69taeFXDc+0+CuGSwsq0dcz0mRgHycIKLTdJHgI3Ry1ySrW7rNwFGob7fJqrt
         gjnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp+SV6r0PNOtiFhLg9eC3e+j1r/CN2OVhrm8dTP10tn6XYSYsjOgS2gq+pzYA4JuJsUNm9uICTgVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YybElqEujA+Ztqaf5smRVt4lK36TbAls3AmcPzftQD1V1NiBvn5
	25TTTlXQo1EvmYhoXtY8m/w/G2bBgQDU1H3E/wcF1Vv9/jRqiOoKAco49pRSxxjEmtRsUIx+bAd
	cWzz5/cI/y1q7lV/BnsttTY/M6TjEMLhb7WJbmdpZOpNNG7tQDeJN7pwgLg==
X-Gm-Gg: ASbGncuAWAPIpq4bLQJKQTY3f28G1io5Ogx7bhy6G/gzQGfyBtj++9fqqlh9+pU9+BU
	BcHFZzPfcGyccSsNe3hihFQaPJFD9Owut7H8s5oQ4x/Vlu5JJQWsvoD9zsvUnoAI+cjowwf3nSE
	jlA14hZP9tVqpMoKSITloivot6Nkb2vX3xEO9aiEmgKTwMueqcbsYI/myn1eJfe54n6ZaAAjz2u
	DznZugnj30ytIPyigaOE7ikvBWol1UPEpEDi2GaN0Y6xE0btP+4E5FsKDHTMtqx2fMNjEOT2q+I
	36bm464kQW207B4=
X-Received: by 2002:a17:902:f54c:b0:212:66cc:8100 with SMTP id d9443c01a7336-21500ffddaamr79314365ad.0.1732781324467;
        Thu, 28 Nov 2024 00:08:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHRr4uQ4ajXTPaCtJdhNmQO8j9vuWZD1ayMBHrIysgr8vtM3qRd8DqNc0PYnC8lkzisnyBRA==
X-Received: by 2002:a17:902:f54c:b0:212:66cc:8100 with SMTP id d9443c01a7336-21500ffddaamr79314145ad.0.1732781324168;
        Thu, 28 Nov 2024 00:08:44 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21521967037sm7690185ad.122.2024.11.28.00.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 00:08:43 -0800 (PST)
Date: Thu, 28 Nov 2024 16:08:40 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] generic/757: convert to thinp
Message-ID: <20241128080840.fldjegxyoudzxga6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
 <173258395101.4031902.14954667811124439467.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258395101.4031902.14954667811124439467.stgit@frogsfrogsfrogs>

On Mon, Nov 25, 2024 at 05:21:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert this test to use dm-thinp so that discards always zero the data.
> This prevents weird replay problems if the scratch device doesn't
> guarantee that read after discard returns zeroes.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

This patch is good to me, and g/757 finally passed on my side :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

>  tests/generic/757 |   23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/tests/generic/757 b/tests/generic/757
> index 37cf49e6bc7fd9..6c13c6af41c57c 100755
> --- a/tests/generic/757
> +++ b/tests/generic/757
> @@ -8,12 +8,13 @@
>  # This can be seen on subpage FSes on Linux 6.4.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick metadata log recoveryloop aio
> +_begin_fstest auto quick metadata log recoveryloop aio thin
>  
>  _cleanup()
>  {
>  	cd /
>  	_log_writes_cleanup &> /dev/null
> +	_dmthin_cleanup
>  	rm -f $tmp.*
>  }
>  
> @@ -23,11 +24,14 @@ _cleanup()
>  
>  fio_config=$tmp.fio
>  
> +. ./common/dmthin
>  . ./common/dmlogwrites
>  
> -_require_scratch
> +# Use thin device as replay device, which requires $SCRATCH_DEV
> +_require_scratch_nocheck
>  _require_aiodio
>  _require_log_writes
> +_require_dm_target thin-pool
>  
>  cat >$fio_config <<EOF
>  [global]
> @@ -47,7 +51,13 @@ _require_fio $fio_config
>  
>  cat $fio_config >> $seqres.full
>  
> -_log_writes_init $SCRATCH_DEV
> +# Use a thin device to provide deterministic discard behavior. Discards are used
> +# by the log replay tool for fast zeroing to prevent out-of-order replay issues.
> +_test_unmount
> +sectors=$(blockdev --getsz $SCRATCH_DEV)
> +sectors=$((sectors * 90 / 100))
> +_dmthin_init $sectors $sectors
> +_log_writes_init $DMTHIN_VOL_DEV
>  _log_writes_mkfs >> $seqres.full 2>&1
>  _log_writes_mark mkfs
>  
> @@ -64,14 +74,13 @@ cur=$(_log_writes_find_next_fua $prev)
>  [ -z "$cur" ] && _fail "failed to locate next FUA write"
>  
>  while _soak_loop_running $((100 * TIME_FACTOR)); do
> -	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
> +	_log_writes_replay_log_range $cur $DMTHIN_VOL_DEV >> $seqres.full
>  
>  	# xfs_repair won't run if the log is dirty
>  	if [ $FSTYP = "xfs" ]; then
> -		_scratch_mount
> -		_scratch_unmount
> +		_dmthin_mount
>  	fi
> -	_check_scratch_fs
> +	_dmthin_check_fs
>  
>  	prev=$cur
>  	cur=$(_log_writes_find_next_fua $(($cur + 1)))
> 

