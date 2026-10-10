Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091842E03EA
	for <linux-xfs@vger.kernel.org>; Sat, 10 Oct 2026 20:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791665844; cv=none; b=SegTbb3stHqQ91GnDfAA0MresMiYng0Wh2fWgBD6Oz8NzCKmERqaA6K1ZjUEWatb6lrF6/TxkLuGkqkTJgNnDZzpiHG5BEC43jI7leto+khPcMOdZK0EsEdFDNjZNtca+KKcCrT35T+6cKFg5geHn5vyh+SR3RCHdP5UABAYCxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791665844; c=relaxed/simple;
	bh=67ExoTRefKcsSFjoP4PqlJuMerTRXqF4LEsD5mWKUL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uqX5ilEq5VKXloHyt5ZKEaVOpH9EBxlHU2PofvsnpMtc15hXvfzuQtw4fi8ynTiW8JHcfWTpF5OVHCEVN49zbRpv8kO5W+SFodSHytzWuzdy6tr0p7Pb5h0YMhl6FRYNjgFyrNkRFyvQFNy90RzgQxnNSzr9HjFcyko0SOECU/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=CRF2kyFw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WOURKotU; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="CRF2kyFw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WOURKotU"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 0A6281D000A6
	for <linux-xfs@vger.kernel.org>; Sat, 10 Oct 2026 16:57:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sat, 10 Oct 2026 16:57:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1791665841;
	 x=1791752241; bh=mygpK4nc9shBhwceCbrZ88Pd8SIDIZnLB4Ubgce8YK4=; b=
	CRF2kyFw6rNkp0Ep474baEn2WdxLXsz89r03wPPtoJ3Xylpztvx4c/RXukWExzxZ
	yohHv5kIiHsFS8UHZQNTam7KZ/8lpXxTm7JMMtkHU9lG8jBurRT4rA/JyQSkhDpp
	F5KH0XlxVpChhtSGpXYSLB7/rhYq143Sxq7mdzV1tyz3W1W/3XtzEyAMzwaAHtRS
	cu5krmft2baDjeqfdILFsD9GojIL/Fxbjtw3vg8yGrJPlZlCFuLMa1vrCccNTmCR
	uX6EweqQihCCb60ssESWCb1CiuafMkXF5Dzv8jZh6z6sK1CZDdZGLlaOFHNV384J
	CMtyCZoqHcI1EewXVLqwUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791665841; x=
	1791752241; bh=mygpK4nc9shBhwceCbrZ88Pd8SIDIZnLB4Ubgce8YK4=; b=W
	OURKotUt6yJKA6DxgvpCrzLkspccxbrA+0rm09cCzJkrwjWRU+qO/4uXngXcij92
	pr3ln+/TR30q8h/T/ILeBzpDpWfDjD54S26xpqevCgpAyc45qQf1ptuLIWcSDSuc
	0brPAiEpHwnu3mR0JsryE5Ray/F+joN50dwNp34STgkv8IoXcSUF33zUprA/tAv+
	5jwaNtpeWZfd49j9segn/NazBTwrV3UTH7mF02rmSWETK9ty1jYh4DS4iVyj+YtF
	xNJUc+lL54boHRg7RtZIiLeQbUKdtE77ssisgfKTWiUFJr6gSsBtH+RXj20tN4od
	IIjwbRio/so9YvCtepcrQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791665841; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:DONaPfQWkqk3NtHuWcg5bY90skhTED9QBZbSIz+8xwx4uWa
	TNy+PTlXk7UptFaNIjgv/CX2RnYpDxoo5JZQs/oQQyjZ8F2i966A/f0Su0qAQ9i2
	PuchA+a690A947OVT/ROdMb+ls0Cypt+ulGQ1mPwXzxlQGwhpUZSsAjOj+eNPtv2
	diTyIktTxKMrf+VpFLB+FkYoZ4JBKYc/nr1vp7Naxs5h68NDmlfxWsjpbV9MLE4X
	OqtbXwqvM+4zVfj8tI/sUUxMmtAm4Uq4EqjsUvyhdo6tL6WE72jH3vhIZQegIRn3
	/3kqWrPvHDOsjl95pQt0wdH2cTWQO0OltW65kjg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:SuHc2Fv6UB8ne2dhh6R3HckSBBKG/dHy0Huy06YJCyw=:67ExoTRefKcsSFjoP4PqlJuMerTRXqF4LEsD5mWKUL4=;
X-ME-Sender: <xms:sKbKauRHklJsKTcRdpZUeowX3bNTf6QsM_Gxje6ZuOrW8uMTOVXWtQ>
    <xme:sKbKane1gIpfs_DyE0AnFp7DFUUl6Lj5pA4-YwNuLTDxcGzuCuVJlObufyXwazbu9
    IUOeurhHu-k2SUayg9u8vYb2GztZYWQ_O5HocZRFqzhHttRdTlyMIJe>
