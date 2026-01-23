Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CFA33AD97;
	Fri, 23 Jan 2026 09:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769159298; cv=none; b=rskcDi6/dCImCKcoLOFnzR9KviIvU0ss1iLAUmwk+S7Jq18RuzOtzFYAy/G8tCkHlvj+L4/icLJBGCUTuR6xEAWDDzx9wJA4U7XSHc76WW6ZSqdj1oJ2tSeipZMEg96/8VUPpVckzfwGAlvbLijR8xk5iJPbt6EWh4vt4l862lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769159298; c=relaxed/simple;
	bh=FqrXViJXlFx7Tkw12hFERAHqJqqesi3p/6FAehWVfCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b1CXHGmvCmDpC3DqqVhCBh7Yxqh0f4giXVnsE/D5pEnb/LryOYP5cnypawzZgDogB/cfhhV9yb75Erz0qlWXNIqajwFiykuVUj27Uyx6+z5JUXPd0PzaW6+cEM8aaWrzUBrO/de95g6LR5h3RsvwmwQLr86Cc3FFh2NYho3ka6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rvi/QL/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rvi/QL/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4141C19422;
	Fri, 23 Jan 2026 09:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769159296;
	bh=FqrXViJXlFx7Tkw12hFERAHqJqqesi3p/6FAehWVfCY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rvi/QL/wbqe25HO7PgbDbXUsAjqnjI7eYrcEfwwJuCAnFVb3rPjcDOin6q2357t5O
	 rUr+9/wT4RCk8kq5LSaRw3IZ0KAZKYewv/wZvofpIDpzjDrgYQnBDtl3fCSZU0pGiJ
	 LGjVUy6oLkMLFYKyvJUnVlqlbqOT0TdrZ0sSHE00Wd4VhCKyNjcUijmx1JiWgAtMmC
	 NARBb5j+ykQev90VqkVCFQ3PWQoLER8qhJQkqCZG4ru30YGi6Mqc65jvCzyWjWHRtj
	 9zRP66VanAUk5fFlN/77+b2cWJjqPeOs8/x+IteiWg9viwS7aUyzG/e5YvjVTOkt2O
	 IOeSjhEp/HrUA==
Message-ID: <ca8744b3-e091-4910-bd0c-9779898c0840@kernel.org>
Date: Fri, 23 Jan 2026 20:08:12 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/14] xfs: use bounce buffering direct I/O when the
 device requires stable pages
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-15-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260119074425.4005867-15-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/19 18:44, Christoph Hellwig wrote:
> Fix direct I/O on devices that require stable pages by asking iomap
> to bounce buffer.  To support this, ioends are used for direct reads
> in this case to provide a user context for copying data back from the
> bounce buffer.
> 
> This fixes qemu when used on devices using T10 protection information
> and probably other cases like iSCSI using data digests.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
