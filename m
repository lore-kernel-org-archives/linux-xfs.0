Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFF52B9A7
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 04:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709008432; cv=none; b=O/SuF3DO3k6U2wtWaZY89j4+fKPHEK3iEuO9Nu1XZEwX15Ea9GVkEMK6ys6MKV0bDvGa63CcbZc9wsDx+jhzdGPFJaKoyPhc6Q/Y4WuS2vgT//3oDSxzs+V0E6iKgsU4kgGaXF6QVvqZmulv1bh8CQAmfW4IMtQNI9SsnnBOwAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709008432; c=relaxed/simple;
	bh=hehOpB5JAIlcm//G2RSZ4t3d+VpOo70K4pah3Z+4waI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2V1tN3abwkZYWlvNrb06zKVqP4MWIEbbC6QlcmfZJVn8DvzGX+RZVoMggaHEdLXyocAM7VnigaXbeug/eTx6L0CCDwNy8Btqa+i5fq5qV/vQmaaB2o1ryUsu5NMRNImmz7PaEENwgek3esath6T8x0YgbH1T0OccJVQUpEvvtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FkK8+sDe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FkK8+sDe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709008429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yNDGTAJZCVhoEtHAIquI3TePOdIzCKlNTYHgKMFv08E=;
	b=FkK8+sDeLEQrYDc75DNiI83RuXHqYYYkPzc/eZ/pyeQo01EzzfSP3aLNAXBEq6/e+4F6OY
	5kgf2gceYQQHKN2uUQl0NyoxY+GCZ/rIC6pY3KpZ9V7nLO6Cs95cjxzHFEMlgXpGz5a1tF
	0AtjSegUXVu/Bvl0gY29mg7fdsGP9tk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-dP665ykSNM-Q-MmDyYkPiQ-1; Mon, 26 Feb 2024 23:33:47 -0500
X-MC-Unique: dP665ykSNM-Q-MmDyYkPiQ-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1dc435b3e87so28912645ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 20:33:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709008426; x=1709613226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNDGTAJZCVhoEtHAIquI3TePOdIzCKlNTYHgKMFv08E=;
        b=vBBwcsnvl+FuK9FiVjrxIIP811WefCMuIB7ZRmh6Vh50dCI0K8g7Jals2De1PEgNvh
         JxkWM2IPIvKTGtcLyIUCIQBxBU3GzSPlSxTxDg9ShUtFDgCZkZuxCU0fN+6XvsXyBz3f
         ix7i4X3XH2pde49plveL6xbwfNuIeaSyir8vvjIRIgi4CsmqB2E/HmdFln92u029ZUdy
         vjo5IOfeOcT0yIuWqJLRbmyJoW/IFGVRd0Qbu9Ki/67Mi/922g4ckbTYJftd5VL5LLc9
         vmsFpecYIXwnnf91sE21TATy17zjukrFcwrocfcKH75pNhGL3kxL7IDhSLZ516w0ENkn
         bPoA==
X-Forwarded-Encrypted: i=1; AJvYcCXGpmAm7/yQzCRHRpuYDg2hvhcaAGZDlEhJ2jvSerw2PhEE9lc9lQTJGi2hd17cZvyj7ryFxv2pGS6fwC/sOmf8EknbjIe/tOSv
X-Gm-Message-State: AOJu0Yz1ubHjoC07yXV/7K187tWTUApKunCLObrsfzQkZI/W/C7lr5KS
	L4SdDNudNOb2JtP+i1hFMaWuhK9fXnzqMPK3kEczFxm908g6DkXqIMDPMgF57a1CJNVknIzq+wD
	H4hufpwva4QUTiVZvVBJmpeJoxaLdNpenvaM0BNWedHK1bezwmfsbrxD+yw==
X-Received: by 2002:a17:902:c102:b0:1db:c536:803c with SMTP id 2-20020a170902c10200b001dbc536803cmr7225886pli.33.1709008426546;
        Mon, 26 Feb 2024 20:33:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0VEsRDaXL3Y7CoFrHcOgiiUY5BNHQ9gKpWDaUseOsR+PDFOSOgZL4QovrvTZmWHeoHJTMmQ==
X-Received: by 2002:a17:902:c102:b0:1db:c536:803c with SMTP id 2-20020a170902c10200b001dbc536803cmr7225878pli.33.1709008426181;
        Mon, 26 Feb 2024 20:33:46 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id lc4-20020a170902fa8400b001dc89fe5743sm507272plb.0.2024.02.26.20.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 20:33:45 -0800 (PST)
Date: Tue, 27 Feb 2024 12:33:42 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs/599: reduce the amount of attrs created here
Message-ID: <20240227043342.74cj5a6rgmzrzpdl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915290.896550.10775908547486721272.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915290.896550.10775908547486721272.stgit@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 06:01:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Luis Chamberlain reported insane runtimes in this test:
> 
> "xfs/599 takes a long time on LBS, but it passes. The amount of time it
> takes, however, begs the question if the test is could be trimmed to do
> less work because the larger the block size the larger the number of
> dirents and xattrs are used to create. The large dirents are not a
> problem. The amount of time it takes to create xattrs with hashcol
> however grows exponentially in time.
> 
> "n=16k   takes 5   seconds
> "n=32k   takes 30  seconds
> "n=64k     takes 6-7 minutes
> "n=1048576 takes 30 hours
> 
> "n=1048576 is what we use for block size 32k.
> 
> "Do we really need so many xattrs for larger block sizes for this test?"
> 
> No, we don't.  The goal of this test is to create a two-level dabtree of
> xattrs having identical hashes.  However, the test author (me)
> apparently forgot that if a dabtree is created in the attr fork, there
> will be a dabtree entry for each extended attribute, not each attr leaf
> block.  Hence it's a waste of time to multiply da_records_per_block by
> attr_records_per_block.
> 
> Reported-by: Luis Chamberlain <mcgrof@kernel.org>
> Fixes: 1cd6b61299 ("xfs: add a couple more tests for ascii-ci problems")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Thanks for this fix, it save much time for us too :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/599 |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/tests/xfs/599 b/tests/xfs/599
> index b55b62d7f5..57a797f0f5 100755
> --- a/tests/xfs/599
> +++ b/tests/xfs/599
> @@ -43,14 +43,13 @@ longname="$(mktemp --dry-run "$(perl -e 'print "X" x 255;')" | tr ' ' 'X')"
>  echo "creating $nr_dirents dirents from '$longname'" >> $seqres.full
>  _scratch_xfs_db -r -c "hashcoll -n $nr_dirents -p $crash_dir $longname"
>  
> -# Create enough xattrs to fill two dabtree nodes.  Each attribute leaf block
> -# gets its own record in the dabtree, so we have to create enough attr blocks
> -# (each full of attrs) to get a dabtree of at least height 2.
> +# Create enough xattrs to fill two dabtree nodes.  Each attribute entry gets
> +# its own record in the dabtree, so we have to create enough attributes to get
> +# a dabtree of at least height 2.
>  blksz=$(_get_block_size "$SCRATCH_MNT")
>  
> -attr_records_per_block=$((blksz / 255))
>  da_records_per_block=$((blksz / 8))	# 32-bit hash and 32-bit before
> -nr_attrs=$((da_records_per_block * attr_records_per_block * 2))
> +nr_attrs=$((da_records_per_block * 2))
>  
>  longname="$(mktemp --dry-run "$(perl -e 'print "X" x 249;')" | tr ' ' 'X')"
>  echo "creating $nr_attrs attrs from '$longname'" >> $seqres.full
> 

