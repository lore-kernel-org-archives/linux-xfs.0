Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F5114D43D
	for <linux-xfs@vger.kernel.org>; Tue,  4 Jun 2024 23:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717542507; cv=none; b=p5/o5tx6nskgicVD7pdMUkzDhlxMRovxg/r0P1JNal56WR0ynRHUSJzcBY0IQnV41vCOyUBP3sRBnj1ogNK9Guzfvi68bfSJNJUje5RWTZHQbeUBt/f6saLRm7hVfmXwmAEpw2vDJv5jwKUEbGYVKB3sLCUgj49nva/vI2exJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717542507; c=relaxed/simple;
	bh=0vZGBYo+uYy2wtlaepnU2yztsmkDMb6mLHZonpHH8Y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOJd58g6mPAzpEPCRh13J90hQsxcoa1b+GGB/U38pfrtSIOB/hYu41RjZlH8iU3m2L9NYZ7GQ3iN+b11n8ZTKDqV31ls6ROfbt/DeYymwRePySbuo5j2pfBlJ4Aamy4+wNAnB79Adh4ituFtQcJrW3sorb53IIRQu/A9aojK+64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AG7IomBG; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AG7IomBG"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2c20eed350fso2550798a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2024 16:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717542505; x=1718147305; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IC/xTVBNFTgVmMry2eRcaW98QzdigW5fBfGayStC56Q=;
        b=AG7IomBGUttHzlVRQLcSTZvd4FZZWv/I61J0QBMWzGJ0XgIXahsXQJK8YXE4oO3IDx
         UIxDO6VxR1OCoCDSMdYIM6r0Xpcz+AFiTNs4eyLq8DP4A3l4wX93rmk/83p0jBEwIOqT
         5qe7b8Zp9tkQdurkfhSPphkmYtQdkV9KryB+tjCIWEQQ7to+BQgz1t0yJskWOwN4cRyr
         AvmdYZDtTN4I5/w10NJif7+yba8Q0/xJVsy6suHuSWV54pG7lardHDCjUfbv7I1iYIWx
         FrFvL0VtAOSDxk3FvXyZ2qTi3FRoqrmIRZdMgdFo1XsYauuSTh9qdR1EzrJ03FbG/LFX
         lSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717542505; x=1718147305;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IC/xTVBNFTgVmMry2eRcaW98QzdigW5fBfGayStC56Q=;
        b=t+poQtRd6wmJlnS5qc7X272aFWKKPneTDqXWn5jG1qwwQYhdEAO+bL7y8JQO4ChRMO
         uznAT/jb+4k5FWdJWdBCa3g4VpMbFUTHVkVTsiPEe4/VFRL5XPnqr+GK92AD3dMqG+Af
         Zt/rASHlDeWmpx0P3T00Bd/F0jeg3iUUs7NBJ7KIloGGZdY9FU3TxF3KHGgUkCwzZpx5
         lmmGhwprealuT499pRpbDjBvQ8fhTRHG0u9u7WmKlcBMyhMXFeWrORFnLSdlFRvANuIh
         RTmOqs4PXZY6nbKj5PgssjRNzgwNzHbbHFME1EEz/2/6JdIJteVr+w8hom3vuj+9mU8B
         GFOQ==
X-Gm-Message-State: AOJu0YxvarXi7tSaCeJOvr9N3lq4hNnAI14KQrXBGlKC1VRiU7mu9xQk
	wF9K6qbgIawvCsM250x/eACOTLEJYmj+2XLI/ZUvPU+BzIaJlQ9IKgRtOXA0d/k=
X-Google-Smtp-Source: AGHT+IFgqHfHhrbdm3xbUBcj41zfs3TqTj0Dc36meOpkBcVqQZRiZz7xX6wGTi+hmt4dt4G4k0Zoaw==
X-Received: by 2002:a17:90a:b383:b0:2c2:4134:51cc with SMTP id 98e67ed59e1d1-2c27db11924mr880171a91.18.1717542504827;
        Tue, 04 Jun 2024 16:08:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c280697d88sm67330a91.30.2024.06.04.16.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 16:08:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sEdGP-004XTY-0r;
	Wed, 05 Jun 2024 09:08:21 +1000
Date: Wed, 5 Jun 2024 09:08:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de
Subject: Re: [PATCH V3] xfs: make sure sb_fdblocks is non-negative
Message-ID: <Zl+eZVhmLaHwmQgY@dread.disaster.area>
References: <20240603183011.2690-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603183011.2690-1-wen.gang.wang@oracle.com>

On Mon, Jun 03, 2024 at 11:30:11AM -0700, Wengang Wang wrote:
> A user with a completely full filesystem experienced an unexpected
> shutdown when the filesystem tried to write the superblock during
> runtime.
> kernel shows the following dmesg:
> 
> [    8.176281] XFS (dm-4): Metadata corruption detected at xfs_sb_write_verify+0x60/0x120 [xfs], xfs_sb block 0x0
> [    8.177417] XFS (dm-4): Unmount and run xfs_repair
> [    8.178016] XFS (dm-4): First 128 bytes of corrupted metadata buffer:
> [    8.178703] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 01 90 00 00  XFSB............
> [    8.179487] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [    8.180312] 00000020: cf 12 dc 89 ca 26 45 29 92 e6 e3 8d 3b b8 a2 c3  .....&E)....;...
> [    8.181150] 00000030: 00 00 00 00 01 00 00 06 00 00 00 00 00 00 00 80  ................
> [    8.182003] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> [    8.182004] 00000050: 00 00 00 01 00 64 00 00 00 00 00 04 00 00 00 00  .....d..........
> [    8.182004] 00000060: 00 00 64 00 b4 a5 02 00 02 00 00 08 00 00 00 00  ..d.............
> [    8.182005] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 17 00 00 19  ................
> [    8.182008] XFS (dm-4): Corruption of in-memory data detected.  Shutting down filesystem
> [    8.182010] XFS (dm-4): Please unmount the filesystem and rectify the problem(s)
> 
> When xfs_log_sb writes super block to disk, b_fdblocks is fetched from
> m_fdblocks without any lock. As m_fdblocks can experience a positive -> negative
>  -> positive changing when the FS reaches fullness (see xfs_mod_fdblocks)
> So there is a chance that sb_fdblocks is negative, and because sb_fdblocks is
> type of unsigned long long, it reads super big. And sb_fdblocks being bigger
> than sb_dblocks is a problem during log recovery, xfs_validate_sb_write()
> complains.

As I explained in the previous review thread, this "summing can be
transiently negative" behaviour is "native" to percpu counters. i.e.
percpu_counter_sum() does not require the xfs_mod_fdblocks()
behaviour to return negative values because the sum's guaranteed
accuracy is only +/-(batch size * nrcpus).

Hence all the percpu_counter_sum() counter calls in xfs_log_sb()
need to use percpu_counter_sum_positive() to avoid logging transient
engative values to the journal, not just the mp->m_fdblocks counter.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
