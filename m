Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EBE43553D;
	Tue, 21 Jul 2026 10:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630707; cv=none; b=DEV2uUHIcPXbee21EO6uRYgqWwcKayJQf16lOnfsGkIMjMpv0hm900IqbgTUlA+eztrN40NiPwp+CI1QonDrQ+03DY5aouDYsA3kBcH7KFNMUCs57il8DYZmy9rBgEpYjMUWRGcY7A25K42R+XIM5+XSYhqVE7eIec+SyDPpaC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630707; c=relaxed/simple;
	bh=YewAkqscRimfnvuK5SyaTK0Oe5wg4d9iDGKk83X2TGI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=O+tOD2dROARfwWI0e4zxOchLEdIPupOtLHpn1B1qiDSZ7ycJV/KvZUyWcCI+TauknfbL5CkgNCbFL0sIksQ5ah6viVyASn1V3SXtCZutm3o7Wjg632mksEFNMKwg3RsEy0/lsFFZnVBj82Hnh/YhBkDObrZJyC0cUNkb3KgCCHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KONPhH1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KONPhH1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70171F0155A;
	Tue, 21 Jul 2026 10:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630689;
	bh=MyHCu3nG3vt9PzFjCiq7D31QBqIFrGwY+RWAPPJh8qY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=KONPhH1fZh+nQpuXMkS2SxkGL/fRy9w3sRlNub6ShvwZCcpi5G04myx/L7pX0oTdJ
	 XQiag+f6Lex/laLO0zv+6VmX2e80mdHSlWQavGENcoy4sIXA3zz4QE4tgJ2NMzX3Rg
	 2+5tle7yeqAk1PVvaoKk/OPOK/837YFePY2A+6B1NmxFTtWG+oLGaQMkfaqKguIkM9
	 pwSFczEd4bY9J3xBK+pt7mW+QUVw/RceP02g/nsd/NFGUaoWiMF0WB1k6vKebEBucq
	 +r4vhNtpxqnm73H00Ip3FWSNr1JrZethnomZsgxfbJm3sASyyUfoPyUYoo5UUP9Nza
	 HvZGiMpkuBWjQ==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>, 
 Cihan Karadag <cihan.cihan@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260716214827.21188-1-cihan.cihan@gmail.com>
References: <20260716214827.21188-1-cihan.cihan@gmail.com>
Subject: Re: [PATCH v2] xfs: use kmalloc_objs() instead of kmalloc() in
 xfs_da_grow_inode_int
Message-Id: <178463068845.324722.5237612936067528088.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:48 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Thu, 16 Jul 2026 15:48:12 -0600, Cihan Karadag wrote:
> Convert open-coded kmalloc() multiplication to the modern kmalloc_objs()
> interface to improve type safety and prevent potential integer
> overflows.
> 
> No functional changes are intended.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int
      commit: 97f34168769238b1fe4412229c99f1a78364f6f9

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

