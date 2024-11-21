Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A0A14EC55
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 09:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732180662; cv=none; b=drvbQOTNxLV9V4AKDkR0IbfzH4Fo4oALDjK8CZSsWqsfEObx5k0TPKDDSzXxjXKQns3h7NyQEDNdVNQvRiYr+OHulnCoL/VIbKEXDAalWeOqkIfasnxibQQyBMIZ6IphBiAzW3bq5/MJ9nIzbvYyyfdFiIz8SUDjw1Q7t3ZGvmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732180662; c=relaxed/simple;
	bh=rSwQmXUj4krzBoA2DXn7wkxpp+LWrBw1vh/MA3jCvL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lA1T2i6Fsn8LF7oIAlQ87i3YBkk6YnzFl63A6MIKHoNDqYnIqSjKksrSIgQtxvPKts2lFyVbDx0mIRhpObzwL2BuP2dzSeb7errmWtjD+PF5e/LciWvHYX03EIOJwIHkdYDl55CeCq6X6tiOEtFp6zBhO4XMbXl8nrOpPYCjRzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LINEBfoI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LINEBfoI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732180659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NWynQ17JVVdzwmK7zsV5nN/jjmRiA2ROsatZlh5cw5A=;
	b=LINEBfoIx50BEQnfzfikbND7mJf+2xdQUkqOY72ccjnHQBiaE/+fGQZ2/YsxIGVGCgdUpJ
	v9sN8XXOiPH7kPmbzx7kjk/1O9orgqEiSwOuosaLAJJiJomet40KmLY8GCLSY8nb9U8HSI
	FR3+Y6yQ0SMOoK3pEpYlI/KCS4g6pqg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-rcnYPj-eMxGMY7K-okdSfA-1; Thu, 21 Nov 2024 04:17:38 -0500
X-MC-Unique: rcnYPj-eMxGMY7K-okdSfA-1
X-Mimecast-MFC-AGG-ID: rcnYPj-eMxGMY7K-okdSfA
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2120c877e75so8052505ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 01:17:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732180657; x=1732785457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NWynQ17JVVdzwmK7zsV5nN/jjmRiA2ROsatZlh5cw5A=;
        b=G/uQKwVLNRk4ZfC6p8de2E59y9b+O7Twq727MQRHinbsQQEvr6O+149kUIc+YXTmfg
         04x58QI+z6Lx2D5UxQMs8HupRNCKjAufjfSYbNS11WA2Pt38dJhWQsF8/Ouc2ZNBIvAS
         EvmfugI9G0ebPRrsenRCu2RywSkozfeTJpYQLvVrrS/IPq2kLLqCOmVIMXFTajsdIymm
         BDjAYJpPoLFiKXJu6iE3B2dI2LPlUpTFec8yqULMGkvf33y8QgrvAjGKCznLkntsqxg+
         bD1qQzxRgE7mc+qifE7KhCSJdc2GE9bgLqILm5E/I4oex2vvwPLZkFTCppMFAEaw0qeU
         GFog==
X-Forwarded-Encrypted: i=1; AJvYcCX4KB0oW9XUUEsFpA6QojdaH3IIxdHz7eRf0LEMiH6pJ6oo/iem7bB4G0ycIHT/KxkYsZicD/mA9DI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXl23w3EAny5NsnL3w/iBg9tODbPbuHp26FCuU+9YVzItOT8u1
	Sdqr0h9hlrHV0nBDSRF2q8nfDKqLLv7tVquVZl7NFsqFEW55XMQ6mih5i/iqVx9eDXHSLmfgHpu
	zt0a0oxIBKg+V/5MjJ+tyZdkqi+mXrmXb75tm3Y71OEsFv0rCaksPBZlSHAS2bdMV9Sgt
