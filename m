Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794156302;
	b=WrHGDbsW5mRtcyUQZxjEiZk5qPouLrI6724+aNc2dsAYRIvEdXzHQ1Ol56RQx6bC39dV
	 b4QyjAjXEOYSnzjCfEiAyBYE2h3FalesN46gKQMBxlZCJhMf4yUol01oqylR0L6l1TCJX
	 0g3V66rup5wJBSiFapbGfcZ+SQbAFPFPX1OM29+v8E8POwwGW8Y1aCy0Y0jPtXMrPr6Gy
	 86UrVYpIEBkxdvfvWjntJIwkW5DJvyK7E5lCfTjmFJKNg/3zLDLqKiJSOpN95E//aO3EK
	 XvY9nRd+oV0OIdVjK/eGetF/EvbwPPpPMMoGXmfgvhN3In2qus4YH3SvkId8RResyTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794156302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Wcu90oheJug2lj3BwNXj66grQCAs2tghFU90gkm7ka0=;
	b=aPeP9dP/ZHROhvT461R66i/NGKlpI35gGfPaBNd3LBWtn6fED8L3sZyr1Jr0UVIXLast
	 F69mj+i28NbMWbUKxdXWUmNce+BSe1MpmXs+vmGBCOsbk+wyHYaIhrZCBWHhugvd6ZM1y
	 TsflbzxX0BK/+4HNRvCSORHr6yewi2iU/peVyzmWZoG2+Ch5khGAYaVLRLvSUx8E4yUHA
	 tRera5ezBxZwl0S8PCheEmtufOtU6T2VXH8SbHK4GBVWqdVX/Oag17ilkaQqZF1kFShNE
	 HZJT9YaKzcL7Ky52VxYjwmuWAvesWC7Pbwo7unzEwfG9tAJCEvza722Q8Wjd3YqZPLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="LMb/InY+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D762606A336;
	Sun,  8 Nov 2026 16:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMb/InY+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BE51F00902;
	Sun,  8 Nov 2026 16:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794156302;
	bh=Wcu90oheJug2lj3BwNXj66grQCAs2tghFU90gkm7ka0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMb/InY+MrS+2WjBowO5gDwe56iBMWk/+U/pzjTzyOOFrLyOHXBEC/PBZpPs1JEfK
	 roNSf4KUdqs9jicBTSdhr9dh+Njykr/hxCvyzqnkdUki+5p7TlXsLWHwl1oGSxZW8f
	 Da0/AYbLWksl6uG1bS2aLlgIbBQe8w2qnKu2zI1t6LWTKZksg7D97M3lzu+JgJYIlI
	 xBmIte+oCiLQmJ8yd4emZrbU1Px2M9e2eWNJUzo8lR8dnyaDnt592jrzCLYEbfyBVa
	 bhBOtZbOCEghMO5efF11uQ9sZwGfSfeabbSkaLHPOzfuNOpACkKmuKe28yRCnbkBYW
	 U6W6sJf3lb9AQ==
From: Sasha Levin <sashal@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: Re: [PATCH 6.18 000/869] 6.18.63-rc1 review
Date: Sun,  8 Nov 2026 11:44:49 -0500
Message-ID: <20261108-rc-reply-03-xfs-6.18.63-rc1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261108155416.119775-1-ojeda@kernel.org>
References: <20261107134852.069646174@linuxfoundation.org> <20261108155416.119775-1-ojeda@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> In loongarch64, I am seeing again the XFS issue:

Thanks for the report. The xfs patch ("xfs: cross-reference the primary
superblock") is dropped again from 7.3, 6.18 and 6.12.

-- 
Thanks,
Sasha
