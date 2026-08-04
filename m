Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB3244E646
	for <linux-xfs@vger.kernel.org>; Tue,  4 Aug 2026 13:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785849767; cv=none; b=hHnpQnKKz506J+GjIzzy5D405648KxJ2i65zZHjqVWfyG7MI5sK5zXt0RYl1lkaL2KYiw5Vrt/inHo0ViFMoZh8F58suIqAApi4PJE2j0ijJyiuJwdgDiMJNWCat0CTCZLvQh8IdCHly6UxXXoaTQM8ykx5yfvCjkpybSebrP4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785849767; c=relaxed/simple;
	bh=FevyRYJfa7aLcNPNfj5fxSj6PUN+bEmuYe7JDXhkGoI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pzqlqh6Utaus6HOs9uCj/ekr7EybEEEEe1qpXcEMFKgEClug/5fm6jHK9ga288bNYgjNeKFkcCkaRVbog8k7njgSlbAS4H81wY9S/S0kwOxnwoU4L5ks6khs5iKUYcmdEZU1KNRKVJ+u3VBLCYnn3iRPm2gVf3f/OXyHvDNMmq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=bJ4ZY/ys; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="bJ4ZY/ys"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-48a0ca07c38so2532726b6e.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Aug 2026 06:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785849764; x=1786454564; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Son60ydP+iiCgzZN46L5iW0372a03THY3apQWLtWwgo=;
        b=bJ4ZY/ys+X2o7SSyKlp9gqCf8RVnaQ5zsDFEQ27YYGK28uNgXTV46FwE0smb13wj/V
         2nDJtcNBflNtDJryyeurU8qEf89XELvXurEsgy75lfhuxBBFdCxqMQyBJ5VpJJ4mV29C
         YPUbngxZOvMG31Air0dco7372BJmSxMdCBCVg+zg/pFEyecYz+bDnQQTx4TbAhmb4NqU
         TtOee6dLO5krN1QRMW6X7s2AySUWcuALiGmoty3Ogdqrqb31fandqog+NAxaSivkeGch
         PF+gk81dc9bRgeTqSOfYf6StizOVZt5acNy7ZbxTO8WIXuChFtJlxWYVYNrhbQPPtSy/
         YvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785849764; x=1786454564;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Son60ydP+iiCgzZN46L5iW0372a03THY3apQWLtWwgo=;
        b=hU963JYTd8+91Gc9Eb3DrY8DUcmG1/ridcDc8OC84Q97XSxZOj9XbFISDgl8DPIiKO
         fymDPCnefu+OFs2HghVV5IL9FPh+Z0hPw2zPJLKGjo8t9zaiM1GVRjTu65dWEfO6p4ia
         MbxFaIR1L4qUaqYgW9J44pd+xgJnr6Kpqa8x620/hVZh+JM9e6LMIl/QCvysSweyT1lP
         FYHCEQDz9K+hHt+wUGE1Dx/YE4foQP8Ma+CxeKrVQ8oWlKzsZb6P6y9mFyuFOkCLJmfD
         th4AF3ohQWH4zHBAtuw1CDSRMF14FkmKVbfehsb9NiUQ3hHvwjNBg5HkKTYpcaT66eFy
         S5Jw==
X-Forwarded-Encrypted: i=1; AHgh+RoelLK3/4vdtWRcuhcWPIpHGMgVv4TQ9xRa031Z3bOAZyUg618Xyc2Yrjf9wa1usSQx5YXleGXORhs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyyOrtUPJ92PEZYUNfAheDuuBfyfgscJ3KgwhqNNbur3NAaklO
	W0HGfmvE4Om9JL/MopO50O7xJv5gh2vLa6fCJ8U6/pJXDDdQ4YST5KqeaFC1VG+gG98=
X-Gm-Gg: AR+sD13Bqh3TaHw2zXetNbXM8pSgC9TwBcZs0ExTtl+vNu3hQW6xRwIms9E4b6z41Mp
	F9rfsTAkNn/VLDNNSzie4Si0/gZNEeElsnWMT6QQoWxDXHQ9KMQ3BcC7yl9odRrM8s398KomY32
	4XfEf/vCWXVfv8nFYBO0900YNZ9KTbvM7Z7cSFvnsoM+v1R0lMf0t5OsrT0xzAItHH55LHFbOwm
	V+SPVi/66w03IFpzPMsIWoQJENUyC84P4QaYjO/rb6VXwfEVHwXpxIqYErpyaomDEtYkAxcgzkM
	eJwxRudijilKFoP/0V2jBEPS9Tww1F9cK2NpQtHeijvneQ51RONQUp9isYXvxmHD6D754OBBXxV
	f4tIlvXY93s2Ed9wm4jrY+JPOvKJ8KCUJqBgNELn1MH1hRM/ucw1oy5+0gohiMgD16mwg6oLrXb
	1k/uTuydZr4gdN4BBKfvE82sLbuB0CL+bXKrej7gTJ+8n7xN0Dfzeee5aX3iO+SJe/tyr2E57EM
	jzPoy2nSzt77cbXGjBEp5EIIrWTyy1qXaO8B2rJ/Q==
X-Received: by 2002:a05:6808:318b:b0:495:f85b:d08f with SMTP id 5614622812f47-4af5e31fe13mr22655308b6e.18.1785849764329;
        Tue, 04 Aug 2026 06:22:44 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4af60f08b56sm7447037b6e.1.2026.08.04.06.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 06:22:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>, 
 Christian Brauner <brauner@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260804123928.736596-2-hch@lst.de>
References: <20260804123928.736596-2-hch@lst.de>
Subject: Re: [PATCH 1/3] block: remove bip_should_check
Message-Id: <178584976213.949603.6178092261493847339.b4-ty@b4>
Date: Tue, 04 Aug 2026 07:22:42 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Tue, 04 Aug 2026 05:39:23 -0700, Christoph Hellwig wrote:
> There is no benefit in using this helper over the simple flags check.

Applied, thanks!

[1/3] block: remove bip_should_check
      commit: 6c13180dba60f835d6909e2a3b4f50862de156c6
[2/3] block: lift BIP_CHECK_FLAGS to include/linux/bio-integrity.h
      commit: 738f01912a1ad68c81a6aed06cac94e09b5f609d
[3/3] block: handle nogenerate/noverify properly in fs-integrity
      commit: 3bf9a21e7bccfd8c35b440efd114c61cc9838a41

Best regards,
-- 
Jens Axboe



