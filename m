Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B96F39DBC0
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 20:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781643089; cv=none; b=OqfNRKKdRVlr3jLidVYoFeIyPvZCLIqwyQkuQBBPm9Qc8Tq1Hh6JvG200WPREQkt9ZmEgh6iTH8d7H6XxFPzJvxESmiqDt2Pc+JzKqU5CcrY63vI9VHCb4Mc9VzW1bU2huYrgD0YQkie2kcTuSozSJ5Q664sXAFLbVEFkg8Le2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781643089; c=relaxed/simple;
	bh=qqvgI8rvdQwsy+7G48Skg3XH+plfsX+hs9hWY2BSqmE=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f9L2cvTgEE/WRhCfhpDWYPxuIe3cpI6/RjFgKQ0z7bXfW/Ag6sXAk+GiG5c55R2Hrj2nFq1tWF0y1RYU5FynoCuJeVYA/pw56XQk1B5tsUuDZrMdYUG3yKBde2iPZs2dcQKtXhyyZy+fw3qMwBLVDTxzLmdo9OxTrNkd49arYpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=i6yGth8K; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="i6yGth8K"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-69de9bc590aso4013132eaf.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 13:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781643085; x=1782247885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M+dpE/j7xi29wlPNe1Z59Oj5BFfMHneb4BxvwGVl0lo=;
        b=i6yGth8K+xHjGLSGYjoW1pvgN+WCbhurXVJrkm8By1kzteQ7KOu2b0xx69lovX4dP5
         gMsawAaMZJPvwnUAR4cFYB/OS0F2HBE0qeWIkj+ElYjyG5oyTwx8/xbuwmHUfr/jeTUp
         qIwb9iOKCtSVWKyEWsYWaCraSJ2NxKkePwOO4Ntv5o2IrfFPP+30LwyNpRu4iq/CF+GF
         n28+Dq7x0Rvca7nwQybIcje51mJ+BbjxyuSX345gTdv8TMEhbTqIej4BpIv3Vsvl+Dse
         x55NGPD0TkjP2MFKhOG8twRkGETjOiQEZkteaJK0s+WmbEPsBrWRf7qyY8n/ZnqRK9sS
         Ejjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781643085; x=1782247885;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M+dpE/j7xi29wlPNe1Z59Oj5BFfMHneb4BxvwGVl0lo=;
        b=QqK/l/vIo+MPTyzAapWCdFEvIBTI+pWthS5U37wYB3klfpEVtc5/vFTVFKZZ7BzMaG
         r2cRL/sbdgecElS+YbhBpnPkwvR1ML6D4EMSy5YciMYRstwNolc1CjpsVOe2WAg3GqBg
         ZhkkNXkUqhpJIwyon/n/A1GUH4JCsBTgZaUWNTLMIV/TA14NtbVkpApsj2E1rDfGoCHb
         V6WQwZ3qaIXzimZoEj2nN3r9H+Ht9oLvTFRYxaLy44FSfImGYVWi3s/lKLcK/pi1SbiZ
         8laLGQ2XCSwwhNz6SyyEEbimL7UBSd5J6bpJG5VBwhzSsrGYVTDUtXl5JshXVKSRihng
         1hvw==
X-Forwarded-Encrypted: i=1; AFNElJ/ohSaz8/KyIHdi9d8Az7p8FIMl0GDh4MtmKgofiMChYePqbqo4H9VamwFtZKV/teUxTYsXGSgQrts=@vger.kernel.org
X-Gm-Message-State: AOJu0YyG0gOMUPFA+N1coI2He762dWQMMRDbgiYGdGyK4MNJk0YYC9j/
	hyI3edAihV1Dhh6d9Fftp46Mx/mUsTfJ7rFCDtrX1b0M6eWdpvqXkHrYHFNtT4mgiRSGf4Ed5hC
	NfHtuUtE=
X-Gm-Gg: Acq92OGksQdp6+Q0G+epgvpM5s4nPtfiwhRf5MWOmlptE/rmP3z9dNPskcps5sNccVj
	BRD55RpnScK2qypk7gmH6ikJSlJ2rJMqSrYDJ7QRdx99jyH0Xy4s/PCFEADal6oIM7RHkQkfzgB
	gAhG+2mafM5kKrv6zONlpueQ8NXySPlonNSLMaVVkJNs3gSFghle1KeDOOHmZ84PjmplMwuVin+
	rRVxFbucT3mgA/6UxWuOKtUlfgiYGw3wZBk1Bo4cglVUi7zojAo6nky+BPgDFJCGvdb75YocgeM
	F8ITe7qInebK7l7RTonBEO85V41FiILtVQqMKJQ3ghDglco9Afxdw2trg0itt6ohTrDk7x1nQ28
	mdQjSkg/w0udLpYRq0Oi0lZfPi08dJbCBbRJDzGFmxuLbOLkJ2MfojAIIDmSJYN3Pe4O9Pu/Xgy
	6fqsiKyFgwZ7qkelapuITfOExFo7woAXCYz2sbq2YflvkLwWYaXKSfuCvBTynIPFwq3xxoUTLGa
	YTa
X-Received: by 2002:a05:6820:6ac8:b0:69e:33ef:4b9c with SMTP id 006d021491bc7-6a0b5e0e16cmr630112eaf.6.1781643085197;
        Tue, 16 Jun 2026 13:51:25 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4430900e368sm2887576fac.16.2026.06.16.13.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 13:51:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 Qu Wenruo <wqu@suse.com>
In-Reply-To: <cover.1781597506.git.wqu@suse.com>
References: <cover.1781597506.git.wqu@suse.com>
Subject: Re: (subset) [PATCH v4 0/3] btrfs: use IOMAP_DIO_BOUNCE flag
 instead of falling back to buffered IO
Message-Id: <178164308431.2260944.8317946373333928448.b4-ty@b4>
Date: Tue, 16 Jun 2026 14:51:24 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Tue, 16 Jun 2026 17:42:34 +0930, Qu Wenruo wrote:
> [CHANGELOG]
> v4:
> - Follow iomap/block layer code style to avoid lines over 80 chars
> 
> - Reject NOWAIT BOUNCE direct writes inside btrfs
>   The iomap code still allocates memory with GFP_KERNEL in other
>   locations.
>   For now just disable NOWAIT BOUNCE direct writes and let the caller
>   fall back to blocking mode.
> 
> [...]

Applied, thanks!

[1/3] block: revert the iov_iter after a short copy in bio_iov_iter_bounce_write()
      commit: b68d4979c88e31488970373f67ac79b4f6267008
[2/3] block: respect iov_iter::nofault flag in bio_iov_iter_bounce_write()
      commit: d5b58fbb2fd7ac25fcd7e1c14730f998a90b0322

Best regards,
-- 
Jens Axboe



