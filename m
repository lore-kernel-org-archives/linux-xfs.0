Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16AF3AD51C;
	Mon,  7 Sep 2026 06:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762588; cv=none; b=BcNh5fXpD8bA2qx1HC4RfQ8wFZ3GM4Nhgp08uc0XNkR0j6ReTkQ7ZWpVwBpy7SRw5VYg8rG8lKMQWzMBJ0OaFRrvwOsSUJwjT+OvHtR0WLkxLfqr58Ok0gksY7hX8AMFxAhA6/zq44LIZeYncmu5nKQy8eG6EmgAi8RNBQwVqxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762588; c=relaxed/simple;
	bh=92aS2JVj2WCP3bJ63sBBIHqJ6YzxUekGCGJYcP7FTwo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XOpmu7hEmvD7loEiIAD7Ivt5/O8Iw+FfFRiSwHy06dQNDNG5m+46iRJgOmQZoBzBOtxFOABarVIH+UjangNInPxQD4Ii+cE+Pckdp56EuFOa/Cm2mfSgn7itXgeJa0TAfR7dETwvSbYdAfV1rLri1e2kgu1NyWtG8MdSPYYqkKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K574PG8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K574PG8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3E51F00A3A;
	Mon,  7 Sep 2026 06:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762584;
	bh=fw8ypknTzLo6jPDG95s/6ciNxFyyzM2hZ1lVq+cMeYM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=K574PG8DCWPRJ1H8VzpW+Auu+X1MO16D+0aKyfZDYj58ec3cg5dufvDuQH1c0xCE2
	 BVCNxdu3/3s1KBXIIyPuIQHcLYVMkFg6eD6Mw1/HxZaF26YsCOjRq7Ofk6TqdE8i11
	 QIODS6JiAjolONs3/VJes4mjxzJ6gRQRXJ69ExdwNpX/MM54OoSMu0ebLFCl59vVEA
	 FAkDbkgHX7GiDpc4d10ueixO83AOojAoCz82jtabin5bk1/lEXJ6l/Q3MCaw1XNQvT
	 BAtQA38OHidFknijvhBoS7wRUXcyfVVudEGcHn/fpDYcUwN8VE4ZMBrhqGud4QvvYa
	 71RyGGArP++iw==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET 5/5] xfs: LLM-inspired bug fixes, part 9
Message-Id: <178876258287.14765.11930057200494595336.b4-ty@kernel.org>
Date: Mon, 07 Sep 2026 08:29:42 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 01 Sep 2026 22:41:54 -0700, Darrick J. Wong wrote:
> Here's a ninth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[1/5] xfs: signal inode btree xref error if get_rec returns an error
      commit: 8c71ad4d4f3e20c30b663bd292526fcbc4d3913f
[2/5] xfs: truncate quota file correctly when repairing quota file
      commit: 0fc67528f54bb91dac22093749b425207c0fc245
[3/5] xfs: compute dquot checksum after resetting dd_lsn in repair
      commit: de20f7014917d661afc03d9a1c157d0ae2775b49
[3/5] xfs: compute dquot checksum after resetting dd_lsn in repair
      commit: de20f7014917d661afc03d9a1c157d0ae2775b49
[5/5] xfs: fix backwards mergeability logic in refcount scrubber
      commit: e8b01aaafffe6b852325debdf1ef4b13ccea1cd7

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