X-ME-Received: <xmr:sKbKalqITWD1lkIR27JDDIDBaqtfk2VV4dUp1fRkT74ocKrDP3tAkw6X_TeAAvOReSgHMB2aqXJKPyDN6AblyTecX8Rjrg>
X-ME-Proxy-Cause: dmFkZTFTLC+l8UluJeb+/XfKxwADrtfDyOxpuByBf3KthK6PElpv7j8OFvITv1HcRG/jcP
    RCxsJCgGSyWvJxsNdTgObQaJZa1+YGQZY5ISK/4ToGL7xUWxvYdfoGL7QkPz+R0vauHJHz
    u1zjcLSAtRp/ai41IAg2RRD4YyYRJJ3X9ohjKnb/9WI1lc7ERAor1iy9fns+1wvGJm48C4
    KyVhNEqCNmuxmIpj0vPERZB+mHo5alHZ5fAHtyoiieejSHgHspZDh96KP/8v/d/WG0CmvC
    oVyBTFPLLH/q/9wLiSySoQh3NfAmbEd+twt2n6ySswgjWGp3h90Vwghp7fGr7936BR3Rrm
    AnG0n70M91PMQGVP/mLvXyrN0GXyockFtSaDjhHqG3HMkpcIRkeBf8uijOFz4hzhsCkzml
    VWYWgrKHkHMC+vvgGVt2lQUH5VLpP/0pm80K5JyXvYkIzo9m/dKhwQvnjClCVsIdoJgDha
    yhfsULR258p+7HWy3mTGD4s3ui99fkyWBcLf8f1s19fW4buxaofJ0z5GL0G8+C+tbN9cMS
    iOl5L7bmG6j+rP77S9Kv1k1wuc/ToxmLIjxiy24UEa+/RNmyxtKrD/oe+hftRZeE1KOHuU
    t2X3mhGfL/QzIaZwObORVZINs9vnhd3AiEKUT00f26kIYTfp3uOAaH9dOa6g
X-ME-Proxy: <xmx:sKbKag9aaUzI67uuTGT59mIhBUs2uudkfbYpI3OqoKmdIgx3RGiwTw>
    <xmx:sKbKapehDp4f6dj3vgFjKHruXY-lrHMgb0t9rHmLJ9iKfD4vtwelRA>
    <xmx:sKbKaiKWzOna-LIrLXBuDwMHghh4SnM1fCxkv66UQibshRf1PZHRBA>
    <xmx:sKbKahjvXkwjSzu4cmSSrtiwPeLfQK4EzNKv8QvzAZPTXPcu2st31A>
    <xmx:sabKaibimdQE9jAwuXlytycxSWkcnNEilLENfejCu9cG2BdoPMbMQyNY>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 10 Oct 2026 16:57:19 -0400 (EDT)
Message-ID: <c23434c9-0d06-4390-ba2b-0feaf7d747f9@sandeen.net>
Date: Sat, 10 Oct 2026 15:57:19 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: add regression test for swapext reflux
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Lang Zorro <zlang@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Norbert Szetei <norbert@doyensec.com>, linux-xfs@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>
References: <20261009221130.GT1615495@frogsfrogsfrogs>
 <101C0648-521A-4ADE-97A2-E03C7A43E4EF@sandeen.net>
 <20261010154147.GV2705364@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20261010154147.GV2705364@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/10/26 10:41 AM, Darrick J. Wong wrote:
> On Sat, Oct 10, 2026 at 01:09:39AM -0500, Eric Sandeen wrote:
>>
>>
>>> On Oct 9, 2026, at 17:11, Darrick J. Wong <djwong@kernel.org> wrote:
>>>
>>> ﻿On Fri, Oct 09, 2026 at 11:13:53AM -0500, Eric Sandeen wrote:
>>>>> On 10/7/26 12:05 PM, Darrick J. Wong wrote:
>>>>> From: Darrick J. Wong <djwong@kernel.org>
>>>>>
>>>>> This is a regression test for a bug that Norbert Szetei reported in the
>>>>> XFS swapext ioctl.  I've ported his reproducer program to fstests so
>>>>> that everyone can run it.
>>>>
>>>> A couple things I notice -
>>>>
>>>> 1) this still requires EXCHRANGE?
>>>> 2) if the EXCHRANGE ioctl fails with EOPNOTSUPP the test passes silently
>>>
>>> Huh?  Oh, the reproducer actually requires it.  Ok, I'll add a _require
>>> clause here.
>>
>> Should it test that exchrange is fully available and mkfs scratch with that option if so?
> 
> Yes, that's what _require_xfs_io_command exchrange does.
> 
> And, uh, you could turn on exchrange in your test config like I do,
> especially seeing as it's been enabled by default for a year.
Sure. Lots of people run xfstests, sometimes even on older releases! If this test is
specifically designed to test something that requires exchrange, it could make sure
it sets up the test to do that whenever possible, even if not default or in an
environment var.

I'm not actually sure what the overarching fstests philosophy is here, though.

-Eric
