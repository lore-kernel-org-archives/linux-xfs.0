Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E5235D60B;
	Tue, 27 Jan 2026 15:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526976; cv=none; b=g5q9V8PWSjlOC3zMAvzXOTxRAxZ26I/nP0LpL1VFpBDoWnOcAdpuAu+WPFYIb1gDqK+Su5Ln8sT010AVoiOm+IQx5Q4bA7kv715OvZx8AZn+oSkMGs8xwHo7VBCG7bT2ZnmbGarZjvoUgU9vKlNaOwg0aMU+zgGfVwsh48TyX7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526976; c=relaxed/simple;
	bh=pmEU1/GjeEWtU5JBXeKFHL6rzRm4Dv+qk3Ok9xl6wR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DRgXNhTZZaYXacoqJXCorivUC6DrkVcPZ7vr423SLl7nNpYBPr9gHTmvpT49OopPkXGTQTbiTQN7QWb9xei6/ALMduS1nvt/gNNsoqucFq8d9ymSFA0anRxdEC8cA0IwR0c1n16aC59rcK/trBVyvtpMjupXnJLp5gXV6i39iQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EEDB227AAA; Tue, 27 Jan 2026 16:16:10 +0100 (CET)
Date: Tue, 27 Jan 2026 16:16:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: support file system generated / verified integrity information
Message-ID: <20260127151609.GA1883@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <CACzX3AuDkwEw3v0bNmYLk8updk1ghVJa-T9o=EHXor9FA7badw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACzX3AuDkwEw3v0bNmYLk8updk1ghVJa-T9o=EHXor9FA7badw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 08:24:28PM +0530, Anuj gupta wrote:
> Hi Christoph,
> 
> Here are the QD1 latency numbers (in usec)

Thanks a lot!

Adding in the baseline numbers, as I wanted to compare those:

> Intel Optane:
> 
> Sequential read
>   | size | baseline | xfs-bounce |  xfs-pi  |
>   +------+----------+-----------+-----------+
>   |   4k |    7.18  |    13.62   |     7.20 |
>   |  64K |   36.40  |    99.66   |    34.16 |
>   |   1M |  206.38  |   258.88   |   306.23 |
>   +------+----------+------------+----------+

So for 4k and 64k reads we basically get back to the baseline.
The 1M numbers are puzzling, though.  I wonder if we need to
add WQ_CPU_INTENSIVE or do some other tweaks to the XFS I/O
completion workqueue so that we don't overload the scheduler.
