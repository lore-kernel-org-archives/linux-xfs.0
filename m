Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077FE4A3F21
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 16:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789144912; cv=none; b=h6fT//OCUNdpoHWbjKV57Ckp4DT9epXc/L+hzOObodNhVX9Midcdj/JF1007p6/KwbK8aFCt3vYkOZa5gqW9LzU+s0GxYDQ0xjrU6/iK/mzTxApG54T2t6nxpRGDZ1Se//OFbIxtYict/EpOZbN0DoApLRMrNc8lDk2/wPNoQs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789144912; c=relaxed/simple;
	bh=iOeKZl+2yYu5n26PAKQjFv7EqGjGpA9xCYCNrpFSoUc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nsW+y3KbjE+uUxVv2PXHSIFeSamJ/tMxcrgNf3XTw7xIGeSBoyWLTr5jBAM751EIUFKv3bENm4k2sx2Ioe3gRdAnuK9b79ZXMqvBDZYCy4so+932RYeZEujQp6W03J1sl/OaoAoKfF0rUYB5gqgq7r9CJ373nNaxVjnDNHrfzRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=UJsGGxZ3; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="UJsGGxZ3"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7f5934ba2a5so650373a34.3
        for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 09:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789144903; x=1789749703; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EzuL2B1Q778W6cbggFtdaW2ynfw2sIwJibVyXt7Oz3E=;
        b=UJsGGxZ3wuw31Ouo2AGAEnQWUkP2HP3H49T5x1zYb/JIxtkq2UklaLU5wnt2IwFjzS
         lmZhF1ZRN5G9I5ETzOKpyDPS1aOItyiwoZNTbXUHjHKQ8UByHX6ov3zZSaDERwOFmVQN
         qq9XniE3kmugXXxRmOiwWWib3ll9APvruZEHQj89cyn1mk36HXXHDJW3dc307c2wFFaH
         whbJHzFa1f1cY/bqPz7v8ETLMe+nmASD12/Cqop0JO2XMRh0Wok4iF/5gtfb6inlse1r
         X2dXHoYJcE1m84BH6ER6a2KGQT5B50tCBleLTV9F/9V/I7xqIlCxv2H3d/tBxnuSH+B9
         cWpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789144903; x=1789749703;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EzuL2B1Q778W6cbggFtdaW2ynfw2sIwJibVyXt7Oz3E=;
        b=UtzIIcaCCohp0CfdpYb4hpJkPF9Ega2dzApV/xMJn2IZjim+LeQZvfcTRKOluM4/k/
         yhQIS5QxbWa54NEt2i0jyWxi6OsAQ7qiV6ymNZhxNzqA44wthLG6zbYGQy2C+OwCgw7W
         OsEAEqNGJpbaEz88b2MiBStBu+EPV4H21Z+Ythe/1uAT9kYdDKvJtEgmKdWoYS1UAfh4
         ig37CAfWujXe7/p9wEUdvPE/1AYFOFsSkTxRWuKTNdu5CJ3oKRK6xfNUvkp28oG95Kuq
         uol2M9EyioEVEY1A17klQ10+SAU92UNKuwepI3lWXYOPosxldRSvg9sCw/7zo1crwKkT
         Df+Q==
X-Forwarded-Encrypted: i=1; AKwUvBzws5TyBXcRi45tWWMuCYcZ0wxuVxoKRB341UiQHrcDIqt1edNQlAsoTYN7J4/ZvS+95dFNhJ/SW14=@vger.kernel.org
X-Gm-Message-State: AFuF++l2HTvdPEA64yxmxpr+X4R9KUBiuq85CALG+sKQ6/czTSakXfqb
	g1YeVB+qeJvgYXaDVbDLLKkRwg+wyBol11BovO9BNMA4qn4h5bZM+uxSqtsTQSKxEOI=
