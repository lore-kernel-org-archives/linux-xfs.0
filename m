Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9563B71B9;
	Thu,  3 Sep 2026 06:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415562; cv=none; b=irLHk0CYl0U3utLxnwfRcU/N/9tAcFvCO+kZjfBUa1jo4dT/ozibyWRCBnI6QZIjuP9Sb3GKFKTN6oA/xOh2odW1sDK6ZeiQd1AOopGQRe7f6vI3dg+W6WesmyCTr2TtbM+qxmFgskH9FaZUHtiHbdefMOEDYUCqyZ9oIB9dnYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415562; c=relaxed/simple;
	bh=8vKxvD5rnsA9Lk5u40COaL8yDrJkiPfkHX8qaIvPwbQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JR59GyJVkuEndSg8E3yV+dHyXXkkbn7TloB7OTaBl7tsn5Dh91iFmZtmep3UtFo1ORfJ7cvve8Yk6bS+jdeIWpglE1rprSbUYMMjwLIz/skfmAgOQ+BIt1V4sJhW7/TEJ3huJ7wmzYXIv914aZzp7y6A7bmCYZJQlx7lETrGI9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPIfoYyZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPIfoYyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFD41F000E9;
	Thu,  3 Sep 2026 06:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415561;
	bh=dGbuKQzCb+UHwOAPHwE1ViHqK+C4Fg3jIdt76aIXTtE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=cPIfoYyZW6NF//rtHPEyX3rn/E7aOumoJoVXn9MVIibiBOO7cVroG4F3YamCpdax1
	 RhsACg7jW73ZeQSUTazJMva1sACyNkfkdtlmERHcMZYaFkmk+dgSBbZx0lL2TjoOLE
	 iEwe4wO98AfOz14PGIJPDzn2+v6LzKtMSKBBSS8M18/WZJQxrOdSsWEZ5I6o0yeD+A
	 i366l8RXuZ0IIV/cwwazmhKCkNHn9RfnEBRSFnM1soQxV2+EpkoeTePXLTCaiRIdNO
	 FfshleO8C7DCNdrTXokVByJOgyRxaJckVJy7x3TC3+EyVxNcKso8mkESXyBWF0J8zn
	 mw1hbDCKiF15A==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Lin Jiapeng <ljp1205831794@gmail.com>
Cc: stable@vger.kernel.org, djwong@kernel.org, hch@lst.de, 
 jiapenglin@tencent.com
In-Reply-To: <20260728071921.81156-1-jiapenglin@tencent.com>
References: <20260728071921.81156-1-jiapenglin@tencent.com>
Subject: Re: [PATCH v3] xfs: fix exchange-range reflink flag clearing issue
 with INO1_WRITTEN
Message-Id: <178841555975.1198521.11635969278161610368.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 08:05:59 +0200
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
      commit: f3772e189ee8e37860c2bb365f6ac3517db937e9

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

