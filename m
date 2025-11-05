Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FE8314B64
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762357510; cv=none; b=WxdkR+Mz2rsDDG25TWnxhQltb2Q2niGCaSYy1hmA8phAvzM+PZ7g7wmLhRUmvxTg0CU9eO8o3/cohhb8gh0PErVo3DYCPHiKP2oBMIMSD0A6HofwD59/o8ild5t5dyfEJpF5AIjHHFx15WZYoHdUeQiGl/5yGRGleRQvE8xkS90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762357510; c=relaxed/simple;
	bh=vBpIbHl5BJYu3GvhFAscHMjHAct8CImIgNJ4c1z/oeA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a7xdwuaaEDdHjcx2qOLpMz4oU1tLm+MOJyYUywuA4wnXeiBbxjpx0fsmSd7aBv2HWNvxd0xPCoMgkbK98I21nblnW6maMrAQWYyaZLVHm1H+ztbpstOVnyjY/4BY1neSgzQo2KZ45tzEBUO42b7LO7KvqvUaYsb1CAvc2jkqjIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oXBG7qxR; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oXBG7qxR"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-43321629a25so43848075ab.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Nov 2025 07:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762357507; x=1762962307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pmEA5UIRtFUkoJTebXPiJtfqEeDxZBhUOtjCk6lwm1Q=;
        b=oXBG7qxRAgxxpjvyoxPULOa1fgROdBp/4Z8g918iu8f5OrPjl3F4GHIx5MFNTDhIAn
         pqEWO68Dj3gmQhJr7qUItHwJwG64ld8NCI3MV7bCUWXu1dZb9kfWdGjqhLEvZ479OLxd
         7WiqKEvubQDho+R74G9Dyx22NjREEAjXzpV9A8ulR2vqMXlAUzbRrF27vJeKUN9IErWH
         nS5fM8dz6irJDPhN+oXQW2NNuh/Xd+GhLhTh5UE92ErPNvWvCwMnK0USG76HfdDLNIZh
         XCRNyUDNOSW9hHsEDGFGMI7ZCsw/O3VLkbMk72QQA/atz5Zr6aL5e+7DVF1PHSDpOj60
         NUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762357507; x=1762962307;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pmEA5UIRtFUkoJTebXPiJtfqEeDxZBhUOtjCk6lwm1Q=;
        b=FLqK7JJOK3EjK/9+Sa6Yg14mQa4PUkdZzqMr1RTIpjcWVWWC5OQer7vEo017YZsl6J
         js2Js7ZDHSSQ9X0kBRHJHFyrBCb00m224UOJ41zq1SIr5Ga0T2QrKEGkQn5qDCtKrq2P
         hb/cK786RTaE+sOBdcguYq3+VGNXxAMVijOhj9I3857+ANoxugfDu+JO6f0PxwwvO1qA
         na7bkdGzWc/h53HDG7i0jEscX+M2kVYiLPnlabTIV/RN5hjarh9d5EzWEbpvD97AG7KN
         v/qZlJW2kH0eB/gB+Z2/r1pVM6NO+mWdIzMEYjfSg2CEr6HjOMCyE+/GPPEZK4fsuKPI
         1q7w==
X-Forwarded-Encrypted: i=1; AJvYcCUdg0DAoAMKjcPWtQqlHPVCGf/utVrCvkkwvTXbM7rEEmXLaS+4rQm4i9f+dc3WqUflj8d/SnmolLo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA+ykt8wZUhghUDwbKy9u0RQfaZ0z+cvzepNXJ+14hBAr056sp
	wzHqL1bsogaV5QG+5wbE7fAVf/ZxCbyqAyqig9f8aryYDH7+6jnWm3MULiaoaLpzJDI=
