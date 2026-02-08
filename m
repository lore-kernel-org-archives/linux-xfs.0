Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7CD2D77FA
	for <linux-xfs@vger.kernel.org>; Sun,  8 Feb 2026 17:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770571626; cv=none; b=b2xprjukd856uhELRlbcmZdqR60teuUGcCyWh7WbeWx4J7ITrKO0x/3Ifl+ys637JY9D5odbQ4thn31YeVejpyT8B6pOltdsrIV+po2rJS2OqtZaC1WTdYPd/XtfKo+Z0022jEhMo/DgozWaXcxcaQHzDp5Pl0Ti6fqB3njwU+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770571626; c=relaxed/simple;
	bh=66MGyAhUlU9MPo46AY/B7WtZrx+zpp+4gQH46VmdMCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sba4ceWEd5v6Zw+SUXrLtp9rgQVghPABMz+ERgtLkkhCd2Tfg/9QjDHuqp2JQXVDxdpcFnU9VxqH6wsvgTxoKseGecXUHsUONsfwIj74TXKuWtX3gfL3IjP5kMy+EdH/UBlWXhXS4XEG+rSFCb5Gh86n2rXJMKWMXhT5DL5DqbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TxZ86VjD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mE+dD9sY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TxZ86VjD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mE+dD9sY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770571624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xfG69KkwbfNss4k8EFcF/QNdJFpkrTk7nknMwMnAeHw=;
	b=TxZ86VjD2c2n1hKnaElDUBgIEhwkmjsWIDVGqpTeiihwh3AOlJWK5wAX6OY2GsV8vNn/DH
	D97WCdZKPqrSYCJtwsr0fWZL+lX4nLclqnKD3o71JjXQoSRatl+YxKQQfxquAmbEHeE6nx
	yyIKlmdMZ2m6J7QysGM25jGZ5BbQMS8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-J3WfPVaLNlWqs38yfdKzmw-1; Sun, 08 Feb 2026 12:27:03 -0500
X-MC-Unique: J3WfPVaLNlWqs38yfdKzmw-1
X-Mimecast-MFC-AGG-ID: J3WfPVaLNlWqs38yfdKzmw_1770571622
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c6de00aff20so626870a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 08 Feb 2026 09:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770571622; x=1771176422; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xfG69KkwbfNss4k8EFcF/QNdJFpkrTk7nknMwMnAeHw=;
        b=mE+dD9sYDWvDvPsV8rJJ9bSszA0WB7dOwbwTytqZ1sVVlKCvEUybcFGXGV/g8esd+z
         mm+S7wwiYrbW1jFFpChm/ldtFhwlltGXjvqeyOii2ebF39ZOj5z3Yg9UF2zvpK62TVHX
         uA1DtyU95UcomFRhopYNjaLIC4oKRjV+3wA6Nc0JXy2HU1grA4S8deZqrWFrMbPiW10B
         yS6ArXnMRJv5RwbZ6XvMQ9Vqw8HGqAJI6PSxi9nguys/ycXaZ+aFFlzCShSodogfXsO4
         qeovqX347aG3VR2z/QR1xSH5V3jgdEORp/wZwRYZDJCz881bDy7n/owIW6d1SDEQ+HK5
         JaUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770571622; x=1771176422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xfG69KkwbfNss4k8EFcF/QNdJFpkrTk7nknMwMnAeHw=;
        b=lw4BFh5Cau1bI/Kwf65Ih0gPZoPZAGlLBbp/aaFcpCmE0bXIh2fKk5KPQn+bVMmTrr
         1RKZWrAbzPf6/Vh/cF3+kngZSX++is3kTDYHmwd7EpG30a0a7dYKfGhkVn47/Y4R6mJg
         FOpZsZugQb9ufNzrEZU/apGOw+ziDLC6OpgYr+MUWrq627R6FtTGKGTuOjpzn0oDtLPv
         hwMr5LsgBdqnTZU5jhR4r/ygzsaFTHaXeUEK+cjYS3dsJbNOOHPTx6C6iotXY6XACGWz
         Y4nd5N+FRVq8yfgBBjJ/BaxufTyN8pYewDqU41L2SrgRr8HRRxixiYxdFJaobQuDkxQY
         4G6g==
