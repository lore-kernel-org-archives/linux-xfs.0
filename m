Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB6530276F
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 14:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764773590; cv=none; b=hkucXA10i3n3Z2Qn+sYYTmZ+Ahqh9iPh4NuJ5u/CJO5uCw5KOqI9mIJTY48hyISGoLOBlWyvxMdAL602HMhlV6hDS8302AlfARU3jnyEp8N575DaEwzQQTiHqARWS7QqL8TuuiNOPO4lYgduKfmwtKtsroKYhyQl7WG/UYv9kfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764773590; c=relaxed/simple;
	bh=51vchZDDuCG99ZyXBOF75m/Ok9cyPANtpXmulk2ebMU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dKzRUHwPoTuiZ4ojyM43qYECPU1Cs7TKHKjve139MR4MyYb3wluqOabUdoSluQcf12JJJUzQm96NW5hkm85IwqeWnn7lPWXGIcbnSRLIjHREREQSStCY7DiMvnOt0PsK6sV8EE7k84WfyPzX4OGEwedkTP/gi+2/63GKBcDicbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WM6bKsSj; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WM6bKsSj"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-44fff8c46bbso2085568b6e.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 06:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764773587; x=1765378387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9tc9SBGUvFCRRJRAPBShVSwTVwLl3EJakXc/nqwdiPc=;
        b=WM6bKsSjxRqS9fzQkNFqQljre1d1/U7jIbEFzdQ53xb/Ykf83vGWbz1fENNm/EM/IN
         RgtJVNluLPT1CoQf6PPlW+ZhKRIA6LYzi7R5qgbujnjkFpRoIoXiufRnUxr08Y0Z7WBG
         HBD9I7FNRf/kuR+Wyx0hMhVHcBKjlXjk2QyTwZeQHjyjezVFaYLwErac93LuwD/6n7SX
         hqfnD7RN/Jv2J16t6xyFwTsq+VVtTvM9GuppO5bfUgSZKwrLgBT+Fo+ZKFy0H+62PQeT
         3o3+RPKj92QSWZ9z0HYxk8yisd1tJ630sGzwJq7Yobv3dMsiZR6oHoa1vbG1xo61lKAc
         dpeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764773587; x=1765378387;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9tc9SBGUvFCRRJRAPBShVSwTVwLl3EJakXc/nqwdiPc=;
        b=Cigk2fXbMdOqjmcJX7rM3heFsHr4ZpmVR9Fkh5qmswgJ1lEK5Zy4Kl+z4oFjx4lOVA
         b2sgQ0OvigGbpnK3jc0E45NVLsr9Ql6rnkxqu/0DhugTpXDALmaf5lXHp4hbypZM5VIR
         0ynV5S8STZRT1iRVIW/2ifuG3Wv9DEx67wnxFU2Mqq18Qe14djW7ZYD0BeRILFHOBzhd
         WXZ1kwPOJQzQyRaFchtqkE5aIUPAmdCYy6wsF9naFUO9XNAuj9vzJZgEJ6FU5RR4Fk6L
         eS3R9HpF6G4/t1jDC7GLJPwqHDc5/RanHWU60pRvecsNbshC7E2XGQMBHiCmMJyiz6fZ
         DYyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYv8aCWSwJf2b7GWy94C1WxG/Uv6Cbvjzi0qGf982rqDxZJg3FXl1BgtRq7Rrc5uBCjYXrs9VONVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBRJvzbKv/HarYvOIurs2O1HnInDRSrCN5TgLKzMD0OlgUmW3Q
	BjfcS2XyR9uJWpxT2s+HMazwpw+Ri/+YJkwDW6ouqrFvsrSCEHubU8DAgSdC0qoZJMk=
X-Gm-Gg: ASbGncvcGJF8/lb/KOv+Q7HzTLSrEO5Gcb7j9TB1Qhg1juyRvYuGz/1LOIqhleTvRbI
	tDVjCjtAUjkN7OaGrEmF/QK5BgnUkKmc6s2fTEEJqwh3sIKwjmqGHQB6R0VjmwesOwiZi94Cr7D
	EM5Kdoes1gd095xbImx7ZGh8hsup5asU4dplPUH9Ytma5vRz2iogWfPKmaVSRXI+bYv4Hy/tyA8
	jrRSLQ5r2qw4N2LvoWABBh9Cmmzt4KDEcO56095HaY46lUaMSbmaZkg+xb+WZ1HzvLL1peaMiTg
	OL/0fIKkyk1Dg9oa1dYBmrz3Dv8mlrVrbAqy1CqyZrC1h1jZ4Tv+G20k0Mf7YARzFwDfb07HWTL
	B1hjG06TN9X6un2LMVagYkjffHtp9Qab9xxoXwFAfB7mLoMiOwtapM7yfdQ6vwe4GFB9ztsjxOw
	WhCQ==
X-Google-Smtp-Source: AGHT+IEmBEK6bTGKnMdujI3ujDy4UcJas/45ozXk4d/lBkl5ABzvdXswERHZW/FvxgYvWIyzTXS/0Q==
X-Received: by 2002:a05:6808:1a08:b0:450:907:b523 with SMTP id 5614622812f47-4536e3af4f8mr1301320b6e.6.1764773587425;
        Wed, 03 Dec 2025 06:53:07 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65933cc55bfsm5953139eaf.9.2025.12.03.06.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 06:53:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
 asml.silence@gmail.com, willy@infradead.org, djwong@kernel.org, 
 hch@infradead.org, ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-block@vger.kernel.org, 
 ming.lei@redhat.com, linux-nvme@lists.infradead.org, 
 Fengnan Chang <changfengnan@bytedance.com>
In-Reply-To: <20251114092149.40116-1-changfengnan@bytedance.com>
References: <20251114092149.40116-1-changfengnan@bytedance.com>
Subject: Re: [PATCH v3 0/2] block: enable per-cpu bio cache by default
Message-Id: <176477358617.834078.6230499988908665369.b4-ty@kernel.dk>
Date: Wed, 03 Dec 2025 07:53:06 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Fri, 14 Nov 2025 17:21:47 +0800, Fengnan Chang wrote:
> For now, per-cpu bio cache was only used in the io_uring + raw block
> device, filesystem also can use this to improve performance.
> After discussion in [1], we think it's better to enable per-cpu bio cache
> by default.
> 
> v3:
> fix some build warnings.
> 
> [...]

Applied, thanks!

[1/2] block: use bio_alloc_bioset for passthru IO by default
      commit: a3ed57376382a72838c5a7bb4705bc6c8b8faf21
[2/2] block: enable per-cpu bio cache by default
      commit: de4590e1f1838345dfd5c93eda01bcff8890607f

Best regards,
-- 
Jens Axboe



