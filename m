Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B1322615
	for <linux-xfs@vger.kernel.org>; Fri, 20 Jun 2025 13:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750427165; cv=none; b=BxPZZVOW9jfUUofuS7jcoWFEiXzSs1MXAVF6JwLxy/O3AUOmg1br8o7Z1U7LWx7c+LftfXI/NuOCYol562WHsyn22rxBp+ZJG/nXKkRrobgL3K6P0JoKhJTi9+7tczpLfvEfp3IEHj9wzAYa21SzWQqHq8N8w0sVSTTtJ5ZOJ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750427165; c=relaxed/simple;
	bh=4NEDyJXdNqSWXOZ4emVLeSKU5MjypHaO00EcnF46Flc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tV3/E6tXU1g8t7dfPMI5QW1rCcQrmkxgJZ3e63q9Bfp7+X2edN7q8VHXJYcWzestbziLbhPrDzo9sio+8Pm3sY0iQi9c+bLiDjKPfEFFBSJ14lvT7oqMD3kChHcBDVz4P0L5Js/+rLvvnXDlHMDvmc49ASD2HEHV3VxSYuGYRPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fkCrALZ8; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fkCrALZ8"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-235f9e87f78so19792655ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jun 2025 06:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750427163; x=1751031963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xn7VkzjBGtxC5wocnjwA6tAAMdVwFSL8OdOVM5bwT48=;
        b=fkCrALZ8rsTj93Feg9iKYgOkhAQ9Gg7jjJKNONhsaYYd/CTFYadKD88soxURVoJtX1
         6Inr5gnZWjeZdMKRKTZr5Q6BMHBd/Sd7hYgp26H8sxAuai6BJprD6Ml+GEXysnRtaVkN
         Y959o6VibclPdMEPSl+yOMeXQpfxENh4E+R5Ok37lmv1jjL5Kp6UQnqRVdvoiVRysQMJ
         pu486wml8Vbvc+oWf8rwRW9tAUrwuFzHiQwQ9c4Iq7PM4KqlV1i8SFGpT2nLIghBQIte
         pW4LTlylo66H967tAaSWpnbJb7bvVOa+hre/dsP5qT5bXh121hfoCPgnOOOIVC6MYalL
         /QdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750427163; x=1751031963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xn7VkzjBGtxC5wocnjwA6tAAMdVwFSL8OdOVM5bwT48=;
        b=b4X1gUq8KboPH7+DsD2cZHbmDTGFMGEc2KI4CF9bCuPdVw57OljPYtLvaeig8Z8dkd
         0nEX7QFtT7OepdyuwKTqLu64oqL11NW4WktyQicbpH7JHHnxioQ5ymdlxtZfMOVoRZL4
         1mVViVpo7RmoI0gIsv42WlAqvP1vknxZv1fZoWR3mO1z27uKeB4HBaDuo4jVxvsHxTlX
         o42xBpzJq3OaIo2mZFNcIdiam1S5BTaBj9A0m9moX7CgLfEUFeypz5v08uxT9RP2yra/
         +Ra8SCWDlAU31AVKHb1cWgqH4buqA6+vnIdqt+gUhkZcdi/h1oY3bntp1MGGE1ozYQlc
         cCBA==
X-Forwarded-Encrypted: i=1; AJvYcCW2Keatp60B4k25UMCYeV06Q+IZFJSBDvcG0v6XYx9tNL2+F/6kdJhgD67Qd3qrkvA0LOqWRYeTuHE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/jwAxOi2lWqLyImvA957GK8yJAqfDc/T7K5G/59iqK02PWys4
	ku+QYNWY09EMZEYzblntUTX5PbmYdM8tiHF/LsMHe9WRzUYQcr0ZX9DxmUoBOT3v
X-Gm-Gg: ASbGncvVtl+hom3vDa8Hye6S6aK59BQsNQ16LiUE3BIRBYqiKVspIpmWsh27SoFJph7
	tAp7/QEdcjha3Mu6+7aS6jc3vN5M6Du99FoP3MK8slQkRK12YmA9TRGyna6eDKhXcDiwftxF6wn
	jRQ7GLr9QXFHKkdxZCHAo6acBgVxXKukW/60LgnaLDrpxTfQ2CzpuBjMvornW539X6qhEm50QB9
	x2XpDI/pizJcnvem7UoaCZekJTxgcXIt9Epsp5WIsXsYrWsGkte2jtmROrMaFGHMBQOUJLDwoQ8
	Ta5fSwoAJUSKIIX33ChdUUVm0ZCWUTvwZEaIQmzpUTHLGjiEnY8AYhifPeM8Q8x8gIQwB0Oi8w=
	=
X-Google-Smtp-Source: AGHT+IG7bk7ch1Ps5BIcXMsH6Ah+evH36uUMUNTWKGBBCg84jfsoFL1dXUUaHhXJnBfJpgrbyL5bIw==
X-Received: by 2002:a17:903:245:b0:234:b743:c7a4 with SMTP id d9443c01a7336-237d9adc218mr48443215ad.38.1750427163044;
        Fri, 20 Jun 2025 06:46:03 -0700 (PDT)
Received: from VM-16-38-fedora.. ([43.135.149.86])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d83937b1sm19289055ad.52.2025.06.20.06.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 06:46:02 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: david@fromorbit.com
Cc: amir73il@gmail.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Date: Fri, 20 Jun 2025 21:46:01 +0800
Message-ID: <20250620134601.231640-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20190325001044.GA23020@dastard>
References: <20190325001044.GA23020@dastard>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 27 Dec 2024 08:50:46 +1100, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
> > From: Chi Zhiling <chizhiling@kylinos.cn>
> > 
> > Using an rwsem to protect file data ensures that we can always obtain a
> > completed modification. But due to the lock, we need to wait for the
> > write process to release the rwsem before we can read it, even if we are
> > reading a different region of the file. This could take a lot of time
> > when many processes need to write and read this file.
> > 
> > On the other hand, The ext4 filesystem and others do not hold the lock
> > during buffered reading, which make the ext4 have better performance in
> > that case. Therefore, I think it will be fine if we remove the lock in
> > xfs, as most applications can handle this situation.
> 
> Nope.
> 
> This means that XFS loses high level serialisation of incoming IO
> against operations like truncate, fallocate, pnfs operations, etc.
> 
> We've been through this multiple times before; the solution lies in
> doing the work to make buffered writes use shared locking, not
> removing shared locking from buffered reads.

Hi, Dave

I have a question that I haven't figured out: If shared locking are used
in buffer writes, how can the read/write atomicity mentioned by [0] provided
by xfs be guaranteed?

  "  "I/O is intended to be atomic to ordinary files and pipes and FIFOs.
  "  Atomic means that all the bytes from a single operation that started
  "  out together end up together, without interleaving from other I/O
  "  operations."
  "  
  "  i.e. that independent read()s should see a write() as a single
  "  atomic change. hence if you do a read() concurrently with a write(),
  "  the read should either run to completion before the write, or the
  "  write run to completion before the read().
  "  
  "  XFS is the only linux filesystem that provides this behaviour.

[0] https://lore.kernel.org/linux-xfs/20190325001044.GA23020@dastard/

thanks,
Jinliang Zheng :)

> 
> A couple of old discussions from the list:
> 
> https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com/
> https://lore.kernel.org/linux-xfs/20190404165737.30889-1-amir73il@gmail.com/
> 
> There are likely others - you can search for them yourself to get
> more background information.
> 
> Fundamentally, though, removing locking from the read side is not
> the answer to this buffered write IO exclusion problem....
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
