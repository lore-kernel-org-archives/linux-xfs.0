Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36241AF0D0;
	Tue, 31 Dec 2024 23:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735687504; cv=none; b=k1JUXZS/zHLXUIV8s45sfnSSnE9ANoJfEeBU547RDV8GyfJkFPZHNWzuFjJsbwTORpOc7d6BHLa4KMgRuG6LNSC61o9K2OD/gQ5f1jFZr9oz9Iew9ZTpTXS85PpA2XXBTT+dUzdeuek1IjOqHOWXyzHqr+dfxxmSdbKWXGUgSVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735687504; c=relaxed/simple;
	bh=xTdGOP/4tlJnYHWAhXgrFmS2k0XV0zsX5gx61KJyxQo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KKuu19FKzf2LnK4lbRU8QNOvSkw9KPxlv+7yO+iBTGKW1OLSXyTtQk0l4vNhE0YphpQ11+pTqJ/EIDx6jxJ33/CCVbd8W4RX+kkODKwTAO9xjAaQy3fR+yG0TaC3usT71G27STSaW53PSKFe678Ul03ykuVl1fU2LM3jB9EpjVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyVcZLt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyVcZLt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E608C4CED2;
	Tue, 31 Dec 2024 23:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735687504;
	bh=xTdGOP/4tlJnYHWAhXgrFmS2k0XV0zsX5gx61KJyxQo=;
	h=Date:From:To:Cc:Subject:From;
	b=eyVcZLt5vUWJZB3yAA0vAueAISCuizy2DlTn86AE9e4/G/gv9IDZWAU61HUyjySPo
	 AXFexjZXd9mSb/Qk+jKv4mWt6M64y/nVzdxWIaKFOUORGse8NKr3HXEJWAqqik7LRV
	 ROpZWivxbrgVZJmw5jfFXt0LbCsWOFdRUqpZ1hMOcx0lL8VxZMNZhIESSCR3MCdqe3
	 zREdi8Ngj9x05lOaUJjb0BwVmvKkE9DKKDJjHqo28UET9gRYEa/hS0f/TxuvaxohXb
	 FmZ/hi0Gtyad9x1I1VHVzl+AYo/H6dTGxzEB03qP56TVrmtKKTe8paBGiLEoQe4Imx
	 axgnnbo77KcSw==
Date: Tue, 31 Dec 2024 15:25:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>, Zorro Lang <zlang@redhat.com>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, greg.marsden@oracle.com,
	shirley.ma@oracle.com, konrad.wilk@oracle.com,
	fstests <fstests@vger.kernel.org>
Subject: [NYE PATCHCYCLONE] xfs: free space defrag and autonomous self healing
Message-ID: <20241231232503.GU6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Thank you all for helping get online repair, parent pointers, and
metadata directory trees, and realtime allocation groups merged this
year!  We got a lot done in 2024.

Having sent pull requests to Carlos for the last pieces of the realtime
modernization project, I have exactly two worthwhile projects left in my
development trees!  The stuff here isn't necessarily in mergeable state
yet, but I still believe everyone ought to know what I'm up to.

The first project implements (somewhat buggily; I never quite got back
to dealing with moving eof blocks) free space defragmentation so that we
can meaningfully shrink filesystems; garbage collect regions of the
filesystem; or prepare for large allocations.  There's not much new
kernel code other than exporting refcounts and gaining the ability to
map free space.

The second project initiates filesystem self healing routines whenever
problems start to crop up, which means that it can run fully
autonomously in the background.  The monitoring system uses some
pseudo-file and seqbuf tricks that I lifted from kmo last winter.

Both of these projects are largely userspace code.

Also I threw in some xfs_repair code to do dangerous fs upgrades.
Nobody should use these, ever.

Maintainers: please do not merge, this is a dog-and-pony show to attract
developer attention.

--D

PS: I'll be back after the holidays to look at the zoned/atomic/fsverity
patches.  And finally rebase fstests to 2024-12-08.
