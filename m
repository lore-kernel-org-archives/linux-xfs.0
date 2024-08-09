Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9972117556C
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 08:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723191979; cv=none; b=crFWhElpaoXMaDOAB7vMx3nXf679fNRWMWn7l3O9bv+sjzM8kbumHJhX2hN+lG5J5rgjWQqPRQedXL7p3N27KryKv7JXKRkie6OWXv9kHwZ7BceYJk7+Obb1N+2ZMaxK6SprvLI/4mWktx/cRCZBHBqnZjHQm770CA9K0mlzL5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723191979; c=relaxed/simple;
	bh=JWsATuTiWoMpIeZ4YUPEPhlhmZYalD0BOQZh1MT1xZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/w0xQ0RPESZzWLkn5H+Jcnh5gszCprGC5mR6GPYdhCnqdgGDIGigrKXjAC7uapnuUNNiYukH47nrq0cKL+A0uS1q2MUg2+BJbQuxmQSC5L1xyPGZsoYP2xhDWATqMwwnOraZvFoIeNvY6NvInTpeunKR/X8vGoM3ZGP40ykrLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfdytXAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfdytXAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397C2C32782;
	Fri,  9 Aug 2024 08:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723191979;
	bh=JWsATuTiWoMpIeZ4YUPEPhlhmZYalD0BOQZh1MT1xZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NfdytXApFtU8U/ifq8LMXyttlWZldNe1vfmSWyLAFvqzLgetwE5wkaz09rXLyyscG
	 ipNpMtrs4dWKMsgy+xbvkj+inlo2vv3tGFh6oAqLtvHD1fZLuo8hMlryBVCmOLxtPh
	 9C5NuCL7+zeQXbHmr1MQijEtxFTjxLZGKbemCEf1b51sd2SGB68XkUfohrDIgGmGe9
	 fC9CPcWc2xBUsKiFtT4rIy8Rhlues8qV4B8QZDo9VL/gMQ/u/MYscnYOvFTwFGfjOH
	 tumxgun/0vw+xqdAEZqn2B8O7if/1KC5ySVRxop3m4m4tGtmfvGjL3tTfk/gCOEiFd
	 HD3BUZvMiApwQ==
Date: Fri, 9 Aug 2024 10:26:15 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [GIT PULLBOMB] xfsprogs: catch us up to 6.10, part 2
Message-ID: <hjwogxs34uq2pb2vjd6b7avyymh43dpojhosf47mwoebl6a26j@szv4fvxg6esp>
References: <20240808164615.GP6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808164615.GP6051@frogsfrogsfrogs>

On Thu, Aug 08, 2024 at 09:46:15AM GMT, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull these last two patchsets for xfsprogs 6.10.  With this
> merge, online repair will be done at last.  Time to move on to
> performance tweaks and bug fixes!

Pulled into my for-next, thanks!

I'll push those along the day.

Carlos

> 
> --D
> 
