Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F9D313267
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758035660; cv=none; b=PHD53zMrsliIcQmhMXGTpzl9QxGg6297G/pF1SUby3gMWKkFj6TSDwEJrv6P6mSfLWJ6evWgR0VsqWIoZpxaO4+2sxMlYcX8CK8ZTcZ1xktHA9b/9lK2I1jp+g//ZZX4AcVKbY9MLVV/lUza7iavv8mD2TeVOJwXAcaekpRoVQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758035660; c=relaxed/simple;
	bh=9mpBg1YiKVNIz0UybkdQ1E/F+59RJKVh8Lxzx5M4TzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CBrJjBexfh2cEfWMbvbft13w36REcp6QLUzQMqfuM6n4sNUHLMtep+I7HVfp8hMWG4ypyIacZYHIc7GfZGfbdKM2OIjrck1r3vsGNFmVRa5vdJSGSRUc5rEXEiTcrUXvBAd7ckVyzNmJyskJLG4N77T75w+yGWBazwK1SHxvkW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A/yODPva; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A/yODPva"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-32e74ae0306so1605666a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 08:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758035658; x=1758640458; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q+X5v61oteZgCH7niAPXzb5OpD596XTCSma4woQ+DbA=;
        b=A/yODPvaSF8jgNJCTjr9pzWhksr5PATTw9yI33/ajW1z4ufsEqwCjUFtgWhE1zcznr
         s3PtU+pyjSR3b9XY0gjZ7Djn7HQKdxiSRX2JkwEiyWVtgAfVLFpKyL9fGcXXFLK7sy0N
         wkKtnuPrU/Jh5MwWW5Jdog2TYljFmWNx1jw87Lpfn1Dga8Fa1YHhTuLARo3d2/mBqGy4
         tE27gtmwVmmshGQOh0e0mF3M5XfvRKzDUShIZQd6VrbkZPJpAwYq9URtKSA9G4FBgeOx
         wuaQpB6Z+J55uu4qP1Qo/OQuJk7czNu2q/QFNuNiQQGO2xOjcZhr8giZa6EPIvkI3eaZ
         kwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758035658; x=1758640458;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+X5v61oteZgCH7niAPXzb5OpD596XTCSma4woQ+DbA=;
        b=Bzr2gALdCSKr/q14thrc/HDh4mAw61RsSoQRql7LDCdCussWPwIx6M/Eb6MnpErKNq
         1rvcuJDmU4eJIsPNDJ16ZIv2bMK2I3K7AaBemQg8qDKrgAMcwGKbB5Ea+UFUVcgmyrHu
         kdOHHGBWrPfi6B17LIlSpM3jYEmVoW42A5Tlp0hUKGm0MRtisrE1jKugE0fZ+1hrNvlb
         N5Ld7gYiswcWkkPAYbHeQh+0USf80hH7N37G8mLf6+8JtE8J5lyuVksLd/wbKWyZoSUy
         KTiRfxZitjwdipw/7wTWO/aeR/eMvcKQ3jLDTx1OkFOMDphyQzm2hc3SY4ksckTGEhoq
         UllA==
X-Gm-Message-State: AOJu0YwJQR9YYzkwVpaaIaTlD+DPmcFdiXR351Ee4K30piGEP8E8OWhI
	wxevURqQi6zotT2eYiW8VPPwZb/MkvrDpIPirS16gN3I7cQ+uJSs64yd4I+4/A==
X-Gm-Gg: ASbGncubA6aPhKoiviHNnCLzOyN4g6sBL1GgWvHFNRNDKpB6qX6eov9KX4INcWMsJbh
	JQULjo0I4J4ho9Zj7DyZ+Tf9F2n0qLfsdoNVgKpojZsNn6Wguj0wQMAYO3UpMKnhrRuAmGUkRxy
	t5goK9aiuBTN8tlJ19WzSyxuH9JVJaud2v9SWoOWurORGDOpJriMGqL2kDGFJd51Qw6m7+Sfz8n
	GQZ0/gd3wum81AZ6D+AumW0ED7dXl3Q5LGR4nNVNgz3oNfXjyB/p8O0Y4P2JwGuWyA+qaIHcVJp
	Fk28pmRKwo3yhrbtzAfAvEDJt3TCmTuFJY0kmQMkkbNLxYa0Fc43tVU2O6S2Y2+q8et0nEtfI1c
	kMpUhsx1QRTn34aCkCGejAngWPHPKsW/R8+BYSKG3OZC4
X-Google-Smtp-Source: AGHT+IH+TNAETbkFIdfATY9jsd9TnhD0g8UwTvIdah+Jv6p/1EwlnsdQvIJ8mkm4gl2n1gi4H4aBbg==
X-Received: by 2002:a17:90a:d407:b0:32d:a37c:4e31 with SMTP id 98e67ed59e1d1-32ea631ba8fmr3454782a91.17.1758035657515;
        Tue, 16 Sep 2025 08:14:17 -0700 (PDT)
