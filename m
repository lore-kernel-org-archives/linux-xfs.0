Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71186334C1F
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 19:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098411; cv=none; b=sMAk25JsdUoF54s1r/QTs10u4tkO68v1Z0aAA8Qze3fUpHs5XK4O0IGkZWmtjtNA50iF3kPCHOUgMjmbJc/0grL1sOtLU3I9SEgBNnSjHeD7CUOAKB6LsxybbtyNrhobiy8F2vvc5J/G7Wib1J/6yb1x/qJS5nmd9VSk/qg5/rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098411; c=relaxed/simple;
	bh=weoF253YS0RDYDNFjzSDJ5tIChF4WqxAAq+yZqEKh9c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aGJvwCo7e1H5AE7xGIXHTjYUj4t0fdSWNwhmgdFM07HF0Ntqy44Hh1lPZZkJHKcPp70eIRfHIBM2zXTqc7eVSb+pH1P+sAxS2eSzATJHEpsoHroNGOnjWkLxIQTuS/XQeP7XmGE5mdZFRnOyxtd4GVwM31EzoqZqhbekxs7PdYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ou4yP+cP; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ou4yP+cP"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-948614ceac0so226579739f.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 11:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764098406; x=1764703206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wynpj+E5fG2Oh1abG+WZEscR5HBvHm5298AKLCuUClg=;
        b=Ou4yP+cPskomYMeVdRXei3aGe4CA8qWru7OsQP6BwdThf2GaArI8DOmVuUTM/9jgv8
         7yfb3c/0JmSqRsVHmB9X6Phme2s4crzBqQXAGysf6khbNn9GegUtUQKxVlcAy26vQYp6
         kl4sPUIwsjVQr7ahV4j/Ysgjpa1LobItHW3YSAHaxTCkylGkOFUf13dApdSBcuce3quJ
         ddfICYEQhhFNAtAxjqjafE/HQviesUSIZ0VFAkfuiWwoW2sMZmGf6ATN89T2oU4YONDk
         y6k1rY57h3ydl5s0+qPDswY0JwxaJs8RBzn4/NiEMU3SkXxLKVYxTQp/dmil0NkNCP06
         IxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764098406; x=1764703206;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wynpj+E5fG2Oh1abG+WZEscR5HBvHm5298AKLCuUClg=;
        b=s3fQA7vRSSdkPT2I8gPX9tg+P/sTLZB1Vs+HL9sUszmLdGWQj3bvQrNeD23XxU7KQs
         isfdrhTEhnwTL3I0iZbuXyxoxP2mbJcTRORwQxOpprmGmvQQFRypak4QKBIjaKeMoLKB
         O6SU6JOoM9fLe+udpd7rZm1PQYeLMKOz2gr+pzWrJoObxQS079MRHpEaM6ehXw68W2mj
         0XRyEHMIq0TqTx63zepjO80tPx2D4K6QL/01sLj8rYNufp1Pb6UtRey+tDkVU5/mJzcR
         z3BjBHEE7nVfcm9rbFRh9NvFwrNqj+Q59ZJZL5vMj9WAJUQfSxRXpDr3kkM9dudbDWvd
         Mr4g==
X-Forwarded-Encrypted: i=1; AJvYcCUGCef6G2t3MmA2YyN2EVcxuMT95d21c4fz8+m6EkTETmjMMBx2JSf/n2eb1Pc7zwC+SYR7hKeZBH8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOFG0RjQHFQJcgYIxomxMWe6pIVLZ9VoV8OsSxiRaBSvfn3FbN
	VqToihcNf+bFevMsQt5gQQIowE2N5LknT5D+qMH9+5+y61JQSoFbYrjVxwPcl5xCeSc=
X-Gm-Gg: ASbGncs03LSAg81KOw8ZqCJmfwwS4Xb6U8NkJRMBlyqqSHifP1Hecv6XRxXb89c4XUX
	bbbwgefwcQN/cjDyWj13O/nbpbTwXnna10tTFNMZY7NWggwcvUWFRzOC3H2z92wKpIC21aQXX+E
	oVIWUFpncGU6+XjfjoSUDeGw1oC9frURsucNAtRoM1zg+N7q0M2wp0iLaIUOdYMQ1wud8nDBINZ
	aN24vSRkwNdw0ZItP6VbCTlOJm8QizNCjzWLl0moV3YNGcB6S+ti/gHdpfTP2ieSc/w14wZpRJw
	N0ljmliJ9bNMAN8OlOgyuZepZud2AHrIQCD62/XkildOr3hbT9q8PRDDL9wqdRNbSU8G9MIXq4t
	XYLZFmNYZ8GqV6Yv+av34c2JAwDjDcuKNBVYCcLf9kezieNQEJuMfva8lWljpnki6Ko78A1hWTk
	Iy8g==
X-Google-Smtp-Source: AGHT+IEoSNUPWsr6TkiMj1VyTgtSM+H2mYKN8PQqct0sy21hTM0OQb7u5ZARk6n0QLi/CE7kBBB/xg==
X-Received: by 2002:a05:6602:690d:b0:948:a32b:b6c4 with SMTP id ca18e2360f4ac-949473eb047mr1023076839f.3.1764098406436;
        Tue, 25 Nov 2025 11:20:06 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-949385c2405sm668551239f.6.2025.11.25.11.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 11:20:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
 song@kernel.org, yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, 
 kch@nvidia.com, jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org, 
 Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
Subject: Re: (subset) [PATCH V3 0/6] block: ignore __blkdev_issue_discard()
 ret value
Message-Id: <176409840493.40095.8097031483064544929.b4-ty@kernel.dk>
Date: Tue, 25 Nov 2025 12:20:04 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 24 Nov 2025 15:48:00 -0800, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() only returns value 0, that makes post call
> error checking code dead. This patch series revmoes this dead code at
> all the call sites and adjust the callers.
> 
> Please note that it doesn't change the return type of the function from
> int to void in this series, it will be done once this series gets merged
> smoothly.
> 
> [...]

Applied, thanks!

[1/6] block: ignore discard return value
      (no commit info)

Best regards,
-- 
Jens Axboe



