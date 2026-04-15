Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAA119A288
	for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 12:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776257412; cv=pass; b=hRUjbO33HibmGL/WaxurLBuCywzLcFB2H62xBV3GJVVUPHom0yc0B/DmyGx4w9Q4usl4t1PQnuJgBMxvpmmQQPuPSaxJPWg1CvENdoQ2Xfcujt3YsnHMp00QAHNTFAkiBHO6UZxQwfeYA0Ii1gP7KCYIKS+BqcgJDPqVTtrqFe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776257412; c=relaxed/simple;
	bh=ZP4vSTi237WM7Shkp/cJXygtdRvJMxuMDi0qZjIwYCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f3CboVJFcRG7P/McTjGJxVBWgmEzmi3sdKNHrSyzstCzs5i9Q3rwtnChAhBe8cBZQHTMuzebP6CdMQQ/sbq9+fUyCPAiCokwe1yNBBTlhJlj20qKqQXE5GBHtx42aNLXQl6qTuaVxQKBanzD0O7G/7f7LRLbdhUCOUW8E0D6A0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U5iWKqd9; arc=pass smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U5iWKqd9"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cd71fb9f06so420069185a.2
        for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 05:50:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776257410; cv=none;
        d=google.com; s=arc-20240605;
        b=Ir3zgyqRTIzUaxsYgVkNGBSo1VSZHfXM4I7xBCrDQKADfgE59MlRIAT3Yq0rNJsFJB
         KG6hAcMEGLwFTuNfkYZmnCSDth5jUv9HBT+md+5yUbTytSWWp59YPiT3+oO5QjsDIVDA
         8NewO3LyhHS/JRXHwyehRVEAOwGXwtT4tZ6lNwc7KKjHuK8iDx70+pibrwNP4vuRh4M3
         RcQe8Dr8IXUwbT8Z/L4lzEzy8R6/OLxidY+Cq6/RLt5KGGK+RDxMqPiIHJ4gTL39hGsy
         LI61Op3tnEGan3gx9hOmQCkqEXITxf1e97oDqMbcVkleZGl+k8hdkmThyFdLP8Z0b+Hd
         On0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=D4tWC3t3xANgqGsaOz03y9MNl8MWkuRMcvKOFAlOirc=;
        fh=5aZPhDmLrZ4/uQHycJXJ1pv0QZwTptswiHHXwBZFKH0=;
        b=bjuMVF4WxleNwmwZF9t+FmgnyrRILwi7rQxlLU98t64YQRwKOGGh2IAiT8iyEWEQvV
         BlPFebdi/VcAbh6P/WMFbHNGaSWTY2v7P21kwj4BkK4Bpozz+cTsH6DvX/ZKsewHzJT+
         ZjrM9mHdJe9EY8HUhqYje05EBmZMDJyOqq9XNiNDTVWyqrOxyIPzBvO+xKD+iNaK18WL
         agK3TfrtJxw2LYnqeJxVAML4Y6GeksDQiV2029Atp1X7G5jGLfW6KvkIjMEeI0n5oWcz
         DKhClIIZXHCY77paXCXn8EwCWQAunkdDUK3kouAXFuuievh7snf+YxRbt9Vlz7HKhBKG
         sx6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776257410; x=1776862210; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D4tWC3t3xANgqGsaOz03y9MNl8MWkuRMcvKOFAlOirc=;
        b=U5iWKqd9C7K17mIJA9DrwIPET8xAgSIjI2Dt80xmicSUiKIzaYpxe+gAPBNblAuSWZ
         DfS+CTLbbUiRFEe/2OIJCdvbn6JwJnQ7g6nGwaiMzvYG92hq04dXUiQCOK0Eoykb2HLd
         +Lf49ORPa7Evp4kGLefWinL34LJAzskx2Z6snitX1Rv6AVyFHdge0ezE9QLgSPx9zXod
         FVeuIF7O8omcL+i2V4/a4lCBxO602uRsOUg5W+g+9Qi7EjUTXQTmpBqrC7Sqpf72WvLE
         bqo3c0owFzf9VVKtgZOxhriAdcbn/sj3rIAfY1XpB/TmMXUbfvX+qQp5Kw3NsVVjO3x2
         HWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776257410; x=1776862210;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D4tWC3t3xANgqGsaOz03y9MNl8MWkuRMcvKOFAlOirc=;
        b=L9EWNxtZbEfeD0MgNm607hjvYGsIWiDciMF2kmsJ/gzremsq27ebWTfqNIqXBDOb86
         61C+4mpUF1ENfKjRA1PF8IUemXSfGB/M6cAjoKnW4L2H7w7ifx3yo3Ag2MdKqhjryBng
         Xs94kdFS1VUQkVROcLT6AppPD3itDR3a8mfYdeyCtfdUxEENSRZtCge9+CLFoXKBtvBq
         LzFXKmjh60tzII9+JhrvWsQk0AkkTHIc3tD6pXR8KNFD3vlRFvn5Z9nnCjjjONwZ5WxI
         93TtcMCGh/TE8xXgSR8exeJuBoc2pHccmo3XgzMugzx3aPtJ20MX2Z+NzfJWA68RRZpI
         2LGg==
