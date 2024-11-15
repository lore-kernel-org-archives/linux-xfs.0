Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA6817E44A
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 10:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731665589; cv=none; b=uml9SrZDQr/ab+2hwhugVB2Cv1VQKDaniUoIlZr83teriHjS4dbvePKdGI3r7+aOSnZCkdKLHpfAmhy6njQXkrNBuSnI0+nKOc2IlrxhG8uCCowgFqCcPblqi0aY389ivwBfgTq9ojCMyNpXcDGILMWVFWBjy8j5FlFqB7Uu8mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731665589; c=relaxed/simple;
	bh=XkiJE9XusmAP0lgRVlvMor6ntqjlnu5X2Spq/MTdVqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/7DBFE7PD8+0sxA9L+T+CW1b/gCbMnFS65Pd8rkid3FQoaA4OCSu061B9pC1Tas+Nzeejgblu2VyO8iPY0vyyE/Pga9HWeNe/UZ7oM+8QcSKONUhwjxSkK+yeKk7A97/I5Am27qWvFuMq/FoYfoz1VWKNlsaPPUVQpb1axLsrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HrPZROw3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrPZROw3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731665587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aA5rJZve+4OtVh1GqfURwYIfWy0JkPd3b0OM0zmpkRg=;
	b=HrPZROw3JRMnOQlfW3r4mVHvVpRu5QZeblMgygIbS2U7N9mJSs6NHmv1QIolgIjAz1d+Mj
	7L3eG6s7pS/YrDUv/DEa4XXz0WGSVPvt7gkRsDx9ErYtbFVb7cY3ziRzFbJiHuxhUuP2oz
	iobvIcVwyAqTgjT91aIGeTdUVitXRMA=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-Hin308UvO92JzhMuwCBT7w-1; Fri, 15 Nov 2024 05:13:05 -0500
X-MC-Unique: Hin308UvO92JzhMuwCBT7w-1
X-Mimecast-MFC-AGG-ID: Hin308UvO92JzhMuwCBT7w
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-71e578061ffso1886207b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 02:13:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731665584; x=1732270384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aA5rJZve+4OtVh1GqfURwYIfWy0JkPd3b0OM0zmpkRg=;
        b=TkT+0+GiJ4l44z9RXV90ZQwAGw3NG6Utd2HrNTj3o4O/LVKBovFTnFuN14ho5e1Zlp
         yhKGzDsGzJqBHB0GYHVj6TsJgZ8w8Ay6uM7n+CWNcKB/SyDbHH/BPXG8Rj+rrGYfjxNI
         WOY01afDs6si4QLMar3zCdwkpD1qpX59H8ucVbPBNuoK6eLGRhzwJPprjUcNK/UQRqyT
         gppdtesPUUsSZPvbr6V5+hFnoT6i5fNGha9oPRosBBpBZX82sCCKAVFtg4Y515PczaKy
         YvArNdrjOaYlweX4j3yOqF8hTwOJwoMoj7rO0mn2Us3Tcie6D/Qi2W5JQBpInsKgNCXa
         rE1w==
X-Forwarded-Encrypted: i=1; AJvYcCUXRFchQa7GdA6s259h+ZMSJcID1ACGblnZzZmw1DSN5NPKi2/M2ky1Zm9t9+kaQtIv2xbZK7UKusQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YztbFgs1kFYMGUX3yxFYygz6mnUdgmEGMiQZKUKR3i6B2tEJ/rd
	gbCu7zssnet7uDPlZEinkVQukZJPpP0t59EN7Rzq5/e49JPd5ZGOa2GdjOtmk8g6d6URWyMXgqO
	aoz+YUgDQBuGTyezwMwGr4PdYOFP38oLidkiHX26faeVYMsKo+t4KPaKXvg==
X-Received: by 2002:a05:6a00:1252:b0:71e:589a:7e3e with SMTP id d2e1a72fcca58-72476b72701mr2711306b3a.3.1731665584425;
        Fri, 15 Nov 2024 02:13:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2PimRb1DcfBVCViCGvQKWBLT7WmQZES7ooWqo7VjA61hQb4wFwd8GgOLIRuC916VMryJLuw==
