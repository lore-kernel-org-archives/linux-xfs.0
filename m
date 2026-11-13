Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598511;
	b=owc+d5q55rGj5cthFHnp5w8DWjOExAOj9qY2DruLPj8i/QSlMmb2dMwUX9C2GpkoXj3o
	 zgAZZcxhLbjgUvzxaVXMSIzWPFcj8F07txxvPefc9EtgnTdZd6zN9Vs/9xJfZEqaM7WQf
	 JtQLMxLs10G0NkHQ1joUo8ISN/HNVzkLxxMMkHNStHifh4n0jskOKPdlbGo0vzHkpb39Z
	 dOVhXwKOSD6kmLkeofmJxfBAfLMbaCVmURWyX2swg43CgNNsAn2bEPvTvgoQLDQQNOzwK
	 3IRoC2lK4aVRlSJI9m50yXZyniyZxDK6+slbBoQrwVNcnwS1ZBQfDhQguXyGSdnCnqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598511;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=J4SqpLYz6xNBDHEM56f/ip5cqnZrQFOa8Gj7x2Hl/bI=;
	b=eoBXyuA6jd18M0/3RsXMzpGpV5IY0rJLEFBNADQgyEH6tmuAURlhE9vaN+AkzlcnJV6i
	 Qnor5znNcmkYAgu5fUei1GwKVHzMZ4SuC2VZaPgSM0Q3BkZaB+3Lzg+dtZKfpqHtHv5cR
	 PAkB702yW1aMTzMhEftq0eFN//oR/Cre6iU68OJ4ZrtFz3j1jktEBReaHjOoWWpS3khGP
	 QB1vw3W1WeDJ32siryG926AcgGkDVZYWA4eCBtLbzkvlaxIwEDg0GCZtJZU76JKxkdrSL
	 tyV/8hNWuPjlV6etB1r66k1oRFJj+F3IsghsvtcuJeCmoo1JeGusXpK3Gdp91hEjhVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UPmwsPKQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EF1606A32D;
	Fri, 13 Nov 2026 19:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UPmwsPKQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5661F000C4;
	Fri, 13 Nov 2026 19:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794598510;
	bh=J4SqpLYz6xNBDHEM56f/ip5cqnZrQFOa8Gj7x2Hl/bI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UPmwsPKQnrDtpeV+Mx8Rttddx/jnCk8//WFXoYAJC+IpTY/9PeceVndv7CrZWo5Tq
	 j5oQxqDaqmc/hJZG7fCoZSpoYGfI29y/yIGcMkHhgCoWCiH8n7fwntEUZCbEW0GS+q
	 Cv+GN5KoLhMHOd3Rjva4OZmWwoZpgsaYlMWj+cjdZNNy/XFs5xY7VBlUm7YxA7+bfd
	 vNSaZFeMo6cyVVMg7oAtOOhCVHXmQFvbteo5i3QWZvxu7EQ1LYNxdeOJjJyuICmYl2
	 avkF2MBSzI1Nj0lI8haVwenkkN+ForKM6lnjPARyvQffy6YAiGbIuXgysS9yWV/fGd
	 mD6VZp6eqMb/g==
Date: Fri, 13 Nov 2026 09:35:10 -1000
Message-ID: <e7facb8344bb662b82266f9f96b7e70e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] dm: fail a REQ_PREFLUSH bio with data when its preflush fails
In-Reply-To: <20261112-dm-flush-data-error-v1-1-c83d3f8f3ac4@samsung.com>
References: <20261112-dm-flush-data-error-v1-1-c83d3f8f3ac4@samsung.com>
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
Content-Transfer-Encoding: 7bit

On Thu, Nov 12, 2026 at 10:35:29AM +0900, Daejun Park wrote:
> For a bio with REQ_PREFLUSH and data, dm core may send an empty flush
> first. If the flush fails, __dm_io_complete() still reissues the bio
> without REQ_PREFLUSH and drops the error. When that write succeeds,
> the XFS log keeps running and fsync() can return 0.
>
> End the bio with the flush error instead of writing the data, as
> blk-mq does.
>
> Fixes: 6a8736d10cb4 ("dm: relax ordering of bio-based flush implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
