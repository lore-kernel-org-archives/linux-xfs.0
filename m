Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD8948422F
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 14:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791381941; cv=none; b=sySt1Eb+dotcuzplgrhMC3LPtrBy++Pg7U77TIYuiTpVE1d1gvQdHyZprk9h9+ZPIskn7bSV06eiw9KTL5Pll2RhIaYlpqfC50yKLvYHS7dcjrUKd7lHeZ7zdYDnO2AwREyw48WcRKSRD5CnV4FsNGBxUKGMbZm5LWrrDzAzrCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791381941; c=relaxed/simple;
	bh=V7wCXFfMiY8I3U4QW7xgovTFawhq2OF8NsZcAprNCLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bRbgJjcM/z+uHHxwQBMhV9i229g93NZ8RuTKYcSeezJCB9sa2zs9oOGG+MwD4uJSlYJG5s+Uw2o5kMXW2BOCqevhsRvAwn/A/Bxla7DrA0GTdObLxckWpe/alzWyz409cI0D1taS5hOkQA7cOk2/FLVISmVq2mO+Hf6GY04Ym7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=PDA4CzXZ; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="PDA4CzXZ"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3a80d1c98f5so2306355a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2026 07:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1791381933; x=1791986733; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2tZULonu7kKZiIqDdMHG3M16ndJSJFse/YYFR6ZGm68=;
        b=PDA4CzXZVp6XIMVR4rSohNCjpWBfkxope7IT5M2ZWrsgom480Z/UP01vKISCHF2G2Z
         CCpY+z5xLDtaGFvhS2U/L74Jm9YVzBJVqHUn+OBzaPEXtDCna5adkSXhG8h6FFIQ87ks
         LvJEMmHWWSyWBy9scoIlPZjgNX/EtGID24DRyYNg2B9sfk8OkpbDxeuXhUeNjhJwEpmm
         heiICQJXz+gjxuQXlR6+Pz3YwyEj1fXtUCkRotDcOuNbpEmrhtt7LAM8WvS6CF43vj7L
         Vne4sw9XzFQ19KaacvBgudTsfUoept3pFiO5znr3scvW1kgrig6bjCR/tRiZI6VBFc+2
         rJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791381933; x=1791986733;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2tZULonu7kKZiIqDdMHG3M16ndJSJFse/YYFR6ZGm68=;
        b=kKu3RwAahe1ZwFRqKzeqLdlJqYtNl50RfxAx8XMNRbcvX3NSGdHHGT4Z/OsOBzU2gj
         fHWA9n1gFUrA26VHT16Tl7HaRSikdBNr5Ax55f615YEnIdKVyKG0yogO9JqbxEFE7lpN
         A9BWj+fVbkzWLYF82AHREOgI+D2VPU6uS2hPiAN9y4KNggoOJY2ZrnxU34XqJ2+79SnY
         3BIqA9qhYtmSBQ+KtkaqShJFazZgMigUM5iRlAOMr41bfDbFVoolLBTWPVCvDQW34e7p
         OSpObjjh4/zHGYM5/IkSiOXGXQRcHUYNzNrPqjp9Ynb/8sWxw+z8FFHONB65gEK6xPDU
         SwmQ==
X-Forwarded-Encrypted: i=1; AKwUvBy7fiunH4Q7NjYrcfSK+0NEsLBiqu6S9wSXgkKu7yX/eR4NQD8N5G4KwdLScx1b2eYn6eZN1ldHvM0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJECc2XUHDQa/MRjrtuDDvbXKhVJtMZeRVnKq1RKmPsyp+Tmtw1
	A+amwzDIAh+5HbNfg49/cqhAK3f465xqfVmtT0ZjHSK/QeOnm3ZskPuuk1wSoNA3K0s=
