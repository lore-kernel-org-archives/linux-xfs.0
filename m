Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EA51AC44D
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 06:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765347786; cv=none; b=VbPlXqoo2qA1LfZFXXSs+y17OSq7sqAZhZrjL52A0mFIecDzMahfx2/qjC24//QMj2cgg5rBCeBHLQHfY9ObJbrAQ4o4gWd3QYarXcu8jLmunVYuQyNXrt5FpzrK0QAlEYgO8F9si78PLOCdFuaig7K3UOkx+QDRtfQZ96nJLBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765347786; c=relaxed/simple;
	bh=CzeYhWmaVgW2sMHLHT/hbS0eL5eNlsEhlKuX12bKFEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fs3j5fozaUnaaw69bVG88r8vuX7lxQHfzQODp+2fZCVS3dzkyXoeBaUhFYeU17WQpSPjFK2HVKmRq+Nb6TQQWXgTbaZv4p40QwmkrUv89eXWJ+/elY3qn5I5ySwKA19KLcbnCkpFBhH8Mupqed0+p/zYhMvNFse09k3KtkuCs9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enE8+Kl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enE8+Kl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431F2C4CEF1;
	Wed, 10 Dec 2025 06:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765347786;
	bh=CzeYhWmaVgW2sMHLHT/hbS0eL5eNlsEhlKuX12bKFEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=enE8+Kl/7WdFaK6/xnq7doaTI6ea/t23NOhR3R7QYP8ikWdMdbnGWAN4kA7LxYYdl
	 X3a6CiKMkUzABSG6d+EVoJC8GZgLXFuqHQrzz93iWx4HoIDeLKZs/p1q4nycIcm7B1
	 HSDDQ3S+IOjFEieT1fQrgx/WMa2F/zwRY3eX1AFKRGsg5vSTFDHaGt85IPtmL9omGA
	 09neSHdOJy2r+f4+b1mm6l5fN/LIeUvDBwBOiQVwDmmuWAlhHj2MpNBgYSSIYzg4ry
	 wYlF6PX/PE9SVDX/3iSwEyzkZB08CLdSuuzJ0MAWEMFqECAuPuXP0FYCCrzuEibYaf
	 XwOVNmqyoM7Iw==
Date: Tue, 9 Dec 2025 22:23:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: Good name for xfs.h/libxfs_priv.h in libxfs
Message-ID: <20251210062305.GB7753@frogsfrogsfrogs>
References: <20251202133723.1928059-1-hch@lst.de>
 <aTFOsmgaPOhtaDeL@dread.disaster.area>
 <20251210060848.GA31741@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210060848.GA31741@lst.de>

On Wed, Dec 10, 2025 at 07:08:48AM +0100, Christoph Hellwig wrote:
> Trying to bring this up again.  I want a common name for
> xfs.h/libxfs_priv.h so that sharing libxfs code is easier.
> 
> My initial proposal was xfs_priv.h, which Dave didn't like for a valid
> reason.  His counter proposal was to just use xfs_linux.h, which is
> fine with me.  Another option would be xfs_plaform.h to be more system
> independent.  Both are fine with me, as is any other reasonable option.
> 
> I've added our regulars to ask if there are any strong preferences
> or dislikes for any of the names, or a suggestion for an even better
> one.

No strong preference here, xfs_platform.h is fine with me.

--D