X-Forwarded-Encrypted: i=1; AFNElJ+y3lSs9sEgV5HtCK/NW1Fb+OpmInBjgTgbBPqDr6wRodXU+KrwEs3iv/d8WX40e6n/VTwJoJGgrxI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/xeFCMUy/T8XvfoB+BKsLIUtI8BmC48jKwzAFFJHypatCTX6E
	1xjbv8k6WZr3WEYleo4hEjIorDkHpUS2JWMR3GGHjv09SQDJagDI91JR2GXKVCnaU0/EJXHykCJ
	tki7+bi7mxtc7iVrq9pB2Xym2TpXJ0UTzcGI4kVY3
X-Gm-Gg: AeBDiesFhc+XlkiEqo1qX4mcysKXrh3mWscgsCpbzbKoaTDogba0bVfe9Av/nk0ELcO
	PLyMqJVPWTfQnKNmy6EvWxVGYHWlw5ZJq/6Vcw3eHC7svt2IJBNOYOcVDNQQUUM5QLy22cFoSll
	gPG/h0VR1PTzqBrJ3tOHV0C0G8FRN8UWNLYz9KKQmYGW3ILQSICUNgZf4LVJYBkYCsHRLD/D3cX
	5AsKjFeim+SLAv/9OkXUSGl0oU5gnn2VKWqkPa01pBGh5bsMkuxQ0D+faJtTLW5P5/4mKN/XTpR
	GSvev8pOEoH2JYl8x8CvFrzQdg4d
X-Received: by 2002:a0c:f40e:0:b0:89c:ede4:ea35 with SMTP id
 6a1803df08f44-8ac8613e90bmr340193926d6.24.1776257409637; Wed, 15 Apr 2026
 05:50:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de>
 <adl1iqhldFvJwSw-@dread> <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
 <ad2RKNo2FGhpzJQp@dread> <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
In-Reply-To: <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
From: Sandeep Dhavale <dhavale@google.com>
Date: Wed, 15 Apr 2026 05:49:58 -0700
X-Gm-Features: AQROBzBdnyNeg6M7eBa34eLrstKbL-D014vWbc0uebEOU17jGRgdz997IpSMUAE
Message-ID: <CAB=BE-SObq4hSO9s36H06eVtZzyj5OBPKJSOOYGJDDD38URN8w@mail.gmail.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion support
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>, 
	Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

> Basically what we want is to get a non-atomic context instead of
> using the current softirq context for read post-processing and
> switch to the task context immediately as you said, because:
>
>   - Our post-processing needs to work in task contexts since
>     advanced features like compression deduplication need it;
>
>   - Even regardless of our specific requirement needing task
>     contexts, using a dedicated task context for read
>     post-processing is much better than run in the original
>     softirq context:
>
>     - Algorithmic work could take extra time (especially slow
>       LZMA algorithm could take milliseconds on low devices
>       (however, we need a common workflow for all algorithms,
>       including fast algorithms like lz4) and verify work for
>       example); and long processing time will interfere with
>       other remaining softirq tasks like sound-playback
>       / network softirqs;
>
>     - If it is then deferred to softirqd, it just makes this
>       latency issue _worse_.

Yes, this was the reasoning when I narrowed it down to per-CPU
kthread approach. Patch has helped reduce app launch times which
has a direct user impact.

>
> But anyway, I think nice -19 can be evaluated if Sandeep have time,
> but such nice value should be set by the filesystem instead of
> the userspace since the reason is as above.
>

I will find some time to re-do this again, including setting nice -19.

-Sandeep.
