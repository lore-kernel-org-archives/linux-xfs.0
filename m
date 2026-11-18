Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794992337;
	b=2je523e5wNhKF79bYkbu38PFBLfkDz0o7iZVDKFUYpx5DTbvOhWdIr/ulqkvdPaWB4kT
	 g+CbfE5CiLR9GhMUrv+Cd5X3xmdnJPSbaCLNbEv3fhG6AFuEvnfwJFXvNf0eBqS9mWNwQ
	 cggize6a745a2U0eFh+rtcZ0fjgzpwHGVhf1P7+x1mSVnfT/6oZQ6WUAWf8WZuNBiuA4Y
	 8yhSe9ro2GVtnrFA8wJLq9V0H2AC6S8K+ySabAO4nZSzGRx3eArq74fGqK7K1F1YT+Nl5
	 YH0s1wJrr0HUrNvUch9weUQAnt+ugWjeiojxYj2R1atv1DQsrB8exC/4ccZuUyC3tVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794992337;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=16q+QGNnClWPAhZ6ICQsB/lvmg8JavVivPJYpngnr6g=;
	b=R4rSNG2A6V15IF4E1m/j+qGDYc9YQMm32Y+TokO8mNY+w0lcOf1n04u5TJ+qhceVt+F9
	 sqBMyX/QpaZyrm9zVSYlJ2dgsT0QlkTpcAYEBLNXMnW2tuAgUi9NhkTPlYwdY3faZVQht
	 4tqUidccxU1FVIsv5udQ5uJSArnPSfCKOqU2rtdabg5qWSHvLc7S7fAfZCnxCff9LWcB1
	 1rjCNjwRxK5MDzLRZLvQE1J3Xdh0nXtUerTTO8Y5QyGnyVnw/o4BDfPK3JK2VS5VLEO0r
	 5+aU0DebUC5UefUoi6oj7ThzNDty2Nql5JUvufC6607auMwbKQIWUXdQyTyagUTtE3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mh+LgBuW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA6E606A31C;
	Wed, 18 Nov 2026 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mh+LgBuW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D93B1F000D0;
	Wed, 18 Nov 2026 08:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992337;
	bh=16q+QGNnClWPAhZ6ICQsB/lvmg8JavVivPJYpngnr6g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Mh+LgBuWklmCKLHWV9NomONKrZIuqLjpIBVQXa7Nu/QePRAUB7OQpLXqpMT1aP03P
	 8XKTgBicN/TEpfplUsGbCUNBC1VDj4qslo0dqpt7aKVA83FVgy2I/zhBRdxTZ6E9TL
	 k1Cb3IqDXKPbZEIQMp7c/wwCjyUFhAp1DYSmwF33W/ABw+RI2yK99uuRXhq17Iq1Ht
	 ybaglpIRKm7gRrKnQ4awHlg0NK9vSPnH1LvkNhry7P/B66pl5q0XYp/ZSNXPFKVYC7
	 VI4+f8o6+1Z9sNnKAEq+yRt+hCE6Pg2mdpjpSNzDinq38fvBN0U2wEoQlz6WfFhQw1
	 hwtX8U2lhmZTQ==
From: Carlos Maiolino <cem@kernel.org>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261112102018.3922571-1-hengyul@cs.unc.edu>
References: <20261112102018.3922571-1-hengyul@cs.unc.edu>
Subject: Re: [PATCH] xfs: fix f_bfree underflow in statfs()
Message-Id: <179499233595.5574.11097163378563687104.b4-ty@kernel.org>
Date: Wed, 18 Nov 2026 09:58:55 +0100
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

On Thu, 12 Nov 2026 05:20:18 -0500, Hengyu Liang wrote:
> Commit dd324cb79e54 ("xfs: refactor xfs_fs_statfs") made
> xfs_statfs_data() limit f_bfree with max(0LL, ...) instead of
> max_t(int64_t, 0, ...).
> 
> However, the value is an unsigned difference, so max() never picks 0.
> As of now, when the free block counter is below the count of
> unavailable blocks, statfs() reports f_bfree and f_bavail close to 2^64
> instead of 0, and df prints negative sizes.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix f_bfree underflow in statfs()
      commit: f0b9e58eee233547e5d77e467ccee89d7a59dd63

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