X-Gm-Gg: ASbGncvz/5udn9gFoyqUk7Skh/gZLcP4NUpGgpNuQlULldZ0VZrW7hDD5YnqTdKF+EE
	vdot8DACCl7RObCqLM2wbzF1Kc8ogA4SKvoR6K9moeSEpS88ldp74qvAVDCzizf6juuTo3Ns1Xv
	udREu9vNzbjNNQEAQhKTS14Lga+PscPpk3o+Vy5z3D7yAdw/t7pdZfo1SyJLSCSsNYwRoMZWXyw
	BMmAkS9Ilj0Jb40Am4FBGQtT4AjtjVrZ12xMs9e4fMLl15mPUjKIIRoHf5Qfm98AEmqCVgi/6VL
	cMET3VF3FSvxwPY7rIDitU9kIJIpBnGiQPRjZwPhQUWBo4cZXVUMtJ914ToaMZGbmg/tCsK37fe
	3/QcjVsTAiOKSPsAU/680PMfq52QskTogHCMq1OwBwa01ihGudL7LjQp7eTmn0RnHv0dy5KOeLa
	+DFw==
X-Google-Smtp-Source: AGHT+IGRprlY0B/j7MFC0euD5DLU4VAIhfixS9xB+G6Pb3CIfQJOwUgjuW1G2xa98UfKd2ncVWvKMA==
X-Received: by 2002:a05:6e02:1a85:b0:433:2957:2e87 with SMTP id e9e14a558f8ab-433407d98e4mr47454155ab.28.1762357507117;
        Wed, 05 Nov 2025 07:45:07 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b72258d4e8sm2521439173.3.2025.11.05.07.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 07:45:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>, 
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org, 
 David Sterba <dsterba@suse.com>, Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20251104212249.1075412-1-dlemoal@kernel.org>
References: <20251104212249.1075412-1-dlemoal@kernel.org>
Subject: Re: [PATCH v4 00/15] Introduce cached report zones
Message-Id: <176235750606.190479.10317258805246349798.b4-ty@kernel.dk>
Date: Wed, 05 Nov 2025 08:45:06 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 05 Nov 2025 06:22:34 +0900, Damien Le Moal wrote:
> This patch series implements a cached report zones using information
> from the block layer zone write plugs and a new zone condition tracking.
> This avoids having to execute slow report zones commands on the device
> when for instance mounting file systems, which can significantly speed
> things up, especially in setups with multiple SMR HDDs (e.g. a BTRFS
> RAID volume).
> 
> [...]

Applied, thanks!

[01/15] block: handle zone management operations completions
        commit: efae226c2ef19528ffd81d29ba0eecf1b0896ca2
[02/15] block: freeze queue when updating zone resources
        commit: bba4322e3f303b2d656e748be758320b567f046f
[03/15] block: cleanup blkdev_report_zones()
        commit: e8ecb21f081fe0cab33dc20cbe65ccbbfe615c15
[04/15] block: introduce disk_report_zone()
        commit: fdb9aed869f34d776298b3a8197909eb820e4d0d
[05/15] block: reorganize struct blk_zone_wplug
        commit: ca1a897fb266c4b23b5ecb99fe787ed18559057d
[06/15] block: use zone condition to determine conventional zones
        commit: 6e945ffb6555705cf20b1fcdc21a139911562995
[07/15] block: track zone conditions
        commit: 0bf0e2e4666822b62d7ad6473dc37fd6b377b5f1
[08/15] block: refactor blkdev_report_zones() code
        commit: 1af3f4e0c42b377f3405df498440566e3468c314
[09/15] block: introduce blkdev_get_zone_info()
        commit: f2284eec5053df271c78e687672247922bcee881
[10/15] block: introduce blkdev_report_zones_cached()
        commit: 31f0656a4ab712edf2888eabcc0664197a4a938e
[11/15] block: introduce BLKREPORTZONESV2 ioctl
        commit: b30ffcdc0c15a88f8866529d3532454e02571221
[12/15] block: improve zone_wplugs debugfs attribute output
        commit: 2b39d4a6c67d11ead8f39ec6376645d8e9d34554
[13/15] block: add zone write plug condition to debugfs zone_wplugs
        commit: 1efbbc641ef7d673059cded789b9c8a743c17c9a
[14/15] btrfs: use blkdev_report_zones_cached()
        commit: ad3c1188b401cbc0533515ba2d45396b4fa320e1
[15/15] xfs: use blkdev_report_zones_cached()
        commit: e04ccfc28252f181ea8d469d834b48e7dece65b2

Best regards,
-- 
Jens Axboe



