Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793625239;
	b=IHhogA2kB1tjI2deqBdNmmMSIP4r8FTi6o9yclPSmnmt5grsa9uh6/cBIMVhRC72Ld7Z
	 AuZrVuyucWkaDNVFoO47ZX8iRGyaduTt8NUHjsG017sgWZ3PYZF0P2UA9iI7PC8DteISa
	 vXgzCz6a7JiEeJKPC7hunrMqm8pxFHxWE7Zss7njFqvfZHH20dwzDDEDDmjOeUPnz9ab9
	 0rgyvownkLymcMJLapbBra94VfIcP76qg8wZ5QfgNgm7Y9aGr0WWm9cjcasQ4aU2YYy1p
	 vatQJRTesC5Ty4JxW9cS+OLyycTMJW6xucCGzlc8rVmzapmnCK7PrEo5c0JwIJ8EeKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793625239;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5KHNYldQCn3+TzmUg4SuvUTUVFYh8/grfQ1oBji587g=;
	b=Q4GV423/Ki6nw66Ih0y75POlUU1sh8ds8ZqLvajNogC8kkNxRaDKjfqnJIo1LXLHH4Bo
	 e/Y2JRLgT0e3ebJex8yxHTqBb0FE7IHPKKDosIe4PgbjhsDlCmpQXY7N8FlOp8KDIe1vc
	 LviLcLHWAu/Voa5SLo2TpT8OzIa8A0g2nKDIberQPjTl4SVi5Zo50ZgaOnmV5UqHWvGwJ
	 b0VXXcgGyaBWa1Fe9CmgTHosrkX4zDDcbU5td1tOX1awLVmKs/vGa9sPBotYT6hhQf4O/
	 lwW44aF1VkJnBQw4TN1lFHupAXAbhhD40aQq1oXWlEld9GFbdg6rk37usNksySqlaaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DbTrKabH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9325B606A32C
	for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2026 13:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DbTrKabH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480F31F00A16;
	Mon,  2 Nov 2026 13:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793625239;
	bh=5KHNYldQCn3+TzmUg4SuvUTUVFYh8/grfQ1oBji587g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DbTrKabHrV6zMO4fevmZvH1VHx0kLg3d1zJsZHkoy4AFr7kGxgbbBYrczyfjCWVpX
	 FiDqHmxbUBtsd0CQuTWLic4tPSZ2QUSwPZPAh7dqhveDJtKx//1hfia0ySIkborS0B
	 dYrB3GODdiJ2nDNWG/HM7yYR6Y4ZjHsz6vKSIsXnQAOCY8ZyGDqZ4Bmmv5CFZdhOzK
	 0MarQqy0JFmcQyJYJ9J94HRSK0b6zqwMM/h3V4JtVngMcOAl/a3jqwlIa8375wh4a5
	 tmYi3W7J2oqX3mGaJDJlr3nR2OulpIX22FYCltdRjkC5cyWW8pl7aDxhD8w48ChdmC
	 yqzg0iXP0nEWg==
Date: Mon, 2 Nov 2026 14:13:55 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 0/2] xfsprogs: warning fix and add stack usage to
 gitignore
Message-ID: <auiMjLAjHMQDisLL@nidhogg.toxiclabs.cc>
References: <20261029161027.1213438-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029161027.1213438-1-aalbersh@kernel.org>

On Thu, Oct 29, 2026 at 05:10:21PM +0100, Andrey Albershteyn wrote:
> Hi folks,
> 
> One last fix for a warning to make it compile under gcc16 and all these
> new warnings enabled. And a gitignore update with stack usage files.
> 
> Andrey Albershteyn (2):
>   xfs: fix two warnings in xfs_alloc.c
>   xfsprogs: add gcc generated stack usage files to gitignore
> 
>  .gitignore                     | 1 +
>  libxfs/stubs/xfs_extent_busy.h | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)

For the series:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> -- 
> 2.54.0
> 
> 
