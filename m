Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716602F8BD3
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039458; cv=none; b=t35nCDKFO4v7RmTAdb8PsYCPojpkDuyge88BuMZBg9q9+YZa3iG9f0lGvew4J7xGCOOOekngawr7KKfQ33UEApw5oAb7C6RcFt1HKmzysrH0E4jqStx5TRViXss9LaqBqGc+0uQ+VWdp/N9lZ31J+WVsEXrMa+qdDF/FZJ7XumM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039458; c=relaxed/simple;
	bh=80Qz7Xev7K/aM6xoRYuCnmYBRuV6GtwOU65kU3hTtBY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MX1S/6xJw+JgvtGSnKHDXaDV+Lzg7qWuevYTKdW2ZBKu85x1cQzh4o5CCdTSLxdijl8YzJdNNUsEbw9Tzv8kOnQoSNceT79shWvLHY1HzbxUnzfLGqOwwJzmi4slDvYIneBokF2LUUhnE2nYpOm/mzdzkk5x/2E4uAMQ5m8zvPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9LaSyQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9LaSyQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECF7C4CEFD;
	Tue, 21 Oct 2025 09:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761039458;
	bh=80Qz7Xev7K/aM6xoRYuCnmYBRuV6GtwOU65kU3hTtBY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=A9LaSyQUHE825eBm6PT6VW4TgVJJKz1S0dm+ryhilyDq295PsAHGjEeDqaMtqKlYb
	 a8pLue3ibooC3BkhmdMyalQrJLTBcyPKaGP/0OFRRjAJFvz43xh4WasIEYEfQbo4Ec
	 ZJKuvK/JZcsbLxYqCYheGjvB6+4qjFJ0XZSf2+7QZpK5H9DATTP/++sOMhyepMlNzR
	 w/WxLDA3KZPKsHROt2wL67tp9q/pgd+jo3BvOg0Hesw7ozj06qk7T7cMfdEbiSeM7l
	 UJ69oD8bC2yJV7UisxN6cgFbb53pzw0ouSHLY5yGgdsWLFtQIL4D42XqXo6RXTcGO9
	 PwEArDmjRKNYg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
In-Reply-To: <20251017035607.652393-1-hch@lst.de>
References: <20251017035607.652393-1-hch@lst.de>
Subject: Re: [PATCH v2] xfs: cache open zone in inode->i_private
Message-Id: <176103945689.16579.11207235697121713316.b4-ty@kernel.org>
Date: Tue, 21 Oct 2025 11:37:36 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 17 Oct 2025 05:55:41 +0200, Christoph Hellwig wrote:
> The MRU cache for open zones is unfortunately still not ideal, as it can
> time out pretty easily when doing heavy I/O to hard disks using up most
> or all open zones.  One option would be to just increase the timeout,
> but while looking into that I realized we're just better off caching it
> indefinitely as there is no real downside to that once we don't hold a
> reference to the cache open zone.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: cache open zone in inode->i_private
      commit: ca3d643a970139f5456f90dd555a0955752d70cb

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