X-Gm-Gg: ASbGncs76//zI7xt5yDNxLMK1pTp6m+j1xRunH8Wq6YKC+lbz1r1N/zVXSsVVai+Ip8
	xpgNSt6u3eThvZoWkbVOI8/yh4gZs16KnPjsv9f/+WGrCvRw5zclP/lKA7c6RcvnLazB6+nk+E7
	x/1FF40+pM8PATMmOM0cfvm/xobPf3QtslRNmWQo/QDyxJVxfXAMyPZoTTawTcEq/Yy4fhwA6U8
	uAyLKe1Ri3yM8bhvp2BUWvyS8gDxOrzy1eiQDX0YNuEuMKt+8DD7V7pVTUsNKGiGRAKTNIBKXxF
	PDH/xtg1AVtP//U=
X-Received: by 2002:a17:903:251:b0:20c:9d8d:1f65 with SMTP id d9443c01a7336-2126c11bf0fmr78131445ad.30.1732180657204;
        Thu, 21 Nov 2024 01:17:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmZSAdJrRh5LAgkwqSHaE9Hyj5J5TIvtOdVxAlTT/5ropqcFpoWz6NRe+pLvjvYKslEn254w==
X-Received: by 2002:a17:903:251:b0:20c:9d8d:1f65 with SMTP id d9443c01a7336-2126c11bf0fmr78131215ad.30.1732180656839;
        Thu, 21 Nov 2024 01:17:36 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21287ee158csm9176395ad.131.2024.11.21.01.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 01:17:36 -0800 (PST)
Date: Thu, 21 Nov 2024 17:17:33 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] common/rc: _scratch_mkfs_sized supports extra
 arguments
Message-ID: <20241121091733.iumhfm2esby6aidt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241116190800.1870975-1-zlang@kernel.org>
 <20241116190800.1870975-2-zlang@kernel.org>
 <20241118222136.GJ9425@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241118222136.GJ9425@frogsfrogsfrogs>

