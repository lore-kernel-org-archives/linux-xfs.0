Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FA0A939
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 10:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732184244; cv=none; b=KOHwWwRES8t8NVw2f/Bia/bSjBF2oqlOLZUhBahPekXAVs/+SEvjIJfPq9afYEbVS6GTvYib8E+KXTgsOm8QmDbiT9QD944jGA/xAXViXijHh+doAnEmdL+1dh8OVrOi+rSxTqFEJj83E/MOK289kXIM7xQtrMxj38/nLt+uKJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732184244; c=relaxed/simple;
	bh=M3YnYS9wQaFUhNZkhE2Oau3JoJyInBh1WD6qka1EFKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTEd5MFCUUS8Ysyw5KzBq3XgQREKUBqbTILkIbZlNL8PGjWz5ZxmvF484OjPvqthEDO4kNy3Vlikw0cdMYcByTk3pXAqUeHN0zvRyQRw+Eu6nZ6yB/hzS7XceZCxJAJs52N2M4MVVFfPgAkvYE3rSl0kJUTNbD7yF6fcEojlnso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cn6U9ZNo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cn6U9ZNo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732184241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qrG6FN/UQSoXCy9CV4FV+KyHxDyYwx9xkKaL5QgRjbk=;
	b=Cn6U9ZNoBQ/0JtTPfcjbYx+Xeco8cxTn2/0/Q5IAzvxKe3W3t/U3TJfjItzc0nv/dTtM+R
	+qa0Fo15BtYobppKHGIqKBL2+7V0T2YiPO2J88aD1i057J2lcFRVRJZgRSNPFw66NxnGLC
	pj2WPYfxky7UQMX8r08nGOGwkrPG1DY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-929lDVwgPESh1G9hsJ6cgA-1; Thu, 21 Nov 2024 05:17:18 -0500
X-MC-Unique: 929lDVwgPESh1G9hsJ6cgA-1
X-Mimecast-MFC-AGG-ID: 929lDVwgPESh1G9hsJ6cgA
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2ea3c9178f6so955015a91.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 02:17:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732184236; x=1732789036;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qrG6FN/UQSoXCy9CV4FV+KyHxDyYwx9xkKaL5QgRjbk=;
        b=JLjBKjWMiFWIhzPO8zNMFCdcIITOiW9nm4qkxjyUO7/M992shwRguhDbyvfidZq19e
         rewjQu1hISAjOgIK/GwaWCnUP1tsNZNxBdJ0D41TUDlK1dDuP5ZkNZyft1wluG2mHXjc
         RQ8MkcasbUN3qxeVWyhyhNYZaM7ygFd4HDJTxsRa0GRWDvJYO+1ecDS44DnC/Na6cyj4
         t7rvGFqvG96z2+v+uS/uqPA/0fAYCuL9YApc+ddQWIAtAYcloBMtP4iSaCjVf7TDb1x1
         ITCdZDZTIP0KlZVWPar+mPES8Y+5iJaIyV2fUvK3oEfoqS1sNR5Jp46mfYb0H+bwOZK5
         hAww==
X-Forwarded-Encrypted: i=1; AJvYcCUS+3V+K01RuWCem0urCPxX3y2x7cilTnlfVJOAr/ebpoGqqHKKyEmyNXM08W8PdywFiIYyclQyArw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM3mtVS/yhkLM4sClGzYXsUBzss++Gfwx+Vpn4vENIaDc9krR/
	QfD7ZBdPhVNpv7VHkoeI6qFeiCEGddDEI/qzfn4UrVQSQ53BLyZSUyIAzerSTqmWhZia/KjzExq
	e9iqqoA8eiOyvLrpDAe+Bu0vh70ZROTC+rXnrvp6av52fpJ7mU2idTz1iIENTksGuupJl
