Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8629F434E32
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 10:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630699; cv=none; b=LCHcb8Znz9r8y3AyLaororfDjDs/qlk8JLNqp/VaK7oDSqwrr728D61SYsqOh51OAjNqngjpyzjxI0N5VaRtCyaC0gs/8lq3LUn1og44HjzKb+Jko4EOOqB7Uyt6qQVIBIc/OPXKFq1iZS72RGJ0VjiJS7tdqYQblmw9ZZEcVV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630699; c=relaxed/simple;
	bh=PDYuOOfinQbdDLkgdnaYgNJmXGEWnNX61WytvEiEfiI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RAUzzrPbC/MMqQAI22KCzFeA77Ju91jZDhwokoogTLlDWDHTUlNdVIoQfe2NvYQqXChzRPUyVMygZxRh+eQUOV/g1PtSm/kI+T/P7GiovJNUCyWAU7scTKwXsdqI+pJDcNtxFrpb5wJXcIcfnxWcZQ0pH22Ubpsx+Gf5n9nTXEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXgtoG2p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXgtoG2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172141F00A3E;
	Tue, 21 Jul 2026 10:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630685;
	bh=AR34j5E8RIKH+UMDDynVra8foHBV6fukr6M3B6DI+no=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XXgtoG2pWCuSmIEkeDqXWewyFi/jdYKA6stzMxhJa4kUdtJpc7XWOCpEScnBzyRq/
	 WLeXod+Mvh5L5cFLvzVbDYWFwmJCMdA3vB5R5D5ImModC7JpvCgpWaYUSw8pgVjteS
	 CdzjAQymRg/E1fxALY6dB6Sow4Jr4vVA4KnXP/NaznWHwvV+Op6JqQ1b0b8T4VkgVW
	 Dd+VpByWtHXOqz/M/nvJXCk1nJgE9SQsoJSyPIs29K4wTjLfYg2q9DK0b/ZwNtIM2g
	 wwAUU9NRCm93EYQm6hU/qpaya/t0fmm85CfotItgwdNQwmj5BwQ3Nczs65CAWJv5xo
	 gM2v1tuPAn//Q==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
References: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v2 0/4] xfs: consolidate metadir creation code
Message-Id: <178463068379.324722.6480297471571446611.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:43 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 13 Jul 2026 14:42:46 +0200, Johannes Thumshirn wrote:
> The XFS metadata directory tree has grown several nearly identical
> open-coded copies of the "create a metadata inode" sequence: allocate the
> creation transaction, create and link the inode, do a bit of type
> specific inode setup, commit, and finish or tear down the inode on both
> the success and error paths.
> 
> Factor that boilerplate into a single helper, xfs_metadir_create_file(),
> which takes the file mode and an optional callback to finish initializing
> the new inode inside the creation transaction, and convert the existing
> users - xfs_metadir_mkdir(), the quota inodes and the rtgroup inodes -
> over to it.
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: add xfs_metadir_create_file helper
      commit: 9bb976117a1b81504af4389a849d1af5938d7142
[2/4] xfs: create quota metadir inodes using xfs_metadir_create_file
      commit: 6b0b126b05cd50587d77d5b7cf893170719adbe5
[3/4] xfs: create rtgroup metadir inodes using xfs_metadir_create_file
      commit: 4885de0d9a15db65545a7b1cf632797302cfcf3a
[4/4] xfs: mark internal metadir file creation helpers static
      commit: eaef2d68a491dcde0c20cac31f54f2b961909bd7

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

