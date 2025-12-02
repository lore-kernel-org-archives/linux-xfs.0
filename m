Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277862F49E0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 04:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764649033; cv=none; b=D/kpOFqLeVm5+G42kx+q8q2op8nJ/RK+iogt2S+gIIhqeKD3kw6P3jjTt6UIlIw11KBmf/rzhGhe9r6JU9zjqAQST2wI4TsTtAQoFalzf/ZeAQLHCDfvqW0Mwcg+sQxIvbuqFJMWfZyKea4d9tonKTx0Mt8PBM+PIZUfw5VoxoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764649033; c=relaxed/simple;
	bh=ah5nYOP6c9lSuKDe49RQ5yuYYM+3psF1VX0FA8BUvSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gc3qgzwpxt/LKnbAp7O1CXIg8EApZhF42x6BwtX8LVkOxhrSXDLoVgABr0HhTEtFy7SYw/kBYwixIhF2eoRQm3Dy2X4lty48306TsTn+vDjbuIgJLoEXtjuX6XYptO+1PzriBS390UGnGWDoUz1mRIYeOAUifLodkIB7wty4DXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AyOZel7Y; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qV2aJjWt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AyOZel7Y";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qV2aJjWt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764649030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOVhVPby26S7Sm2GODw1N28S+VVsoHvVcOsIsxdA41Q=;
	b=AyOZel7YFTie4yKCTtv4fc/qjoeR3gCiNI4YpLg6jdP7izcq52RoBwJ49V7VCYB826m5ph
	aM84ZtVM9gr0I56Yul7pjInsD6Liw2bOJiJfrl8KE6cuYms8ZaEHck0WibG3068A2Yubge
	s97R/GPP9ZpOfU/dOaVSYrOcXMD5KN4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-rjLZAIVoMiCflozsmlCt6A-1; Mon, 01 Dec 2025 23:17:08 -0500
X-MC-Unique: rjLZAIVoMiCflozsmlCt6A-1
X-Mimecast-MFC-AGG-ID: rjLZAIVoMiCflozsmlCt6A_1764649028
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-343fb64cea6so8963362a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 20:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764649028; x=1765253828; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOVhVPby26S7Sm2GODw1N28S+VVsoHvVcOsIsxdA41Q=;
        b=qV2aJjWtikSKBZypQzcb74LxQjr6QE62pM+8xNFUEMYdMBQzHJuqLhnDRRB9QbQhxS
         VpudV2JQogUOCSvbVAg1vFOy8imSOLQfA56V/u9a5a5EhhnBzbO7RBIPmkHg/FzwG9wT
         dCZ/MXZzQpbwqUC5EKqrziG5ZSupj4trdf+4xrzEzdbjh0runA0Xlo7hz+gdWBDmPK+D
         S7PE7jjPnA19/wu4uOROaadDS7+pJEUEuSLTT3D6ZfVL+2+27fVUF2q3DulOPbmrg4Xn
         ilNWijINb3wh174Ie3F69w4Fgd65bPQ7M+B9LxuS/dfD0i9WMK8PN/ImgjWsOh+NH5cM
         LRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764649028; x=1765253828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOVhVPby26S7Sm2GODw1N28S+VVsoHvVcOsIsxdA41Q=;
        b=DBaYI0s5704vJpi8CF3OMNVVjRFWnAZtOV0hDMhVfnVSoQ4d/bbfh2Y9Avgcl7G8Na
         FiZFGxhZlzLO6DBqH4Jb8vM4KhBoOSsY4DbibM25diGTwSAJcY4mo67X33CYwTQ8mBNa
         AFYiXBw+P7KrEUs/TBdB7nK7uyXhArLSOKM2ztoJFqbChRpdRKDgzEFdbxlqcSmijup9
         LOjeLxclL46mg+cF0uPyKKxbb2H1cBrCCqr6TFFvT9+ctBdgii2klfWsiHMAPSVpUiIe
         /rPfsL9dL7yyr80nftM8Up5hAY2eXyoF7DWf2/e8ud25Q8+jWtTZVeRgVl0TasznDR4g
         L7tA==
X-Forwarded-Encrypted: i=1; AJvYcCX26JWs8DFzC2OfJPPIjXgO/BzO9J0mv0xOxAbvtf3zU88Ys1rMegSvP6xKuH+gLO78gkqG3RdKfrU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkvCa3+zN+EqcN+qO82iwuVQaHGZTkOKxI8qGtzs1SxofuS9Pw
	kP7qvI/CrzKfhuKBzjI+dhUS5jEq8Alp82AWq0bUQe8t56HXkmtgVZa6kVqGfbAYxDv3ys55c+V
	STn9UF87dNkfME9NlG8inxwz3scnKdQS8JlT6kOyCG1KuepaQEQt7sZ+3yY8PYQ==
