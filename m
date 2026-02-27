Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F253A44CAEE
	for <linux-xfs@vger.kernel.org>; Fri, 27 Feb 2026 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772209623; cv=none; b=Xy8mpePCe0b/0UJj3iysIAatcVh6rqgwnfiLRlEmxik0Rr7U2RFp8u1MO/tZYX54heCGZoTcS0rOA/qjDheYgItdkm9SYnJzyA1qxwXjrf9xkypuVHzlbKQNhX2tm+oRkS6ISpBxOwf0z6N0siSE9TS1Y1oDrOWHHumXPUcHwtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772209623; c=relaxed/simple;
	bh=eUGlgvBw2sqpiR2bHyJ+kUaK1vBEurR9UQTx/gH8ot0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBTbA5ElcSizmMfFd77kcppBwRtOBWZxa4QPhqY59d6FQeRTbUrz89NkRi8zMVECKzsJhaWQJg+yoWqQCQpa3yjfW//B2zn1l1YozVPlxa5MoTV/n3Gqey2BiTY601eCElCJq6x2g/QYConucaUhXqDKAZTRplZTl4AvwWO1fK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CfcueGEb; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CfcueGEb"
Date: Fri, 27 Feb 2026 16:26:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772209616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rnMCmZv1P1jQsccPtDJTW+HFX8QIxa/WaKjighx8usE=;
	b=CfcueGEbAXhpN/ZVfzrpXgnsikM2GXCa5d9pQQFdeQ8gvOmJlJtF2ZRhNL8XfVgkpubdoH
	IE1QktGL2n/tHZ85prWTA+ma3MlIJE4RcgaoNywgggYMrW/Y561a1Z1BMai5aUyVJqzRnT
	bKNEi3z8m1V4nS3kdqBC2Jmi2ciwMIY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, dchinner@redhat.com, 
	"Darrick J . Wong" <djwong@kernel.org>, gost.dev@samsung.com, andres@anarazel.de, cem@kernel.org, 
	hch@infradead.org, lukas@herbolt.com
Subject: Re: [RFC 0/2] add FALLOC_FL_WRITE_ZEROES support to xfs
Message-ID: <5fdwrd2sxgc635tf7yihzhwpbfcjlhcizhcmf2j6vnk4nmu36h@gyqktd2fbu56>
References: <20260227140842.1437710-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227140842.1437710-1-p.raghav@samsung.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 27, 2026 at 03:08:40PM +0100, Pankaj Raghav wrote:
> The benefits of FALLOC_FL_WRITE_ZEROES was already discussed as a part
> of Zhang Yi's initial patches[1]. Postgres developer Andres also
> mentioned they would like to use this feature in Postgres [2].
> 
> Lukas Herbolt sent a patch recently that adds this support but I found
> some issues with them[3]. I independtly started working on these patches
> a while back as well, so I thought maybe I will send a RFC version of
> this support.
> 

CCed the wrong Lukas by mistake.

cc: s/lucas/lukas/@herbolt.com

--
Pankaj
