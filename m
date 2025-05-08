Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83EB1990A7;
	Thu,  8 May 2025 18:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746729804; cv=none; b=Y2KabdzZDjJdXTPnsx5bedd4fq+ZeAs0LzfsbBPWXhf77HNQ93OGnV2O+TG5gHvr4FWbLRBrFNc+bw0yFuOGX1iG3dnnE7i50ebpWI16QlcCZJ7+WnFy9q9xIN7dJX2GvIMwbpWZKAvVl7LKGsSgq8ehX5qzZvtBKfhKhkR60ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746729804; c=relaxed/simple;
	bh=XAcbLfu1HyyCISc1dBx9Am/IUGvLqXE4bJphLt1JqAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YV5sv/ga6694rkPksVOOVhwI5ANCmLB70VZNV/8GooBukGKg7GwH8Ik++9tMS/zWkkWSVNapjCQZuXGdjHp8Ibi1PTExHmRHn3OI52wLt1K9bsu8eZteZpYpYoUCOBlcsGUXuWGwIpgmIKsWeZe2qZGzfESKDQkhdeYIMXJqg3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aLCnoPLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aLCnoPLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E034C4CEE7;
	Thu,  8 May 2025 18:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746729804;
	bh=XAcbLfu1HyyCISc1dBx9Am/IUGvLqXE4bJphLt1JqAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aLCnoPLFnDV7ux6pj9DjR+Cd8mZYo9ZNEG7DjTPZSydjuSA+Lu90n4wffxLl5tK4u
	 ZJ26tYsc/Q1k1c8fdcCsdcJZBMjgC39ykdOhirGW97eKI2uJfFUdUSJLFa/SiVo1rx
	 yaSm8wGf9DrnsScOscmjTeVhbQlTF0HU+iLFqgYgYsvQjXeGEmsH6MNYU+4CqogFtm
	 O5OA6YqetqieTOwsqwo758HTtn5sfNrpIsZ2CxMHoFtV1qx3MmxbRJP37MN3a0num9
	 Kizas/apHeecLYBiS+D70jYQnW8A61DuB7XBSFBcucPgNMRXbeskRCXhksWuZ1WNAn
	 8OczmthvAdIlw==
Date: Fri, 9 May 2025 02:43:19 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: new tests for zoned xfs v3
Message-ID: <20250508184319.z66ln74lven4cqgh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250508053454.13687-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508053454.13687-1-hch@lst.de>

On Thu, May 08, 2025 at 07:34:29AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds the various new tests for zoned xfs, including testing
> data placement.
> 
> Changes since v2:
>  - generalize the rgroup number filtering helper
>  - add back the wp advance test

Thanks, this version is good to me now.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> Changes since v1:
>  - drop unneeded _cleanup routines
>  - drop _-prefixes for internal functions
>  - remove pointless sourcing of filters
>  - drop the last new test for now as it doesn't handle internal
>    RT device, it will be resent separately
> 
