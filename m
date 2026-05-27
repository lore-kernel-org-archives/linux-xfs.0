Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A82F40855
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779904844; cv=none; b=qZSLDJiCmpedG3UT+x4nxFoKuVeR1QJ0s1kzhh272UVosL0qayJhSTNXwRLfreRFHjSyakPaNiPgAGjtrBsIVslAtNkTzjjcF5GDT4FydW/z04rknZwvvoH2iExaNJccxMpjh1CvJRvPgnalAGVSkDgF6XHiAJ5GlXYoyJuZ7Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779904844; c=relaxed/simple;
	bh=oGacxXTAZWElDDAVgDzTSMS7d0KzbqYGEGtYx+am0R4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZNHT07RsbAmy5HW/WTiL9eDL/0QUqTiWRZ+UvSmw1dkVXZFidpeUs334QFD7ISqDniZ62/iDaPlpBRBGRqGHRXl+BhTlQlwKPLW8T12DNr4z7xkIyiP0r2fNvZRvU6CqASfYgiEApEcKW9j1EwZr9Rz+6QWGvMiAICRIIQUno2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xqxwjtjf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xqxwjtjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120CD1F000E9;
	Wed, 27 May 2026 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779904842;
	bh=EVic98tgEzvr5q+/kCKVrzkG1ZGoF3agG7wrNSKTBB8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XqxwjtjfzbUs6XEyY+t5vgu0nRQ0zn89r/753UMmQzYqFjzUS5pL00q75JLjEbMc9
	 Jr8lVQVzb+D4pRyGArhlDjNWwtbNi09pSFxaxFQqhjhsBzekNapxw7hiTDdHF58QsS
	 0XnTRvBOdJLCpMDBzIyeEY8k4K+UC/cVUK3RZtzUHDJ8C6Au5e6LlrSBsk5AaSkxHZ
	 a6lLFCT6BUIlnBT0ruWA10JZZ0HtxqdzhFMDAUJb73mxLX8zHRP9+m90n+8s2CgWhV
	 qXIPWsDKl1wKBpgCJuKTWnk27bD9l786IVfP78YwFSEwoJLJtzDb8tfVDR8eU+bh+H
	 P2umH/HBossRA==
Message-ID: <f2b412b8-ad8e-4771-b0c7-c7df368a6f36@kernel.org>
Date: Thu, 28 May 2026 03:00:40 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfs: drop the RTG reference later in
 xfs_ioc_rtgroup_geometry
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
 Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260527123941.2319377-1-hch@lst.de>
 <20260527123941.2319377-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260527123941.2319377-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/27 21:39, Christoph Hellwig wrote:
> Keep the rtgroup reference until after reporting the write pointer, as
> that uses it.  Right now this is not a major issue as we don't support
> shrinking file systems in a way that makes RTGs go away, but let's stick
> to the proper reference counting to prepare for that.
> 
> Fixes: c6ce65cb17aa ("xfs: add write pointer to xfs_rtgroup_geometry")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
