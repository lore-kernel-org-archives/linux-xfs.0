Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482D2354AEC
	for <linux-xfs@vger.kernel.org>; Tue, 28 Oct 2025 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761691681; cv=none; b=cR95Ln4ChbiknaXoAtqM2I6V1txKfperLBqRMLPmlvdATHigyWzHjVLA7v38rbkMo2ZSEq4MJzFNh5cpdewQA+KH7FuaHssUbzyZ6r+JZ4nBUIlh/06bL4nsTzqhT+Z2Da6R0NGzTsAe1N9uBTdCBzYTCEzAey8XAYSKDnf6GOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761691681; c=relaxed/simple;
	bh=1/WE+xbvc6Dal5pEAP6nQ5I9Rm9+W8PbrmOyYOyQAU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atxropIvzBYSL7KQMfHxxdyU68DdsbMm1Z4TipcDpP9xSn+230nB8aaUT/2NE9FImj6Yfj6aCYX4N1wirRbZPL0k5CNkUruGchMBpF8Z3v9HQOG8tfS7gHITHDGLrxjbkrmXBHFU9SY85iZ/x68G7i9lMtlyrhbN/XCPEqhp2Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cw5txWlI; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cw5txWlI"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-27d67abd215so74035ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 28 Oct 2025 15:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761691679; x=1762296479; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bDTzcXmi62N+bAdKsA9MM3K6VkUn2QF2TaFyCxaOopA=;
        b=cw5txWlIuTN2QU5L8mb2O7HgmcLoujhWuSezj1By528HjRtYaUcMiQ6ei/hW+b4eSg
         EtyXebaRu/guzPzERPHfgX3ubrJykfDzZRr/XEk7+wGPKaoerQvXYXPY2L0QWLKQ46g5
         Uvx5e21Jx//zbeMzmrg6WDPFkOSznKFBZaYpg2GJ6thXiaaiuZFjUG+RL1yen2BwqewK
         OtTH8DkpgOKjon/ej6BoZWQk33lvIZFQIaQPsOjRriuJCzmkoPXYbIuXJYBS0u9w7YQH
         1wbMUD6wKbxfvjZHhxYFFJuqrM3uQCWm7CPtxzv4/bAFL74ldejUQpj/YpNtpEI2mJrz
         wBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761691679; x=1762296479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bDTzcXmi62N+bAdKsA9MM3K6VkUn2QF2TaFyCxaOopA=;
        b=Ur38wzLl6LerNhOwdctz4O6VR8VLy6TGLuu1Jxvm96havM3K4WAhr4zo/7VT96ZVlD
         OYZeOGDgr8BMbeRC5zsvrI0Toztl8nSfEDKNpwi8CTVmJGzVE2zbdEMxkv65HEkbetxk
         1Z0hU+e8pFx4iqo2hVKX4N/cgnvR6lmV5S+hq6yVTN5sG4L1Y0ssL8Yqh07HR+dCeBwP
         guej+Ijhck8pN9FDeLHEsOGbs6E4I3sVJ9tVXCWAqc/laBOcbat4pwdapJwk6qFqrfbM
         zm8+nlyomd8Kf0vsRVxhSyFCLiGJdO8nfQmeSj3LVKNuICZr+oR0gjnh/ag0eiyVlb1p
         UE9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUetRFoUpHoA5fhMEJ19wP/0/uSTcNoi92fERcMI7gzjVRdkGRJ+o5NQxcjsK2OOwcjpGYZiJeNKZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjEiU5EDx8AuDwOyuC6cbWOxaf/hMzh98lcISYvUUIJWHeS4Of
	yO87tX0+hilwtboX7linLxytJGk3VS753Eb3OBZ5NAGDr8k8dvWdv0gWgZ51Zw5LNw==
