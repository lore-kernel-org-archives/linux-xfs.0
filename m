Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793623395;
	b=eK7dPQDDImQSNZry0UoTBIGZW5kTlrDsayZuq85pAfHaWLtdIiF87gGPXuqCxX5eJ0hu
	 oZoz1IcOB3O5gJjkwgUkkuU+jGj6l4jCEFb/W4Xb70udoz+Xg/yUPfWvzGjQvbe9ZPzHE
	 liKf+1hAjf90LDu8r/x8oGM9KfqGuobC+jPcAzqK91cx0cLk9HPa1z06D1JDh0ulab1KL
	 BAvV4pdLgDepTybXTpVtCUjA5TWYHM6UqTEzdcicEe+I8vuVQv0toXTmVPPTaBxeQ0DRh
	 F28Q4gF4Ro7nhK8zY8cPqGu1xt7YmQS4rJxkYJoE8VzWaxQqy+T7Nh3UN03619TKAuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793623395;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2laWryKi0XCwueEc4kSXsy9Z3fNuSYcKISPd8RxPKxU=;
	b=Dc6wyayQc58ndMuCbjJeZjxBu+wvmRAIHP0qz8ugUt2OLchDlJtIpGBqPVfkW23VYNr+
	 9nvTdxLhRF7yhVBOuTf9HuduZ1u2upr3H7TfKk0WinJ6nvRAwRXM0NAni+kaaqO6qiUD8
	 vJt0Q8eXzCKYMkGbvX5xY6SZy4KaAyFmm09AT9X402RjOSHaWtJYHEWaUehFfUY4BHvz0
	 4OHGnInYUdZcpJNosJzZWMSRaKn1NHlU7/8HgbkywbqKBs+p97rOxbI6RUHhon8d/x/2b
	 7kwwyDxz0ujDFNyiD3t4+jGinR32MFO/Q8OLnZEmui4TpvqfNyC4DPgWWoJBzNdQGJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k46+Lb2t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DC660A5BFE;
	Mon,  2 Nov 2026 12:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k46+Lb2t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64261F00A22;
	Mon,  2 Nov 2026 12:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793623395;
	bh=2laWryKi0XCwueEc4kSXsy9Z3fNuSYcKISPd8RxPKxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k46+Lb2tZ4lKhOVUJlFYJQQchEYpGBGxOcj96O5rydwjCO+sQsp3IcfAqutuGah7V
	 DKtTJXkaMexNQeKhSGjAXgKVdlT68crZHvPQp+Esmaj6IWdnxSkYiso+noikhLMtD8
	 7RQCkrM40r/Jdc6dfeOB9rS7b6KX6/Yymyyugg3DywblSMis41FciHIwqMlT5mjyx6
	 KTTb8yv0dOJxuIMxE/SYrQTYZRhpeQ4brwHmAsrhPqmWwVu+RI3qw7jnqpiOWI/NWQ
	 CBa9sSY2SjMWTbz8cVvPNXZLpEYFuX1HLdb0KeBh8lDzexvdzZqkX3jzWZTrMnKVbI
	 LlgVEw1z4JZtg==
Date: Mon, 2 Nov 2026 13:43:11 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Reid Downing <skibletz@gmail.com>
Cc: David Laight <david.laight.linux@gmail.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, 
	Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: fix wrong compat fields in
 xfs_ioctl32_bstat_copyin()
Message-ID: <auiFOLV7AkgH5OgC@nidhogg.toxiclabs.cc>
References: <20261027161748.2760321-1-skibletz@gmail.com>
 <20261028113127.3374246-1-skibletz@gmail.com>
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
In-Reply-To: <20261028113127.3374246-1-skibletz@gmail.com>

On Wed, Oct 28, 2026 at 07:31:27AM -0400, Reid Downing wrote:
> Hi David, Eric, Carlos,
> 
> Thank you all for the careful review, and Eric, thanks for catching
> the second line.
> 
> I looked at the refactor David suggested and Eric sketched, and I
> agree it is the better way to write this function. I'm not confident
> enough in the 32-bit compat code to send it myself, and I only want to
> send changes I can fully vouch for. If the refactor should go in, I'd
> be glad to see it done.

Might be, but that's a subject for another patch, not this one.

For this one:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Reid
