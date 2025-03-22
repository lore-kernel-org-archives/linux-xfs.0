Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C9F3398A
	for <linux-xfs@vger.kernel.org>; Sat, 22 Mar 2025 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742654284; cv=none; b=ILgTu4GFAWIuishcqgn/kkmrpwJ4gTF9ceoCFfFoIrgGFBrYE5EjWbdJB0tEh+80jGoeE8nSFll/f7f9M9NuumfpORaGJr3eyFGwbevUmopN5GGFLnpmffCAVYVtjHcH4/Wn3lwn6gnXkA7XVnmApOrbw6ynumxIQazft8+K4gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742654284; c=relaxed/simple;
	bh=2fdnEY2lYQk5H8e0MIVLSDGVI9GVumGby0EbS/eam9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvJ0aXh6Ksa8Ih+FKQoDkK2wPJQoFK2z8nkJP7PlMrUkIO3aMHTZVhaqoO1dUndb4g3js7GWb7uGSEH6tmo5lg+zSFO/05cevMOLBWRlq4EQEuSW8SgPOZQIVNeXEhmW1m8WttlOlFxLVhZ7muElJx3OBAuemCRPrbS0wWcHXhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hu59NZQu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hu59NZQu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742654281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nWumP6XyzLk0iADffqbx495sd8xP6cjzDc3KSalZiZI=;
	b=Hu59NZQuL4kr4aNUgmU1aCd/OprzYd9zXiXYtzMmfKccGbEJNViGyTwzQNwHEp9aaykchg
	bsMq3ga8fZg73vxoMqPgiZbQpi/088rOPM+RjSQOFAtGb+lfJ1hpfrvfJJ03Nio6rCIe9C
	YkyIjPQLYmBDUyzB2+0evhA5L8yV+PU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-5Cs8-f7FPL-0A8no7HFFVA-1; Sat, 22 Mar 2025 10:38:00 -0400
X-MC-Unique: 5Cs8-f7FPL-0A8no7HFFVA-1
X-Mimecast-MFC-AGG-ID: 5Cs8-f7FPL-0A8no7HFFVA_1742654279
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2ff854a2541so4657617a91.0
        for <linux-xfs@vger.kernel.org>; Sat, 22 Mar 2025 07:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742654279; x=1743259079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWumP6XyzLk0iADffqbx495sd8xP6cjzDc3KSalZiZI=;
        b=nK82PtAxz8HVNKI2SW6/M23aRQ4gOft0Oy4EKhLfDmWewOlIqUmWh3WcQECLGpb18T
         h0JwwPy3qX0tDf9whXz49vaYnNav2sC9nwfljARcxSbz3ljL7ufXoIcLpppVW1861k9k
         ewOnRaUcfHQPgYfDnFnN9qiQgjNdGM8dX6E0uQVfMZtaV55n2MwwjrKDDkr85iWDbYGz
         Ed2a2bPykyVtbRsQVDThmZNX345Bq4IqmBFlatqR3x+G/nh98+AunNMrmOVg/8eP6P+/
         dSblTIObseBBG4SVXV6H+SfOdZMrjn2CKZqgzCPuERXv9vhkBmHEYwpSfu2eMSn5vt4q
         uaVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV62l0LTaEU+nuz0i25x0eltA/vQZAdHsaeUQt9MrPqNNJEfYKRsAqYBYdSFRyIqGgOUo5rs0EcahU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6iujp/MNO7OZHhiQ2J3FuT+IdvGDFHnxw5H0wGxIx4IFTunqv
	0epTGzlrsFV/z/EBrqU14mXMGwHvc9zLBY1qIKVK5B/NliExoyamJhVE5OfyRuRgLq2hSmcKyuT
	II7b21uty4ih0jygJmuZouSzkh2XRJDWSbbunCGPhvTbAj9Z+E8/Lgwrvdw==
