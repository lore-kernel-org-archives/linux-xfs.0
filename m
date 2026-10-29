Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793241394;
	b=YklPWhPgUyGca3dlVfhKRIEo2kFfurNmBscw/nOH+CR0+xgN4JlmqVpIYt8S/m4MTveX
	 8NqH9lu6eq3GjMDBTeaPIAm2bEPU46TibsBwlVkLftji+ywiAfPxEe9g1dCNozfaWbUpw
	 ppEtHZgqBaCKfWRjhA6UOo8k60/3B4fIWzvpYR5UgpAkTOPLM6Q0gIVP7P60BMp1VjBbT
	 oMsxu/JFSu5FwXtp47R7+Hwjd/h1WakPL4Ee+9GJTxOwSenzmuxKhBjwyRfX477YGK68V
	 4iTybOTnFp+l6l+bJ1baVWzBcuaQRzCvhNVGUQXRlZBnw3o06lto9PFxxOqt3bCBX8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793241394;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=+xhRwd9MYDt0tvkIhIFVmiSdsV4hM76bGb1xq49PgPM=;
	b=GB/iJCi3SzMHhwryt7BHw5P8OkxIBFPrsswpdLf+hxSIZP0dy+QcTYWTYfq2IexDXdN8
	 VQ1qVypd00gkfkXwc5SgiGn1G8vBMZnM6/vV8NnTO9klhBqXXPiBx7b66XBb9hCXx59n5
	 1OrKHEAltUV2j+jMa2S82bZtU8R0RYtQS0L75cU1SZiLtniYO8Fq4CmNpG7fZ41ITYVV/
	 u7AqnKnOlfYKe+5wJ6xKL1gFjTGhU9QtWbltIf3s/13sPJ+pzWVI5m6ZokoHd8n4aFQN8
	 XTh0ui0KuMDV3fPDNbP1SpSKxhB6gPCYCL0PJyUb7SZxefb85uVopsHmBoP1gL9/GBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=T+lWHQea;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E737606A321
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 02:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E737606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=T+lWHQea
Received: from macsyma.thunk.org ([12.0.67.227])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69T2Z4lO004165
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Oct 2026 22:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1793241310; bh=+xhRwd9MYDt0tvkIhIFVmiSdsV4hM76bGb1xq49PgPM=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=T+lWHQeaP1i9hnr8/s6uca+jUyjj3dYJXNKhCJwzn78rfUH5i2+M8Pbom5196uFpQ
	 BK0u2a4IBX0n8ozAmgZn7zcNt3oZWLx/o5giEtDseaXQ5Y2viiNQ22+o0IKr518xb5
	 6neQS2gJFgHFcctSVZxZmYNxN1uITIWTHuRhjzwmDsAiEDDPvAvELLulKtYAt5dy/W
	 mRPuSs9SeGMSHjVpooDDE1FvBCfic5lx4cJAqLiz3an+ERShuLelFV+uRlMeHfTuVu
	 4+0R2Fstuup6LAKFbe9TMImzozdmhzHjzq9jXWbhShRDD+z2j4pHGpFr66qzGSBVa7
	 BIRmhFXCSz3jw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A253A237A5BD; Wed, 28 Oct 2026 22:35:03 -0400 (EDT)
Date: Wed, 28 Oct 2026 22:35:03 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Dave Chinner <dgc@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Henry Martin <bsdhenrymartin@gmail.com>,
        Carlos Maiolino <cem@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Hildenbrand <david@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Kairui Song <kasong@tencent.com>, Myeonghun Pak <mhun512@gmail.com>,
        Rafal Ostrowski <rafal.ostrowski@amd.com>,
        Likun Gao <Likun.Gao@amd.com>, James Clark <james.clark@linaro.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix out-of-bounds write from crafted btree root
 numrecs during log recovery
Message-ID: <auKuGGDHTxhCDJSY@mit.edu>
References: <20261027151703.973392-1-bsdhenrymartin@gmail.com>
 <auJ2jgIIh8e_JJwn@dread>
 <87cxsto38m.fsf@trenco.lwn.net>
 <auKGlGJwOSZpioMd@dread>
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
In-Reply-To: <auKGlGJwOSZpioMd@dread>

On Thu, Oct 29, 2026 at 10:34:44AM -0500, Dave Chinner wrote:
> These aren't security bugs. Bugs that result from maliciously
> corrupted filesystem images (i.e. fuzzed) are explicitly stated as
> not covered by the kernel security threat models. IOWs, they are
> just -bugs-, and bugs that just don't ever happen in the real world.

Well, there are people/companies who might be silly/stupid enough to
think that containers are a real security isolation layer[1], and who
think that they can let random users mount untrusted file systems in a
container, and not have to worry about one company gaining access to
PII belonging to another company because both companies are using a
particular cloud hosting provider which uses containers and allows
their customers to mount file systems as (container) root, with
multiple customers sharing the some physical host.

As Dave has said, *all* of the file system maintainers have explicitly
disclaimed this security model; from our perspective the block device
is inside the trusted computing base (TCB), and if someone wants to
dedicaste one or more full-time engineers to be file system developers
who have contributed a large number of improvements to the file
system, and who understand the context that they can competently drive
LLM's to create architecturally sound patches, I *might* be willing to
change my stance for ext4.  But those hosting providers' engineers
would have do most of the work to try to make this security model work
--- and it might be that using fuse2fs, and running that fuse server
in a sandbox (e.g. seccomp-bpf, etc.) might be a much simpler /
cheaper solution in the end.

Cheers,

					- Ted

[1] There's a *reason* why Google Kubernetes Engine (GKE) uses VM's
and not containers as a security isolation layer.  :-)
