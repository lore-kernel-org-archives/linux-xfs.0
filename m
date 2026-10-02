Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F3F46AA9C
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 08:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790931396; cv=none; b=GNPnBengMQkMZ1nU2QXtbPHXlUwRivZoIi4wT9tmLJc7jz1S7M9rD+vs99puxaGZqxSjg7QDJfDOQPb3KTrV5mjQWyzy1c1BIhJt/W5IVz8sYIvPUFeYw8gAmitdL/NqNtkHnhjoKE93EsxypsTRO6HISxyI/JVjg3KtYdZT+/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790931396; c=relaxed/simple;
	bh=AWf3YZ0HlGRWO5VYkOGblMKnvuap1wL/uLHG0EYY5s0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dPYiYFSM+iyoyt0Oke0s05pmaOtgIpYasgr3OsA024O7L4hgTWoYX+YoGp5VwhAsn4h2oqs//ewZ+vYxeQ7LpeU5NngO3+hImn7a2lj42C4uGHSk+w8pERkiPzw7zQIM7VReIghLDpaFrrQwHSWEl6GT+JP+2DOBuLYsvKeued4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCbatPvu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCbatPvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCB31F000FF;
	Fri,  2 Oct 2026 08:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790931395;
	bh=jF/MQSJ2ekFa4zSG9jnfMKw9U9XflelC9z14Bqucq1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LCbatPvusDiF8yknQl4I30KHVzIjKrwe4DvtHajWlAyIiXbnNOe5KdQY8AAHmJtF/
	 Ju5r3bhibMX8pAFNM8iKTgjbn2qMyrvB6HkQsFowYiaby18A2P7ByUATLY188DGSFZ
	 pbc1PGEQ+hfYHESv6MjFIC/DVbFNO3BsUGf0V25Vts8r520GJxICmmlaNtNoSJSTh9
	 TUHwbj5hZjLuitHmZp3b+IvS/FjkRX+fbodl/9BM7s81wgSFgHcfkuNeQ2Fk6eT85q
	 UnG0rxvMIG2cmLfn4HMUhG52HAloUmlRTZWSw8GPxw9CZWCd/3z+oUVlojX8xKOK8E
	 rjd9niYhUhjGA==
Date: Fri, 2 Oct 2026 10:56:31 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] xfs_healer: correct xfd_ API usage
Message-ID: <ar9xrb8Jx9GRtgPO@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs>
 <179086618131.2606256.16059054100746680560.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179086618131.2606256.16059054100746680560.stgit@frogsfrogsfrogs>

On 2026-10-01 07:50:47, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This callsite is wrong -- the xfd_* functions return 0 on success or
> negative errno on failure, so we should be using strerror on the value
> provided, and not perror, which uses errno.  Fix this to be consistent
> with the other xfsprogs utilities.
> 
> Cc: <linux-xfs@vger.kernel.org> # v7.0.0
> Fixes: b9b03770197d19 ("xfs_healer: create daemon to listen for health events")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
