Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794992341;
	b=0IS/pT5tYN5Ts6QKsV+YPr7YpAWcnW3GRACUGjIIJ/Tc+dEeIqR/68t7/FKxEbZXqcZ0
	 jo6gsCXFLJ6LroEWrUpiS0vM/VhU5kfMKL4XJH/E1ilNwk0zpryUaRVlIxJiDs/GYVHYy
	 UUIhE0i1C9J6MsoLOwZBqY3agfc4ijeN/ezyInvB/sAy/DrQZ8ZuQ3he/CANGT2+QxqZ9
	 X2gZ17BrkTBBlsZBdozr8IyDbcs1cqrccrQi/IW1/gv646wkNImWcaL4m6M0/CkUqe7cj
	 G3Jk6Ofpxj+Ti7jLD37TfpCzdYiWis3/CxtIeyAvDHNy7ylmEPfjuewSC66SF8WAgpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794992341;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=zYYY60GcrqcBT5vMnZB8Nuqc2EsNShOf4EWlFfvFVsQ=;
	b=i3pghIpnXS/chj6Y5xb/zwCKQ3u8bXiof87c8Ohq0JwGoHSLciT2+EiU7x4d9BRiQj00
	 7h/gcX2NQK/kgt5FJ6D//Sn/oJGdWtqQ6kq34p6uIBNmxn6XvWnPTK72/HcRiVuoDyVcs
	 w5/CT67O8E57s0ec68iAMfZGbsL++G7MMt2Y9j8SP2xCnS4dzTsw3yLbMl4g42DkpIQII
	 TS1DS+1M6OB0PSTFGQ2RNoDEaV8SOFEqn3s7VN+9lzI83HsNU4tmLH/VTEZJR5MgynkzQ
	 yZBibcNnt8gJOnQ9rU+SJpasu397atJB9n+u/rZouPt4y4R12vIh6d1rchdIclH4xmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aarPjwLG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A08606A890
	for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 08:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aarPjwLG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CCD1F000C4;
	Wed, 18 Nov 2026 08:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992341;
	bh=zYYY60GcrqcBT5vMnZB8Nuqc2EsNShOf4EWlFfvFVsQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=aarPjwLGSTsMsHO773iW7GAQ/1wKm5/9Vl1E0purivoEZ+H+Oz4i1yEVvLVSygLMy
	 U1zuX78WqwIc8XRnrhV+MQwwCC8mNzxjiguffEIcGm9a3GcRjz9GwsGV7AeYA7cgIf
	 Kco4wyUMlrmuHuHGK4SHIO2D+3FinaFe7EDzo4di4kfaArmg1vBepiLDuEFALfSnpG
	 JO9ku9scZHEvfDYaBUlS3PCtkCSMiyMreG+SpDmok1EAHleFspCu7vhVqQDrtMPOsr
	 fPW3BZn8RWO05A3xPgTb1GrIOJp02GP/nJ3n/gxBnDb6jE+mbHHLZcL9A7TfaEwZH0
	 KCSPHfepf/kaA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Cc: xuhx@hust.edu.cn
In-Reply-To: <20261114005925.103130-1-sandeen@redhat.com>
References: <20261114005925.103130-1-sandeen@redhat.com>
Subject: Re: [PATCH] xfs: properly order xfsstats proc/sysfs init and
 teardown
Message-Id: <179499234032.5574.17794386237944477976.b4-ty@kernel.org>
Date: Wed, 18 Nov 2026 09:59:00 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 13 Nov 2026 18:59:24 -0600, Eric Sandeen wrote:
> The xfs statistics are accessible both through procfs and through
> sysctls, so they need to be fully set up before exposure via those
> interfaces, and those interfaces both need to be torn down before
> the underlying percpu structures are freed. Today we get that wrong
> on both ends - we expose them through xfs_init_procfs before allocating
> the percpu structures, and we free those percpu structures before
> tearing down sysctls and procfs.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: properly order xfsstats proc/sysfs init and teardown
      commit: 765db499ad5837365b445b26b6fc81f30f134758

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

