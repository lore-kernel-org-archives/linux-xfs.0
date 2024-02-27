Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459691B962
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 04:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709007387; cv=none; b=Eq/kdWUdr1P888th9XA28eEQleMqmpfzM2otMWTqNDClnPwMTcD//YNLqlB/nbTeMmPKGDsg4Nm1m8OyTy0OsQV5W8Yis46dSDfI7DShEGDODyD30ymm8xb/bPgwdfMkn3FUTNHqU8hCv3GpTioZQY5AhR4Sf5rfuPL3SIG5Xfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709007387; c=relaxed/simple;
	bh=fCZxZ79T+RHJupTqN8Cyk6BgPOPbjb0B04KksYNWTCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hV7iFUO4251rFQYa+65z7KugtHlF6z4hbVlJzdfI8Rfggqa0YMTAm2o+TmeCuF/c2lJk5kRWdRLBEzC5B52ParmN4d6LuQ/+lEjuEulIs4pLrubdQIpDJi4pSo7S8CpMFr0vBCILz8mp5cQgCcKZB9M1fmBGe1duzBmOZffI1V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HABqEKw2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HABqEKw2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709007378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eyOoA5koOVutIKiKKqZk9fEO+ed02Y7qXkvJabUcrV4=;
	b=HABqEKw2zFYwlnmfNVusJR4qgpzKlQa1+mqvcPYNxHj2depuIlGzr5OO57OJa7SGI5qE22
	4kmZgloDyv5snNg6Mkd+fBm9UKfBkV9jw9FB66EbWZfDTD4cZI4tiE03GW2md3Zs7JLRM6
	lBZE3C1SAuqW/F5y1lkT/k9ZNdJx6rA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-zCp1q43UPhSREHkpTBtHqg-1; Mon, 26 Feb 2024 23:16:17 -0500
X-MC-Unique: zCp1q43UPhSREHkpTBtHqg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1dc8b828178so18323885ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 20:16:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709007376; x=1709612176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eyOoA5koOVutIKiKKqZk9fEO+ed02Y7qXkvJabUcrV4=;
        b=TegAIiRrqRnjaQWonV5vPYRZVUN0Sghcap5yXcSyoaoGk/qX5Mj/ijgb6M1GRKiHbO
         iiGdbDB+5t3aj/bN6LRlygUsowX9/z7nsAgLxgkmmyGRnBZ8VK406bBXDkPmQP+3PEPO
         KxqXeUA3GeT/XDoIa+HnhQh9nZajGvpSx/+8bGTJjrShlHoqT21+AUqcw7hoyp5/GwRj
         bKt7C55bPS6HF3uKWSGPqSkR63i0HeE+HhDtdViQ2dF7/xBdykitWS5q4J8SlqSa6E6o
         nLZWsvbNqoQ/IatWu7gkhlPFLclBsMNSmMWpGzhj8XUmK6rtK3nMIRN2dmDn/pAg9MKn
         Vg/g==
X-Gm-Message-State: AOJu0YzTmJkbOnpvGmBupxniyptBAPWdkptp7Z5J0o2S1+SP54mAaOQM
	1SEKYI5ObSGVUw2H8uERK9RtwJ9kDT59cDtKVT4RZXwarPNc9/QCphuO6IJrvsdxXMVo4jB+m7Y
	h8UlOM3hcjieVSL8lZOcAvJXoUSHoDwQDvQhlmw5YGZgJFzhmPKNFkC8Fd7NjBoiYCxNI
X-Received: by 2002:a17:902:da85:b0:1dc:b382:da8d with SMTP id j5-20020a170902da8500b001dcb382da8dmr2772516plx.38.1709007375955;
        Mon, 26 Feb 2024 20:16:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEtL0l/FbYeQ2m9KCNgqISJYl3BE2vkVGA6xjyM3ltrKAeyisLx3FG1llAOIvVaUfQ+P3V/Kw==
X-Received: by 2002:a17:902:da85:b0:1dc:b382:da8d with SMTP id j5-20020a170902da8500b001dcb382da8dmr2772500plx.38.1709007375614;
        Mon, 26 Feb 2024 20:16:15 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id kv15-20020a17090328cf00b001d9c1d8a401sm466250plb.191.2024.02.26.20.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 20:16:15 -0800 (PST)
Date: Tue, 27 Feb 2024 12:16:12 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs/155: fail the test if xfs_repair hangs for too
 long
Message-ID: <20240227041612.pdprea6bzmncaput@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915247.896550.12193016117687961302.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915247.896550.12193016117687961302.stgit@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 06:01:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a few hard to reproduce bugs in xfs_repair where it can
> deadlock trying to lock a buffer that it already owns.  These stalls
> cause fstests never to finish, which is annoying!  To fix this, set up
> the xfs_repair run to abort after 10 minutes, which will affect the
> golden output and capture a core file.
> 
> This doesn't fix xfs_repair, obviously.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/155 |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/tests/xfs/155 b/tests/xfs/155
> index 302607b510..fba557bff6 100755
> --- a/tests/xfs/155
> +++ b/tests/xfs/155
> @@ -27,6 +27,10 @@ _require_scratch_xfs_crc		# needsrepair only exists for v5
>  _require_populate_commands
>  _require_libxfs_debug_flag LIBXFS_DEBUG_WRITE_CRASH
>  
> +# Inject a 10 minute abortive timeout on the repair program so that deadlocks
> +# in the program do not cause fstests to hang indefinitely.
> +XFS_REPAIR_PROG="timeout -s ABRT 10m $XFS_REPAIR_PROG"

Others cases of fstests always do:
  _require_command "$TIMEOUT_PROG" timeout
before using timeout.

Others looks good to me, as you only change single one case, it won't affect other testing.
Just hope the 10 minutes is enough even if on a big storage :)

Thanks,
Zorro

> +
>  # Populate the filesystem
>  _scratch_populate_cached nofill >> $seqres.full 2>&1
>  
> 

