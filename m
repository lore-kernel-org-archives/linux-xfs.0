Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.203
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795433677;
	b=d/zWpmGCt1bhw+Wuf8eLgcIIDozMXuXiD6Ys62gbnxsI+vuCDtze/dI2mm7C39UZvFTY
	 RzQWMdWso2dMi3a5S8GrTB6aOebnky9hk0OPaFRYDase4XNl5+HuHgpuqS2sriX9N1J6E
	 9xCiTuF2gg8RGtGaeyMZswl9dFbpggosP8CFpaRc3r7nlWgwe5HbM0PFxCYh4VZcA8kPj
	 Vzv0YyLkLNJh/XLwZCxCCgvMzpXU8tv/UXAcnfs+eAT4QzATwGCGLtJTB5OWnsyFXGjwD
	 cUeYiI1/pLybHxYrvyBC0BFH/B0q19T4LXY+SOAjaZOKh/gTqJcsOGMa6i8BxNs+1kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795433677;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=0NW5PHzU8niu/Vyq4xWZ0l8rjf3Rlalc4LXyc2xQlwg=;
	b=Jq03S84TyznybhZSxy4Sq16UrapDXTEGt1xrjq0A05B+tyGA/TrUg+G932fTvrG7Up7a
	 FwZ867Q2QokW/M/NmhJ41JY2pPh5nDLbr2t2RkuhlsZ4BxJRDsAbqZl5Bk+XvNIGmtn1u
	 6NKx2H7ML0yEtVCdzd0Gm9Iy8z7ZBGyV3z5WgpC5vPf+a4/tSeyf8jBj9ELFiBuOD+TGl
	 QfxyB3NAS/wi67HPq7joU3JE7g1Tn0V4bU+NLsUBrHnq49KRtodb6k1ag+2cXqBb8plxh
	 HmFc4AW7FZROlPzMDPBP50eX4Lzi240xeJ3dIcPBsMVaRs9u8hrO8qm33TzKBuJyK9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W1HjE5bz;
	arc=none smtp.remote-ip=95.215.58.203
Received: from mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30A1606A31E
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 11:34:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E30A1606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W1HjE5bz
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oxaCqIVg13ImZ+B7nAeaMCiK0nlxtkXNZVdvJO0RIyc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795433675; v=1; x=1796038475;
 b=W1HjE5bzp1rH8OCW52+xWhhIRSJeMKRMn6cVUnk14tIyopR95KQN/KHY1nNoWzRztc76DvVY
 xYynpAaIyyjGRJG79CvDaaJ+qPr5uGvmc3IbYdYNoZwUZFtL3bYRR3iq1OAoqKgLdwSpLYf35yC
 Eurx2tzpGFpBw64JT8nIvJ+U=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 6f5034aee4cb3981;
	Mon, 23 Nov 2026 11:34:34 +0000
X-Mizu-Trace-ID: 6f5034aee4cb3981
X-Migadu-Flow: FLOW_OUT
Message-ID: <28200e68-464d-45b8-a7c8-c3f239b31841@linux.dev>
Date: Mon, 23 Nov 2026 11:34:32 +0000
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] block: fail short atomic bounce bios in
 bio_iov_iter_bounce_write()
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu>
 <20261120-gratwanderung-wickeln-mitkommen-1fa50bede59a@brauner>
 <20261120164309.GB32683@lst.de>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20261120164309.GB32683@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/26 16:43, Christoph Hellwig wrote:
> On Fri, Nov 20, 2026 at 10:04:37AM +0100, Christian Brauner wrote:
>> No objections per se, I just would like see Christoph take a look first.
> 
> No fucking idea.  As far a I can tell atomic writes are a mess and we
> should not have done them in the first place.  Ask the people who
> create this mess.

For this series, the 2nd patch just removes some duplicated code.

As for the first patch Re. bounce buffering atomic writes, it's a 
another similar check for creating multiple bios for a write. To me, any 
atomic write should be stable and userspace should ensure that. But 
whether bdev_stable_writes() should also check for atomic write 
capability, I am not sure.

> 
> ---end quoted text---

