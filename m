Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2549D199385;
	Wed, 21 Jan 2026 12:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998118; cv=none; b=Rk+VVrhkfwr0PEU1lIqmZC92sMqCORPdbjBB/ogUPkM9JMOdMAK43J+pBTLuM5M/UYPYJBLAZGanzPtXMLNDOVfk7iCNx/AWlcaVJOqi+VG0B55VFUUXcF430oFHIVayjp3VDYJZV/Uj8FBqLusSVqKS49IKTAx8bCaSTfTu2yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998118; c=relaxed/simple;
	bh=uAoexXlStnKJ6Ucj7FIagodxFTAoMSySrT/B9piab1U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mtzbqxUhCGfbKbQGtl6Td3ThPYTCnciYnzqp2mgewQsPaMqZXntR2kq13waNxXRleNfg4Ky66Y0po2TQV2QuKrOOwUvh+VGYmIbr8AEGOS5NDOPfMgPKKU8LQ673/GkW92LliY/8QMDDxc4Oe8FobA8V8aryn6Sx5wqId75LjW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZK1D4ksh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZK1D4ksh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8B1C116D0;
	Wed, 21 Jan 2026 12:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998117;
	bh=uAoexXlStnKJ6Ucj7FIagodxFTAoMSySrT/B9piab1U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ZK1D4kshikxSph7pV6IC/3hh7jvWlXldnwo7fpmYCgO/o+iOamiapY5Con8dtaEEx
	 Wc/4/eBfkA6UY4v++D1w+07vAc0ZSmbrWMQ4Szuftp/YKVZa/IBKPZoB384DBTlWA8
	 p251o8C1Ty+DebyjoItpt7cSV7PYTrXHTBlyAnCi3EVsVFhgm7pTasfT0a6gQ38Zf7
	 2fUkjvJ0uYVwJGbeZkUETh6nrc7wqHZb7uN+tLyka0/oDG6X0ibmGpvFkOOn9OUSYC
	 sqj8DDKY4eSWrr4ut1Xd0bPe10fjLEBqLdWegLEG4POH/PIaDeqk+dldDe9pr8IU/O
	 TUlbc6SzLqMvQ==
From: Carlos Maiolino <cem@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
 Hans Holmberg <hans.holmberg@wdc.com>, Keith Busch <kbusch@kernel.org>, 
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260114130651.3439765-1-hch@lst.de>
References: <20260114130651.3439765-1-hch@lst.de>
Subject: Re: improve zoned XFS GC buffer management v4
Message-Id: <176899811589.852468.8217537567492644435.b4-ty@kernel.org>
Date: Wed, 21 Jan 2026 13:21:55 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 14 Jan 2026 14:06:40 +0100, Christoph Hellwig wrote:
> the zoned XFS GC code currently uses a weird bank switching strategy to
> manage the scratch buffer.  The reason for that was that I/O could be
> proceed out of order in the early days, but that actually changed before
> the code was upstreamed to avoid fragmentation.  This replaced the logic
> with a simple ring buffer, which makes the buffer space utilization much
> more efficient.
> 
> [...]

Applied to for-next, thanks!

[1/3] block: add a bio_reuse helper
      commit: 7ca44303f9f6160a2f87ae3d5d2326d9127cd61c
[2/3] xfs: use bio_reuse in the zone GC code
      commit: 0506d32f7c52e41f6e8db7c337e0ce6374c6ffbb
[3/3] xfs: rework zone GC buffer management
      commit: 102f444b57b35e41b04a5c8192fcdacb467c9161

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

