Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4E0233709;
	Wed, 16 Apr 2025 08:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744793127; cv=none; b=ZhEg8u9I345kHBxpD/5cgustLW8hxNeW2Hb7kD0u4ENlGpAnuP/3A48l6EAQ6j1j/9now9ajGEAIlCbzZdTj0tNW5JyOC7zAnKRjORK65nqziLzZDagGlHKbO4a5FjHe4u70jaul6j3e4NmmLncj/NxNWAGQ7Woti8vMnDD2xf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744793127; c=relaxed/simple;
	bh=/tMw4MFQJxenXUlcjgLjfOEVd8C3ZeD+4Z/fOmZuipI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NE7p6ALhRp1yLAkjyueuKjLKqPkSY0jf6/HA2irJYlKebKFcdzUk2stvC0DzGOsk9C7mHpWg6LP0ieojx2qKyWoHAXhwRnQHaAyohWKIxmlcoKhJTF3XtdBmAZrJe1mcgfgJ51djqXpG3FbgjKS2CWARffQBp1Y16Aq5OYZKRR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u+W5qO33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u+W5qO33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382BAC4CEE9;
	Wed, 16 Apr 2025 08:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744793126;
	bh=/tMw4MFQJxenXUlcjgLjfOEVd8C3ZeD+4Z/fOmZuipI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=u+W5qO33cAizx5usKDDg9t5JScxjiWsZy+mtMEHuLz9XMbzAwGCsUlMEvs+zY0Swa
	 nDoljfZW9tqShLxKroe70fLXASgYRpSi7/K9L/dl8skNTStOsofMPR0+HSXqrNQHBt
	 XyKGNLNpY7qCwQLFjZnRoxAf0sW2p6qIObz8gzrRNE8gZSK+JUjaug9ezC9VZ5qp87
	 UgoF1AoUSiFTusE1xre6d1CK5tYHgRxpvroQNRqFdDXDnsjaaAUEO00GChNcuKbylq
	 HVqp7sBoP9jK8pVa12S+oAQkd3F2fRNfEpX4OQByxWXOxNzvM5wI9kc9kBZOSJFKoe
	 ww+HyQb5om0jA==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, long.yunjian@zte.com.cn
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mou.yi@zte.com.cn, zhang.xianwei8@zte.com.cn, 
 ouyang.maochun@zte.com.cn, jiang.xuexin@zte.com.cn, lv.mengzhao@zte.com.cn, 
 xu.lifeng1@zte.com.cn, yang.yang29@zte.com.cn
In-Reply-To: <20250315143216175uf7xlZ4jkOfP5o3oxuM4z@zte.com.cn>
References: <20250315143216175uf7xlZ4jkOfP5o3oxuM4z@zte.com.cn>
Subject: Re: [PATCH v2] xfs: Fix spelling mistake "drity" -> "dirty"
Message-Id: <174479312384.188145.15074148652154459631.b4-ty@kernel.org>
Date: Wed, 16 Apr 2025 10:45:23 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Sat, 15 Mar 2025 14:32:16 +0800, long.yunjian@zte.com.cn wrote:
> There is a spelling mistake in fs/xfs/xfs_log.c. Fix it.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Fix spelling mistake "drity" -> "dirty"
      commit: 1c406526bd84f1e0bd4bb4b50c6eeba0b135765a

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

