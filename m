Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C215037143;
	Wed, 19 Jun 2024 16:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718814489; cv=none; b=Ys5PqSzLqMZENcJaqaUQ9GcKtZqRzIDfYkFJdeRHyKTr16Lv1K/iRRZWchzVJ3MsfjVwi77J2EIhiy3bpEGBdUC0D+8pzLzFtdrgD3D77124CYc15O/EcfSV877ubFTSkxLo8C6VckznJNVTRqoLXZdE/r1MVsmZttxFou1diOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718814489; c=relaxed/simple;
	bh=wCoNiNM2jQ/vFYcy9WY1WTVI39nYv67Lkzc8iHcS2nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJbAiFmpiL0Wgt+TkbbKmTr+ksz190mbGyWvDcg3bnfnYOm6SRElclNsr9R4Z+fZq9Z8emnRjwJPiJZUKRLZctOnyRJtdMZiYO19r/SzJBhmfa/WikRjLT/b2b6vb61gXJ3I1o6Nbl4gHpniQX1UuaITtMJi19OYH66XOOlvVJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfMiPqEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfMiPqEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3DAC2BBFC;
	Wed, 19 Jun 2024 16:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718814489;
	bh=wCoNiNM2jQ/vFYcy9WY1WTVI39nYv67Lkzc8iHcS2nw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WfMiPqEWHHs7m26ch5FoHS4l8MKVhfVbCCaYZYHDl3A4A/fW97XLFnrgi0r4E59kn
	 Xbsve3W7mftXRDM9A7At4G7Ci+Hf2OJ4yWXIw04bAyiE+RlwK8m8L1VUws8E1NqcsY
	 odCqW8us+KN5zH+ewRrVrO4n9BfXaLVFb+Xo1ZvXzSW13Z0vTboKQalE2krUFQ9Hp3
	 L4lH2oZwIpeh0VhiaM0qqgMNkaKn4esiuOBUl9wj1vEGKEf1xLV7zEglhOMX4+pTTj
	 TVblKlX8RJBRJSENq4Fz0I7gXtujrPBorZVLVfcKB1SEcr7g2vOGykdkhnv+CQxblN
	 BFEW36G03sB+A==
Date: Wed, 19 Jun 2024 09:28:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test scaling of the mkfs concurrency options
Message-ID: <20240619162808.GL103034@frogsfrogsfrogs>
References: <171867144916.793370.13284581064185044269.stgit@frogsfrogsfrogs>
 <171867144932.793370.9007901197841846249.stgit@frogsfrogsfrogs>
 <ZnJ5mfiqfnur5lFc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnJ5mfiqfnur5lFc@infradead.org>

On Tue, Jun 18, 2024 at 11:24:25PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 17, 2024 at 05:46:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make sure that the AG count and log size scale up with the new
> > concurrency options to mkfs.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/1842             |   55 ++++++++++++++
> >  tests/xfs/1842.cfg         |    4 +
> >  tests/xfs/1842.out.lba1024 |  177 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1842.out.lba2048 |  177 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1842.out.lba4096 |  177 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1842.out.lba512  |  177 ++++++++++++++++++++++++++++++++++++++++++++
> >  6 files changed, 767 insertions(+)
> >  create mode 100755 tests/xfs/1842
> >  create mode 100644 tests/xfs/1842.cfg
> >  create mode 100644 tests/xfs/1842.out.lba1024
> >  create mode 100644 tests/xfs/1842.out.lba2048
> >  create mode 100644 tests/xfs/1842.out.lba4096
> >  create mode 100644 tests/xfs/1842.out.lba512
> > 
> > 
> > diff --git a/tests/xfs/1842 b/tests/xfs/1842
> > new file mode 100755
> > index 0000000000..8180ca7a6e
> > --- /dev/null
> > +++ b/tests/xfs/1842
> > @@ -0,0 +1,55 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 1842
> > +#
> > +# mkfs concurrency test - ensure the log and agsize scaling works for various
> > +# concurrency= parameters
> > +#
> > +. ./common/preamble
> > +_begin_fstest log metadata auto quick
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.* $loop_file
> > +}
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +
> > +_require_test
> > +_require_loop
> > +$MKFS_XFS_PROG 2>&1 | grep -q concurrency || \
> > +	_notrun "mkfs does not support concurrency options"
> > +
> > +test_dev_lbasize=$(blockdev --getss $TEST_DEV)
> > +seqfull=$0
> > +_link_out_file "lba${test_dev_lbasize}"
> 
> This should probably check for an lba size that doesn't have valid
> golden output instead of having a weird failure case?  Not really
> an issue right now, but it will be one with the large lba size work.

Weird failure case?  If we don't have an output file to link, fstests
spits out:

1842.lba268433408: could not setup output file

That said, Bill's patch to fix u64 truncation in the log concurrency
computation means the .out files in this patch are buggy, so I'll respin
this patch.

--D
