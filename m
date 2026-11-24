Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795550730;
	b=Fwaj8ClATdfxym7ChiZRFpzcL/2dHdqe7B2SytR5/AMbeLFvYuADB3GevWTUe0Esk6zR
	 g2vUgicA2rOuM5AE2hiW3XkznUjvBaVFjBGgIUJcrDaLluAK6myJtaxXWU8ROFqxs5S/Y
	 k6G25Fh0Yndx+jp5OAyL3Tj5r6yvZa+Tvr7az7QywluN8VJpW9fHAPDUgHWtXYHRZrcT8
	 ia7VwqadVgNA3Pog7yd8AEt0o4suZKvujuPgOklXQnbGpH0FGEwlZX7lt6flU75bhukRp
	 QFY4jBhKsOS15zx0ywpeVzfmoBdhkuiunOn+RUtE54oXyT3MQqCgdrwI4AoMRBU2cyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795550730;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=AyBvgoaflSOYlWmLqE/zHPGUFjIj+qxPBeaaPtkZhDU=;
	b=aC4SQTuqCn+MZ36s4EbM2Hmwy87N0WC0lNGTDP1UtGd1jL8kMPiE6C67+iloaRSoe5LQ
	 yrD8eZZOKIDgZEw4JlsLmGsPAXfpHAL/HVG0bYpCaqDFk1tTAOLNXLmc7RVx4A89sYMp4
	 Us6d7/DvXExYoF1svu5v/hLz32zwW63jNqBYX3ZJ1FHbqugk01Xdgwjg9F7+14WgpfBkJ
	 A6t63zNntDha1eazRb/hyRc13NIQaGALcswD4QfBK/uM0wcNuccUvmxiWLGJclYJI1svq
	 Usg8spt//o3T8dCIKrxYdgysqOuE3iKb5Tve+ZiH64pDvazIzpwn0ky330sXoPrbpvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="MGdCw1/5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F604606A31E;
	Tue, 24 Nov 2026 20:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MGdCw1/5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A9A1F000C6;
	Tue, 24 Nov 2026 20:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795550729;
	bh=AyBvgoaflSOYlWmLqE/zHPGUFjIj+qxPBeaaPtkZhDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MGdCw1/5SZDEJzXkuLyv2kDRKES2MAQQwGlYaOLsnHLOHD1ul4NA0IPaHpTaAuybb
	 gG53L7cYFO/uKp7fqdz3o9svkeK4/js90kSYSMrfk1E8qHD8gScUWkuZmFl/vI44JZ
	 hzfaQSznQaLpx8iwEgZKcyLUUVWrtCPfVlBNPJA9bfQu9/bXI0ry2Jxp+9hVXswdWw
	 zgxptwpsGif3tHzF/ErlHOWKmsGKxIyYRUTS6HzpDeDuqth8zRp7qy2XqQv+eZG1jE
	 VyrgfbZeEvQLLuv92bNgd5IxwxMkzw197uwPfm6jrnsmTEp9B80ppNxEAB9gnWILfe
	 RgzZewqWOKwsA==
Date: Wed, 25 Nov 2026 07:05:20 +1100
From: Dave Chinner <dgc@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: Wayne Gao <Wayne.Gao1@solidigm.com>, "cem@kernel.org" <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
Message-ID: <awXuAESDkLr1nd3n@dread>
References: <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
 <awSd1JEB0F4WeKt0@dread>
 <2a615ca6-3777-4b71-bea6-4072d4fbd950@linux.dev>
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
In-Reply-To: <2a615ca6-3777-4b71-bea6-4072d4fbd950@linux.dev>

On Tue, Nov 24, 2026 at 08:32:56AM +0000, John Garry wrote:
> On 11/23/26 20:11, Dave Chinner wrote:
> > > The intended use is a controlled comparison of hardware-backed and
> > > software-backed RWF_ATOMIC writes on the same hardware, without having
> > > to construct misaligned mappings to trigger fallback. The existing
> > > DEBUG-only always_cow control also affects ordinary writes, which
> > > changes the workload being compared.
> > Ok, so you want it for your test/dev environment, not production?
> > 
> > I thought we could already change the block device characteristics (i.e. support hw
> > atomic wirite or not) at the block device level?
> 
> The block layer just accepts whatever atomic properties is reported by the
> block driver and there is no method in the block layer to change these
> limits or turn them off.

Isn't that a bit of an oversight? Lots of the hardware related IO
capabilities are configurable in the bdev queue (e.g. max io sizes,
max discard/unmap sizes, max queue depth, etc).

Sure, they are initially populated by the hardware values, but the
user can then override them (e.g. via udev rules) and that means we
don't have need to add 'override the <bdev queue property>'
management interfaces to every filesystem that supports those
specific bdev hardware offloads.

> Then for the only block drivers which today support atomic - NVMe and SCSI -
> similarly these we just use the atomic limits reported in the disk.

That seems to be inconsistent with how we manage other hardware
offload size limits on block devices. These are -not- filesystem
properties, and we should not be trying to manage them at the
filesystem level.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
