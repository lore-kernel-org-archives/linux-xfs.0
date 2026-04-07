Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDEA3B6BF9
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 13:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569099; cv=none; b=FOjAAah+rdQJI4vsM3rZ+8JZo51Bjqg3d3Q99sGWYz7RvnQlnQFpp8I9/dOBCgffySGvC6rQciPiCMecKrQOB2cXnhDe8mLBGc1JJRXaSFAK1YzOT5FXGGo90F0HzHjivMxJN0xdRYRDfrwTOa+xLDTncrnrmPJsfLxPBp77K90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569099; c=relaxed/simple;
	bh=5Oj22xd9k0JTJA1BPPjKX9gAol6YRYv/Njw/e0LXLGQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rPIqVVk8gIE1fRUlZzU0KiRviI+OgZLGSgjuANl8Oe8Kgz6xyj3PbRpxFwT4srKrs48y8LsOpT4TZgBgYek+9VzbERkU1cHialdcChVKCBIeNOOXI+t/d6BQwowv0GYwj/rc7CVA0/xV17K3b36WhsVSNeV2MCNpdemBFGJktyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNmFdZju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNmFdZju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3021AC116C6;
	Tue,  7 Apr 2026 13:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775569099;
	bh=5Oj22xd9k0JTJA1BPPjKX9gAol6YRYv/Njw/e0LXLGQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=fNmFdZjum1zs9+Mu9GnRkcJsLgvZQLDzgBfHdGYA3zNOE+lwsNXYozBovLcguHAe8
	 wcGDU+wQCEh0ti+tCTHL7WNyOwveCnZRLphoc1CoiKiMQZ2TkKG/++qb4T9J5kSe1e
	 uda5sQlFUBqBUxxYPC/Vy1P+XC2SHs2wZiiUhZOJ/clUAEwsM4dJokuy/aGB/INrkR
	 5eQhhno9EGMqt2f+mQN1zbsjKs6EIF4mbjIZC4Wx91G5Ni3EwELvJocLm2aNfGmw0w
	 ZDG4u2lMBzFjhdhpTfRJR8mH5V4EwbqM8eoa7DlzUeVXWEnP24kgMlPcT1wLa31m0n
	 STzS9ADjS1MMA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
 Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20260331152617.4047908-1-hch@lst.de>
References: <20260331152617.4047908-1-hch@lst.de>
Subject: Re: fix handling of too many open zones at mount time v2
Message-Id: <177556909790.105112.12314275496041263630.b4-ty@kernel.org>
Date: Tue, 07 Apr 2026 15:38:17 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 31 Mar 2026 17:26:04 +0200, Christoph Hellwig wrote:
> because there is no actual write pointer when running the zoned allocator
> on conventional devices or zones, we can see spurious extra open zones
> when the last blocks in a written zone have been invalidated.  This
> series adds code to handle that case and remove these spurious extra
> zones.  It also fixes up the mountinfo code for open zones to be
> more easy to parse, and adds a new sysfs file reporting the currently
> open zones, which makes it easier to use the value in tests.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: refactor xfs_mount_zones
      commit: 02367990bdcbeabb0ffd3e8e227e5f79a04186fc
[2/2] xfs: handle too many open zones when mounting
      commit: c6584888864e36d6225a6c16d8c39fd2aa9a45d8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

