Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794992336;
	b=P+SMtsUaVd4+I5hA4hZfVgR516rr+JjGQBChz3MK6Kz1HbMeZWRSzPxQeq1b86jWog4I
	 AxXm0nsdWhPQmHBYN8S99eU7qvo9XHMcYG2bu0bkqZRZH6bZcu9hlQYhaUnOzg1xDvuhq
	 VcIQL1sEpLxYXfr4Qn3i5a9eaNHfw77FmL4LNviuvEGmTMqQd/b6YAwbESK+7Ssgai5N+
	 hOUhdb2/Qc9h812ELdiPI9rOnOxxBFRJFjpGip49MYGgcvak/CTAa7RdpgsZYcxNBYe9y
	 jF1MaE/zwLanF/kFMqTPgrgirq2lvG7coDcROkKif3xDPv5SGyJkwvsq2oh+ToCyBbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794992336;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=qGnnEq0WJPJtLNLMoz7uGL9Hpss9KQfixaOo9i4hrZ8=;
	b=ikfK91ky0jtUU8Kn1AykNdwjyqkh2nd36mD3PQj6uaGIR5V/WRgBVn5JGM6YKvtw2AxI
	 x/9NVmX4mpqeUdgEcehWnKOFy70kJdgvRGOsv7v/5yNfoONCMD3zsiE2NmVs5O2wsLvhw
	 qxHQi0yJHi/b8uxiwuBwZRey9kS1tsU0iuRA1ozCAdtoIO89uBl17grIMxJ8X8iA9lJnC
	 3F7MTQ0TJckMPY+LmBNvxkrWNusZwU5jRwUNxYkkPbZFvtXBV6eRc3poic0w2vX5+Q6iT
	 AE4DrfLEVWhbc/vmYj8epoRLk6oaX+t3FXAMyW6fMoU9Jj5OWVbGuZ/m2mBtcfdKubw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RPQnWzhR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208E8606A332;
	Wed, 18 Nov 2026 08:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RPQnWzhR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322581F000C4;
	Wed, 18 Nov 2026 08:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992335;
	bh=qGnnEq0WJPJtLNLMoz7uGL9Hpss9KQfixaOo9i4hrZ8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RPQnWzhRxAlX6eWMB7GszdWozwJmjVeoNXvKDAMw5AMfBn4h211VrKiTjO9TTsLPi
	 2rCgPAwDaw9hzmPpo0W+5ECtft5IcciK6N3l2/YhhcS7ynbl334rjKIDw44jLu+9vD
	 rNju4WAOekO0tx170iEFGh5qmcNIT6c3b4J3h6ZnuOMWEutbkCTUn/35LMgSB6aI74
	 V8XOnrt3r7y22OfGVQFrPw1PPRW7opntAbyNjvmtEUCUcGvgG1z6T1f8YyIwzYiStN
	 1FTqXqx0uXI5QlsPxPw8D+Bs2ZuKbxYPFjNI0KqEFqe1JKoP3DHa/+MfvF3fnI3UVv
	 R1HvNrH5IaK2Q==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261110-xfs-swapext-dio-wait-v1-1-b8ccc5d5ef3c@samsung.com>
References: <20261110-xfs-swapext-dio-wait-v1-1-b8ccc5d5ef3c@samsung.com>
Subject: Re: [PATCH] xfs: wait for direct I/O before swapping extents
Message-Id: <179499233390.5574.1088700355736623145.b4-ty@kernel.org>
Date: Wed, 18 Nov 2026 09:58:53 +0100
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

On Tue, 10 Nov 2026 09:38:17 +0900, Daejun Park wrote:
> An AIO direct write drops the iolock before its bios complete.
> XFS_IOC_SWAPEXT does not wait for it. The write can land in blocks that
> the swap moved to the temporary file. Once xfs_fsr frees them, the
> write corrupts whatever reuses them.
> 
> Wait for direct I/O first, as exchange-range does.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: wait for direct I/O before swapping extents
      commit: 844bc1167f1b2d19d9495a556599af24dc4468bd

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

