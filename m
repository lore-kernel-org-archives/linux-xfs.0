Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240EA4A387D;
	Wed, 14 Oct 2026 08:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966512; cv=none; b=eVO0RsW8L6Ua2kP5ZEH1MKlSTRIJmDTpEXuMwrv7QWIHPySIhaOx9L8XNnJaH4GAjviVSmWZIlRwow3vQyOwJHMlAG2lahiKFjcx5kgGinaztq8QsbyiUydzwknSv6oZnKrhqGCM/g4ZRt7bESg/XwoM3wXwShn6mxn1i1TtNw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966512; c=relaxed/simple;
	bh=/ghn7zXIqSN3lEft1xpnueQrhBGERBwTyAWLTwqzRKw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MtT5zTIk6ZGjInjIwpIzrPv9jETbzlO1/BNmhzg6GA6JgfAoxDpn1lxPXzosRGxxT0BNXNhtVBnKZuUpF5H2mKFuz+f6BXEJUwBvUbndYzEh+P9x8aq5JivbC6O2auyrAD3i7UYWzMLDCqmX+JjgGYX9BZx1wVXGaWc3O765VYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQ+N7hho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQ+N7hho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0B41F000FF;
	Wed, 14 Oct 2026 08:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791966510;
	bh=SMpDamsMbleqc5S2RX8KzTnCOiUmqSGhB3pK8yjFSP8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XQ+N7hhoFX/suTQqLDzL/t1cwQF4cswkMjPgHMSuUJN0GcvD+pa3oj721ikID7NFL
	 FwSrsfpn8TT0oHdUc0bTvNSEF26hgchWJS05VyDtEGIxpJcRi0XksALxRFCqPs14si
	 ogM0Tztb18h9e9QOkVJbS2QxE5GTrV24NE6Jo8c438D2trd7lewCKQ97rVTxB3/ZdK
	 mIE82i/zNtZ+G6CCperjYPETHNdexCsdzL418+w7Wb1+NOvAVV0mZLhXoRizADpsch
	 P126brRciESQPT19imVpJCCd8qMAGSAdCpwtOk28F48F6aQNbcLBEHG5ABVgCIfyl7
	 C/XCFtemxTBVg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v3] xfs: LLM-inspired bug fixes, part 21
Message-Id: <179196650947.20513.10827562354547303420.b4-ty@kernel.org>
Date: Wed, 14 Oct 2026 10:28:29 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 12 Oct 2026 08:20:30 -0700, Darrick J. Wong wrote:
> Here's a twenty-first batch of xfs fixes resulting from a LLaMma.  Mwa
> mwa mwa...
> 
> v2: fix various problems noted by reviewers and other lollms
>     refactor xattr entry checks into separate helpers
> v3: fix bugs that the buildbots and other lollm found
> 
> [...]

Applied to for-next, thanks!

[01/13] xfs: check for termination during rmap btree walk
        commit: 1fc241cdeab276dc6c3ec14840faa706ed7712ff
[02/13] xfs: don't subtract excess usage twice when computing agf_btreeblks
        commit: 4439b626fb5104204952aa2f169451688fb6be26
[03/13] xfs: abort directory tree repair whenever dl->aborted is set
        commit: 4582327e7068194d55941b49dd66be211b9e3f90
[04/13] xfs: reattach dquots after changing inode ids
        commit: 2f528e4a8f89daa6d0cc64b044f6f94c018fe9ae
[05/13] xfs: never reset the default quota timer
        commit: ddf4fe30c3fd7d37cf9bad3887ddb69984954cf4
[06/13] xfs: fix correction of unwritten extents in quota file data fork
        commit: 6f2792720673f569fa3e1f68181b9d6fd26802b5
[07/13] xfs: always report inode repair setup failures
        commit: ce9098338a7e1a77246684242d10779fc4d4a539
[08/13] xfs: range-check bc_levels array access in scrub tracepoints
        commit: 73b7276b8a4b5eb272f3c3b36ea3042e786f4741
[09/13] xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
        commit: fd012955641881169a9f01a00f656f6ca73842ec
[10/13] xfs: break out xattr entry checks into separate functions
        commit: 9eb04a6d41c7e474d4665118895c3c2d8e5a2741
[11/13] xfs: check for buffer overruns when examining local/remote xattr entries
        commit: 91c41f9524906a8ebd2ae68c98a07b4bd5255ddb
[12/13] xfs: clarify various parts of the bitmap API
        commit: 00f32fdf54983371d39162efef7df693e2842ffb
[13/13] xfs: complain loudly when dirtree checker finds broken links
        commit: e09438cab72c2c6a32665829d4186155346bfee8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

