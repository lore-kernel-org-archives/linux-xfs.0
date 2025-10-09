Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAEA35972
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 14:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760021865; cv=none; b=cXZR2/H3yaNhXnFGEQnQgB8Y+70Wvz3mMptJQcd7LIsgExw8CDXMGPAneFo2MT3Cr7ar0A61FuBj33LWjNvjFgGaZtywQSs6DMNb80tfFqvPRB3dC+a+bWPgNvcRTfWmVrn/sM/fSdF7eAAzmmYcpw8kehaQkLAt+q3g0k2cXjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760021865; c=relaxed/simple;
	bh=tdZdrH0F4Q41RA0HnicHJVi9HvGCt56J75Xz5i/63nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ptHxRU7TQpzGoRHiPUIxlLjQG6iNUXfdXAduoznB7H/x3dskPmzolDwHSBIXPmjuyuFEkVbvfZhs+IBCdEQ3gXlXn4fCJhJgDzftXAV/sqm8GiYQBW+kCu5pvCaVsdroRplOQmVtTrg8DFOvcmxAYK4TyeYGpGZFyG0TwQ0ymjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=th8vaMQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="th8vaMQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBF8C4CEE7;
	Thu,  9 Oct 2025 14:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760021865;
	bh=tdZdrH0F4Q41RA0HnicHJVi9HvGCt56J75Xz5i/63nc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=th8vaMQB7Mxi9Pz5uEdx59eTW/z5K1AOvCbG5rvwrkximlIugCOSMQN5Zqd8jqbu7
	 RocD6B5nPbGOo5G6bSOmDnhkZr5oGPk+7yNJXwChshQvEP2SWQk/Ec3U81L62UzTpw
	 UGeB2WKIob1QYxpbphUgKWLDb08jzl6QIE+mA4z1EKGRvWRSFb/TEwc/ijiE11qKHt
	 HnfCHUOFvNUQNGNS+cykgjMcgLZPpOBFNhVTbovoJyZ6Bec+WHGIjtKk5O02F46U8M
	 9M7atY1M4K4KdsNONe5rpTvTg66YqQ0wMM5JzinfjLeHRsyx1sot5qcBhZgpxhRh0D
	 gVrKLgjbgVgaA==
Date: Thu, 9 Oct 2025 07:57:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org,
	cmaiolino@redhat.com, hch@lst.de, pchelkin@ispras.ru,
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: Re: [PATCH v2 0/12] xfsprogs: libxfs sync v6.17
Message-ID: <20251009145745.GC6188@frogsfrogsfrogs>
References: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760011614.patch-series@thinky>

On Thu, Oct 09, 2025 at 02:08:24PM +0200, Andrey Albershteyn wrote:
> Hey all,
> 
> This is libxfs sync with v6.17.

Thanks for porting rcbag_btree.c to cmp_int! :)

and now for patches 3-4 you can add:
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  0 files changed, 0 insertions(+), 0 deletions(-)
> 
> 
> -- 
> - Andrey
> 
> 