X-Gm-Gg: ASbGnctvBKaIfqQed11nBqOH432AtHQirgYc1yJ5UFE05muefv50yFQL8d6yXdSoYGE
	0RcNIjKXRDoCtnsH//hK8mwgoIJ8Vm48Qb4oFhKMe+upuNJ+zJyaqUTwz/WatbW9cXuYWBCyKL4
	vHoPB5/pSVrIFjur8gNuzLn+xW7fR12yRP9uhhr7iA5zvlOgasUlWno83iNUPY2ZcaNEXgGJDa8
	x0vN1XV0VzLl4EYKT0NxrYisvLaHbn7PRR/H6P1P8pFwVOYa3qCxlJXrEqPFODI7M8IGfHHufGG
	5Jh7rLOcdD5zG21b8ABKOJChptT8GiKXzcuCe4/wWK4E8dFKYPia+nzh
X-Received: by 2002:a17:90b:3b42:b0:2fe:9581:fbea with SMTP id 98e67ed59e1d1-30310024becmr9124292a91.29.1742654278921;
        Sat, 22 Mar 2025 07:37:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEVTHKB8s1VcTQC0v9wcAETY37gGTJ2tiYhNh3dbJSsj0bi/mEHhkerqVv1fDGcpeL8kvEOw==
X-Received: by 2002:a17:90b:3b42:b0:2fe:9581:fbea with SMTP id 98e67ed59e1d1-30310024becmr9124273a91.29.1742654278462;
        Sat, 22 Mar 2025 07:37:58 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf589fbcsm8263269a91.12.2025.03.22.07.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Mar 2025 07:37:58 -0700 (PDT)
Date: Sat, 22 Mar 2025 22:37:54 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] generic/537: disable quota mount options for
 pre-metadir rt filesystems
Message-ID: <20250322143754.4fe7rges6whcz47u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
 <174259233999.743619.6582695769493412159.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174259233999.743619.6582695769493412159.stgit@frogsfrogsfrogs>

On Fri, Mar 21, 2025 at 02:27:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this regression in generic/537:
> 
> mount: /opt: permission denied.
>        dmesg(1) may have more information after failed mount system call.
> mount -o uquota,gquota,pquota, -o ro,norecovery -ortdev=/dev/sdb4 /dev/sda4 /opt failed
> mount -o uquota,gquota,pquota, -o ro,norecovery -ortdev=/dev/sdb4 /dev/sda4 /opt failed
> (see /var/tmp/fstests/generic/537.full for details)
> 
> for reasons explained in the giant comment.  TLDR: quota and rt aren't
> compatible on older xfs filesystems so we have to work around that.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/generic/537 |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> 
> diff --git a/tests/generic/537 b/tests/generic/537
> index f57bc1561dd57e..3be743c4133f4f 100755
> --- a/tests/generic/537
> +++ b/tests/generic/537
> @@ -18,6 +18,7 @@ _begin_fstest auto quick trim
>  
>  # Import common functions.
>  . ./common/filter
> +. ./common/quota
>  
>  _require_scratch
>  _require_fstrim
> @@ -36,6 +37,22 @@ _scratch_mount -o ro >> $seqres.full 2>&1
>  $FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1
>  _scratch_unmount
>  
> +# As of kernel commit 9f0902091c332b ("xfs: Do not allow norecovery mount with
> +# quotacheck"), it is no longer possible to mount with "norecovery" and any
> +# quota mount option if the quota mount options would require a metadata update
> +# such as quotacheck.  For a pre-metadir XFS filesystem with a realtime volume
> +# and quota-enabling options, the first two mount attempts will have succeeded
> +# but with quotas disabled.  The mount option parsing for this next mount
> +# attempt will see the same quota-enabling options and a lack of qflags in the
> +# ondisk metadata and reject the mount because it thinks that will require
> +# quotacheck.  Edit out the quota mount options for this specific
> +# configuration.
> +if [ "$FSTYP" = "xfs" ]; then
> +	if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
> +		_qmount_option ""
> +	fi
> +fi

I don't know if there's a better way, maybe a _require_no_quota, or _disable_qmount?

Anyway, for this single case, it's fine for me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +
>  echo "fstrim on ro mount with no log replay"
>  norecovery="norecovery"
>  test $FSTYP = "btrfs" && norecovery=nologreplay
> 

