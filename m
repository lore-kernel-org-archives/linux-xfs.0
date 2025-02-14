Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE0188713;
	Fri, 14 Feb 2025 13:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739540220; cv=none; b=fpYt3J4NR0bwLAT/0uBrnBJitJGf3nNJihSsJnhh9f9/96168iuGLBWbrC3WOWP4lZcmKd/2y3CSTuFVFdnyQftB+Ubanq8d1agQpDAnPGJnGIazwyBpeUZxdc6QY/0QK/7504hRqHauPUGtLgAfaSenKAhPOAswBxPaE4tm05Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739540220; c=relaxed/simple;
	bh=583K14ihYPs7s9bkquTFFzsz3XER8F4uZKQtK+ocAsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ouivVDn4SNHoV3iDLk4YS4a+NbGHYveGiHUxDvWs6KE4cyU8jegn3AxlptyKop6wHEjXl6G2ARxeu2FWiTcyGQlPAWw3G+Rh9nqFFT9eMWeK6e0+NwtjH3LdQCnN8BTUUiljpRoEOd6RoIJtAdcR/nNkOCQcmC3o7+Qu1Xl5WsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqsIgHpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqsIgHpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C433AC4CED1;
	Fri, 14 Feb 2025 13:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739540219;
	bh=583K14ihYPs7s9bkquTFFzsz3XER8F4uZKQtK+ocAsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xqsIgHpTFapERtnxOK5Q7wMBP0S+9V5fWII8f0M9pATCkf+kxQoOY2aRbVFUoMCdo
	 Pr9ev6ucnPhC9EJz8/pO8RDenfewrlEyyQjWuSq7BzB9dUilrUmq7W4xSw4U8qdbyX
	 oOBeuUjVLpqsf86e4xKMjs+b8UZGWfjlbV2KdIxo=
Date: Fri, 14 Feb 2025 14:36:56 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>, linux-xfs@vger.kernel.org,
	chandan.babu@oracle.com, "Darrick J. Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>, Wentao Liang <vulab@iscas.ac.cn>
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
Message-ID: <2025021448-ignition-aluminum-b304@gregkh>
References: <20250213142436.408121546@linuxfoundation.org>
 <CA+G9fYuVj+rhFPLshE_RKfBMyMvKiHaDzPttZ1FeqqeJHOnSbQ@mail.gmail.com>
 <CA+G9fYsVFoLTXYBqpeUN1VUTwy5kXTB82fztK62fMPR6tYxChA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsVFoLTXYBqpeUN1VUTwy5kXTB82fztK62fMPR6tYxChA@mail.gmail.com>

On Fri, Feb 14, 2025 at 05:59:40PM +0530, Naresh Kamboju wrote:
> On Fri, 14 Feb 2025 at 14:16, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Thu, 13 Feb 2025 at 20:02, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.12.14 release.
> > > There are 422 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Regressions on the arm64, powerpc builds failed with gcc-8/13 and clang
> > on the Linux stable-rc 6.12.14-rc1.
> >
> > Build regression: arm, powerpc, fs/xfs/xfs_trans.c too few arguments
> >
> > Good: v6.12.13
> > Bad:  6.12.14-rc1 (v6.12.13-423-gfb9a4bb2450b)
> 
> Anders bisected this to,
> # first bad commit:
>    [91717e464c5939f7d01ca64742f773a75b319981]
>    xfs: don't lose solo dquot update transactions

Offending commit now dropped, thanks.

greg k-h
