Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541922DAFC4
	for <linux-xfs@vger.kernel.org>; Tue,  8 Jul 2025 12:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751976023; cv=none; b=BlbB4/vuP4JwTJ1v+An+TCUh4sawwtq5rAWPaedvC9cV5DZmOGnz2UAAjgpHkb4W0XzElPiNMVtPrJxhWo5q9llcre8X8UW1Wz6gQo4EC2OLL1T0rDhbHq3btirTc9fkgkI7WPvpYB0NXl848ETZP2w4w5pEIlSsQ6lYhFnMTGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751976023; c=relaxed/simple;
	bh=q0p0ivii7mVxFiue5YzeEIy8lxJoI4OrmyMgRs82vZ4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MzhoEAVLAwcAPKEzskbRt/Z3f2MR2Ts5Vk4gAkNjAe+sHc9kSpoBqMqB/R6RqUBV+fciVM1yMXjffuUTCz1Y9GbNzDQ1Zl00dUDIX5NSY5FovFxSxKxPvm29AFWX4o/wROR/z9QpZyPHCnPSUwbhkNN/ebiJ5yHLUFaAAXkrUYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgyGX6+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgyGX6+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB00EC4CEF0;
	Tue,  8 Jul 2025 12:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751976022;
	bh=q0p0ivii7mVxFiue5YzeEIy8lxJoI4OrmyMgRs82vZ4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=QgyGX6+xs5Jdv82CMuNzybcMH6QzvFw+/jCu22gcbZIp5VAqDiMHTvC/lt3ZknDM7
	 t8GSKvo5QHLuqmm8+Y9Wr/aUnbfdRljxMkvxVUA+rd3cz/YUptOrQigWF42c8wvUhO
	 dybw94JLVvfr9mBxHQ7dOpdigFssl8CukE3FwPpBBsc46oZmK+Ta9rJ2qn2rliAzmQ
	 UP9/+GbbyH67MR4MVXLT2VuXDwV5g4HBfQyIw/TkCOLIkCwMI3EggFaE6ePdmg0jI+
	 9VdjQrhL1x3Q14rsaLp90MWH7x1s/vF78xSaBD5Eq19ihuzmx/d+a1DqSJ8mUenYr5
	 IlFwI1gas8+uQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.g.garry@oracle.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20250707125323.3022719-1-hch@lst.de>
References: <20250707125323.3022719-1-hch@lst.de>
Subject: Re: misc cleanups v3
Message-Id: <175197602154.1155040.8638602749384585019.b4-ty@kernel.org>
Date: Tue, 08 Jul 2025 14:00:21 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 07 Jul 2025 14:53:11 +0200, Christoph Hellwig wrote:
> this series has a bunch of cleanups, mostly around the mount code and
> triggered by various recent changes in the area.
> 
> Changes since v2:
>  - drop a now obsolete comment
>  - fix a commit message typo
>  - drop the previously last patch
> 
> [...]

Applied to for-next, thanks!

[1/5] xfs: clean up the initial read logic in xfs_readsb
      commit: a578a8efa707cc99c22960e86e5b9eaeeda97c5e
[2/5] xfs: remove the call to sync_blockdev in xfs_configure_buftarg
      commit: d9b1e348cff7ed13e30886de7a72e1fa0e235863
[3/5] xfs: add a xfs_group_type_buftarg helper
      commit: e74d1fa6a7d738c009a1dc7d739e64000c0d3d33
[4/5] xfs: refactor xfs_calc_atomic_write_unit_max
      commit: e4a7a3f9b24336059c782eaa7ed5ef88a614a1cf
[5/5] xfs: rename the bt_bdev_* buftarg fields
      commit: 988a16827582dfb9256d22f74cb363f41f090c90
[6/6] xfs: remove the bt_bdev_file buftarg field
      commit: 9b027aa3e8c44ea826fab1928f5d02a186ff1536

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

