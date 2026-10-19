Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792423978;
	b=pkoIlZm2+iW7/H736155fu+28nwmChj17AIc8/29FtpirAxCywR2+47c314INru+a2Zk
	 We2Jo9hOhgfNkkvQKZIDb4mMF1oueGm54ZdGnYu5hX64oPYoPwTWr0LpxWSuRRUAZSKVW
	 V3djVXbs7Docls7KAbb1fkTHE42FZSEKzxS6JcfYMicqPrK9Q0tIrlSPiSYn433WUlbW7
	 QOAmFWVLmhoHWlmBiaaE4kq95XokQawNwTumZNunNAIdlaDONqAIzc2BqzJC28Qr0cZb2
	 jsrv6vNLpGmKPzBU1vlt8+Hcq8Su9ux1xqQOqSUVNcnNVoMJ+QWSzRnHSVSPWJKtGPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792423978;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GSTp3O1gn8/DPYgq1eEhJwmeRMQLwtbrlVS4a+j0UDg=;
	b=dyQ+FcQQ4OyINYCSkmDgpmLHLM2ZpWzRxrW53FrZ+keaCbmPFP/3xWjRitGq1oPTFzmq
	 33soTEtc4ctkS3TyVnjalSwLHfv8rB+71aGrtK1E7ktPBXtC97VnqLucESeVEfab4vDnU
	 J+6v3qx8NVzlY7HkZYRF2uOFKPm4UNaIL3D21rS0VTSEw4n0E08JRwdmdRnNsb2DXBb5u
	 1nDeoXT8MebkHzEiT2bmH/xNxFaw7obVthMPpBDRpmciSOFje66dhHHWLT9bRqZLvm9S7
	 3zRgbTNt6Ra7fFnYHUgcyzBTpqvoYOohkteuFnzQ190e9MMgjq6dlzk8XBQ+Xf6BxJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lSK6Yu74;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615A8606AAEB;
	Mon, 19 Oct 2026 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lSK6Yu74
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553151F0283C;
	Mon, 19 Oct 2026 15:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792423977;
	bh=GSTp3O1gn8/DPYgq1eEhJwmeRMQLwtbrlVS4a+j0UDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lSK6Yu743DheSdIEHoJOfTV+4rrtw3o7Jf+lV0ipqfBo9+q7BjUfRePfnze/p0diY
	 H6LJJWPD3ywG/Jh/uhkQUlYLv/ole2Oa3KOQyRrmlwUDkbbOBKSGaZXdxQFCmF4hmx
	 AIsh00qNPDMbQdhOnAb4VckaDCzErkZ9O2z1bk9ZNsq5x4kPqgZlljizO9z4ftWXzq
	 YbjRmLGPGf05XGN9myHcQ/U3Xrsni9jBd5DsgYC+P9eQ8i1mJjDpJ6wfSIAA+1YhPD
	 wjUlIzaSS2JInNgPhroh2QHa5qF+ZHj+l0ytUoHoyq7pPNLo2ljC7qj0tuQ9Zv2ZpZ
	 oAGBkHt7oB9bQ==
Date: Mon, 19 Oct 2026 17:32:54 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	fuse-devel <fuse-devel@lists.linux.dev>, fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
Message-ID: <atY0Q2O9ZgXRB0KS@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261016160037.GA107919@frogsfrogsfrogs>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>

On 2026-10-16 09:00:37, Darrick J. Wong wrote:
> Hi everyone,
> 
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.
> 
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
> 
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!

Thanks you for all your reviews and help! Enjoy your well-deserved
break. I hope you have a great new journey ahead. It was great
working with you :)

-- 
- Andrey