X-Gm-Gg: AYBFou3z4pROus5ytX73+cTUId6bt9qBQlSoOMcPQJvPOF0XxxTiv68gLkcsW/RybPO
	SUVIjYv2FX0F+2ABhjF6MQx/+05d3c99dzUvBOBeI7HJiOMwFhSqXYTRJYe6aNsCw9XdjujyfnX
	ZQwixDNrgacZXO0mQFeXnTj3u7izy7BE55KG3qlRUBSiEVWDOv2+udfVQxcz4PluHHShgX/EuXt
	/ptGX42/D3N5cpt982Pq+9u1DS/ATHXcL9auTg6g6ivzLz/B8Nq+4M1G3XZwn1tHc8++S//AiBK
	Db5BaMqb7LGYmXCXuMTZrDDH79/DYs3mD9Z9hu9Hg/1SZ/0W3/DDTd8WijdPW9NcFtBRbhnRjhU
	fPWjs98E9s5BpHoc9koXqzJnIKgUZrdP3ZLouV6ytoG+WIt3dBTyCA0Q7JWvKAoh5hbfDU/bpca
	yvmCUlSWVH5GPCPfQlt+lXnLLh+ZgUDIzzrOs7kI4YXv1WJsm8zEClHilONL6l6X/vsd79CB+gC
	E618K977vhiqXQLkHQZtTdVDUNCC2/Q5SBgOHQnAX3cfTp6mXQCcUN1WQ==
X-Received: by 2002:a17:90b:4d02:b0:3a4:6f38:f2a2 with SMTP id 98e67ed59e1d1-3a8a1ac0562mr1978385a91.25.1791381933049;
        Wed, 07 Oct 2026 07:05:33 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543b0c1fsm13716636a91.14.2026.10.07.07.05.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 07:05:32 -0700 (PDT)
Message-ID: <960b1305-c5a6-4554-8bab-1cf4244fa11b@kernel.dk>
Date: Wed, 7 Oct 2026 08:05:23 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/9] block device fixes for large block sizes,
 IOCB_NOWAIT, and direct I/O
To: Tal Zussman <tz2294@columbia.edu>, Christoph Hellwig <hch@lst.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>, Hannes Reinecke <hare@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 John Garry <john.garry@linux.dev>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Keith Busch <kbusch@kernel.org>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/23/26 5:56 PM, Tal Zussman wrote:
> A set of independent fixes for the block device file operations. The
> first two were found by Sashiko while reviewing the RWF_DONTCACHE series
> [1]. The fourth and fifth were found by Sashiko's review of v1 of this
> series, and the rest came from asking an LLM to find any similar or
> related issues. Each issue has been reproduced, with the fixes resolving
> the issues.
> 
> Patch 1 fixes silently lost mmap writes with CONFIG_BUFFER_HEAD=n.
> 
> Patches 2 and 3 take i_rwsem around the direct I/O write fallback and
> the splice read path, which race set_blocksize() changing the mapping's
> minimum folio order.
> 
> Patch 4 makes the buffered read path honor IOCB_NOWAIT instead of
> blocking on i_rwsem.
> 
> Patch 5 makes IOCB_ATOMIC writes fail instead of tearing, and patch 6
> stops the buffered fallback from retrying an atomic write. Block
> devices can reject both paths into the fallback before submitting any
> I/O, so we fail rather than issue a WARN() like ext4 does. Patch 7
> makes iomap_file_buffered_write() reject IOCB_ATOMIC, so no other
> buffered fallback can complete an atomic write either.
> 
> Patch 8 fixes leaked page pins in bio_iov_iter_align_down(), and patch
> 9 removes dead metadata handling in the async direct I/O path.
> 
> These issues are currently unlikely to be hit in practice due to the
> specific configurations required to trigger them.
> 
> The reproducer for patch 1 is in blktests as block/048, and tests for
> patches 2, 3 and 8 are posted at [2].

This is based against the 7.3 series for some reason, can you please
resend against the 7.4 based branch, for-7.4/block.

-- 
Jens Axboe
