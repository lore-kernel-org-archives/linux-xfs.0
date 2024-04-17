Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE742B9A2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 04:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713329301; cv=none; b=PV2aW+f7agt2oRXrK3mFWxP4DH7qzVrB6EDHLmcTQYKD3ru9vmcvtTFufr+Gb1PYyQRH9BjO/zUdbLN5RI3bzxeGHqVmT+pGCK8a85aJPIGc8cMRA4fPcy4njHGZKifldzr4x+9y74hiEMawfrDb5Vfu1p9CrGKzR6JZfIq4dxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713329301; c=relaxed/simple;
	bh=ZmqDOYxWcizF0cFiG7LzuTUl1GFxnYfdOg88Q+tnYTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XgAbuvtiqXnC3XE1rrAwqWOR6SazX0NxcY178+ipvMOZPb7mMrMtWl9wL/ZnnhK+Ncdtg47EMwZ7EMGpXbZi6bWheZVv8sZNXO5UDFLP/GB79C2z49dJyqtu9684lfeoHm0yRPyJHs9/llwMoEpwvz1XdpxaFMwX2ZxKEpn4raY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=jQ91mlt/; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="jQ91mlt/"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e455b630acso23833645ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 21:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1713329299; x=1713934099; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qzYslW1aC2ppMxc5o9XjwDFjTbA8y3cpFfmsZYKNfQg=;
        b=jQ91mlt/HeY1URw4tJfEZhhV85bQZ76s8PMaOWjxvMfXNjtVVCj/83ZlQCA2rzcMWL
         ak6cIoB95DYyeSK1oN+QL0liQlVxqxgTUj6XJFNlyUv2bIup5VAJHyfAPoqu4eEOtwTB
         tMCGbWyob54MNYYmKfNkvJL6vgxVcynlVGsRHLxB7op5lu7TCG9D4mP8woeBCwuM813w
         MqUr6k1wR1IrZwkvzpY/tAW/adFMf3js2B00zqXbnNpmW5AvwlhbbF9PXUaaVnkywkuD
         tzwKwfXcmu4qiPYkSCBAuwYowrfMUEKc/qU6FI4ZrhMvRD481dxEfpkDGFSJ+qGc8MKV
         O8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713329299; x=1713934099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzYslW1aC2ppMxc5o9XjwDFjTbA8y3cpFfmsZYKNfQg=;
        b=iBZOcLi3H365HMCvnUSestwQ4+NtLZNwDwlLi3YV+u4L2/tmyZLwixncHSw0l699Zh
         xt7vbTiSC2+qWKYIDTozKQXzU8DfBzb+V9aawkgMbHAbDhQDfkU/7+y6wCO81Fn//bpX
         G0WCsNMCttkub7Hks/yGr1kAFUlCCpqWtgqBNLWdx0+ol9YSDI5LE3mH5oj3ZIDveCLU
         P9ASnrZ1PdomWl79dLn6hzKXSqAm1PCVOl3pGfAxCBFc9dGqDB2lJmFFMlF2OAezIVej
         Rxq32qbQIL6rahlTu/0Oaqf69w8FM9CkTiSMJn9A1/0w2B86MVnaD7WerSf+Za+tVfee
         DcKQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2qiIs8RL0M2zDrWPdo0YnAOHURZoYf1JakNmeFHJQr6aoCS+wdLQ0a1RosGfrhYP+2LNEufKH93GClJKTo1iQjCVPAff4XVXU
X-Gm-Message-State: AOJu0YxPDE54BhaKiuDng9oEfnQLxozkqPBLyvYVWsZVfV2TvTqPEikr
	yh9B744adAprE3Drp+lyj5yHJE8BN4pL2HgAkzxAbg24kzOT1gekoTgPm+dn8/nAwC7jCqSlSLt
	S
X-Google-Smtp-Source: AGHT+IGP3L6ZnkSdK0N2R99RlDrClJFU7WmERLwKk72JVWuOMF3IA4iL2MKCvC8xBVNG3QoQw2vI/A==
X-Received: by 2002:a17:903:41c7:b0:1e3:e137:d3af with SMTP id u7-20020a17090341c700b001e3e137d3afmr17134532ple.9.1713329298949;
        Tue, 16 Apr 2024 21:48:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001e503c555afsm10660421pld.97.2024.04.16.21.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 21:48:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rwxDU-000nAR-0J;
	Wed, 17 Apr 2024 14:48:16 +1000
Date: Wed, 17 Apr 2024 14:48:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: kdevops@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH kdevops] xfs: add xfs/242 as failing on xfs_reflink_2k
Message-ID: <Zh9UkHEesvrpSQ7J@dread.disaster.area>
References: <20240416235108.3391394-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416235108.3391394-1-mcgrof@kernel.org>

On Tue, Apr 16, 2024 at 04:51:08PM -0700, Luis Chamberlain wrote:
> This test is rather simple, and somehow we managed to capture a
> non-crash failure. The test was added to fstests via fstests commit
> 0c95fadc35c8e450 ("expand 252 with more corner case tests") which
> essentially does this:
> 
> +       $XFS_IO_PROG $xfs_io_opt -f -c "truncate $block_size" \
> +               -c "pwrite 0 $block_size" $sync_cmd \
> +               -c "$zero_cmd 128 128" \
> +               -c "$map_cmd -v" $testfile | $filter_cmd
> 
> The map_cmd in this case is: 'bmap -p'. So the test does:
> 
> a) truncates data to the block size
> b) sync
> c) zero-fills the the blocksize
> 
> The xfs_io bmap displays the block mapping for the current open file.
> Since our failed delta is:
> 
> -0: [0..7]: data
> +0: [0..7]: unwritten

That's most likely a _filter_bmap() issue, not a kernel code bug.

i.e. 'bmap -vp' output looks like:

EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET          TOTAL FLAGS
   0: [0..231]:        2076367680..2076367911 18 (6251328..6251559)   232 000000

and _filter_bmap has two separate regex matches against different
fields that both trigger "unwritten" output. The first check is
against field 5 which is actually the AG-OFFSET in this output, not
field 7 which is the FLAGS field.

Hence if the ag offset matches '/0[01][01][01][01]/' the filter will
emit 'unwritten' regardless of what the flags say it actually is.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
