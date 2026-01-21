Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062A042048
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998277; cv=none; b=SoRhMgTIucIF+5vmpL598eqqE28ELBpOohpY2M0PrfMN3nPJWY5aHIMWmmOUwiwwoSNpNdn72lYvM8KzmOaAdGVZohzZn863K5MTMLajeqCqWcMUYu3j71sLmsD51zyGbYmaFEOnB2V/uYNz2s3ECT5fi3wg9JoweRbSzJ/Ovw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998277; c=relaxed/simple;
	bh=xeCGpho21PAnheJB+fWbv4rXVJMYwI5kaFZcO+748pg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=b0zIQoiIVeGOGmxbeq+DqEnsx+bYzSFuiSIDio3kyPLPuSUzXBG2dShFAiEpoW5IVchzcZcLVzSCRsd6gZM5X57sP7qxK/WEir6r9O/Ue1KVK+7sjXqlHGDfnM36nUSvMWxbvTaLzMZYTg2PrmlxMbFgwKCbbXaOOMrjnlalbdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3mqyqps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3mqyqps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07AAC116D0;
	Wed, 21 Jan 2026 12:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998276;
	bh=xeCGpho21PAnheJB+fWbv4rXVJMYwI5kaFZcO+748pg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=f3mqyqpsb1qQr2uYHfBGFVJAg31OFBHKX0/if2yvPhIRD8cI+kCA7DlC/B8l9fC7M
	 yySU/mkCjz4xZKOsWcrEF0tKTEgjWTzJOur3EVZpkbbPbYbK/EuJE451o4SCJ562e2
	 3g5hwdKNE9WCjv07QRCERhgE/RnzpOnDSx7Z7it2vje4qa+5+qegHm/J6poQ3omtcS
	 h5v43K7Cin+uT/6ktstOJcONxsQmeKMcnwqN+rF+a50WayNYdgSJEyQfLLSk/QqMRl
	 0wLcTVWgFh0xCl+Fn2G+1aoYvvmVHCX2CFbhgYs9wFi1ZIr+setAkmt6pDw7U0F3Lq
	 AHZWhUyXSRosw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Hans Holmberg <hans.holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, 
 "Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 dlemoal@kernel.org, johannes.thumshirn@wdc.com
In-Reply-To: <20260120085746.29980-1-hans.holmberg@wdc.com>
References: <20260120085746.29980-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH] xfs: always allocate the free zone with the lowest
 index
Message-Id: <176899827456.852996.335962182196285347.b4-ty@kernel.org>
Date: Wed, 21 Jan 2026 13:24:34 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 20 Jan 2026 09:57:46 +0100, Hans Holmberg wrote:
> Zones in the beginning of the address space are typically mapped to
> higer bandwidth tracks on HDDs than those at the end of the address
> space. So, in stead of allocating zones "round robin" across the whole
> address space, always allocate the zone with the lowest index.
> 
> This increases average write bandwidth for overwrite workloads
> when less than the full capacity is being used. At ~50% utilization
> this improves bandwidth for a random file overwrite benchmark
> with 128MiB files and 256MiB zone capacity by 30%.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: always allocate the free zone with the lowest index
      commit: 01a28961549ac9c387ccd5eb00d58be1d8c2794b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

