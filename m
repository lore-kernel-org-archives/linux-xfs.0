Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836E22222B7
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 08:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744880145; cv=none; b=cIJFQYSoEFKr4VTKhKkeezwRMBTaD4sLN3tVIOzINh6RhdCpajxnMO+Xbib1d+W54jJye443mZNT9DGzAsgh9rJ3lzrmVNFH5haCwCtwo/LJ7Houvk1esqPGVsBSNQ4Ip5NjxMrUtvi7gGW/8YsqxxA6VlzFq6C7v+9aH4azhuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744880145; c=relaxed/simple;
	bh=3tiScRQCGvkaoyvXTpBsnXNZRvVsHPurDDfspud6R20=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FEMvqSXki5VpTdjftbImOlxZ/sdN+/c1NvT2gEitSLJtLCQEEtZvRQf5gCq4iDjRBqYyeO4y6ufWeQUPJ5Dc3Cm6M+UARQjSy1/LlhpaK3zibpWLimbHiOMka9odeCMEVES58gKm+V4n/kuv/Hafbr/L07fqulihA1TSvpiS+ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3ntwUNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3ntwUNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC2AC4CEE7;
	Thu, 17 Apr 2025 08:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744880144;
	bh=3tiScRQCGvkaoyvXTpBsnXNZRvVsHPurDDfspud6R20=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=X3ntwUNqpzBbdbyFxHJIsTKV1TQCDvShOTsi5kU5SzXt1IeORv759DguNPvX9/tKU
	 3L4HbLbfsVEoKSL3BHmSmMoSBkuXbsG0QgZX58W8XZGdNRL5UdirpebuAbQzCvVlp4
	 +8PRQAgIMnu0hxJk8UeBNDSCiith8nxzdlcv36eHC3jDm+lzAs0g5L77sRFITXFW1C
	 SzHZwQs2F3vL1cC4rNLtHOfvJ9+gwNC03ITt4x68cF1a7nfWNrx3H9tLkXVrs/Y2dV
	 WU5ae0hWorlX77dY9n1V/CCWR68IWvWB/iDe4mbJoWx2db1GiaQd+Pld13U/v/1q7d
	 67Eh/eUDGu83w==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, 
 "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
In-Reply-To: <20250415003345.GF25675@frogsfrogsfrogs>
References: <20250415003345.GF25675@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: fix fsmap for internal zoned devices
Message-Id: <174488014292.437909.3385425658059253049.b4-ty@kernel.org>
Date: Thu, 17 Apr 2025 10:55:42 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 14 Apr 2025 17:33:45 -0700, Darrick J. Wong wrote:
> Filesystems with an internal zoned rt section use xfs_rtblock_t values
> that are relative to the start of the data device.  When fsmap reports
> on internal rt sections, it reports the space used by the data section
> as "OWN_FS".
> 
> Unfortunately, the logic for resuming a query isn't quite right, so
> xfs/273 fails because it stress-tests GETFSMAP with a single-record
> buffer.  If we enter the "report fake space as OWN_FS" block with a
> nonzero key[0].fmr_length, we should add that to key[0].fmr_physical
> and recheck if we still need to emit the fake record.  We should /not/
> just return 0 from the whole function because that prevents all rmap
> record iteration.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix fsmap for internal zoned devices
      commit: c6f1401b1d5fb3b83bd16ba8a0f89a8b1c805993

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

