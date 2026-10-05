Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105FA485936;
	Mon,  5 Oct 2026 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206851; cv=none; b=GKI/6i3NmjkoYLzhWlAaow4w1eDGhzKscXMselwfKt5C/gSUgHwM3gPLVdKxDP75k9TmnYRZIA9hpAe9JU0eXuLTwn8Ei3tvXDl3ATedTZA+e8vSOOhjp0dw7XjGHSoeCz8TCqrV14jH5ajioUbSJCxDdpgpmzQ2qhbF2ArbO+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206851; c=relaxed/simple;
	bh=hbapMfchkyUXX6egUrd58dTsgBOtj0q0eKFttl8ClN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=At/MTTlE7nP3Qgn3tlCkX5sbpEUwzhMLyNOXv+JV89NhcWJ7KPEU2hg0zKlzCc/OsU7pbcBjnI51Bebp7XiQlAAKjRalJa2KwOHZKBD6K/Ko1tIyunSXVpEznjTDrGrBy1BenmEBzM7t4BbL10n41agzvFAqjNB3vLTMS8/+0Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EA1968AFE; Mon,  5 Oct 2026 15:27:18 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:27:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs/2308: test rebuilding of csum files in
 xfs_repair
Message-ID: <20261005132718.GA29227@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-14-hch@lst.de> <20260929020357.GO2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929020357.GO2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 07:03:57PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 12:07:54PM +0200, Christoph Hellwig wrote:
> > Plus handling of corrupted csum files in the kernel as a side effect.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  tests/xfs/2308     | 47 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/2308.out |  4 ++++
> >  2 files changed, 51 insertions(+)
> >  create mode 100755 tests/xfs/2308
> >  create mode 100644 tests/xfs/2308.out
> > 
> > diff --git a/tests/xfs/2308 b/tests/xfs/2308
> > new file mode 100755
> > index 000000000000..5c4f647ced7a
> > --- /dev/null
> > +++ b/tests/xfs/2308
> > @@ -0,0 +1,47 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2026 Christoph Hellwig.
> > +#
> > +# FS QA Test No. 2308
> > +#
> > +# Corrupt rtcsum and check that scrub and different kinds of reads catch them.
> 
> Heh ok here's the real meat :D
> 
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick zone datacsum scrub
> > +
> > +. ./common/filter
> > +. ./common/fuzzy
> > +
> > +_require_scratch_nocheck
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +_require_xfs_data_csum $TEST_DIR
> > +
> > +cat /bin/sh > $SCRATCH_MNT/sh
> > +sync $SCRATCH_MNT
> > +
> > +rg=`xfs_bmap -v $SCRATCH_MNT/sh | _filter_bmap_gno`
> > +rg="${rg// /}"
> > +
> > +_scratch_unmount
> > +
> > +$XFS_DB_PROG -x $SCRATCH_DEV \
> > +	-c "path -m /rtgroups/$rg.csum" \
> > +	-c 'dblock 0' \
> > +	-c 'write csums[0] 4266'
> > +
> > +_scratch_mount
> > +$XFS_SCRUB_PROG -x -a 1 $SCRATCH_MNT >> $seqres.full 2>&1
> > +if [ $? -eq 0 ]; then
> > +	_fail "scrub did not find corruption"
> > +fi
> > +
> > +# Test buffered I/O
> > +$XFS_IO_PROG -c 'pread 0 64k' $SCRATCH_MNT/sh
> > +
> > +# Test direct  I/O
> > +$XFS_IO_PROG -d -c 'pread 0 64k' $SCRATCH_MNT/sh
> 
> Should this also run xfs_repair to make sure that it also notices the
> checksum validation errors?

xfs_repair does not validate checksums.  That would mean make it run
forever and is generally not helpful if people have corrupted file systems..

