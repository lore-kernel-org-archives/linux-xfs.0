Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5685C2459D9
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760721215; cv=none; b=uWq1cpTfrVrM+PmcJFA8cFxNA27biELfeWAVBXVCF9bbLnMt6CMeMVh43boSMKFkEKyjcHTP7qZyHbIn8Fe8JDdSmKuHLpHHZ/WJHQC5u7Tu1nvOZpolXNoHUt3a8JEF73ruUSU69hVN06MZi1yS2kC+8wEiwZn4ztFdVUinAH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760721215; c=relaxed/simple;
	bh=BNRwFUIELG2ygw4bW3PH2KI/Q+nWDQN9xxXtMUGUR/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Idd+/yccXVNeBusq/B3bYKu6i/6PVaFzfnwDXqa9/IEyJ6zj/LnI/1KHjJMHFYi5F/4xr1xoWojb36VhzJpsCGJrp/JaxnT0mc1Xys2Zvbodux2aa+2ePhJY6yTC4o6vY/8yTAy+G3ij8bLwTehfDXRofq0TA48HTxq6rdmxvdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d6NPxULX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d6NPxULX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760721213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3oH+JLZtPmhaQBCzs5M5q290f+e5pQcBKbkdAyZCCUc=;
	b=d6NPxULXYC1fh6dU8rq4mV6vYPoK1rtJD6Xd0sRmJ+iOVLeZGbfAD+zX5JEDEhs/GhaJF+
	6V0niiCiYRx5Iomt/OUjhaT8ZTH0wcNojdWAW3rpp2nNPPyEhHCMcQf90D8KKxpqM2gZ+m
	G4Wkrs9JFYpCsp8rx75VoumsJ4fU6A0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-doF7bpmTOUigzrs7AYlWdg-1; Fri, 17 Oct 2025 13:13:32 -0400
X-MC-Unique: doF7bpmTOUigzrs7AYlWdg-1
X-Mimecast-MFC-AGG-ID: doF7bpmTOUigzrs7AYlWdg_1760721211
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2904e9e0ef9so40111785ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 10:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760721211; x=1761326011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3oH+JLZtPmhaQBCzs5M5q290f+e5pQcBKbkdAyZCCUc=;
        b=pXODcKBEX2iPJW90ChRWySjS50tmRRAVQY4/ID5jW1YXljk6J2FsZBvqRADMmBw0Hf
         4umRh+ymfLzVAoMQ2UQaoUO0HsF7390gm6/pZgbgJbJ8eWomuwNWZRoGEckPjdHOIAxa
         ZhLYO7eGcrdGDB3zq0wRNDTEvAJOpAEbxr69dH0ae7sCbNenymZZH54Lj189Ci2inzg/
         YBHZDnbeqO6tFAQh9hbYUXzxAG1BsUWVoFrBN8bStSnbZtWGcHUDpHLQTKMEJkiMTj8S
         JHHJUNZdMqK31BSZujZOqM5AKPWybboiQHnTeu1q5Ku4t1WFFzJwZFtJ+DDf8vvu1Cqx
         cqIw==
X-Forwarded-Encrypted: i=1; AJvYcCXIcjjQblwQkTxprVTfkcXcGKcDgwSeqNlaT5Ww8JZFwDLkMv08gnmJo8j4wA9FahzgNuVmcM4TqYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfjScuFw5xQGIHLXwDoHPZDZ0OtHPivAgLP2O2+XXQyRjRB+sx
	tPguVKyAYDF6qri9a8e0lMVsbago14VRSSfXFnfLZTVsDX/oXt4JwZPixfhoci2tkULt5ijrtjB
	uEELjHBi+/TF93MFBGn+DVGzAA1lEwvKvCydA6gBPoxbCuuPQAix4N6ACu5pV9uuF7bkI1g==
X-Gm-Gg: ASbGncvkeEOmGJqV4ORyG4qT7il+tw9sSOufJpWqVbkIznn7dR1jdE1Vlf/QN6fd97e
	+lZyAJwocm/iFKzUD8usuFLABGh/SEqlDgVM/Bb9ASoXg8IcQBRDtrbyY7xTtwgh+yYLFPA5YvA
	Td4GlFsYO4LXmooVhjo/lGNtL9/Eb4Kv4joefF1e8PnkDmyiyeAcZ1IVFOL70qsm0Mg3LySZAlu
	Dg9Qg1clDP1uaq6qYNCiZ1y5QXsU1ST0nbDVl0DgGX8lnGYFs3QABgZLCaVuCbNQzIe/rQfULGM
	1ETgBCtv7nO3BM8L3z59Z1d/Cu7JpjglH4gesoS9x1BB1snjsxWnBRDWlB56tF++qoFwe8vN+zg
	z+PXGw2+yerBd0rfgNfgcn0XzQoHNwLLfXRfE8YE=
X-Received: by 2002:a17:902:ebc6:b0:290:9a74:a8ad with SMTP id d9443c01a7336-290cba41dc7mr49790855ad.53.1760721210540;
        Fri, 17 Oct 2025 10:13:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbtm0LLhBl1rlaDnMsaDwvVnWrH3jQfQnns6FlKnwY1B7IPleG4xQHqEgv+4VDuDOp3wi7cg==
X-Received: by 2002:a17:902:ebc6:b0:290:9a74:a8ad with SMTP id d9443c01a7336-290cba41dc7mr49790545ad.53.1760721209989;
        Fri, 17 Oct 2025 10:13:29 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fd9ddsm274415ad.89.2025.10.17.10.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 10:13:29 -0700 (PDT)
Date: Sat, 18 Oct 2025 01:13:25 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] common/attr: fix _require_noattr2
Message-ID: <20251017171325.b35z55fbubi3kxut@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>

On Wed, Oct 15, 2025 at 09:38:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> attr2/noattr2 doesn't do anything anymore and aren't reported in
> /proc/mounts, so we need to check /proc/mounts and _notrun as a result.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/attr |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/common/attr b/common/attr
> index 1c1de63e9d5465..35e0bee4e3aa53 100644
> --- a/common/attr
> +++ b/common/attr
> @@ -241,7 +241,11 @@ _require_noattr2()
>  		|| _fail "_try_scratch_mkfs_xfs failed on $SCRATCH_DEV"
>  	_try_scratch_mount -o noattr2 > /dev/null 2>&1 \
>  		|| _notrun "noattr2 mount option not supported on $SCRATCH_DEV"
> +	grep -w "$SCRATCH_MNT" /proc/mounts | awk '{print $4}' | grep -q -w noattr2

How about use findmnt? e.g.

    grep -qw noattr2 <(findmnt -rncv -M / -o OPTIONS)

> +	local res=${PIPESTATUS[2]}

Then the PIPESTATUS isn't needed either.

I can help to do this change if you agree.

Thanks,
Zorro

>  	_scratch_unmount
> +	test $res -eq 0 \
> +		|| _notrun "noattr2 mount option no longer functional"
>  }
>  
>  # getfattr -R returns info in readdir order which varies from fs to fs.
> 