X-Gm-Message-State: AOJu0YwuL5wNuhKKmO4J33ZD44Wk4pERhs+mXsFdBOpTkM1QdAtKv4k2
	sGGyWqQ4X7YQCPRx0RjWHvs1fEACHHF3UbhN+XoRqztDleX+oOO1oQ+u77Hyu20f+txHM6+Fu6+
	vCeERemvDdDkowvZENsz3f5JXx3DvPGJ+dhAeRPR5GF/xRy9UAySDT1OjjDtDCIAXTfI8pA==
X-Gm-Gg: AZuq6aL53vzZ5/VV10I8ZBVawvO/t4qM07vfCadEoPEN8PrUi0D6WoDQqY38k5HJc6n
	gAvqYyZBo7r29weCivG0Auh9nAbkt509A2qqsrt23EPjAFbWhyLerrsLmFePncudpqOZtIdlmxR
	vhioN/by5jQZxsu9HJncC/85Jyfe2wj4qiAZq5d/9fQ5LbFHNGvZOJdVTv7EOLJov1qnoFB0zyn
	P829U+EzTBOjTyspIil9UjglRLQ+qq7qirnIvIXFLzius/J5Ve0z6aCV966BZnGKosHOkG3fdch
	QFntlisJPCrmGRaoioYXpmiD2XLKbvgaZy/xdBUcyJp2b0NdWnVEMJ7ZBk5CpEDUbrKgeS7mtLW
	GV9jTAu3scGBDzMiz3o/6va1+SiW4iI9HFIHU5KX1noToKQ1viA==
X-Received: by 2002:a05:6a21:7a8b:b0:35d:1bcd:6882 with SMTP id adf61e73a8af0-393acfe82d8mr7048430637.23.1770571622000;
        Sun, 08 Feb 2026 09:27:02 -0800 (PST)
X-Received: by 2002:a05:6a21:7a8b:b0:35d:1bcd:6882 with SMTP id adf61e73a8af0-393acfe82d8mr7048422637.23.1770571621527;
        Sun, 08 Feb 2026 09:27:01 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb4fb808sm7753079a12.6.2026.02.08.09.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 09:27:01 -0800 (PST)
Date: Mon, 9 Feb 2026 01:26:57 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 1/3] xfs/018: remove inline xattr recovery tests
Message-ID: <20260208172657.2dq3esy44c7p7vnb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177005945267.2432878.7105483366958924034.stgit@frogsfrogsfrogs>
 <177005945298.2432878.17951687824065765554.stgit@frogsfrogsfrogs>
 <20260206215400.GC7703@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206215400.GC7703@frogsfrogsfrogs>

On Fri, Feb 06, 2026 at 01:54:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In Linux 7.0 we've changed the extended attribute update code to try to
> take a shortcut for performance reasons.  Before walking through the
> attr intent state machine (slow), the update will check to see if the
> attr structure is in short format and will stay in that format after the
> change.  If so, then the incore inode can be updated and logged, and
> the update is complete (fast) in a single transaction.
> 
> (Obviously, for complex attr structures or large changes we still walk
> through the intent machinery.)
> 
> However, xfs/018 tests the behavior of the "larp" error injector, which
> only triggers from inside the attr intent state machine.  Therefore, the
> short format tests don't actually trip the injector.  It makes no sense
> to add a new larp injection callsite for the shortcut because either the
> single transaction gets written to disk or it doesn't.
> 
> The golden output no longer matches because the attr update doesn't
> return EIO and shut down the filesystem due to the larp injection.

