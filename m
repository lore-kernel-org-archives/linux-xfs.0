Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3942E7659
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039784; cv=none; b=eMBv+HhpQiQtgigE4VJzbodazJ7mKvQKzZKHDQRAU9GRKDMI3vv99G8p7d1jaixPFo/Z4mLSaRrOTVKMNindQ3q6LY0QpV/pQvSlsJS2alUNojwOHJ5fIe1eZXFEcd6314qWnAO6HZPkK4S+Y5T1Bv4IrJucMdr2XoZkP+eDQyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039784; c=relaxed/simple;
	bh=P4gCDvH/zMOQGJkEZiaJWtdsJmoEYgSWmOfl8171fOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTirWDKzXRGMqEbW4Eri2xQqutOmV8mY6VTB5+RUk+81gEF5YVavkL7Dv995CQD6VuXLfEDe2ZUBhYm+1P8SNLx10Aegv9hD7LTvSN5werPcZgcHXVefmdLRDsTRJWOGT7j2VcZwVnC+0z+lxBBP9QAV6nfocBMgAn9Pd7yV3mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eCRWr7xt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eCRWr7xt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761039780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CAiylbs5rXtcRmqiMyDqRxwPYODKhX4aswI7sohZIDE=;
	b=eCRWr7xtKA3Osb94AOtzgge4wMyYkFKuxAB25rJp/VELbg3p39zUzFO7FN68ZG3ENqtofs
	JwmmqWJwh7edQCtvGCZoTrQBuU8b1sL2xEmxWz9Pu61ydtQm+nVt7bOwIjsPn3Y+75C4sv
	+AYlh8lFsmGIvgPU8h71/9lv19AbEbY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-qQGaS5LrMSGuom7FSaK9aQ-1; Tue, 21 Oct 2025 05:42:59 -0400
X-MC-Unique: qQGaS5LrMSGuom7FSaK9aQ-1
X-Mimecast-MFC-AGG-ID: qQGaS5LrMSGuom7FSaK9aQ_1761039778
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ecdb10a612so6028135f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 02:42:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761039778; x=1761644578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CAiylbs5rXtcRmqiMyDqRxwPYODKhX4aswI7sohZIDE=;
        b=aq+ngoEvkCn11p8vygoXEsShS5gaho1pX56XHgMlS4efke/PfZ1g25Nr1RqvPhpJNn
         5SPBp43l/Ey85UWUxh4z+Z59+JwNmzBmDXajNVyc5YINFLrJyMA+UfI3fsLVZEzqiMdN
         Dq1X0nI3SRFa2aNT/vIE9LnsUnaIZNcyAgtNUhceQ9d8X8QvD6BbhqBT3iCUkmBVlex3
         o57wHBa8OBaQqdu3rxio83W6HUi1MSmT8rSHjVB6Kd8rDow+gTtd/DFE2sqcnKO9VISo
         oUKHl+70tGitJqzwlaWh/y6lfIS39ifGoX3SJQIrga6zz7sjrJBbcvibHAYI1iC7kSKR
         nP0Q==
X-Gm-Message-State: AOJu0YxezLnOoEF8Ka5qf+kLI/Zw6vrtsSIj/KXLJTWaFcpB4zgCN02R
	JnKbw0o4jpq+VK0eU7MqiEYSczqQ8c6kstSbycZ1fWr5KaBV86gFTHBZeyyTilQAiNcBhqd4zXx
	KdMz9akZd2FHOUCHs0C8bhlQZvF1pWilpR2RIfeoexs7mM79tbP3285bJ3h/b
X-Gm-Gg: ASbGncvd/yKmRnbDxl22cfu0ZlAXYWcwtIVyJ2p3NXJnLaIR33xm4deJ+YII7G/HsWu
	q5bWJ92cflQuWn38WpgNt/kar6JENg9GZQs8aJvpJ49sc+wTBIXC2pVgbS5sJPumpwRnUkqM4Sk
	+NYn3ZWHkTiAaQKdqEv+5gKsxe72qpH4jf+8AaW/29qKApPO5vUiGzhBy52rOl6wkab5cYoFYs4
	VX04ZcFoUyauThbdgy1X9yNlatiJEmb62anu6tbcpjxFc+4y2jVR3PJ6Rnk7aqpCceEIlUsD8K3
	Kc1f1D0hm0S9uHTjZMQW5wRqOt9p5kZ7jF5/stmVw+juBSGFYIJFOGYZyvQYSHjUTGXNT5/FY8Q
	NytGGP6ocuFV7nHnJCqk=
X-Received: by 2002:a05:6000:2c0e:b0:426:d51c:4be8 with SMTP id ffacd0b85a97d-42704d87e06mr10215302f8f.19.1761039777725;
        Tue, 21 Oct 2025 02:42:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfxdCns6HfXonlhpN1SWHEmy7QcDZ5EriPzm36GKTVH9QB2Akl3rAXfsj/tq17gstph1b2oQ==
