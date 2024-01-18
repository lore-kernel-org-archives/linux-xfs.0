Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEED563A4
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 04:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705551628; cv=none; b=ZFOpBcmuB0lbYlzJy4VmijApAo8m3i/ZblWeBrilZ7DnD10QLXWHg9bTy8tPKbgBeIKRgcsxrWBaNZmVQ1p6Aoz3tI4GoGUHaHUuipOdXzqiqZPNi2uoBcTMy3dzRbL+r+pvEEDS47VtUXozcThqH+sNk06Soo4LKJJ8retpugE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705551628; c=relaxed/simple;
	bh=9z+DOJMS20+7akTAo82abVI/Sq2W+16iChaV1JV6pdQ=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To; b=uj6NdXCFRFZo+Pp47r9TxlgdqgDh3SBl1I5opWwURA8dgwQ6mSxm1tTdi3+Q5+gpnRCX3gdCmNa6OFaOIAAFRjH4bgpu+9CxIjmK5XcaEXatnE/r+b38+soVbtgHopfGJxnMscUZstmwDfHVmHHHLrV3rgIF228LcSUCZGze76g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zjXjdPN5; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zjXjdPN5"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d70a98c189so94065ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 20:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705551626; x=1706156426; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8vl/r3DGRPA/1LorOTAaVEPd5pfPjsf71a9s7DNPhCk=;
        b=zjXjdPN5z0LSbOtDriUIGRHGqmH2Q0VpAYHC/cAWXQw5IFy3joUFilET1vCGkkGQKd
         kxOWHK8vTyscqzeSRzVsK8NzPCVoD18vNd3Ff1xu4OPQBtoDUQuA8gRcNNhAbQ/BctNg
         XaQp3jHp90Vbm+LjWXvXgASpuISon7TgjoCr5QueV1G0/7TFiqGYJ0hQaUnV798wOiGn
         G3p0vmtOWRgEKlczneNRX6iytRrJN2W7jIBxKBTNzqtBKpEoUkwBCfD/hMStCd/iexmq
         HJM5XT98KourQ9U9ACAUYxeJaCRsb3NfpVpEp73PKl3y/eIyESAxPyfiwPf35Czib3rH
         EGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705551626; x=1706156426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vl/r3DGRPA/1LorOTAaVEPd5pfPjsf71a9s7DNPhCk=;
        b=rqLCSfGATgXB1Jj9pjDxroSRSZ67m+pAicbnGSfzpRlKy+3Aw9pfPwo8JYLYMTJjC2
         +XsqFTnKhky+ubV65PxJxRSyphJenb6pwWU1SrNNaAUJCvxLYnl9kMsp1qptABE9xUE2
         tjOlpLN/RHrGkJn6Na2/yKa3tZ7mUap/yhqRZj3ONTiyXD1L8Fq+scG8uV4rgi6XIv0+
         MBb9UayB3h5WFWn//ZqJz1YCESgWz6ep+zrX+ByjnGAau169r5QI61FtYf2ax0VkE0sd
         4tRkLBdJ9Yj9CsG05B/iWY3RTXnuPOgNczxyWb8tZfSZQSplMZQeOExTrwzKCYZgJ0CL
         m1OA==
X-Gm-Message-State: AOJu0YwjaoYjCc++fMc55stxsnFZbWwfmPSSHpW5NHN6KO+JR5LvC2lb
	p85E3d8XDfRfQ0daOBr54vg3scoGLuCEuBfYZmr5EkoOCX5pKDcIJ7qhvATKzYQ=
X-Google-Smtp-Source: AGHT+IEf7rfIjOCPPJBdRCuz8y89550uTvqSTu1Umbb1OPK3NhjJntJ/AhbzmZAfCpPNbzP1KLzD9A==
X-Received: by 2002:a17:902:edc2:b0:1d6:fcc3:c98f with SMTP id q2-20020a170902edc200b001d6fcc3c98fmr281633plk.29.1705551626176;
        Wed, 17 Jan 2024 20:20:26 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902650600b001d5ed020153sm432772plk.224.2024.01.17.20.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 20:20:25 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rQJt7-00Brkc-0e;
	Thu, 18 Jan 2024 15:20:21 +1100
Date: Thu, 18 Jan 2024 15:20:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <ZainBd2Jz6I0Pgm1@dread.disaster.area>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Mon, Dec 18, 2023 at 10:01:34PM +0800, Zorro Lang wrote:
> Hi,
> 
> Recently I hit a crash [1] on s390x with 64k directory block size xfs
> (-n size=65536 -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1),
> even not panic, a assertion failure will happen.
> 
> I found it from an old downstream kernel at first, then reproduced it
> on latest upstream mainline linux (v6.7-rc6). Can't be sure how long
> time this issue be there, just reported it at first.
>  [  978.591588] XFS (loop3): Mounting V5 Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
>  [  979.216565] XFS (loop3): Starting recovery (logdev: internal)
>  [  979.225078] XFS (loop3): Bad dir block magic!
>  [  979.225081] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414

Ok, so we got a XFS_BLFT_DIR_BLOCK_BUF buf log item, but the object
that we recovered into the buffer did not have a
XFS_DIR3_BLOCK_MAGIC type.

Perhaps the buf log item didn't contain the first 128 bytes of the
buffer (or maybe any of it), and so didn't recovery the magic number?

Can you reproduce this with CONFIG_XFS_ASSERT_FATAL=y so the failure
preserves the journal contents when the issue triggers, then get a
metadump of the filesystem so I can dig into the contents of the
journal?  I really want to see what is in the buf log item we fail
to recover.

We don't want recovery to continue here because that will result in
the journal being fully recovered and updated and so we won't be
able to replay the recovery failure from it. 

i.e. if we leave the buffer we recovered in memory without failure
because the ASSERT is just a warn, we continue onwards and likely
then recover newer changes over the top of it. This may or may
not result in a correctly recovered buffer, depending on what parts
of the buffer got relogged.

IOWs, we should be expecting corruption to be detected somewhere
further down the track once we've seen this warning, and really we
should be aborting journal recovery if we see a mismatch like this.

.....

>  [  979.227613] XFS (loop3): Metadata corruption detected at __xfs_dir3_data_check+0x372/0x6c0 [xfs], xfs_dir3_block block 0x1020 
>  [  979.227732] XFS (loop3): Unmount and run xfs_repair
>  [  979.227733] XFS (loop3): First 128 bytes of corrupted metadata buffer:
>  [  979.227736] 00000000: 58 44 42 33 00 00 00 00 00 00 00 00 00 00 10 20  XDB3........... 

XDB3 is XFS_DIR3_BLOCK_MAGIC, so it's the right type, but given it's
the tail pointer (btp->count) that is bad, this indicates that maybe
the tail didn't get written correctly by subsequent checkpoint
recoveries. We don't know, because that isn't in the output below.

It likely doesn't matter, because I think the problem is either a
runtime problem writing bad stuff into the journal, or a recovery
problem failing to handle the contents correctly. Hence the need for
a metadump.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
