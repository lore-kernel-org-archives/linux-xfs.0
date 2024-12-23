Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C4B61FFE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989345; cv=none; b=JlsSkznbbuKBGmYiD3E3uI0h8rGC6WxHhvxTAfm5y8mieQOWSkL9o5PqvMvFOc68P63+DWZTOQOV8pn3VWdSSgkYYGg16yCt+yCAFUNGIp7FowXLY1ZJFMhBo3uZ0lzrfnyK9IC/+5jgqZFOgx7ImwR5T8hSgt+Ea1XNFzkk/sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989345; c=relaxed/simple;
	bh=/3EcpcD+F/FIqyqXwEAxxalsgxlJLABLTCiMXa0yXH4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KS90mL6GUeAc3rs+BaOy1XSCRtMTFsGO6zcTML8QPh3mVSmbz9p3voiwHVItWu9FTsNmi+ecEWClr6gg+yupKPgCwUN+9pqVNJfYSWo/I++5ABSzovP/btoDEdwDcSWgTR6ya86FpkeduG+T4setlzQkYU8QMVrOs30CkZ4xk94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rynmjPme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rynmjPme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D667C4CED3;
	Mon, 23 Dec 2024 21:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989345;
	bh=/3EcpcD+F/FIqyqXwEAxxalsgxlJLABLTCiMXa0yXH4=;
	h=Date:From:To:Cc:Subject:From;
	b=rynmjPmeTdhKvqQ0RjOuS8dNARFp5OxAX7lD6ICTP8rwu/nsG07fStd7Bm0OAoggD
	 eUYV7fEZWxPBenWjepZFVuFE3ULyV9fNMsddUTsbOtthLDCk1uo6L7meo7t66S6YdW
	 v67ggQebOqnXXDqQMOMBKl+RaAy1WkdVolaah6UGx7h60C8uQFb6DyBCl0fj8lO+qV
	 0ye0Az1uimb6dVBBsiP6S6jjrYfLZSWAo5O7CU9K/p232g7X0Ckbp+AWs9Y9e4a5Uc
	 gkkmdrs9C9SVXLOgYkvlC2KluizmvoQHx9SKxd++SrYTieLmDuvSxTHQIUS0aP03sr
	 H23CWqZ4JFi2g==
Date: Mon, 23 Dec 2024 13:29:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB v6.2] xfsprogs: metadata directories and realtime groups
Message-ID: <20241223212904.GQ6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey,

This patchbomb completes the review of userspace support for the
metadata directory tree and realtime allocation group code that was
merged into kernel 6.13-rc1.  I now submit this for xfsprogs 6.13.

As with last time, I'm presenting the libxfs sync for 6.13 a bit
differently than I've done traditionally.  Whereas I usually do all the
kernel sync and only then go to work on the surrounding utilities, I
noticed that the conversion of xfs_perag to be a subclass of generic
xfs_group objects and the introduction of xfs_rtgroup objects causes a
lot of changes in the utilities.

As a result, I decided that it'd be easier to take care of the libxfs
sync for only the metadata directory tree code and the utility changes
*before* moving on to the allocation groups restructuring.  That's why
there are nine patchsets instead of five.  I hope that makes it easier
to tackle.

Note that this is /not/ the last code I intend to submit for xfsprogs
6.13 -- I found a few more bugs while examining Christoph's zoned
storage support code and will submit those when I return from vacation.
This patchbomb merely covers everything that is ready for merge.

As always, you can browse / pull the branch from here:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas_2024-12-23

--D
