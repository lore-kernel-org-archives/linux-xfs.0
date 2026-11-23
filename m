Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795464679;
	b=yq5B5HXCf7hROlclCuF1EMW6zyLmugjo7VY2Gm2VQX+53E0KUTAyraHkycc6MIWgQf63
	 K3FabzUiK0WNwUJlsFkRkCC13PDoqBm2cZD4F957O+Rni+GCMMeUD30fP/bQOHZHoObr6
	 cT8rMoTFBmvhU+nKkG1cD0w5v8HpFo6Fi4M3HzUrw7ZAqVZpJMFUr8dHN5g6QQqvntrif
	 zZvPaim/gQRf9/Jnc5LSReEWh412qN9r+e6uIMTv6SOVLMxy32gmFVu9uyG2XR9mfwbOB
	 vKtG9Ra8iqtxgEttR0uQdi9So3m74xKxCdPL7HNFXUm2QT/V7T6PIzYbyhSk1zGvA2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795464679;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=cUgS5Ez3DQQyfb/DT8KDvLNhCT4V2U9xukPp/9ulTh8=;
	b=dCywXiopvSI4qcBkF0rENeUUYlUM7t8LzWbKA4UmD6qcMXSTKNRDpCqwYrA4d9BxcgRb
	 n2Cu7WSXYv3WHquQAUfSv4DPEqN7bkPDsh7cDszTToumkHIu11YYNjLoE3KjtQVQMyi0P
	 3d6JoMWrBgD7cKvtEPj302dTs6n+5L4J7MtAoGSapKzXb+PPfPDqLAmVbFwyX80qr2sPg
	 sZnpAYO6lSeH0q7BxrtXhNzLIuWGKSp9bfGHKAEJ3uphF5EJv0j0BKVBECSq4w5pOv/nQ
	 F9aJoVGH30XBh9oP1ewlVMDZE1Q7sU+InC4jFDMgXqv/ToyTakyFyt7gGvRIejj9NmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ewTVt3Mg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEB7606A31E;
	Mon, 23 Nov 2026 20:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ewTVt3Mg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE9F1F000C0;
	Mon, 23 Nov 2026 20:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795464679;
	bh=cUgS5Ez3DQQyfb/DT8KDvLNhCT4V2U9xukPp/9ulTh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ewTVt3MgXhmHQNiLQm8cgvN8qlk7/CYUuL3r2g5T5uW6YbrsIycxvcprlSIVJEqF0
	 EDS8tWY+xp7m2W6BRW0HybIbAciGr2bBd2P86jM5QydeskRsg1vvT8WXAccoF74+cT
	 vn5kboj1rFjlv2fLNV+N3bOnVs4Um6ZNc5Z0auVDiKxpnobv3f40YMoAEsMZI2k5/3
	 pV2XjvQppiM0xqVJI0yj6Frn5WwtzK+AY5Cb/y7fMwUYokRdTdIXewXbc7r/htIxCD
	 PtsQNgfbrR8dmsjRj7lqVktDCTWvJOIkw1ymavoJEtx55N76V45Ec0IbgMov6pLSAV
	 Njgk69ttvSXbQ==
Date: Tue, 24 Nov 2026 07:11:00 +1100
From: Dave Chinner <dgc@kernel.org>
To: Wayne Gao <Wayne.Gao1@solidigm.com>
Cc: "cem@kernel.org" <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Message-ID: <awSd1JEB0F4WeKt0@dread>
References: <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
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
In-Reply-To: <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>

On Sat, Nov 21, 2026 at 03:47:32PM +0000, Wayne Gao wrote:
> 
> 
> Hardware-capable devices normally prefer hardware atomic writes, making
> it difficult to exercise the software CoW path deterministically without
> changing file layouts or affecting ordinary writes.

Why would we want to do this at runtime on production systems?


....

> The intended use is a controlled comparison of hardware-backed and
> software-backed RWF_ATOMIC writes on the same hardware, without having
> to construct misaligned mappings to trigger fallback. The existing
> DEBUG-only always_cow control also affects ordinary writes, which
> changes the workload being compared.

Ok, so you want it for your test/dev environment, not production?

I thought we could already change the block device characteristics (i.e. support hw
atomic wirite or not) at the block device level? If so, why do we
need this at the fs level? If not, why isn't it the hardware atomic
write behaviour configurable at the bdev level?

i.e. I don't understand why 'unmount; change bdev setting; mount' is
the obvious answer for back-to-back behavioural characterisation on
the same hardware and filesystem with different configurations?

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
