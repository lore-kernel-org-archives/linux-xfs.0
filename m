Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847B6207A1A
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 06:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730789944; cv=none; b=uLnQh6mP9BlNQzlawII2wPdkb9SdBXFgw9Yj9vkVAaNh9O7sY+LNDr0SMbxSkAfqu+WETodo4OU5dRBJCwOpfw+jOoINYhWgBsnlWbu/FEM/cnjJow72jhoPo2+nNKbMb2TQ22drWsLt2qufG2o9C6k2iCV7U9WoUYOHgcBTEDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730789944; c=relaxed/simple;
	bh=Gm9i0clkxJ30aqKU7WU/nqzFWkGI7SoxJ16OmrRd8WA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HwV2qC8MyyFaBQcXZXRxTSKnJzB82uTV1OYyiliOvZu1n2J/wZRGnKTAKnyX6HRMINdgCfZXCy82PKUoDmWCbcDshYi5LTtE5PnwsBKLwKQnB1OZFzE0fj4ZQlcC25fe3Tj4Qvg7LaVW1+6A0xMcIGkXZuoJq7De/LDSSagTQHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KNFV0TGe; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KNFV0TGe"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20cd76c513cso39421855ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Nov 2024 22:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730789942; x=1731394742; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k3rnpr5FnaON2NYr2e34KJVxPEQKrPchOjIXUSnnsCk=;
        b=KNFV0TGecTjPG9lhaGZTUN+RO/zl19AThMjo8XQI0JRIvsngFNUa7az26IqxoMDqdr
         7unoFxMkXvEKSclv6xj4DeO1Mf+ngxg8KFI80NODhvj13CHbzXiNQm+pAel5li+Vbrjy
         6QY0HjRfwYTiy00KNH9/GJgCWiORIewD2H+ksyLtGcDrrPcxau/3neGG4BoL81u0YX1Z
         /X245spdhVzWR8nCmIncgqIhrkguVS7ZJBv14DB7o0USoEU4HvkD8g9SMB/mlccs858p
         V3mT50WioJnQC3h7g2stUEuoo6RsFggrcLoUYxDeoxZUUvVJwtwZlR1N3qYTp3xOsWY2
         lWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730789942; x=1731394742;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k3rnpr5FnaON2NYr2e34KJVxPEQKrPchOjIXUSnnsCk=;
        b=wb42PeNtlO1XgWu85wvWdU40eJcUBNeh2fbj01QF+rGHDuLzfKgJhZT+IkgyQEFChk
         d/DviEBhfzRqlJRCvsai86ca4b3Ok++W+GwBmJCTqMAbfQIXKGJ68tnPkH41Xgvg5Wxy
         sRZ1b7jn46V7/HZAjpOK5+sx01pncPo9+/ybonTYw6UP/8VnRkU6n7JrxkRpHZ3qXwuZ
         NIPvn8VnLxo3OpAErmqAndYncGkUB+TSZdEhJDX0leDxsph45nxiYZwtsboP2G3kd69C
         UyL0biSQetXdsRAiZLs7mz+riXP3W2/bJQ4tesy7k79BmYL1bKRmoyX/O2u/3VosXkHV
         C+Mg==
X-Forwarded-Encrypted: i=1; AJvYcCXElGd3QpQK6M1N76Q1zDoATxWZdS8Z3PDe45SMTOJ1EhW3SepCMHlbUvjpwqoG7LxCiIuNKe3/90E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIfcT4DfGrK0vWiU4us8J+SdQjU+/UaCN3FbhAgC7onoXywuML
	jaJJpHBeRLqOSCZrLTpokDXnaZrb3Y38eH3/UtlWPFtT/TTMgllb6ODa6KW62yI=
X-Google-Smtp-Source: AGHT+IEPye7e3EczdfPkKEL5uIbBUM11W80YIbastGKfWg2y8emTitUFShtETky2q5yRQeLZZv4kQg==
X-Received: by 2002:a17:902:e852:b0:20b:6458:ec83 with SMTP id d9443c01a7336-210f74f6e5emr331609685ad.4.1730789941796;
        Mon, 04 Nov 2024 22:59:01 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057c51e8sm71760145ad.210.2024.11.04.22.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 22:59:01 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t8DWk-00AOOk-22;
	Tue, 05 Nov 2024 17:58:58 +1100
Date: Tue, 5 Nov 2024 17:58:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <ZynCMiPQMnxrISve@dread.disaster.area>
References: <20241031193552.1171855-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031193552.1171855-1-zlang@kernel.org>

On Fri, Nov 01, 2024 at 03:35:52AM +0800, Zorro Lang wrote:
> The xfs/157 doesn't need to do a "sized" mkfs, the image file is
> 500MiB, don't need to do _scratch_mkfs_sized with a 500MiB fssize
> argument, a general _scratch_mkfs is good enough.
.....
> diff --git a/tests/xfs/157 b/tests/xfs/157
> index 9b5badbae..459c6de7c 100755
> --- a/tests/xfs/157
> +++ b/tests/xfs/157
> @@ -66,8 +66,7 @@ scenario() {
>  }
>  
>  check_label() {
> -	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
> -		>> $seqres.full
> +	_scratch_mkfs -L oldlabel >> $seqres.full 2>&1
>  	_scratch_xfs_db -c label
>  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
>  	_scratch_xfs_db -c label

Looks good, fixes the failure I'm getting here.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com