Oh, that really makes sense to me now, thanks for this detailed explanation.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> v1.1: improve commit message, add rvb
> ---
>  tests/xfs/018     |   24 ------------------------
>  tests/xfs/018.out |   45 ---------------------------------------------
>  2 files changed, 69 deletions(-)
> 
> diff --git a/tests/xfs/018 b/tests/xfs/018
> index 8b6a3e1c508045..9b69c9cb14b33d 100755
> --- a/tests/xfs/018
> +++ b/tests/xfs/018
> @@ -127,16 +127,6 @@ mkdir $testdir
>  
>  require_larp
>  
> -# empty, inline
> -create_test_file empty_file1 0
> -test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"
> -test_attr_replay empty_file1 "attr_name" $attr64 "r" "larp"
> -
> -# empty, inline with an unaligned value
> -create_test_file empty_fileX 0
> -test_attr_replay empty_fileX "attr_nameX" $attr17 "s" "larp"
> -test_attr_replay empty_fileX "attr_nameX" $attr17 "r" "larp"
> -
>  # empty, internal
>  create_test_file empty_file2 0
>  test_attr_replay empty_file2 "attr_name" $attr1k "s" "larp"
> @@ -152,16 +142,6 @@ create_test_file empty_fileY 0
>  test_attr_replay empty_fileY "attr_name" $attr32l "s" "larp"
>  test_attr_replay empty_fileY "attr_name" $attr32l "r" "larp"
>  
> -# inline, inline
> -create_test_file inline_file1 1 $attr16
> -test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
> -test_attr_replay inline_file1 "attr_name2" $attr64 "r" "larp"
> -
> -# inline, internal
> -create_test_file inline_file2 1 $attr16
> -test_attr_replay inline_file2 "attr_name2" $attr1k "s" "larp"
> -test_attr_replay inline_file2 "attr_name2" $attr1k "r" "larp"
> -
>  # inline, remote
>  create_test_file inline_file3 1 $attr16
>  test_attr_replay inline_file3 "attr_name2" $attr64k "s" "larp"
> @@ -195,10 +175,6 @@ create_test_file remote_file2 1 $attr64k
>  test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
>  test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
>  
> -# replace shortform with different value
> -create_test_file sf_file 2 $attr64
> -test_attr_replay sf_file "attr_name2" $attr16 "s" "larp"
> -
>  # replace leaf with different value
>  create_test_file leaf_file 3 $attr1k
>  test_attr_replay leaf_file "attr_name2" $attr256 "s" "larp"
> diff --git a/tests/xfs/018.out b/tests/xfs/018.out
> index ad8fd5266f06d0..be1d6422af65a5 100644
> --- a/tests/xfs/018.out
> +++ b/tests/xfs/018.out
> @@ -1,26 +1,6 @@
>  QA output created by 018
>  *** mkfs
>  *** mount FS
> -attr_set: Input/output error
> -Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
> -touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
> -attr_name: e889d82dd111d6315d7b1edce2b1b30f  -
> -
> -attr_remove: Input/output error
> -Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file1
> -touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
> -attr_name: d41d8cd98f00b204e9800998ecf8427e  -
> -
> -attr_set: Input/output error
> -Could not set "attr_nameX" for SCRATCH_MNT/testdir/empty_fileX
> -touch: cannot touch 'SCRATCH_MNT/testdir/empty_fileX': Input/output error
> -attr_nameX: cb72c43fb97dd3cb4ac6ad2d9bd365e1  -
> -
> -attr_remove: Input/output error
> -Could not remove "attr_nameX" for SCRATCH_MNT/testdir/empty_fileX
> -touch: cannot touch 'SCRATCH_MNT/testdir/empty_fileX': Input/output error
> -attr_nameX: d41d8cd98f00b204e9800998ecf8427e  -
> -
>  attr_set: Input/output error
>  Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
> @@ -51,26 +31,6 @@ Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_fileY
>  touch: cannot touch 'SCRATCH_MNT/testdir/empty_fileY': Input/output error
>  attr_name: d41d8cd98f00b204e9800998ecf8427e  -
>  
> -attr_set: Input/output error
> -Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> -touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
> -attr_name2: e889d82dd111d6315d7b1edce2b1b30f  -
> -
> -attr_remove: Input/output error
> -Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> -touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
> -attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
> -
> -attr_set: Input/output error
> -Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> -touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
> -attr_name2: 4198214ee02e6ad7ac39559cd3e70070  -
> -
> -attr_remove: Input/output error
> -Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> -touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
> -attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
> -
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
> @@ -131,11 +91,6 @@ Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
> -attr_set: Input/output error
> -Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
> -touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
> -attr_name2: e43df9b5a46b755ea8f1b4dd08265544  -
> -
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
>  touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error
> 