X-Gm-Gg: ASbGnctaVUW3QBm2HNMnMxfFo/IPzeo1s6/SxU5TkBkhaHAypOxYoYu3ul7sFyppyZo
	EF4gcsOjOyb0UKFU1NHkP0qvRETgsojeUsPToQEDmnWyEgRsGj4Eqz0K/pgQon1HN454Z3Gku0c
	+ya+yKnLqOcy8Jpe0SJUWia3It02lHOMJ+PkCF6tdXjs5zsIyc0uke9OzVLretEaA2IansTWl1P
	I+8taEtJJNjx9zJ0XVJeoG5G0FsmFk526Hm8kFTCb6tTj/5qgm2fyJVMk59TPLoc+1vLyISO8NM
	nevSriZIqQny21l3opvClNPXUaGtNn+SzkNbdMbL7oGiiWxHI9dcSIpYmWPl5hQo1/bohVbyyvF
	tWjTjp7nju5kq5/PLqXMDa0RO8aJVrb58SbdUfaAbCkpNBBOJ1g==
X-Received: by 2002:a17:90b:1c91:b0:32b:df0e:9283 with SMTP id 98e67ed59e1d1-34733f3e84fmr36685149a91.34.1764649027561;
        Mon, 01 Dec 2025 20:17:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEar7S2w5DviYqZgaxduHjgAYE/sRtZ6cpfS/3FDaT23TH2FRg4PWLmyOMfqyTzuB9g1zt2ZQ==
X-Received: by 2002:a17:90b:1c91:b0:32b:df0e:9283 with SMTP id 98e67ed59e1d1-34733f3e84fmr36685112a91.34.1764649026925;
        Mon, 01 Dec 2025 20:17:06 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b1cbdc0sm14643857a91.2.2025.12.01.20.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 20:17:06 -0800 (PST)
Date: Tue, 2 Dec 2025 12:17:01 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Su Yue <glass.su@suse.com>, fstests@vger.kernel.org, l@damenly.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: use _qmount_option and _qmount
Message-ID: <20251202041701.cb2yzns2ytddt7dh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251124132004.23965-1-glass.su@suse.com>
 <20251201225924.GA89454@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201225924.GA89454@frogsfrogsfrogs>

On Mon, Dec 01, 2025 at 02:59:24PM -0800, Darrick J. Wong wrote:
> On Mon, Nov 24, 2025 at 09:20:04PM +0800, Su Yue wrote:
> > Many generic tests call `_scratch_mount -o usrquota` then
> > chmod 777, quotacheck and quotaon.
> 
> What does the chmod 777 do, in relation to the quota{check,on} programs?
> Is it necessary for the root dir to be world writable (and executable!)
> for quota tools to work?

Hi Darrick,

The _qmount always does "chmod ugo+rwx $SCRATCH_MNT", I think it's for regular
users (e.g. fsgqa) can write into $SCRATCH_MNT. If a test case doesn't use
regular user, the "chmod 777" isn't necessary. The author of _qmount might
think "chmod 777 $SCRATCH_MN" doesn't hurt anything quota test, so always
does that no matter if it's needed. If you think it hurts something, we can
only do that for the cases who really need that :)

I think this patch trys to help quota test cases to use unified common helpers,
most of them don't need the "chmod 777" actually, right Su?

Thanks,
Zorro

