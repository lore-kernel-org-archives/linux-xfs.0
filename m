Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6991990B7;
	Thu, 19 Dec 2024 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629280; cv=none; b=KSinItshC3KWjZ7cP84m5OdJ98dkUC/ux/hMW6HFW7QDpNSdJQyne+CvMqm0GaUqfCpf98jzJjbALoVKMwt/fCxqfyqysV/UmsZ0a9mMIOAjcnGDbC1P3kYd7VwVfDmpWPPGFLy8SLIQGEo6oSExsgM+79pjgYYmz759lencrdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629280; c=relaxed/simple;
	bh=o7ForNynE78F162mr8QRnmgLZhC+AZAHF6DjmvTWTH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDZ2hJHoTD//5TW/9g7Gn1YMCW6PAGklcPenRy064ai6WA7UW6dlw0ZRxgr7JjdjP0se3a444b1DpRwX5xJkPzdN58AQlHDnX8c6X0uJXXIXwNEBUDtJAxpApEbeNylXVeOPFtJ8kEKLMfT0OPB7aFeNhkpvMw4/LthWjwM0fj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncJIU8zn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncJIU8zn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86806C4CECE;
	Thu, 19 Dec 2024 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734629279;
	bh=o7ForNynE78F162mr8QRnmgLZhC+AZAHF6DjmvTWTH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ncJIU8znOQh3L1HIzUK5cnPBin6+zw7WdCPPmJT55TcM2QvkFrkLbMwpYQiWMOjFP
	 mPOC0oxbHK3dAVGCQlOI0NhBcxVbC/xm484v/XeIG5urupMLLaMPwKYpsvDS5uIv0w
	 lnh2A4phfxQudb3UcI7VPoHSzGDGDDSlSqa7sxJWD0gQ3k0eQ6s3BZHGXt6Ebtk1ia
	 kIlNYN/dEu9SIF/Qfn3kph1x0TMb55e9FziNoD3kHH4MPeZJfw1IxqB7E2rbTn2u19
	 J6Aqdz+m5Z+3+Q7aTRtlvnrH/spuY0i7w0IQTFJIBLNtDmUh00AFB5s42n+IBe38CM
	 WrrulegeupxmQ==
Date: Thu, 19 Dec 2024 09:27:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v3] fstests: random fixes for v2024.12.01
Message-ID: <20241219172759.GF6160@frogsfrogsfrogs>
References: <173328389984.1190210.3362312366818719077.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173328389984.1190210.3362312366818719077.stgit@frogsfrogsfrogs>

Any review comments?

--D

On Tue, Dec 03, 2024 at 07:45:43PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Here's the usual odd fixes for fstests.  Most of these are cleanups and
> bug fixes that have been aging in my djwong-wtf branch forever.
> 
> v2: Now with more cleanups to the logwrites code and better loop control
>     for 251, as discussed on the v1 patchset.
> v3: Add more acks, kick out some of the logwrites stuff, add more
>     bugfixes.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> ---
> Commits in this patchset:
>  * xfs/032: try running on blocksize > pagesize filesystems
>  * xfs/43[4-6]: implement impatient module reloading
> ---
>  common/module |   11 +++++++++++
>  tests/xfs/032 |   11 +++++++++++
>  tests/xfs/434 |    2 +-
>  tests/xfs/435 |    2 +-
>  tests/xfs/436 |    2 +-
>  5 files changed, 25 insertions(+), 3 deletions(-)
> 
> 
