Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.35.52.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795727942;
	b=oYPrapbKDjPq9Bs2yrDbRR82gQrQdMSeE/fDdNaO2FPk6VsoKbcWgITey8A8yDbVh/vz
	 JZXuWvosS/45BFztE9gBCXU4ECA5CVJh0upKhLIwpiSIbBGFA8RK+aJriiVAx4UMHcqwp
	 Rt9sATccbIw0I6eFeE7MjxlMmg4himtqpk8qvCXTNkVEz9kTcV6QMplRnQF0qxg+Bnsnt
	 ReeU4d8+lgMEn/RNYjk7ZQjJBAVhEXTT4GBNZdnNScXCZ2nLhNvM4gW3UPJYu633Z5yhW
	 UdKf/JTC35vbxHOCJ7P2NOmGVSQj1bgtcnvI7koKbQgaTpc2yTuU367+5HCKSen8dUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795727942;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:X-Operating-System:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=REynGEJVKcai/er1r3FuItLRjMzRv2/rC0nPKDdH8KA=;
	b=D5mkf2FGnaCCEuFmxanQLVCIuSikc1GquadiRv7kU6UXBA9pyUJ7psw688OJyoty7rpP
	 MveFGeB/eQyO1vPuWkNunaijAkKGP511xHgs3Xt4CnAVlxxVBnQeSwOIYs7DRZZcfrb+u
	 JIDN//VsokR/vEyFDOSks7z4g0kJN61Hm8lMSgKpuTfS7kFCnxQTepAfMCS1NijGbBgwb
	 X6IAETcL+XKc8BbZfmrKhMOrdMS86yIHoA8qvjTgqpY1hjf6W/aFZ7E6yPBgIATtd+TyT
	 W0b6oNOuBkjASJ7pRxlA/vIKQPDaablAfeJILygNHErgJZss35a1am4zsKtzkOfSRBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gunderson.no;
	spf=pass smtp.mailfrom=gunderson.no;
	dkim=pass header.d=gunderson.no header.i=@gunderson.no header.a=rsa-sha256 header.s=legacy header.b=iAVr5jHj;
	arc=none smtp.remote-ip=193.35.52.50
Received: from pannekake.samfundet.no (pannekake.samfundet.no [193.35.52.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6044E606A31C
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 21:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6044E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gunderson.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gunderson.no header.i=@gunderson.no header.a=rsa-sha256 header.s=legacy header.b=iAVr5jHj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gunderson.no; s=legacy; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=REynGEJVKcai/er1r3FuItLRjMzRv2/rC0nPKDdH8KA=; b=iAVr5jHjVn56rXqaeOEMcG08q9
	AS2YC01A5qxHh81CprfeTwGqIJgwZS+Ox7DU6tNt3YLYo9h/vbnj8VKaLnVTHDNy5tzQGJlVLdsGg
	4hJazLzDg6t0vTrMmMmwOqcHpR9wJKl4jqIv46580dNZ6eB4PdSMm6J9/yP5WSJ97Gdzi5/8RAp1j
	UEdeZ0iiAkkuQciKDN2bJ8nhLNi44VPrL/OSEiAMX9InSQpB1mDDKUCfMasrSCOPUP/Bo8D55N64f
	h7B+e80kd3ZG3Kwb+1XixsPMVNlOxatkrv7O70rCg6/c1Zv1B3aRb1Lag3/8h6ieKZt+jl6+3GeQw
	vqprZpXQ==;
Received: from sesse by pannekake.samfundet.no with local (Exim 4.98.2)
	(envelope-from <steinar+bounces@gunderson.no>)
	id 1xWgrr-0000000EhFq-1iHJ;
	Thu, 26 Nov 2026 22:18:59 +0100
Date: Thu, 26 Nov 2026 22:18:59 +0100
From: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Hung I/O
Message-ID: <xwmbrziug3hpwq25v2u5dfqevqjctjok2xcm5saz2oi3cdh7ak@qv7vlu36cvdo>
X-Operating-System: Linux 7.3.6 on a x86_64
References: <sh2gykmlybrlf77d6mp76pddecwl47pxoookx2sbo74y6ffme4@gcu2kqu7q4o2>
 <awc-vvNFH3vfYLWv@dread>
 <w7gmeo5scvyud6uzggjcdegitwh3r4jnj3bl4ozivdzfwcrxda@tfafi2wvvnmx>
 <awiXpKJTg0RvIGE1@dread>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <awiXpKJTg0RvIGE1@dread>

On Fri, Nov 27, 2026 at 07:33:40AM +1100, Dave Chinner wrote:
> This looks like an MD problem (slow or hang), and not a filesystem
> issue at all.

OK, perhaps I should take it to the md people?

I haven't seen this at all before the last week or so, and this installation
is 10+ years old. The current hardware is only about a year or so, though,
but I haven't seen any I/O hiccups before now.

> Yup, and there's enough stuff queued in the md block devices for it
> to trigger throttling on all incoming writes, even non-writeback IO.
> 
> Ok, so what's the storage config? What's the storage config?

The storage config is 8x10TB 7200rpm SATA (CMR disks) in RAID-6, on a SAS
backplane, FusionMPT controller in JBOD mode. (stripe_cache_size is 32768,
so there are lots of stripes.) There are also 2x1TB SATA SSD in RAID-1,
and as noted, it gets equally bogged down when the system starts getting slow.

(I would love much more SSD, but storage prices right now...)

> I'm guessing the problem is wide RAID6 stripes, lots of small random
> writes, and lots of partial cached stripes that need (slow) RMW
> cycles to flush to disk, and slow disks....

Well, it also happens before the process does any writes at all... :-)

Partial stripes or not, I don't think the system should be near-hung for
30+ minutes even after I've stopped the process, including the RAID-1
devices.

/* Steinar */
-- 
Homepage: https://www.sesse.net/
