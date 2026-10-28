Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.79.88.28
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793227426;
	b=C/mnrFr1/UnQwyMrd0OVrypcZVWsuMggSYaMGP+EGc5AZLVVnRFp3/0D/7Nh7x33ZKx0
	 vzndEBHvKyb4tWh8PMZ3eslLK1V6P3ROgtakfEiCdH6xFDEo/he8l9OfZEkK6YdxNtMRT
	 3qbxyWMLN/rHojZIpwR6io1/MHE/5WIGrQ0UkNi8rwLwYZYLoYVvrIE6YSOxzLRFkpMjz
	 t+O1QFJWxJ+2NzjWpglSORaGYUgxznPClt/+F7gDI8It1euqO9sg5PZPsMv+Z95PI6udw
	 oAukTUXeMPyl0iULeU7yEBG75SroDfPpeslCvC9iX7AOEDKrnroM5hFjKa5m0ktliEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793227426;
	h=DMARC-Filter:DKIM-Filter:DKIM-Signature:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type;
	bh=j7f5LaVF7LK/0yFyUEEAwY1tZa6hpbG308Dw7fIa7rU=;
	b=GG5b3skJlQ05Z0ruUMlK8d+lVpRg81xkKi9xBY8p9JbP+boCTS53hjZMXh9574vd2IYd
	 ROXOqY//vIE73eCVBWZi4sEPI0G4Mrzoa5Ftss5m62kssEp88rQBROuMsrKUv29yn/4do
	 R4e1+8remhckPbzqK+16EkZQqQBG38xqrnvSTnfS+4OU5fr6mjnMQcShWiwd1PrW9ZKTb
	 iV4WLLe8MILPAF3gV3PMjGbxIx2/1krePcbyIMgm/m5YN9Ak8LgIayjdtX+arrMQYTMxk
	 M9I5XivUbQgnh7rSzrK04TasfA9s0TkQf83SbuJ5/F54D1sfkbJPqnkw4dshmTvtTfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lwn.net;
	spf=pass smtp.mailfrom=lwn.net;
	dkim=pass header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=Ay00vNkW;
	arc=none smtp.remote-ip=45.79.88.28
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F55606A31D;
	Wed, 28 Oct 2026 22:43:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77F55606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=Ay00vNkW
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 7796F40917
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1793227418; bh=j7f5LaVF7LK/0yFyUEEAwY1tZa6hpbG308Dw7fIa7rU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Ay00vNkWXKz/a3v3C1SmUHLS84UNrjr4dRFLPEW3FqSxgzSVfZeLjC304WIpKE+Z5
	 89/gK5bA2fv5Gz0y2UNlEQyIIZCdSSdAHbUkMJYINODdA/K1n/ECaIDInGCKcYJsQm
	 O8BqhYWmUXSilPiFwryHObnT8gJmbibI9NOUH3wVIMHtYAMIjYw93piYHin6l9XMBJ
	 LMAKyA7hhagBl9uEJghH/ERSQ67ywfxJ7C6U9/k4HhuNDCrdAtr5olDleUYAB/rMmB
	 bA14CqPnxfZ5BXQGKg1JWjdTssLlG7GBKJY9AFshXjHxmZWYoyUwOZgtDDO18I8qpo
	 PChgw6IN07bWg==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 7796F40917;
	Wed, 28 Oct 2026 22:43:38 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Dave Chinner <dgc@kernel.org>, Henry Martin <bsdhenrymartin@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "Darrick J . Wong" <djwong@kernel.org>, Alex
 Deucher <alexander.deucher@amd.com>, David Hildenbrand <david@kernel.org>,
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Kairui Song
 <kasong@tencent.com>, Myeonghun Pak <mhun512@gmail.com>, Rafal Ostrowski
 <rafal.ostrowski@amd.com>, Likun Gao <Likun.Gao@amd.com>, James Clark
 <james.clark@linaro.org>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix out-of-bounds write from crafted btree root
 numrecs during log recovery
In-Reply-To: <auJ2jgIIh8e_JJwn@dread>
References: <20261027151703.973392-1-bsdhenrymartin@gmail.com>
 <auJ2jgIIh8e_JJwn@dread>
Date: Wed, 28 Oct 2026 16:43:37 -0600
Message-ID: <87cxsto38m.fsf@trenco.lwn.net>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Dave Chinner <dgc@kernel.org> writes:

> Unless you know how to fix the discovered problem correctly, don't
> send what your LLM proposed for review. It will be garbage, and all
> that will do is annoy whoever has to review it. Just report the bug,
> let the subsystem developers fix it.

Just to be obnoxious...this runs counter to the advice we have in
Documentation/process/security-bugs.rst, where reporters are requested
to include a proposed fix as well.  It seems we're sending a bit of a
mixed message...

jon
