Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4663286D5C;
	Thu, 18 Dec 2025 07:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766041943; cv=none; b=ZU3x3dQZPhYv4Tf3WMIMnNsYXrLk3z5Ut73vR9DM7MumhomxzNRz9TDWvyKI905YAG2iwXCW9l/mc+r2cmEt5fJGYN5HaF+YdP+JFJRekDnO5UvWykfqg3N8uxi7DD/ybQw/7w2PsQ2YVI5VkzGHm9GuCPAN44fN+FW8uh/uDX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766041943; c=relaxed/simple;
	bh=66GovLG+jQQcN2/zYVUXdmTLt1ic6AP4S1aix2zEHlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=foyql7UO7tXmj9wi/FSIQdwc92RWHlJHhhOsIW12WSPQOzJitA9XtUYEYZA1qfEjPDdhwQDSnOcz9Cl15Or8jIHi0UITSXINjy6AGl4xn2a3RvJ8Indr85bZApmC4bnHxP8dI3uqmZVwCBQgeHNtKs7cls6+/xgD/+/QUomFBdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oD2qu4bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oD2qu4bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41168C113D0;
	Thu, 18 Dec 2025 07:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766041943;
	bh=66GovLG+jQQcN2/zYVUXdmTLt1ic6AP4S1aix2zEHlg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oD2qu4btglZra3tBWo9nu/qnlvrQnm+trqXdN1g7QaUlyPOtyno5MXzJrYVbAhTuM
	 73jQqO/OnK8hln5kNFYQnaHNrlnwQxQ/oZ00wx9WHbE0sf6HtGgKsnQJF8RdMPqNbO
	 6pRfW01GFQ/3TkI0Hd6Inq5s1sr+q+Ll95hrDZqHTvmL2JpPUZCoGnGfXoes4/PtHE
	 3yq0BKm40dCGeOqWlgLgxrCICTnurLi8735/FZYFIEjSjwgef6ktOJxkMlc1aC7VXP
	 Y6mC0iXGLBApdtTyu28XBX5lzFyihxQcTjI2Uo02VHtZZzGTf0MdQVQUJvqEtWAdyD
	 c6JlPCxnCfT+Q==
Message-ID: <9c9edfb7-716e-4a9e-a133-a3f24ce31cb3@kernel.org>
Date: Thu, 18 Dec 2025 16:12:20 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] xfs: rework zone GC buffer management
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20251218063234.1539374-1-hch@lst.de>
 <20251218063234.1539374-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251218063234.1539374-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 15:31, Christoph Hellwig wrote:
> The double buffering where just one scratch area is used at a time does
> not efficiently use the available memory.  It was originally implemented
> when GC I/O could happen out of order, but that was removed before
> upstream submission to avoid fragmentation.  Now that all GC I/Os are
> processed in order, just use a number of buffers as a simple ring buffer.
> 
> For a synthetic benchmark that fills 256MiB HDD zones and punches out
> holes to free half the space this leads to a decrease of GC time by
> a little more than 25%.
> 
> Thanks to Hans Holmberg <hans.holmberg@wdc.com> for testing and
> benchmarking.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
