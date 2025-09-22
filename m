Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA4830597C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 12:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758544919; cv=none; b=sNZDISenNSZbY1RvxLPa646B4zSXH9KD/+UygC4rh/b/rxqG+mIaEVt7E0Xuf1zvgpnB7rwQ1OhJ5yi7FyF9QyjRDAMVyxOdL/wmPOhSGXd7thIs4w9JNulqiYrmBLxOwBwfhMNSXYm7WdpDGIC62uNrzkU3JVaNa3xRIJgueDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758544919; c=relaxed/simple;
	bh=jh8OFfPDqK4rKysJGsmM0BoPBFxsCM3oB4zgKfISl1g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NIKCNLkyFDvBCNRqZ9EKpnW1BogHVrRg4vxo1XrbhdaLHdyaJqDJy/e9X+ybZOTRUViZe4J+Z+dzpd1YhLbGsUXJj8jtcdxjan8kWO0rsMgdsbM6P/EWPTyKGTzZEL3HCBm9/TQGu9FrXgFVk7m9Hrs8yODMW3JTOeHDjDOicQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jCbO3vho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jCbO3vho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6972BC4CEF0;
	Mon, 22 Sep 2025 12:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758544919;
	bh=jh8OFfPDqK4rKysJGsmM0BoPBFxsCM3oB4zgKfISl1g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=jCbO3vho+IEnpvTwcIcphvR03+HTFpwFu3hsozWm1DRmsNsB8djDzY0W22yaPLVpe
	 aPItd4gAmjFHIfPdN7uVjW7TFsi1q6DR5O0tNGYkwMVUprIrgW8WEEdRk0/0vkFbfB
	 /kpMgya+FKHHgvx4KFrkvd23svj7+y1ragdXTsdegegntfTujIZJ7lc7EUXICpLqYs
	 Nef/at+Y8lVaKXpwsH3rPvI4NGI6EsfcZ4ISsAdYISgeU4bdHieVhT7gmeRyqEfA5E
	 ODvCx0azX6hjnHyj0dtoG2yFIrSB/LwS0kn1hwn4F5/lss/ht9E04UexRIUt4t7fAH
	 WZIiT4hsVUnJQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20250919131222.802840-1-hch@lst.de>
References: <20250919131222.802840-1-hch@lst.de>
Subject: Re: store the buftarg size in the buftarg v4
Message-Id: <175854491813.13267.6502278047906882071.b4-ty@kernel.org>
Date: Mon, 22 Sep 2025 14:41:58 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 19 Sep 2025 06:12:07 -0700, Christoph Hellwig wrote:
> when playing around with new code that stores more than the current
> superblock in block zero of the RT device I ran into the assert in
> xfs_buf_map_verify that checks that a buffer is withing sb_dblocks.
> 
> That check is obviously incorrect for targets that are not the main data
> device, but unlike to hit in practice as the log buftarg doesn't store
> any cached buffers, the RT device currently only one for block 0, and
> the in-memory buftargs better don't grow larger than the data device.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: track the number of blocks in each buftarg
      commit: 42852fe57c6d2a0abb10429841cb1226b7186b7a
[2/2] xfs: use bt_nr_sectors in xfs_dax_translate_range
      commit: 6ef2175fce30ccab80d519f2afcc93d8b138c16c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

