Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B20E1465AD
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 02:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741143591; cv=none; b=KY7jswPPOi4386HVqQHYIIZ5ADhUTZZU3XpSjQHraAd9NNM2aYEewMdp2VGSw0bOgLm6RwDiPA5W9mM6Z07jNpkhTLYav65ZN3lXIEE3/Cxl/tE0+C+Gr0ScTxesY/l5ILlcMk0rSbEsik2e/JKMDPOkoAuDzy6zO4elL9pl3E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741143591; c=relaxed/simple;
	bh=PCNzOrZ6fFHbZFlpkP/J9R0cTPAHndmjskgnEeXZdu0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kYrWojVVbpKcQfJbgThPJCSdXKUUiRfx0Ej6LoSmFk9RtdchQAkn03I4RUbzHFCBbBk7dWmarjLN2MGtSNliQoEtfn2RVknHH3GW9Tm05vC4TawwdLUt3UI77AiMbpYZ4kzY1rhJ/QBDRTPOU/9Z84YIbQalnkY2/wYElTFoCWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qHAlah7c; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qHAlah7c"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741143577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TZUD9FHcJZMRi3hr6Ln+x8h4/Fn+HQN5iiqIcRwcYIk=;
	b=qHAlah7c6HYkboSWz6seWxBu15uRDhQ/OHZkb82vNp7rN6n51Himjf/ZmWCZg8ES+Nqqvf
	NBqk+9wLogJtBpRzkuH66vlwpHA60/rgf9Kk6SBEwBKQv7Miwf0+Q8mNxmunSIzu7YtLrZ
	HHE0cZKOfHqJbKIOGYiqtUYGrDDlDAk=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.1\))
Subject: Re: [PATCH] xfs: Replace deprecated strncpy() with strscpy()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <20250305022153.GC2803771@frogsfrogsfrogs>
Date: Wed, 5 Mar 2025 03:59:24 +0100
Cc: Carlos Maiolino <cem@kernel.org>,
 linux-hardening@vger.kernel.org,
 linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C7A61D9B-F2C2-41A2-968E-0E6A937140D9@linux.dev>
References: <20250305011020.160220-2-thorsten.blum@linux.dev>
 <20250305022153.GC2803771@frogsfrogsfrogs>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Migadu-Flow: FLOW_OUT

On 5. Mar 2025, at 03:21, Darrick J. Wong wrote:
> On Wed, Mar 05, 2025 at 02:10:21AM +0100, Thorsten Blum wrote:
>> strncpy() is deprecated for NUL-terminated destination buffers. Use
>> strscpy() instead and remove the manual NUL-termination.
>> 
>> No functional changes intended.
>> 
>> Link: https://github.com/KSPP/linux/issues/90
>> Cc: linux-hardening@vger.kernel.org
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
> 
> Please read the list archives before you post:
> https://lore.kernel.org/linux-xfs/20230211050641.GA2118932@ceph-admin/

My bad, I found [1] and saw that you reviewed it, but missed Li's reply.

[1] https://lore.kernel.org/linux-kernel/Y9sKXhxvf0DDusih@magnolia/
[2] https://lore.kernel.org/linux-xfs/20230211050641.GA2118932@ceph-admin/

