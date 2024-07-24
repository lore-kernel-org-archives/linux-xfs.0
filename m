Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC59A73440
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 22:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721858822; cv=none; b=Ko03mUweqGchAeL6bDcuX9xJj8WlhZ30iV6qo4zJP+/kPOZyS7SaHIUlwlgjnh/vEfJUR6MWp/fj9/DsAdVy55MW+2dCiXMwcbLXyWtS1kNoGkKBluml8aCL4W1cdcTlcMrrPiPWS4yF+82UDpfeDmYXONEBJk0S+LdczAQYNoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721858822; c=relaxed/simple;
	bh=JwJIe83I8zcspmcZxuf/DS9iDem5jccZYD31EqeOe48=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sGrNCgQ8kqSCJgVBEnBi8IU09vZt8w8XC1q43x1hskTRI2plaJnoyAXkH0FuE7r/FjIQyd2hJzTezifPAgv4xtRvMn0fJgcVdqIOglw2zlAshJ+n3vOmXF8Jg2kprs4m9+k6ZMnF48+l7kBumnrn2268NsrOMS51nx2vDCb6Zzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=kb3tBP0R; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="kb3tBP0R"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C58AC5CCE30;
	Wed, 24 Jul 2024 17:06:58 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net C58AC5CCE30
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1721858818;
	bh=JwJIe83I8zcspmcZxuf/DS9iDem5jccZYD31EqeOe48=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=kb3tBP0R2ZAnz5xxBBXldr9pY0KLfutNX5m0OVlY7XU0/xPqajmJtl3vrKteAgrI0
	 nQpuBTALNuxEXxA0fNWOJJbb4mmhNRbrWtbn0bprDj9TkTejiFY3u+1cbRsSlbS0Xt
	 uX5rnkjO/mWm9mvngQU5R2BS0tV1Jlhys/b1TSUBB3AOEqrDqRiTXb151KXAzQKFsm
	 AU/Xi0+oXBe6fiSqn9++3F+1x4WS3cwBx7olLFuwM4aiR4Rekk3NNE3eqnvU7OC9ww
	 z4qtGgB4cGwct49Vkh7iIfuGeDgMp6ljAUOldNtzP0MidqyrPI2R3LWwH8sBcRQOl6
	 Gq+VggSToU6jw==
Message-ID: <345207bd-343a-417c-80b9-71e3c8d4ff28@sandeen.net>
Date: Wed, 24 Jul 2024 17:06:58 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20240721230100.4159699-1-david@fromorbit.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20240721230100.4159699-1-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/21/24 6:01 PM, Dave Chinner wrote:
> +The solution should already be obvious: we can exploit the sparseness of FSBNO
> +addressing to allow AGs to grow to 1TB (maximum size) simply by configuring
> +sb_agblklog appropriately at mkfs.xfs time. Hence if we have 16MB AGs (minimum
> +size) and sb_agblklog = 30 (1TB max AG size), we can expand the AG size up
> +to their maximum size before we start appending new AGs.

there's a check in xfs_validate_sb_common() that tests whether sg_agblklog is
really the next power of two from sb_agblklog:

sbp->sb_agblklog != xfs_highbit32(sbp->sb_agblocks - 1) + 1

so I think the proposed idea would require a feature flag, right?

That might make it a little trickier as a drop-in replacement for cloud
providers because these new expandable filesystem images would only work on
kernels that understand the (trivial) new feature, unless I'm missing
something.

-Eric
