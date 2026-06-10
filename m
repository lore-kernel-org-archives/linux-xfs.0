Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CFE3B7B99
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 09:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781082916; cv=none; b=mykh10NbPXsSl5Z/D0ZcJdeKLmFXteChTiDx52MaxBgiPuhJOZXFfbDS0v31z8XAywouBrXdU4V7j9MuDXEhEO9MUSWOPGwHXPvmvf0592110JNgN7xll6HRsRUju7zQoOLjma0iUxVXdrHXj80k27L7ALISgDWhnPQbYt11r0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781082916; c=relaxed/simple;
	bh=Hc2SOHicZ44fSfamb5HPpM5t/9oRWUCjHA47DU9M/GY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IvUrBjdhlNB06N7UwD/lJx/7HW6tCke85SvaV5EtsYIupxq5SXMXEG+Q+EsBqDhDVmZeFhMXl2rji6fcOh60ZYm4ItgR5l91e8qda7T8N4EmlxCroMlq0rBmHljJMGWZ7i0qnxJ8q5PyniVN8l5We8HZZG1nbn9UWQT8lhT0ASY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpVPG+Q6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpVPG+Q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1121F00893;
	Wed, 10 Jun 2026 09:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781082914;
	bh=vo4dZW2p9t+QUpbOdikh3z2H8ug6zMZMNvLR1aPFXAE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SpVPG+Q6MQ72JNmPGL92b4FPNIz/Lk+vkl1Ajka9XP1JKnM4LASPdP1jam8QSKWpJ
	 ECudV8LmUrj4Tq38PBO4zST2oty8iBdLtcjdLfNREdfbubbowMp9VEFbqdUOvXriqt
	 kIbANlC+6gRFBCmoDl6KO5+sOswNWUsjTb9OhdshSrSlK7nBAaBfGvMar9QVHcSG1f
	 KYCb9osBLNSmiyDu77cQlFe3bGCk1/I3l/xR3gOmL/AN9VxTByJOzMFKbRXmlb0A/k
	 vIPfVSJHpQ/r9XR379VxWzOBqGqcbFOu9sYktEuBfhRDt0EujbK6omZ5rRzrNWWExB
	 ZI0S0F3BUzjJg==
Message-ID: <8059334c-4b96-4eb0-a14e-0fca2e0b237a@kernel.org>
Date: Wed, 10 Jun 2026 17:15:01 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] xfs: only log freed extents for the current RTG in
 zoned growfs
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260610050731.1906760-1-hch@lst.de>
 <20260610050731.1906760-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260610050731.1906760-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/06/10 13:07, Christoph Hellwig wrote:
> Otherwise a power fail or crash during growfs could lead to an
> elevated sb_rblocks counter.
> 
> Note that the step function is much simpler compared to the classic RT
> allocator as zoned RT sections must be aligned to real time group
> boundaries.
> 
> Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