X-Received: by 2002:a05:6000:2c0e:b0:426:d51c:4be8 with SMTP id ffacd0b85a97d-42704d87e06mr10215279f8f.19.1761039777208;
        Tue, 21 Oct 2025 02:42:57 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce3aesm19874088f8f.48.2025.10.21.02.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 02:42:56 -0700 (PDT)
Date: Tue, 21 Oct 2025 11:42:56 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, zlang@redhat.com, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 2/3] generic/772: require filesystem to support
 file_[g|s]etattr
Message-ID: <zhavh6jregdtrt5e5jhduyijesfyl25gmgjxdur47smv5r3gmo@6pzt54rm5yj3>
References: <20251020135530.1391193-1-aalbersh@kernel.org>
 <20251020135530.1391193-3-aalbersh@kernel.org>
 <20251020164503.GN6178@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020164503.GN6178@frogsfrogsfrogs>

On 2025-10-20 09:45:03, Darrick J. Wong wrote:
> On Mon, Oct 20, 2025 at 03:55:29PM +0200, Andrey Albershteyn wrote:
> > Add _require_* function to check that filesystem support these syscalls
> > on regular and special files.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  common/rc         | 32 ++++++++++++++++++++++++++++++++
> >  tests/generic/772 |  5 ++---
> >  tests/xfs/648     |  7 +++----
> >  3 files changed, 37 insertions(+), 7 deletions(-)
> > 
> > diff --git a/common/rc b/common/rc
> > index dcae5bc33b19..78928c27da97 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -5994,6 +5994,38 @@ _require_inplace_writes()
> >  	fi
> >  }
> >  
> > +# Require filesystem to support file_getattr()/file_setattr() syscalls on
> > +# regular files
> > +_require_file_attr()
> > +{
> > +	local test_file="$SCRATCH_MNT/foo"
> 
> Should the test file be on $TEST_DIR so that you don't have an implicit
> dependency on _require_scratch?
> 
> Otherwise looks fine to me.

Oh right, will send v2

> 
> --D
> 
> > +	touch $test_file
> > +
> > +	$here/src/file_attr --set --set-nodump $SCRATCH_MNT ./foo &>/dev/null
> > +	rc=$?
> > +	rm -f "$test_file"
> > +
> > +	if [ $rc -ne 0 ]; then
> > +		_notrun "file_getattr not supported for regular files on $FSTYP"
> > +	fi
> > +}
> > +
> > +# Require filesystem to support file_getattr()/file_setattr() syscalls on
> > +# special files (chardev, fifo...)
> > +_require_file_attr_special()
> > +{
> > +	local test_file="$SCRATCH_MNT/fifo"
> > +	mkfifo $test_file
> > +
> > +	$here/src/file_attr --set --set-nodump $SCRATCH_MNT ./fifo &>/dev/null
> > +	rc=$?
> > +	rm -f "$test_file"
> > +
> > +	if [ $rc -ne 0 ]; then
> > +		_notrun "file_getattr not supported for special files on $FSTYP"
> > +	fi
> > +}
> > +
> >  ################################################################################
> >  # make sure this script returns success
> >  /bin/true
> > diff --git a/tests/generic/772 b/tests/generic/772
> > index e68a67246544..bdd55b10f310 100755
> > --- a/tests/generic/772
> > +++ b/tests/generic/772
> > @@ -20,6 +20,8 @@ _require_mknod
> >  
> >  _scratch_mkfs >>$seqres.full 2>&1
> >  _scratch_mount
> > +_require_file_attr
> > +_require_file_attr_special
> >  
> >  file_attr () {
> >  	$here/src/file_attr $*
> > @@ -43,9 +45,6 @@ touch $projectdir/bar
> >  ln -s $projectdir/bar $projectdir/broken-symlink
> >  rm -f $projectdir/bar
> >  
> > -file_attr --get $projectdir ./fifo &>/dev/null || \
> > -	_notrun "file_getattr not supported on $FSTYP"
> > -
> >  echo "Error codes"
> >  # wrong AT_ flags
> >  file_attr --get --invalid-at $projectdir ./foo
> > diff --git a/tests/xfs/648 b/tests/xfs/648
> > index e3c2fbe00b66..a268bfdb0e2d 100755
> > --- a/tests/xfs/648
> > +++ b/tests/xfs/648
> > @@ -20,10 +20,12 @@ _require_test_program "af_unix"
> >  _require_test_program "file_attr"
> >  _require_symlinks
> >  _require_mknod
> > -
> >  _scratch_mkfs >>$seqres.full 2>&1
> >  _qmount_option "pquota"
> >  _scratch_mount
> > +_require_file_attr
> > +_require_file_attr_special
> > +
> >  
> >  create_af_unix () {
> >  	$here/src/af_unix $* || echo af_unix failed
> > @@ -47,9 +49,6 @@ touch $projectdir/bar
> >  ln -s $projectdir/bar $projectdir/broken-symlink
> >  rm -f $projectdir/bar
> >  
> > -$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> > -	_notrun "file_getattr not supported on $FSTYP"
> > -
> >  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> >  	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
> >  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> > -- 
> > 2.50.1
> > 
> > 
> 

-- 
- Andrey

