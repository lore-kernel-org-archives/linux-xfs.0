Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7177264FB5;
	Thu,  9 Oct 2025 20:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760040832; cv=none; b=WyWGUcln/0iTa6Nyo/+DkVU6Q75UK0W0tgmPSbbZbeDuRXiO40KEezGo/a558Hg1Apa+sbj3rctn6ixLpp68/CVgwQsw9Aws92A7QbXoeo2TabU1LXM50kL97V3mMinIFMyLU2tmbZk4WEHj7P02kaaiECJwRU8Pxk6ds9P5cTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760040832; c=relaxed/simple;
	bh=9AjLQYvVBXlOqXoly79mNevUBYd8UiKGNvv/z+j3Ws0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ScUmtQ5JmNCsXgdwUTwd+LhLnMr5Vem6DDPTjRXndSgDjXznLLNVPLc9RWJVuDXWsoi1qAb8SGgCBQYjMbrqwZy3lNXD4xorTsoDGWhyi4YP654P4UtEpw9lcZUOb/rgxjBQVRJzc1WhwoI65pjwpDpCMTpGCwZk1TPzmpGy6SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=eeJB2GD+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=C1K1oOfF; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="eeJB2GD+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="C1K1oOfF"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 115FD14000D5;
	Thu,  9 Oct 2025 16:13:49 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Thu, 09 Oct 2025 16:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1760040829; x=1760127229; bh=by
	aPV/hzxTRnPB07BSzudbh23pV+4nv/vKtJRwrJKtg=; b=eeJB2GD+eUrnpU4WLx
	fh4dHf+BZa16qw4Zaszp3/Sdug0859cl2TO9dP7tFe128JNiUoM/aXB2xPuDbgEv
	GTr6PUi1RE+3bxvQ7aDErpR12yMtjKGye/OgnBJ87WkYRDEgUuBrpKBmT/toYGdd
	nVyfOHfB2MCN3CaMnd/et8U+WM/3Liiw2B92i5sfk9TEiYlhbbxwo5UJOcId4fA7
	RSg59rPyuaAT260S31X/STRoWZLF3wLp0ziSWggj0Ru+DyoccUJehPLC473dTXXx
	Rkn04vT25B+o7RFwqWcOVnFwmgu41Lk5ju7d8XtqtiAGqEuM0kYCzJBtzm95z1Tf
	xbIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1760040829; x=1760127229; bh=byaPV/hzxTRnPB07BSzudbh23pV+
	4nv/vKtJRwrJKtg=; b=C1K1oOfFsDh2PbwC2LdYDHrqzs5MXDCFvSpzVCau8S8Z
	xkk+dppej8JTE46up83uJqbtfnwrok09znAbrnhUT5AEu+Ade/868h2gX7pIx0j0
	z2j28+kMpZiJGfGC2a6Kd9BtTLNE1U4NxIxZQPijEoB65pGVaF9z2jLVlS7Oi5cQ
	t3Dx/LZ31bfd5mHhb82LXOq3vABHqcV6HM0jaW7edyYLLXY9fNKSIxCoAvBeTbDW
	m+ngYRg+jJxYYJ0m6J0gp89Y7BZrwWE/nGIX0Bc5oRYWSpxdsKtaBTfM6AIIF3yA
	KjI4FBBpo6mj0Tp15XFnk3m9UjZXVjfM1p7KpFWV/g==
X-ME-Sender: <xms:fBfoaLqiMAe3NCB6izGKpcDFWafPxzG0JLOGDG2wIcxgW-4h49tvOQ>
    <xme:fBfoaNboKvrLTu5jJDz_nvu_apLvfYW926QTPzqnwasVR4_Lb16MbH07N6woGt-UL
    f5uGMA9YY6o02Xc5O4bOfYQq9UiJdPSS-7gnz_kcbtDXCd-dnX2LUA>