X-Gm-Gg: AYBFou3Z7zUoqvtZJWmA+B8VIzcoFAgmnp3H7xGOAiwkIkFhPTc2TAf0w+9D95rlfgP
	GFGfAiha2u9/UVfDaGNV6Kqyaa6OiLfp3DFmdeqt8SgAbmdyq9h+fbliSzmbhYsd2k8Oe9k/w1W
	i2c5BUqKu+ghno6RK9iPj+YgoEl97kSijlx2fuvKR9FS3RfzBrvMi+TjUCPwl2Ex4akTcwHNs7M
	+m7Yv1lrj4jc80Eq+U6etVz5096AjGn9gsGaeWs2Km3xz+t247njuM73D1tCF5H3kOioMfiYLj2
	8jqeXGEEWWCfnKMt3zsra7EuI/+Z4uJDGyT2LrfDKAVg4hDJFLDe4dFcv7bL6gZDEMruQP/CmbZ
	tA505YUyDbAyQXwknoj9lX1g5wrS6ZBsBM5nPm7xdOGB0r8Kn9QJGNnUJuZCsMwcbu7UUwGWVQ1
	Hwg23BAiMOG/aNXfx73gBZdPEqIIgFlfV7KR+hCGKhkw+gJXuPLAX+7Zb5fseqjg+5Q1+0E/n06
	gSkaEz3TNwmxjwSKga0fzOVpSm8V8+hW42dp9878ld+rDyRFKw=
X-Received: by 2002:a05:6830:4390:b0:800:bca4:5626 with SMTP id 46e09a7af769-803ff447ademr4057338a34.19.1789144903340;
        Fri, 11 Sep 2026 09:41:43 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80477ea9138sm1764401a34.1.2026.09.11.09.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 09:41:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christian Brauner <brauner@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
 Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Anuj Gupta <anuj20.g@samsung.com>, 
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20260909060924.1102037-2-hch@lst.de>
References: <20260909060924.1102037-2-hch@lst.de>
Subject: Re: [PATCH 01/16] block: split bio_iov_iter_bounce_write
Message-Id: <178914490220.653901.14299562273015668594.b4-ty@b4>
Date: Fri, 11 Sep 2026 10:41:42 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Wed, 09 Sep 2026 09:08:50 +0300, Christoph Hellwig wrote:
> Factor out a bio_alloc_bounce_folios helper that we'll use for a
> different take on read-side bounce buffering soon.
> 
> For that make it and also bio_free_folios available to callers outside of
> bio.c.
> 
> 
> [...]

Applied, thanks!

[01/16] block: split bio_iov_iter_bounce_write
        commit: 44c209f294b88bfa55fc5fcb9753ed925ceeab6b
[02/16] block: export fs_bio_integrity_{alloc,free}
        commit: 7848da3b1ec374620318bba49328093c99e846d4
[03/16] block: add a bio_prepare_reissue helper
        commit: 584e6e36b6d0b95af00e0ee38bab43607152c981
[04/16] iomap: respect maximum I/O size in iomap_dio_bio_iter_one
        commit: 1112619902b89849da2d05a1125c3bc029d8f576
[05/16] iomap: add a iomap_ioend_flags helper
        commit: d3ff80dc0c51e0a13cf8bf5c06656175377147fd
[06/16] iomap: add a IOMAP_IOEND_INTEGRITY flag
        commit: d06c1744acb73ea1a4c21873208b971928ae5a97
[07/16] iomap,xfs: move T10 PI handling for direct I/O into ->submit_io
        commit: 946df943d1ccc826e4e66cd12a5fb13abcd99e59
[08/16] xfs: move PI generation into xfs_submit_zoned_bio
        commit: d0573f6a723f3484627c046d7dad81bf48d8fd3d
[09/16] block,iomap: fix protection information verification with initial bvec offset
        commit: 71987f0e9eb53492de97e7ca0037e04e2f818620
[10/16] iomap: better read bounce buffering support
        commit: 7daf4cc7161e92765a6a8b21f7b2abe83b414b16
[11/16] xfs: use BIO_COMPLETE_IN_TASK for bounce buffered read I/Os
        commit: 4427c12e8ae5c5cb6ced698d993cf75cb3b52040
[12/16] iomap,xfs: move integrity verification to the file system
        commit: 8a70309165a78ac12c0d3fd8e9da334b0b4d8d6a
[13/16] xfs: add support for lazy direct read bounce buffering
        commit: e5c3fdd8a0af34c1ff75808bb60fdcbefd37639d
[14/16] xfs: add error injection for lazy bounce buffering
        commit: 715f6122e78bac6a502af6f694dd4a20b4b064ae
[15/16] xfs: log a message at mount time when using integrity protection
        commit: 30f76ca12478237ad6c585f9d5996f57f44e3e29
[16/16] block,iomap: remove the old read side bounce buffering support
        commit: f6c63fe642795117124d6ea7eca39ba8823e30f9

Best regards,
-- 
Jens Axboe



