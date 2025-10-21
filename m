Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4371C2E6CAD
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039454; cv=none; b=e8D/ZMJj7bqwwEiua3ZzpdclRgAcFyCjxnYpkI0UrFUKwFF+1GjS3wpyptyh+hnJBRjKke30YBbQooBnFOjmPWRjs2xgo11lkOexu/aUV2YbPlgK8cAcOsbqGfZYK1m08d/xWswJCFcVqLN91EV0Sw4rdMbrqtA8hQhU/X/22dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039454; c=relaxed/simple;
	bh=76C7by3F0QB8ZT9Xa7rwEhmtajXEchwx6gzWSh/bRKE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bc8Q4SKFP2Y5BaeFKWcpmhQKyF0KGJmPFCjZ+TDIW4oNEVc1GCWVxNA5UbaoSGC75Tki7ru3z4eHswaOBhRxiLU4mnVaIs6Pzr0LEbxaFqjZHfZsXZZgYLzBQ0ZDUTxRosmeX64hIj6AzbhNwUTWRatAUktq9xgjvqdyG7Eb7qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNmmP6QZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNmmP6QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C64C4CEF5;
	Tue, 21 Oct 2025 09:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761039453;
	bh=76C7by3F0QB8ZT9Xa7rwEhmtajXEchwx6gzWSh/bRKE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=KNmmP6QZAdH+Hn7e871eovdJWVJctlQqNUVYV5HprdP+EcMJXKfwc1qNIDId603uv
	 v8F6bg48SGG4aItS+TLV3UrYNT2uJPpJ7wN0tJ7DDrnew915PQvs2uQK8lEzRMzunC
	 jCxvOZriGA8F2MQeKmddZs7qP4QDwUeWQ5CO/xuR6rI0NU9IxVFLPK+h2/zBQxqVM0
	 VS2d8/LbrtQ62BTgscwav6vgZzmVgaB2hUMMma2BkeC6FuEHSxmm9qT+FeFB63iQy7
	 wYJtUKSAStXZlQSHa+RnCfZPQivG1H5DSi2djkJ+hAoVypOOqxEt4qD/N7NCDYaAx6
	 Rc1u90BfJYkPQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>
In-Reply-To: <20251014041945.760013-1-dlemoal@kernel.org>
References: <20251014041945.760013-1-dlemoal@kernel.org>
Subject: Re: [PATCH v4] xfs: do not tightly pack-write large files
Message-Id: <176103945250.16579.2989044467636536958.b4-ty@kernel.org>
Date: Tue, 21 Oct 2025 11:37:32 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 14 Oct 2025 13:19:45 +0900, Damien Le Moal wrote:
> When using a zoned realtime device, tightly packing of data blocks
> belonging to multiple closed files into the same realtime group (RTG)
> is very efficient at improving write performance. This is especially
> true with SMR HDDs as this can reduce, and even suppress, disk head
> seeks.
> 
> However, such tight packing does not make sense for large files that
> require at least a full RTG. If tight packing placement is applied for
> such files, the VM writeback thread switching between inodes result in
> the large files to be fragmented, thus increasing the garbage collection
> penalty later when the RTG needs to be reclaimed.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: do not tightly pack-write large files
      commit: b00bcb190eef35ae4da3c424b8a72f287e69f650

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