X-ME-Received: <xmr:fBfoaLTiHrX4568IqLbJytshBBqJYv0PfU4CWplb5LZJF_bKdSxQnbgfHLa_DczPRou3WHC6rgMKSERaAGkCaI4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddutdejudduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfvfevhffutgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcuufgr
    nhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrghtth
    gvrhhnpeeiueejjedtgeeuhefggfejleekffduledugfekgedutefgvdegtefhteetfeet
    heenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrg
    hnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopeefpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepfhhsthgvshhtshesvhhgvghrrdhkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:fBfoaM6_Vf5xH9dS4GkVROEn_ofho2Lc4axlB0IbhohPzcZmwureBw>
    <xmx:fBfoaIzIkDi_KoUihiTzmCae1JNSqvf5p9brIdDNerX6Ok0OJIZi1g>
    <xmx:fBfoaDTsEdbFGd2D5xZbN94TaR_X7iA1YqS4Mqm4IS_L7yLg13fIuw>
    <xmx:fBfoaPVXsoWbhQ0DShHyteLz4B0gS3hCcOCxACRsaEG7izsysQ7mkg>
    <xmx:fRfoaCIRLesa1hnkC_e8mK2PkD07AnMuaG4_yu64uXpaVx7ACmx2dplI>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Oct 2025 16:13:48 -0400 (EDT)
Message-ID: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
Date: Thu, 9 Oct 2025 15:13:47 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: mkfs.xfs "concurrency" change concerns
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hey all -

this got long, so tl;dr:

1) concurrency geometry breaks some xfstests for me
2) concurrency behavior is not consistent w/ loopback vs. imagefile
3) concurrency defaults to the mkfs machine not the mount machine

In detail:

So, I realize I'm late to the game here and didn't review the patches
before they went in, but it looks like the "concurrency" mkfs.xfs
arguments and defaults are breaking several xfstests.

4738ff0 mkfs: allow sizing realtime allocation groups for concurrency
c02a1873 mkfs: allow sizing internal logs for concurrency
9338bc8b mkfs: allow sizing allocation groups for concurrency

Specifically, xfs/078, xfs/216, and xfs/217 are failing for us
on various machines with between 8 and 128 CPUS, due to the
fundamental change in geometry that results from the new
concurrency behavior, which makes any consistent golden
output that involves geometry details quite difficult.

One option might be to detect whether the "concurrency" args
exist in mkfs.xfs, and set that back to 4, which is probably likely
to more or less behave the old way, and match the current golden
output which was (usually) based on 4 AGs. But that might break
the purpose of some of the tests, if we're only validating behavior
when a specific set of arguments is applied.

(for 078, adding -d concurrency=4 seems to fix it. For  216 and 217
I think I needed -l concurrency=4, but this might depend on nr cpus.)

So, we could probably fix xfstests to make mkfs.xfs behave the old way,
with loss of coverage of behavior with current code defaults.

Other concerns, though - I see that we only do this if the storage
is nonrotational. But in testing, if you set up a loop device, the
loop dev is nonrotational, and gets the new concurrency behavior,
while doing a mkfs.xfs directly on the backing file doesn't:

# losetup /dev/loop4 testfile.img

# mkfs.xfs -f /dev/loop4 2>&1 | grep agcount
meta-data=/dev/loop4             isize=512    agcount=6, agsize=11184810 blks

# mkfs.xfs -f testfile.img 2>&1 | grep agcount
meta-data=testfile.img           isize=512    agcount=4, agsize=16777216 blks

so we get different behavior depending on how you access the image file.

And speaking of image files, it's a pretty common use case to use mkfs.xfs
on image files for deployment elsewhere.  Maybe the good news, even if
accidental, is that if you mkfs the file directly, you don't get system-
specific "concurrence" geometry. But I am concerned that there is no
guarantee that the machine performing mkfs is the machine that will mount
the filesystem, so this seems like a slightly dangerous assumption for 
default behavior.

I understand the desire to DTRT by default, but I am concerned about
test breakage, loopdev inconsistencies, and too-broad assumptions about
where the resulting filesystem will actually be used.

Thoughts?
Thanks,
-Eric

