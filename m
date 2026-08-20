Received: from mta1.migadu.com (out-234.mta1.migadu.com [95.215.58.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3443DE434
	for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2026 09:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787218287; cv=none; b=Qk7eDkpQvPepTBXZTiW9G0gVJWvvJVSlz0kwYjd6wEnUKOe2P22ueA96L/gzxzi5oMkWx+iSWXAHHmNyH0nFP+hLrqRDzdai72BrONjAsczeZcLciydXNT4F/CNktxJueNLQaEC6Xy5uf9yvSlbqVAmXYO4TvEpwBhh3eZTU9nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787218287; c=relaxed/simple;
	bh=X91BR6hnRFqJLfNJe8kieezAl5qpauGkI5pHrzRWeXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ho4qSWbXV4SBG4wmROYLSE5/yufY0E2+ZoYYi7OsNUopXuyxwkeSIMg6WS/gvDFWScerZG9vdbKiF8kmq9nvi5wlS0gUcaSAjnOQly5kF5k6OD2maZiy8LAbz1smzJ5YxcIYwsJHQhYx5VEEK+NYi2cl7CHihBq2Mf7FJBvde8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nj1cGTRT; arc=none smtp.client-ip=95.215.58.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nj1cGTRT"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=X91BR6hnRFqJLfNJe8kieezAl5qpauGkI5pHrzRWeXs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787218283; v=1; x=1787823083;
 b=Nj1cGTRTA024lCuz86kI0gLZvwoItELoRjtBldfIFihOQdsFkjWykfUMzPeNhrVNg8L9KSc8
 xDa5ffvjbiuH5pZlsnkpY4KwDB9CthKLRwpSkW5twiQPqQivcj9IzajF7TqxponCMeNDfD1zqUH
 GmcE+u+4Umq8D7yERBVEGtsw=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: from [192.168.8.135] (87.104.0.147)
	by smtp.migadu.com with ESMTPS id 06cbd8b77fd6dc5e;
	Thu, 20 Aug 2026 09:31:23 +0000
X-Mizu-Trace-ID: 06cbd8b77fd6dc5e
X-Migadu-Flow: FLOW_OUT
Message-ID: <47034326-da2d-4eb4-b6e7-a0d16972b1f6@linux.dev>
Date: Thu, 20 Aug 2026 11:31:18 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
To: Alejandro Colomar <alx@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, hch@lst.de, Zhang Yi
 <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
 "Darrick J . Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org
References: <20260820090400.857720-1-p.raghav@samsung.com>
 <aobIkmL6d9x5nPPg@devuan>
Content-Language: en-US
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aobIkmL6d9x5nPPg@devuan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/26 11:28, Alejandro Colomar wrote:
> Hi Pankaj,
> 
>> Date: 2026-08-20 11:04:00+0200
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> This flag was added to the kernel in v6.17. As of now, only ext4 and
>> block device nodes support this flag.
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> ---
>> Changes since v1:
>> - Change the phrasing around zeroing and its condition (Zhang Yi)
>> - Update ext4 support only for extent-based files (Zhang Yi)
>>
>> Note:
>> This feature was recently added to XFS and it is expected to land in
>> v7.13. I will update this man page again once v7.13 is released.
> 
> Do you really mean Linux v7.13?
> 
> 

Oops. I mean v7.3 :)

--
Pankaj
