Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.79.88.28
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793284629;
	b=HgY5dsH3CD/Lib5yd0IINlyo9WUnuB2QPbi4uT5TUvJqEO52Aexn4MhWBsdt9qZhoIqw
	 iSBbOZtGup6XLUUXJq6odhS6l9f/FOG5/Amh/+AqtDU+Vqj3Ed7y89JAtHX4IS8cp5rCk
	 F21Z5x9tS4y6yg6KuAQuquf0Ccyh32Jeusb8RCEMklSNobTsm5FFOvmP/JArZNqYbnuVB
	 xU9G2DU5McEnm2PKp8CeZhifseX7GQIN5Ot0vLihe/LOWF/An2CrsMgr8oQ8RM9BMmbHC
	 lePK4Z+ZgFza4S+tsNODgnSBlzU0LSskQaKzJPFHP5uM8SFgAoKpkj7bAnOez8BjjNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793284629;
	h=DMARC-Filter:DKIM-Filter:DKIM-Signature:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type;
	bh=DS9sgLqAP/1EvRFFFqIg5sk0bi7L6HM+95oRDwxbCZE=;
	b=cCGFo8vTvlmXvJGMFuwVOESdMi+IlxrWUlI4BAy1S2oXBbtQOVFY7LdU4Lmg5x56lkC2
	 Q3effsDf1Kgkojkg0FgSC/Dz5aD43oFItTCbUccdCB5VljMx4Ff06rKj+IKbaIgt5OiM9
	 TCLL6jH8pPX5inOacALRviOxSl05vWASF23ilZunsdqU4EukxFnPnd27dqRD5bc5qeT57
	 qXQh1PUmziTqZcI5A89xN8BhDicvlYDxf6HLhzC4db9Lwo2YrCkFQHCVRtsPxVTnjik8c
	 cUTvn6n6+Wtm80lhHu8F4LtrHzF3lL17PuEIyXz/N03SrOg0kLSG/x/vreZrESWBboQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lwn.net;
	spf=pass smtp.mailfrom=lwn.net;
	dkim=pass header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=JL860Aq5;
	arc=none smtp.remote-ip=45.79.88.28
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417D5606A31E;
	Thu, 29 Oct 2026 14:37:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 417D5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=JL860Aq5
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3DFDC40911
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1793284627; bh=DS9sgLqAP/1EvRFFFqIg5sk0bi7L6HM+95oRDwxbCZE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JL860Aq5NVfRCBDh62rDcU0WJSmwj0ctywPT6zzWMJk6t7smReAhCcvkzOwcQ8bFR
	 tVuP3qOc6GFMABSyRNk/wF862TX4dkUo81iF6IoNvToLkAE2SzkDDRajw3Wv0cJcJ7
	 wVMAVaMmqO6rBFsLG+sa2DJWEMBtnGZacco3XsnTugyKQ2IuXrrot2ahkyB7mmrzMC
	 oQJiigW/rhPDvTVPSnJG4w43lLgbTxCer0ZuBfl2rrVaFYHQyh0CUD8DkcEdKwWHx6
	 CntoOeHsrdeTYHC39I3/SuGm2JgLQMlfy14VEiLVHIPFFAqMIoYcopuztGy4PyRFxb
	 C0VZ+WndVRwFw==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 3DFDC40911;
	Thu, 29 Oct 2026 14:37:07 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Dave Chinner <dgc@kernel.org>
Cc: Henry Martin <bsdhenrymartin@gmail.com>, Carlos Maiolino
 <cem@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J .
 Wong" <djwong@kernel.org>, Alex Deucher <alexander.deucher@amd.com>, David
 Hildenbrand <david@kernel.org>, Kuninori Morimoto
 <kuninori.morimoto.gx@renesas.com>, Kairui Song <kasong@tencent.com>,
 Myeonghun Pak <mhun512@gmail.com>, Rafal Ostrowski
 <rafal.ostrowski@amd.com>, Likun Gao <Likun.Gao@amd.com>, James Clark
 <james.clark@linaro.org>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix out-of-bounds write from crafted btree root
 numrecs during log recovery
In-Reply-To: <auKGlGJwOSZpioMd@dread>
References: <20261027151703.973392-1-bsdhenrymartin@gmail.com>
 <auJ2jgIIh8e_JJwn@dread> <87cxsto38m.fsf@trenco.lwn.net>
 <auKGlGJwOSZpioMd@dread>
Date: Thu, 29 Oct 2026 08:37:06 -0600
Message-ID: <87v76kmv3h.fsf@trenco.lwn.net>
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

> On Wed, Oct 28, 2026 at 04:43:37PM -0600, Jonathan Corbet wrote:
>> Dave Chinner <dgc@kernel.org> writes:
>> 
>> > Unless you know how to fix the discovered problem correctly, don't
>> > send what your LLM proposed for review. It will be garbage, and all
>> > that will do is annoy whoever has to review it. Just report the bug,
>> > let the subsystem developers fix it.
>> 
>> Just to be obnoxious...this runs counter to the advice we have in
>> Documentation/process/security-bugs.rst, where reporters are requested
>> to include a proposed fix as well.  It seems we're sending a bit of a
>> mixed message...
>
> These aren't security bugs. Bugs that result from maliciously
> corrupted filesystem images (i.e. fuzzed) are explicitly stated as
> not covered by the kernel security threat models. IOWs, they are
> just -bugs-, and bugs that just don't ever happen in the real world.

I wasn't arguing about the nature of the bug ... just noting the
disconnect with what I've heard from some maintainers, who say that
providing a patch helps in the identification of the problem, even if
the patch is not used.

Thanks,

jon
