Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ACC3290AA;
	Wed, 14 Oct 2026 15:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791993121; cv=none; b=awHrtOut0H6LVRIPBrD1ATqijqJhQD4FuGqsRTzlct7L98MNnY0udz30u2T8keaq10zrHVTvodTpEyUyaHDp4Z2YZrTb/VZA4xjfRLAH9GgVBXafp9ouQnM76BPNRFeKV2fVePTVo1YpWmo259pM1/OUMeK4U1IBKIHlnQ75RvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791993121; c=relaxed/simple;
	bh=jNrmjzjX4rKRGELywhWD1VlzYfdM4c6ynVPEKc54vFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZQIy2oiwBySMtqTmFfIOPxQGMdlkS/S00Fb91bPzdKvl4woqIXbNWjAdnSgCG20plc7KQzZblDY1k/IcF/Fz7WMcbqPrMWRvx/KrfAQYTNE85nepNlDt4gvr1ATGpo2GHFj7HyiH9L5kZfF8IQ6c1ykrXMbOt+usQlCbnjnO8h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARbtIXGa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARbtIXGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5358E1F000C5;
	Wed, 14 Oct 2026 15:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791993116;
	bh=43ZLBLfnvJxxKfR85LrlW5FckVxU489yT7vidGKuJm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ARbtIXGaZAA5ycXb4D0viNAyxvX/NhiAAPJhoRcJc1cgpT+BUu1Kdd8eFnUQ0pPvQ
	 QR0arnHgWJXORYq5kHyZOEUEhHMdGmoCgzQR0AqJKUPiVNb3IsRuHLyL3esIMTjb5P
	 +e3B9KhGDIEsYZstQUAs5fDQtivr7LHwiV2PX1h+lO6oQtJEaiaSjNEsdAAW5AiyuC
	 BKIW4g/MDhV9j+g+AJfEha1P7aoDzdgEFjGQZFJXuIkcbeltw+zz35QnhEo/NVhwu6
	 o5AToENQSIUuaNoYT4JrycCSB3i0+ekG7XZbriiBmWyaf5H3vGXvPHcIIy113jqZg/
	 j1s2Mr/38KuHQ==
Date: Wed, 14 Oct 2026 23:51:48 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, norbert@doyensec.com, aalbersh@kernel.org, qsa@qualys.com, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v2 1/2] fstests: new tests for old features
Message-ID: <as-kcrNLF-MrbDLU@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de, 
	norbert@doyensec.com, aalbersh@kernel.org, qsa@qualys.com, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org
References: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>

On Mon, Oct 12, 2026 at 05:08:39PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Here are some new tests for old features.
> 
> v2: various tweaks requested by reviewers

Thanks for sending a v2 to consolidate these scattered patches into a single
series. In that case, I'll drop the four patches I already applied and just
merge this series instead.

This version is still good to me,
Reviewed-by: Zorro Lang <zlang@kernel.org>

> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> --D
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests
> ---
> Commits in this patchset:
>  * generic: regression test for refluxfs fixes
>  * common/xfs: add zoned/rtstart info to mkfs filter output
>  * xfs: basic functional testing of media verification command
>  * xfs: test mkfs.xfs config file generation
>  * xfs: add regression test for exchangerange-to-eof reflux
>  * xfs: add regression test for swapext reflux
> ---
>  .gitignore                      |    3 
>  common/xfs                      |    3 
>  src/Makefile                    |    3 
>  src/refluxfs.c                  |  435 +++++++++++++++++++++++++++++++++++++++
>  src/xfs-exchange-to-dirty-eof.c |  210 +++++++++++++++++++
>  src/xfs-exchange-to-eof.c       |  168 +++++++++++++++
>  src/xfs-swapext-reflink.c       |  230 +++++++++++++++++++++
>  tests/generic/1956              |   58 +++++
>  tests/generic/1956.out          |    2 
>  tests/generic/1958              |  138 ++++++++++++
>  tests/generic/1958.out          |   11 +
>  tests/xfs/1908                  |  123 +++++++++++
>  tests/xfs/1908.out              |   28 +++
>  tests/xfs/1909                  |  163 +++++++++++++++
>  tests/xfs/1909.out              |    2 
>  tests/xfs/1939                  |   70 ++++++
>  tests/xfs/1939.out              |    2 
>  17 files changed, 1648 insertions(+), 1 deletion(-)
>  create mode 100644 src/refluxfs.c
>  create mode 100644 src/xfs-exchange-to-dirty-eof.c
>  create mode 100644 src/xfs-exchange-to-eof.c
>  create mode 100644 src/xfs-swapext-reflink.c
>  create mode 100755 tests/generic/1956
>  create mode 100644 tests/generic/1956.out
>  create mode 100755 tests/generic/1958
>  create mode 100644 tests/generic/1958.out
>  create mode 100755 tests/xfs/1908
>  create mode 100644 tests/xfs/1908.out
>  create mode 100755 tests/xfs/1909
>  create mode 100644 tests/xfs/1909.out
>  create mode 100755 tests/xfs/1939
>  create mode 100644 tests/xfs/1939.out
> 
