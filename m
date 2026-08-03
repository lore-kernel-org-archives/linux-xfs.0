Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCD034F497;
	Mon,  3 Aug 2026 13:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763379; cv=none; b=AgKQOdnC83yIR1QwXpMHXyTeNdjK4LpJcB2thb/Sk9kr3fo3f7UggPjeg096cuChuVSQcD3OAgeyvJZ1fl/CyZkLMQmLCTdU9oJ4QF1emViCQpU4lrq9i6J5S4uIL3hJTjRd/aq9hxBquRDOi52pA91eoBbtqaC2gpChDn6eR9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763379; c=relaxed/simple;
	bh=ogNtK8XOvLWCbgR3XO+dHzLLv6b8EgLdUR8FvLA8DMg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AsRqSD1AkDDtXKULg4p/8U8N4tN3ngaD6dyu2Wg84VBYA9of188ihkeR9iOn23e3MnNzHl/pEBAp2mdly3p7ru4VcSBPABb2qeG3hpXlV7Jm4DS0/SqhRCaNhYsDZUCbiK+iXQ5uS50+7KAXorZxA6LlPRd7ogFeldBImzisUNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nPvCjPmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nPvCjPmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706721F00A3A;
	Mon,  3 Aug 2026 13:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785763370;
	bh=YBfLgZWFxN+GlyVIyX/CbhV03uaWctmBi8QzsO39wfc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nPvCjPmI+8UDkrbb4E6nP2cXLh1jkvurUEWChWILHONfkzDPruTJRmklGDXaW1vvq
	 +0x1qyvMmkFE4JPA86U0O+NhKBVtEs2ZjzuiudmIIEr28JI9SaKSuVtV0QmQaeTki/
	 jCp3L06OEkRQGinK7P7O2IKNCTlVjGo4N+bp1jC7Bam6tiW+H9t9xY1RHFzDHXXWtc
	 G9GMeehXu5BvK9xSk/gfExbyNENJV91Bl4UyaY9myqNj/LVA6QrXQUOsZKp6DZ2e0i
	 rOLgwDW91nZ1XXFtBpAuv/ezLqOWpE7UxpTvTBesbDegxFfJ13UEXmXo3FXcR823Hd
	 FJOiahQUS/gKg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Lin Jiapeng <ljp1205831794@gmail.com>
Cc: stable@vger.kernel.org, djwong@kernel.org, hch@lst.de, 
 jiapenglin@tencent.com
In-Reply-To: <20260728071921.81156-1-jiapenglin@tencent.com>
References: <20260728071921.81156-1-jiapenglin@tencent.com>
Subject: Re: [PATCH v3] xfs: fix exchange-range reflink flag clearing issue
 with INO1_WRITTEN
Message-Id: <178576336810.315832.1742029218392868015.b4-ty@kernel.org>
Date: Mon, 03 Aug 2026 15:22:48 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 28 Jul 2026 15:19:10 +0800, Lin Jiapeng wrote:
> When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
> can move the reflink inode flag from the file that currently has it to
> the other file, as long as exactly one side is marked.  This assumes
> that the file contents, and therefore all shared extents, are exchanged.
> 
> That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
> xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
> from file1, so an exchange can complete without moving every mapping
> that the earlier flag-swap decision accounted for.  In that case the
> post-operation cleanup can clear the reflink flag from an inode that
> still owns shared written extents.  Later writes then take the
> non-reflink write path and may update blocks that should still have
> been protected by CoW, which shows up as data corruption between
> reflink-related files.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN
      commit: b2d5a81dae385333f9734910277fbf94c78bd17f

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