Received: from [192.168.0.120] ([49.207.211.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32eae661d14sm1863798a91.5.2025.09.16.08.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 08:14:17 -0700 (PDT)
Message-ID: <261b9066-6480-45ee-845a-7fb34851ce0f@gmail.com>
Date: Tue, 16 Sep 2025 20:44:12 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 0/3] Add support to shrink multiple empty AGs
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org,
 bfoster@redhat.com, david@fromorbit.com, hsiangkao@linux.alibaba.com
References: <cover.1758034274.git.nirjhar.roy.lists@gmail.com>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <cover.1758034274.git.nirjhar.roy.lists@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/16/25 20:34, Nirjhar Roy (IBM) wrote:
> This work is based on a previous RFC[1] by Gao Xiang and various ideas
> proposed by Dave Chinner in the RFC[1].
>
> Currently the functionality of shrink is limited to shrinking the last
> AG partially but not beyond that. This patch extends the functionality
> to support shrinking beyond 1 AG. However the AGs that we will be remove
> have to empty in order to prevent any loss of data.
>
> The patch begins with the re-introduction of some of the data
> structures that were removed, some code refactoring and
> finally the patch that implements the multi AG shrink design.
> The final patch has all the details including the definition of the
> terminologies and the overall design.
>
> We will have the tests soon.

Tests are here[1]

[1] 
https://lore.kernel.org/all/cover.1758035262.git.nirjhar.roy.lists@gmail.com/

--NR

>
> [rfc_v1] --> v2
> 1) Function renamings:
>      1.a xfs_activate_ag() -> xfs_perag_activate()
>      1.b xfs_deactivate_ag() -> xfs_perag_deactivate()
>      1.c xfs_pag_populate_cached_bufs() -> xfs_buf_cache_grab_all()
>      1.d xfs_buf_offline_perag_rele_cached() -> xfs_buf_cache_invalidate()
>      1.e xfs_extent_busy_wait_range() -> xfs_extent_busy_wait_ags()
>      1.f xfs_growfs_get_delta() -> xfs_growfs_compute_delta()
>
> 2) Fixed several coding style fixes and typos in the code and
>     commit messages.
>
> 3) Introduced for_each_perag_range_reverse() macro and used in
>     instead of using for loops directly.
>
> 4) Design changes:
>     4.a In function xfs_ag_is_empty() - Removed the
>         ASSERT(!xfs_ag_contains_log(mp, pag_agno(pag)));
>     4.b In function xfs_shrinkfs_reactivate_ags() - Replaced
>         if (nagcount >= oagcount) return; with ASSERT(nagcount < oagcount);
>     4.c In function xfs_perag_deactivate() - Add one extra step where
>         we manually reduce/reserve (pagf_freeblks + pagf_flcount) worth of
>         free datablocks from the global counters. This is necessary
>         in order to prevent a race where, some AGs have been temporarily
>         offlined but the delayed allocator has already promised some bytes
>         and later the real extent/block allocation is failing due to
>         the AG(s) being offline.
>     4.d In function xfs_perag_activate() - Add one extra step where
>         we restore the global free block counter which we reduced in
>         xfs_perag_deactivate.
>     4.e In function xfs_shrinkfs_deactivate_ags() -
>             1. Flushing the xfs_discard_wq after the log force/flush.
> 	   2. Removed the direct usage of xfs_log_quiesce(). The reason
> 	      is that xfs_log_quiesce() is expected to be called when the
> 	      caller has made sure that the log/filesystem is idle but
> 	      for shrink, we don't necessarily need the log/filesystem
> 	      to be idle.
> 	      However, we still need the checkpointing to take place,
> 	      so we are doing a xfs_sync_sb+AIL flush twice - something
> 	      similar that is being done in xfs_log_cover().
> 	      More details are in the patch.
>             3. Moved the entire code of ag stabilization (after ag
> 	      offlining) into a separate function -
> 	      xfs_shrinkfs_stabilize_ags().
>     4.f Fixed a bug where if the size of the new tail AG was less than
>         XFS_MIN_AG_BLOCKS, then shrink was passing - the correct behavior
>         is to fail with -EINVAL. Thank you Ritesh[2] for pointing this out.
>
> 5) Added RBs from Darrick in patch 1/3 and patch 2/3 (after addressing his
>     comments).
>
> [1] https://lore.kernel.org/all/20210414195240.1802221-1-hsiangkao@redhat.com/
> [2] https://lore.kernel.org/all/875xfas2f6.fsf@gmail.com/
> [rfc_v1] https://lore.kernel.org/all/cover.1752746805.git.nirjhar.roy.lists@gmail.com/
>
> Nirjhar Roy (IBM) (3):
>    xfs: Re-introduce xg_active_wq field in struct xfs_group
>    xfs: Refactoring the nagcount and delta calculation
>    xfs: Add support to shrink multiple empty AGs
>
>   fs/xfs/libxfs/xfs_ag.c        | 193 +++++++++++++++++-
>   fs/xfs/libxfs/xfs_ag.h        |  17 ++
>   fs/xfs/libxfs/xfs_alloc.c     |   9 +-
>   fs/xfs/libxfs/xfs_group.c     |   4 +-
>   fs/xfs/libxfs/xfs_group.h     |   2 +
>   fs/xfs/xfs_buf.c              |  78 ++++++++
>   fs/xfs/xfs_buf.h              |   1 +
>   fs/xfs/xfs_buf_item_recover.c |  37 ++--
>   fs/xfs/xfs_extent_busy.c      |  30 +++
>   fs/xfs/xfs_extent_busy.h      |   2 +
>   fs/xfs/xfs_fsops.c            | 358 +++++++++++++++++++++++++++++++---
>   fs/xfs/xfs_trans.c            |   1 -
>   12 files changed, 678 insertions(+), 54 deletions(-)
>
> --
> 2.43.5
>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