> 
> > It can be simpilfied to _qmount_option and _qmount. The later
> > function already calls quotacheck, quota and chmod.
> > 
> > Convertaions can save a few lines. tests/generic/380 is an exception
> 
> "Conversions" ?
> 
> --D
> 
> > because it tests chown.
> > 
> > Signed-off-by: Su Yue <glass.su@suse.com>
> > ---
> >  tests/generic/082 |  9 ++-------
> >  tests/generic/219 | 11 ++++-------
> >  tests/generic/230 | 11 ++++++-----
> >  tests/generic/231 |  6 ++----
> >  tests/generic/232 |  6 ++----
> >  tests/generic/233 |  6 ++----
> >  tests/generic/234 |  5 ++---
> >  tests/generic/235 |  5 ++---
> >  tests/generic/244 |  1 -
> >  tests/generic/270 |  6 ++----
> >  tests/generic/280 |  5 ++---
> >  tests/generic/400 |  2 +-
> >  12 files changed, 27 insertions(+), 46 deletions(-)
> > 
> > diff --git a/tests/generic/082 b/tests/generic/082
> > index f078ef2ffff9..6bb9cf2a22ae 100755
> > --- a/tests/generic/082
> > +++ b/tests/generic/082
> > @@ -23,13 +23,8 @@ _require_scratch
> >  _require_quota
> >  
> >  _scratch_mkfs >>$seqres.full 2>&1
> > -_scratch_mount "-o usrquota,grpquota"
> > -
> > -# xfs doesn't need these setups and quotacheck even fails on xfs, so just
> > -# redirect the output to $seqres.full for debug purpose and ignore the results,
> > -# as we check the quota status later anyway.
> > -quotacheck -ug $SCRATCH_MNT >>$seqres.full 2>&1
> > -quotaon $SCRATCH_MNT >>$seqres.full 2>&1
> > +_qmount_option 'usrquota,grpquota'
> > +_qmount "usrquota,grpquota"
> >  
> >  # first remount ro with a bad option, a failed remount ro should not disable
> >  # quota, but currently xfs doesn't fail in this case, the unknown option is
> > diff --git a/tests/generic/219 b/tests/generic/219
> > index 642823859886..a2eb0b20f408 100755
> > --- a/tests/generic/219
> > +++ b/tests/generic/219
> > @@ -91,25 +91,22 @@ test_accounting()
> >  
> >  _scratch_unmount 2>/dev/null
> >  _scratch_mkfs >> $seqres.full 2>&1
> > -_scratch_mount "-o usrquota,grpquota"
> > +_qmount_option "usrquota,grpquota"
> > +_qmount
> >  _force_vfs_quota_testing $SCRATCH_MNT
> > -quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> > -quotaon $SCRATCH_MNT 2>/dev/null
> >  _scratch_unmount
> >  
> >  echo; echo "### test user accounting"
> > -export MOUNT_OPTIONS="-o usrquota"
> > +_qmount_option "usrquota"
> >  _qmount
> > -quotaon $SCRATCH_MNT 2>/dev/null
> >  type=u
> >  test_files
> >  test_accounting
> >  _scratch_unmount 2>/dev/null
> >  
> >  echo; echo "### test group accounting"
> > -export MOUNT_OPTIONS="-o grpquota"
> > +_qmount_option "grpquota"
> >  _qmount
> > -quotaon $SCRATCH_MNT 2>/dev/null
> >  type=g
> >  test_files
> >  test_accounting
> > diff --git a/tests/generic/230 b/tests/generic/230
> > index a8caf5a808c3..0a680dbc874b 100755
> > --- a/tests/generic/230
> > +++ b/tests/generic/230
> > @@ -99,7 +99,8 @@ grace=2
> >  _qmount_option 'defaults'
> >  
> >  _scratch_mkfs >> $seqres.full 2>&1
> > -_scratch_mount "-o usrquota,grpquota"
> > +_qmount_option "usrquota,grpquota"
> > +_qmount
> >  _force_vfs_quota_testing $SCRATCH_MNT
> >  BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
> >  quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> > @@ -113,8 +114,8 @@ setquota -g -t $grace $grace $SCRATCH_MNT
> >  _scratch_unmount
> >  
> >  echo; echo "### test user limit enforcement"
> > -_scratch_mount "-o usrquota"
> > -quotaon $SCRATCH_MNT 2>/dev/null
> > +_qmount_option "usrquota"
> > +_qmount
> >  type=u
> >  test_files
> >  test_enforcement
> > @@ -122,8 +123,8 @@ cleanup_files
> >  _scratch_unmount 2>/dev/null
> >  
> >  echo; echo "### test group limit enforcement"
> > -_scratch_mount "-o grpquota"
> > -quotaon $SCRATCH_MNT 2>/dev/null
> > +_qmount_option "grpquota"
> > +_qmount
> >  type=g
> >  test_files
> >  test_enforcement
> > diff --git a/tests/generic/231 b/tests/generic/231
> > index ce7e62ea1886..02910523d0b5 100755
> > --- a/tests/generic/231
> > +++ b/tests/generic/231
> > @@ -47,10 +47,8 @@ _require_quota
> >  _require_user
> >  
> >  _scratch_mkfs >> $seqres.full 2>&1
> > -_scratch_mount "-o usrquota,grpquota"
> > -chmod 777 $SCRATCH_MNT
> > -quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> > -quotaon -u -g $SCRATCH_MNT 2>/dev/null
> > +_qmount_option "usrquota,grpquota"
> > +_qmount
> >  
> >  if ! _fsx 1; then
> >  	_scratch_unmount 2>/dev/null
> > diff --git a/tests/generic/232 b/tests/generic/232
> > index c903a5619045..21375809d299 100755
> > --- a/tests/generic/232
> > +++ b/tests/generic/232
> > @@ -44,10 +44,8 @@ _require_scratch
> >  _require_quota
> >  
> >  _scratch_mkfs > $seqres.full 2>&1
> > -_scratch_mount "-o usrquota,grpquota"
> > -chmod 777 $SCRATCH_MNT
> > -quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> > -quotaon -u -g $SCRATCH_MNT 2>/dev/null
> > +_qmount_option "usrquota,grpquota"
> > +_qmount
> >  
> >  _fsstress
> >  _check_quota_usage
> > diff --git a/tests/generic/233 b/tests/generic/233
> > index 3fc1b63abb24..4606f3bde2ab 100755
> > --- a/tests/generic/233
> > +++ b/tests/generic/233
> > @@ -59,10 +59,8 @@ _require_quota
> >  _require_user
> >  
> >  _scratch_mkfs > $seqres.full 2>&1
> > -_scratch_mount "-o usrquota,grpquota"
> > -chmod 777 $SCRATCH_MNT
> > -quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> > -quotaon -u -g $SCRATCH_MNT 2>/dev/null
> > +_qmount_option "usrquota,grpquota"
> > +_qmount
> >  setquota -u $qa_user 32000 32000 1000 1000 $SCRATCH_MNT 2>/dev/null
> >  
> >  _fsstress
> > diff --git a/tests/generic/234 b/tests/generic/234
> > index 4b25fc6507cc..2c596492a3e0 100755
> > --- a/tests/generic/234
> > +++ b/tests/generic/234
> > @@ -66,9 +66,8 @@ _require_quota
> >  
> >  
> >  _scratch_mkfs >> $seqres.full 2>&1
> > -_scratch_mount "-o usrquota,grpquota"
> > -quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> > -quotaon -u -g $SCRATCH_MNT 2>/dev/null
> > +_qmount_option "usrquota,grpquota"
> > +_qmount
> >  test_setting
> >  _scratch_unmount
> >  
> > diff --git a/tests/generic/235 b/tests/generic/235
> > index 037c29e806db..7a616650fc8f 100755
> > --- a/tests/generic/235
> > +++ b/tests/generic/235
> > @@ -25,9 +25,8 @@ do_repquota()
> >  
> >  
> >  _scratch_mkfs >> $seqres.full 2>&1
> > -_scratch_mount "-o usrquota,grpquota"
> > -quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> > -quotaon $SCRATCH_MNT 2>/dev/null
> > +_qmount_option "usrquota,grpquota"
> > +_qmount
> >  
> >  touch $SCRATCH_MNT/testfile
> >  chown $qa_user:$qa_user $SCRATCH_MNT/testfile
> > diff --git a/tests/generic/244 b/tests/generic/244
> > index b68035129c82..989bb4f5385e 100755
> > --- a/tests/generic/244
> > +++ b/tests/generic/244
> > @@ -66,7 +66,6 @@ done
> >  # remount just for kicks, make sure we get it off disk
> >  _scratch_unmount
> >  _qmount
> > -quotaon $SCRATCH_MNT 2>/dev/null
> >  
> >  # Read them back by iterating based on quotas returned.
> >  # This should match what we set, even if we don't directly
> > diff --git a/tests/generic/270 b/tests/generic/270
> > index c3d5127a0b51..9ac829a7379f 100755
> > --- a/tests/generic/270
> > +++ b/tests/generic/270
> > @@ -62,10 +62,8 @@ _require_command "$SETCAP_PROG" setcap
> >  _require_attrs security
> >  
> >  _scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
> > -_scratch_mount "-o usrquota,grpquota"
> > -chmod 777 $SCRATCH_MNT
> > -quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> > -quotaon -u -g $SCRATCH_MNT 2>/dev/null
> > +_qmount_option "usrquota,grpquota"
> > +_qmount
> >  
> >  if ! _workout; then
> >  	_scratch_unmount 2>/dev/null
> > diff --git a/tests/generic/280 b/tests/generic/280
> > index 3108fd23fb70..fae0a02145cf 100755
> > --- a/tests/generic/280
> > +++ b/tests/generic/280
> > @@ -34,9 +34,8 @@ _require_freeze
> >  
> >  _scratch_unmount 2>/dev/null
> >  _scratch_mkfs >> $seqres.full 2>&1
> > -_scratch_mount "-o usrquota,grpquota"
> > -quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> > -quotaon $SCRATCH_MNT 2>/dev/null
> > +_qmount_option "usrquota,grpquota"
> > +_qmount
> >  xfs_freeze -f $SCRATCH_MNT
> >  setquota -u root 1 2 3 4 $SCRATCH_MNT &
> >  pid=$!
> > diff --git a/tests/generic/400 b/tests/generic/400
> > index 77970da69a41..ef27c254167c 100755
> > --- a/tests/generic/400
> > +++ b/tests/generic/400
> > @@ -22,7 +22,7 @@ _require_scratch
> >  
> >  _scratch_mkfs >> $seqres.full 2>&1
> >  
> > -MOUNT_OPTIONS="-o usrquota,grpquota"
> > +_qmount_option "usrquota,grpquota"
> >  _qmount
> >  _require_getnextquota
> >  
> > -- 
> > 2.48.1
> > 
> > 
> 

