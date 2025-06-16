Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98A51F4CA9
	for <linux-xfs@vger.kernel.org>; Mon, 16 Jun 2025 07:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750060424; cv=none; b=t+56MI5eWGkpMVbQ8EpWTtTtHMes9FMids2y+OSqPZ4pIaXmJPTUMV4QFT7OpEZX5171HxC52Mu6m4ICOjLcPVjAvKcW/M8euruNdSPIuW652dq34YmOXTQbK25GL4iOnVI4zLTiWjEu3V4GbLPNhMjIfitdHC/cWCtUHfdVj6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750060424; c=relaxed/simple;
	bh=dew0sXhXhtXPNyoQaNhVczozovQjKzIvN4zdkRo9hqE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oL48WrfeLF0hecav41NvKk5QCs8iMANfBm2IlpkMOt1W7QoJAanAxcZlfC91tY4mvR6t/9H3j0itewpdCeqbhcKuf/etOS5kS+SCxi9EzyK9a95ihOGO8kinu/0G9rpNaObXUnu/LmBvGFtZuY/kIfEp+05pslWMfGF7mhrB6SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oCcd3PoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oCcd3PoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B2EC4CEEA
	for <linux-xfs@vger.kernel.org>; Mon, 16 Jun 2025 07:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750060424;
	bh=dew0sXhXhtXPNyoQaNhVczozovQjKzIvN4zdkRo9hqE=;
	h=Date:From:To:Subject:From;
	b=oCcd3PoMV7zjAW32hEkTHRi4SWbJC3f7P9W+P2ULwx2wCwEfFKjvzrOAYCqXcR/B+
	 AvS4WMTXFIUB7UeM0GcepdJPTbcdjpOivXpBP6cfFBNNPVJRqOhcUm/AaN18wtiMCg
	 1Huwnm7hC2Cy8J6TUx8PH6vHsAzwLkV7jW0N2UIP1KPlqs0Uujksm6PvnZnpp62pLj
	 32QooBK1aGrBb2bFq0k0DTxX53PH0sc0Nh261sU+H/bef1Kv9dfQS1dAJtmdIsoRE0
	 nj+UzM9al9xfSjNM7gAir56+SODeCy4kBaTfTxkzt7n0Nh5uaEGd93VibPsJi4u6G+
	 cY971evn6Lw2A==
Date: Mon, 16 Jun 2025 09:53:40 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to e04c78d86a96
Message-ID: <p4nfmahgxypnejn2rmge52ujiyavo7pboolljqell33kdlyux3@2s6lntpsbwih>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

This just resets for-next to Linux 6.16-rc2, so I can start pulling patches for
this cycle. There are no xfs patches being added here.

New Head:

e04c78d86a96 Linux 6.16-rc2