X-Received: by 2002:a05:6a00:1252:b0:71e:589a:7e3e with SMTP id d2e1a72fcca58-72476b72701mr2711284b3a.3.1731665583927;
        Fri, 15 Nov 2024 02:13:03 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f8c1c176b0sm987657a12.2.2024.11.15.02.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 02:13:03 -0800 (PST)
Date: Fri, 15 Nov 2024 18:13:00 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/273: check thoroughness of the mappings
Message-ID: <20241115101300.u4fcn3hu5u4435pz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
 <173146178829.156441.9898313568693484387.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173146178829.156441.9898313568693484387.stgit@frogsfrogsfrogs>

On Tue, Nov 12, 2024 at 05:36:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enhance this test to make sure that there are no gaps in the fsmap
> records, and (especially) that they we report all the way to the end of
> the device.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

This version is good to me now,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/273 |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> 
> diff --git a/tests/xfs/273 b/tests/xfs/273
> index d7fb80c4033429..9f11540a77603d 100755
> --- a/tests/xfs/273
> +++ b/tests/xfs/273
> @@ -24,6 +24,8 @@ _require_scratch
>  _require_populate_commands
>  _require_xfs_io_command "fsmap"
>  
> +_fixed_by_kernel_commit XXXXXXXXXXXXXX "xfs: fix off-by-one error in fsmap"
> +
>  rm -f "$seqres.full"
>  
>  echo "Format and mount"
> @@ -37,6 +39,51 @@ cat $TEST_DIR/a $TEST_DIR/b >> $seqres.full
>  
>  diff -uw $TEST_DIR/a $TEST_DIR/b
>  
> +# Do we have mappings for every sector on the device?
> +ddev_fsblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.datablocks)
> +rtdev_fsblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.rtblocks)
> +fsblock_bytes=$(_xfs_statfs_field "$SCRATCH_MNT" geom.bsize)
> +
> +ddev_daddrs=$((ddev_fsblocks * fsblock_bytes / 512))
> +rtdev_daddrs=$((rtdev_fsblocks * fsblock_bytes / 512))
> +
> +ddev_devno=$(stat -c '%t:%T' $SCRATCH_DEV)
> +if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
> +	rtdev_devno=$(stat -c '%t:%T' $SCRATCH_RTDEV)
> +fi
> +
> +$XFS_IO_PROG -c 'fsmap -m -n 65536' $SCRATCH_MNT | awk -F ',' \
> +	-v data_devno=$ddev_devno \
> +	-v rt_devno=$rtdev_devno \
> +	-v data_daddrs=$ddev_daddrs \
> +	-v rt_daddrs=$rtdev_daddrs \
> +'BEGIN {
> +	next_daddr[data_devno] = 0;
> +	next_daddr[rt_devno] = 0;
> +}
> +{
> +	if ($1 == "EXT")
> +		next
> +	devno = sprintf("%x:%x", $2, $3);
> +	if (devno != data_devno && devno != rt_devno)
> +		next
> +
> +	if (next_daddr[devno] < $4)
> +		printf("%sh: expected daddr %d, saw \"%s\"\n", devno,
> +				next_daddr[devno], $0);
> +		n = $5 + 1;
> +		if (n > next_daddr[devno])
> +		       next_daddr[devno] = n;
> +}
> +END {
> +	if (data_daddrs != next_daddr[data_devno])
> +		printf("%sh: fsmap stops at %d, expected %d\n",
> +				data_devno, next_daddr[data_devno], data_daddrs);
> +	if (rt_devno != "" && rt_daddrs != next_daddr[rt_devno])
> +		printf("%sh: fsmap stops at %d, expected %d\n",
> +				rt_devno, next_daddr[rt_devno], rt_daddrs);
> +}'
> +
>  # success, all done
>  status=0
>  exit
> 