X-Gm-Gg: ASbGncs55CA0uyXQn/2aFtwmMm1O0HOUkol4h5nUhyhO+9W98j8vXGGZx2uVFxAOIRK
	GA5nfzueNjuOT9AGsqmc4qfsOKo5rEW/apCgV6aM7fjEcq++4hhnj1E/nsLD3bAVJTmIAVykoJK
	JMPAaRexekch+nR7eGnay8p3wLvG7mkZb7zbJJ5kvjWXnATwCm8FI1yv+gw+vsBp1s+cOXasXFM
	ZzuacI1CIiHJtVyawztcUebbLJxGEVuChziR4GKQVkdI5zLyvjGsjHPJbYhtO/1J90if4n8J1RG
	VafJMVP+0ptF/atCLdn7JkIaNNeC6B+35oIlegS0M1iyH216dFI80N3RcH0j86A5r8MaMHWkvCD
	Uyp0nVL3PZazMSedcjbMAM+u8/ok78wV+OHeIFG61ZJaPouNv+vFmEofPDzp9YR5Hdk/ZWNVGVq
	Cx9ghgM1vCEeQHvjYg2+1DizZ9xRtaQEcjqb+59Sph3bYWC5hFMWdmsE5lu+dIjc1Xl42bpsNoy
	EJmAvYgFB5MWsvkCF3Yt+6nSfDynW+aBUc=
X-Google-Smtp-Source: AGHT+IGVgm4/IjLLQT0cmQiv9nPeepYGw4HODw55Q9JYgkuJimkY420lDMBroEQm+to1DoESC9iCmA==
X-Received: by 2002:a17:902:f693:b0:291:6488:5af5 with SMTP id d9443c01a7336-294dffb2cecmr1077105ad.1.1761691679356;
        Tue, 28 Oct 2025 15:47:59 -0700 (PDT)
Received: from google.com (235.215.125.34.bc.googleusercontent.com. [34.125.215.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d4287bsm131385965ad.80.2025.10.28.15.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 15:47:58 -0700 (PDT)
Date: Tue, 28 Oct 2025 22:47:53 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCHv4 5/8] iomap: simplify direct io validity check
Message-ID: <aQFIGaA5M4kDrTlw@google.com>
References: <20250827141258.63501-1-kbusch@meta.com>
 <20250827141258.63501-6-kbusch@meta.com>
 <aP-c5gPjrpsn0vJA@google.com>
 <aP-hByAKuQ7ycNwM@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aP-hByAKuQ7ycNwM@kbusch-mbp>

On Mon, Oct 27, 2025 at 10:42:47AM -0600, Keith Busch wrote:
> On Mon, Oct 27, 2025 at 04:25:10PM +0000, Carlos Llamas wrote:
> > Hey Keith, I'be bisected an LTP issue down to this patch. There is a
> > O_DIRECT read test that expects EINVAL for a bad buffer alignment.
> > However, if I understand the patchset correctly, this is intentional
> > move which makes this LTP test obsolete, correct?
> > 
> > The broken test is "test 5" here:
> > https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/read/read02.c
> > 
> > ... and this is what I get now:
> >   read02.c:87: TFAIL: read() failed unexpectedly, expected EINVAL: EIO (5)
> 
> Yes, the changes are intentional. Your test should still see the read
> fail since it looks like its attempting a byte aligned memory offset,
> and most storage controllers don't advertise support for byte aligned
> DMA. So the problem is that you got EIO instead of EINVAL? The block
> layer that finds your misaligned address should have still failed with
> EINVAL, but that check is deferred to pretty low in the stack rather
> than preemptively checked as before. The filesystem may return a generic
> EIO in that case, but not sure. What filesystem was this using?

Cc: Eric Biggers <ebiggers@google.com>

Ok, I did a bit more digging. I'm using f2fs but the problem in this
case is the blk_crypto layer. The OP_READ request goes through
submit_bio() which then calls blk_crypto_bio_prep() and if the bio has
crypto context then it checks for bio_crypt_check_alignment().

This is where the LTP tests fails the alignment. However, the propagated
error goes through "bio->bi_status = BLK_STS_IOERR" which in bio_endio()
get translates to EIO due to blk_status_to_errno().

I've verified this restores the original behavior matching the LTP test,
so I'll write up a patch and send it a bit later.

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 1336cbf5e3bd..a417843e7e4a 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -293,7 +293,7 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 	}
 
 	if (!bio_crypt_check_alignment(bio)) {
-		bio->bi_status = BLK_STS_IOERR;
+		bio->bi_status = BLK_STS_INVAL;
 		goto fail;
 	}
 
