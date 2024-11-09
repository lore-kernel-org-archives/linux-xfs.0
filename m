Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B717A147C96
	for <linux-xfs@vger.kernel.org>; Sat,  9 Nov 2024 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731163526; cv=none; b=tZTmEEPxY2BZ1xRyIDNOqkbvc3v8q+46zDznMVWiV7bnxThIP8Yz+TCl4Fd9lcIUWC4NISXz2Sda6abnE2t0ni2q//c/9jed1+tTDMw6/r6MtXkcLdFL/H6cmHYVQl/6sz8bM9TE8SLCW8L4vgTpvjgDVXnTJrflznJLDk19Xh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731163526; c=relaxed/simple;
	bh=cutoGnQRKZU9iRxSMSDTUqfSXbqXLt/kbE1TY2XfZ3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIRVyBQAXVnBcKxPRT5yluafMqLX3sCJRBmWG39eKLTVgWv0x22k2i0xOCKxZo+pEQ2zmDBiWV+OyTW6/BpRhjpybjYzfBlm6cFC9FpzX4+we6ks5BXUTLc4RwqcbMfC5ahbFFvhpAR+q1O7V+7BSJ/0qyefzFCj05TkDNJ9AnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UQ6ReJ+l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UQ6ReJ+l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731163523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g3CjoQuczp6rmcvUlbRNJt8VL0+SRWNEWsJsSI+5bV0=;
	b=UQ6ReJ+l6GlluxPFV+owmKTtRS2z0OPEdlSnBdyCl49KnrHmQ51lM3Nsmraf3EN3B85N3E
	NJVpa3y+u9D7HPcrDMt3vaC4p/YxwavFBL141heibcS1cVQaQIkQJS0ghugBbhJnQkHYCU
	IL25vq6THcyNTpyctgAh1P2PX42ANBA=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-oC4abbeJO1iyShYXVaxqQw-1; Sat, 09 Nov 2024 09:45:22 -0500
X-MC-Unique: oC4abbeJO1iyShYXVaxqQw-1
X-Mimecast-MFC-AGG-ID: oC4abbeJO1iyShYXVaxqQw
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-7ee6f829458so2848812a12.3
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2024 06:45:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731163521; x=1731768321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g3CjoQuczp6rmcvUlbRNJt8VL0+SRWNEWsJsSI+5bV0=;
        b=JzG26/XEI3ZXeXeOoLOTJm80EmIXafnqiYr0qonVntVI06oyL/bZ+T4rS2b1AhiYww
         DjBJS9tNMcV0Y311KZ+SQWEV47AXGQYt0VdXZcUd9jNe5UQjqf5gX4IgZhDG/YcKCDHz
         4c4/bdigYlNymEgjkKt0qAlHtqWgCWZAS5F42kqZnRcoiqM/Or9oOiVnaws6IqDVhGup
         LEqwiRk6P8KuqcOO3mNsO5EhiGkj2V0J+AUQG5wdGCUWezgc6UHagmDKMUYi8bJxQx84
         NchZYVxIgjiTPIc67veaCiO27sWSte2aD5AozvXyIhp+mxm707k0Yx3la1mMIOHBv946
         9bgg==
X-Forwarded-Encrypted: i=1; AJvYcCUeP8axQv5z9UozneeUhaMhNCU4NqVVfjaP0j4fAEevGasCL8yUQEXh5qA+zskYEKdNEgaPi2r7ASw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSP402MN8DJRz1OzpBzAMJ5rAuabNwfehtiNyr9DN29Q0yilym
	My4VD1T106ID48qTh37y33KBVQoo0WvFxQk2ZYIZO9i0IkKJTPfg6ql+wTt+AXU2D9RDZPd24tn
	OBOlPQedN3C4A4uhCeZQYJnRMZbgF5XIGhgP18oG1+GIFGktoX+uRIChxaxKyrajeXzdE
X-Received: by 2002:a17:90b:2e42:b0:2e9:5360:22b2 with SMTP id 98e67ed59e1d1-2e9b17415f4mr9033095a91.20.1731163521223;
        Sat, 09 Nov 2024 06:45:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMN/9u7kcohcwtvE3HTNYuf7mk6yU5cVAgZmL/uxNu7pBSGIOkMlcB3JWlQt/lBA3PvpVAog==
X-Received: by 2002:a17:90b:2e42:b0:2e9:5360:22b2 with SMTP id 98e67ed59e1d1-2e9b17415f4mr9033079a91.20.1731163520878;
        Sat, 09 Nov 2024 06:45:20 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177ddf19esm47549305ad.92.2024.11.09.06.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2024 06:45:20 -0800 (PST)
Date: Sat, 9 Nov 2024 22:45:16 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zizhi Wo <wozizhi@huawei.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs/273: check thoroughness of the fsmappings
Message-ID: <20241109144516.irgjz2zllkpkqsqz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241108173907.GB168069@frogsfrogsfrogs>
 <20241108174146.GA168062@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108174146.GA168062@frogsfrogsfrogs>

On Fri, Nov 08, 2024 at 09:41:46AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enhance this test to make sure that there are no gaps in the fsmap
> records, and (especially) that they we report all the way to the end of
> the device.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/273 |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/tests/xfs/273 b/tests/xfs/273
> index d7fb80c4033429..ecfe5e7760a092 100755
> --- a/tests/xfs/273
> +++ b/tests/xfs/273
> @@ -24,6 +24,8 @@ _require_scratch
>  _require_populate_commands
>  _require_xfs_io_command "fsmap"
>  
> +_fixed_by_git_commit kernel XXXXXXXXXXXXXX "xfs: fix off-by-one error in fsmap's end_daddr usage"

The _fixed_by_kernel_commit can replace the "_fixed_by_git_commit kernel".

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
> +		next = $5 + 1;

Ahaha, awk expert Darrick :) I tried this patch, but got below error when
I tried this patch:

  +awk: cmd. line:15:             next = $5 + 1;
  +awk: cmd. line:15:                  ^ syntax error

Thanks,
Zorro

> +		if (next > next_daddr[devno])
> +		       next_daddr[devno] = next;
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