X-Gm-Gg: ASbGncsBfL9jCjMgg28kc8G+Tw+/MTWoWvPJXDAIw0g1Adsk5AOuOFbd2NXxmJbyqO5
	viWOdLcJYztN9P+2mBRBnfKP7Ep9mgRb96TaWJJShzpILPBougVLkjtQaXHEixxyl3euhRp8jA8
	Wj4+j56ExBwdCeXKVEv2fWmxgx8veEvUDGjKtjcjtRXPOegCcBz5RIC4UJ+Ui4+6hYBYgMVxeZ3
	J7UAuTRJI7PsSxfZBryejnH0zVOQsPAjOvkkvN4AQoud7ovQL9tLRKAL/kbzaXq5yijGQUuRww4
	wVoXxGRYuOpSOF4=
X-Received: by 2002:a17:90b:4c8e:b0:2ea:5e0c:2848 with SMTP id 98e67ed59e1d1-2eaca70a894mr7508907a91.14.1732184236614;
        Thu, 21 Nov 2024 02:17:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1rmkHmET3WzotuB11BQlZdFTw6uOVie3FkDnXxWjYLTXyigbA6bgxrW1UsvDU/ezGxSk71A==
X-Received: by 2002:a17:90b:4c8e:b0:2ea:5e0c:2848 with SMTP id 98e67ed59e1d1-2eaca70a894mr7508891a91.14.1732184236249;
        Thu, 21 Nov 2024 02:17:16 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ead033494asm2883693a91.25.2024.11.21.02.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 02:17:15 -0800 (PST)
Date: Thu, 21 Nov 2024 18:17:12 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs/157: fix test failures when MKFS_OPTIONS has
 -L options
Message-ID: <20241121101712.qdtdk63aq6kp4pdm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064609.904310.7896567442225446738.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197064609.904310.7896567442225446738.stgit@frogsfrogsfrogs>

On Mon, Nov 18, 2024 at 03:04:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Zorro reports that this test fails if the test runner set an -L (label)
> option in MKFS_OPTIONS.  Fix the test to work around this with a bunch

I didn't hit the xfs/157 failure by setting "-L label" in MKFS_OPTIONS,
I set MKFS_OPTIONS="-m rmapbt=1" in local.config, then "-m rmapbt=1" is
conflict with rtdev, that cause the "-L oldlabel" be dropped by
_scratch_mkfs_sized.

I don't mind having this "xfs/157 enhancement" patch. But as we've talked,
I don't think any testers would like to write MKFS_OPTIONS="-L label" in
local.config. So this patch might not be necessary. What do you think?

Thanks,
Zorro

> of horrid sed filtering magic.  It's probably not *critical* to make
> this test test work with random labels, but it'd be nice not to lose
> them.
> 
> Cc: <fstests@vger.kernel.org> # v2024.10.14
> Fixes: 2f7e1b8a6f09b6 ("xfs/157,xfs/547,xfs/548: switch to using _scratch_mkfs_sized")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/157 |   29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/xfs/157 b/tests/xfs/157
> index e102a5a10abe4b..0c21786e389695 100755
> --- a/tests/xfs/157
> +++ b/tests/xfs/157
> @@ -65,9 +65,34 @@ scenario() {
>  	SCRATCH_RTDEV=$orig_rtdev
>  }
>  
> +extract_mkfs_label() {
> +	set -- $MKFS_OPTIONS
> +	local in_l
> +
> +	for arg in "$@"; do
> +		if [ "$in_l" = "1" ]; then
> +			echo "$arg"
> +			return 0
> +		elif [ "$arg" = "-L" ]; then
> +			in_l=1
> +		fi
> +	done
> +	return 1
> +}
> +
>  check_label() {
> -	_scratch_mkfs_sized "$fs_size" "" -L oldlabel >> $seqres.full 2>&1
> -	_scratch_xfs_db -c label
> +	local existing_label
> +	local filter
> +
> +	# Handle -L somelabel being set in MKFS_OPTIONS
> +	if existing_label="$(extract_mkfs_label)"; then
> +		filter=(sed -e "s|$existing_label|oldlabel|g")
> +		_scratch_mkfs_sized $fs_size >> $seqres.full
> +	else
> +		filter=(cat)
> +		_scratch_mkfs_sized "$fs_size" "" -L oldlabel >> $seqres.full 2>&1
> +	fi
> +	_scratch_xfs_db -c label | "${filter[@]}"
>  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
>  	_scratch_xfs_db -c label
>  	_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> 