On Mon, Nov 18, 2024 at 02:21:36PM -0800, Darrick J. Wong wrote:
> On Sun, Nov 17, 2024 at 03:07:59AM +0800, Zorro Lang wrote:
> > To give more arguments to _scratch_mkfs_sized, we generally do as:
> > 
> >   MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size
> > 
> > to give "-L oldlabel" to it. But if _scratch_mkfs_sized fails, it
> > will get rid of the whole MKFS_OPTIONS and try to mkfs again.
> > Likes:
> > 
> >   ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
> >   ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **
> > 
> > But that's not the fault of "-L oldlabel". So for keeping the mkfs
> > options ("-L oldlabel") we need, we'd better to let the
> > scratch_mkfs_sized to support extra arguments, rather than using
> > global MKFS_OPTIONS.
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> >  common/rc | 34 ++++++++++++++++++----------------
> >  1 file changed, 18 insertions(+), 16 deletions(-)
> > 
> > diff --git a/common/rc b/common/rc
> > index 2af26f23f..ce8602383 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -1023,11 +1023,13 @@ _small_fs_size_mb()
> >  }
> >  
> >  # Create fs of certain size on scratch device
> > -# _try_scratch_mkfs_sized <size in bytes> [optional blocksize]
> > +# _try_scratch_mkfs_sized <size in bytes> [optional blocksize] [other options]
> >  _try_scratch_mkfs_sized()
> >  {
> >  	local fssize=$1
> > -	local blocksize=$2
> > +	shift
> > +	local blocksize=$1
> > +	shift
> >  	local def_blksz
> >  	local blocksize_opt
> >  	local rt_ops
> > @@ -1091,10 +1093,10 @@ _try_scratch_mkfs_sized()
> >  		# don't override MKFS_OPTIONS that set a block size.
> >  		echo $MKFS_OPTIONS |grep -E -q "b\s*size="
> >  		if [ $? -eq 0 ]; then
> > -			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops
> > +			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops "$@"
> >  		else
> >  			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops \
> > -				-b size=$blocksize
> > +				-b size=$blocksize "$@"
> >  		fi
> >  		;;
> >  	ext2|ext3|ext4)
> > @@ -1105,7 +1107,7 @@ _try_scratch_mkfs_sized()
> >  				_notrun "Could not make scratch logdev"
> >  			MKFS_OPTIONS="$MKFS_OPTIONS -J device=$SCRATCH_LOGDEV"
> >  		fi
> > -		${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> > +		${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
> >  		;;
> >  	gfs2)
> >  		# mkfs.gfs2 doesn't automatically shrink journal files on small
> > @@ -1120,13 +1122,13 @@ _try_scratch_mkfs_sized()
> >  			(( journal_size >= min_journal_size )) || journal_size=$min_journal_size
> >  			MKFS_OPTIONS="-J $journal_size $MKFS_OPTIONS"
> >  		fi
> > -		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV $blocks
> > +		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize "$@" $SCRATCH_DEV $blocks
> >  		;;
> >  	ocfs2)
> > -		yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> > +		yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
> >  		;;
> >  	udf)
> > -		$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> > +		$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
> >  		;;
> >  	btrfs)
> >  		local mixed_opt=
> > @@ -1134,33 +1136,33 @@ _try_scratch_mkfs_sized()
> >  		# the device is not zoned. Ref: btrfs-progs: btrfs_min_dev_size()
> >  		(( fssize < $((256 * 1024 * 1024)) )) &&
> >  			! _scratch_btrfs_is_zoned && mixed_opt='--mixed'
> > -		$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
> > +		$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize "$@" $SCRATCH_DEV
> >  		;;
> >  	jfs)
> > -		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS $SCRATCH_DEV $blocks
> > +		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS "$@" $SCRATCH_DEV $blocks
> >  		;;
> >  	reiserfs)
> > -		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> > +		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
> >  		;;
> >  	reiser4)
> >  		# mkfs.resier4 requires size in KB as input for creating filesystem
> > -		$MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize $SCRATCH_DEV \
> > +		$MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize "$@" $SCRATCH_DEV \
> >  				   `expr $fssize / 1024`
> >  		;;
> >  	f2fs)
> >  		# mkfs.f2fs requires # of sectors as an input for the size
> >  		local sector_size=`blockdev --getss $SCRATCH_DEV`
> > -		$MKFS_F2FS_PROG $MKFS_OPTIONS $SCRATCH_DEV `expr $fssize / $sector_size`
> > +		$MKFS_F2FS_PROG $MKFS_OPTIONS "$@" $SCRATCH_DEV `expr $fssize / $sector_size`
> >  		;;
> >  	tmpfs)
> >  		local free_mem=`_free_memory_bytes`
> >  		if [ "$free_mem" -lt "$fssize" ] ; then
> >  		   _notrun "Not enough memory ($free_mem) for tmpfs with $fssize bytes"
> >  		fi
> > -		export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
> > +		export MOUNT_OPTIONS="-o size=$fssize "$@" $TMPFS_MOUNT_OPTIONS"
> >  		;;
> >  	bcachefs)
> > -		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt $SCRATCH_DEV
> > +		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt "$@" $SCRATCH_DEV
> >  		;;
> >  	*)
> >  		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
> > @@ -1170,7 +1172,7 @@ _try_scratch_mkfs_sized()
> >  
> >  _scratch_mkfs_sized()
> >  {
> > -	_try_scratch_mkfs_sized $* || _notrun "_scratch_mkfs_sized failed with ($*)"
> > +	_try_scratch_mkfs_sized "$@" || _notrun "_scratch_mkfs_sized failed with ($@)"
> 
> Nit: Don't use '$@' within a longer string -- either it's "$@" so that
> each element in the arg array is rendered individually as a separate
> string parameter to the program being called, or "foo $*" so that you
> end up with a single string.

Hi Darrick, do you mean I should keep the later $*? Likes:

  _try_scratch_mkfs_sized "$@" || _notrun "_scratch_mkfs_sized failed with ($*)"

> 
> shellcheck will complain about that, though bash itself doesn't seem to
> care.
> 
> --D
> 
> >  }
> >  
> >  # Emulate an N-data-disk stripe w/ various stripe units
> > -- 
> > 2.45.2
> > 
> > 
> 

