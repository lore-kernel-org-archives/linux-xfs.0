Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B301E4BF
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 12:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719145833; cv=none; b=VpgDAtXt2gieI0QG/BkyVebOBFITzr8cLg22uvLrhkpDCvBYEsZJAN5P/kYBXqBmhSjS7BkXx64Y41l/4K0PGEbIyy+vKCLBkt3pOkoZknW7nMFw6F3fS9GOvjjsFRfodSJlS2qRgW9yDIDL6DL7YwPJLHE1FKSI4wKDBnicqxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719145833; c=relaxed/simple;
	bh=o4Gp798G4LQROljPAp91bslqhNxP3LMAJNhWI4ZXnmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFY7woc/N72Lzz54n7wf+ic/t/07nukdP3azRtUVhH/aZ+6AlcDILMhKR0UhEEr+9g/ghxi2f0rOaPWGF01ttfGrqkAZsGW+/sz8Or4I7wPwWoKoLLPpgScOypul7g/dfVyuimT0+zvTXZ6G06+Mpl60v6NrwOrTWzPBl+GN0jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NUzNhS6e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NUzNhS6e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719145830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3xDHfGJIjxsQtrMCEa9w3wbTXGl+md9IvoOczoXJBo=;
	b=NUzNhS6esIyfOClLeRLo43kZpW37Pfk3i3s1UcGAEKztDc13lU4SmGPSldW2nPD97qPg+b
	O4AhdByWEGiRP7Z4fmcPuAOfcsIGU7AHbwwBMkMkStVNlP1MBm5l+FSUZI5uNJ+jeAK7aC
	I0VpTb4vwai3rLcKu+mXkRCW0zeQ9M0=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-5WMFd9kGOoOlqkRmRmHWyQ-1; Sun, 23 Jun 2024 08:30:28 -0400
X-MC-Unique: 5WMFd9kGOoOlqkRmRmHWyQ-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5bad2fe768bso4287959eaf.1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719145828; x=1719750628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3xDHfGJIjxsQtrMCEa9w3wbTXGl+md9IvoOczoXJBo=;
        b=iOVsfE1CzwW5NYVETR2tUSDyCk9ByC/S3vkDn+p99yJt0RBfAj7CTGWhi0mQqBgC3G
         Pjz43NJ4ZY7J8sDxLvaDBX572wKwg1i1+HAylhwiKhEKjC5J6W/6CTPggCYQPBgJ/PT+
         8MgPY/nOQjKFFvVlqdiVuf37iToRmtkmjFZgr+QdyE61BdPcdfvelu3KQ0fYV+2VRwM6
         fW23cKYbOuGq7Rd+nkrO1UuWJeu9iWg11OoUbf9DkkD095nFboSsNQeXDYGGRl4wzNF7
         aGZdi9iMS5W5THWyouLVn38lY3VwylIE8TKacvxT012dztSuv1XXPDdxvQLS9LcZ/pvJ
         7JMg==
X-Forwarded-Encrypted: i=1; AJvYcCVt2+re7BAqCTvb09f+eKEA+Wx8oU+aEWJKu5OspJNQw5vdSKYsvH7qYdIo0qesKUzI4TUp1MAVOccRrO6SKQodOl+d6NRtGEqk
X-Gm-Message-State: AOJu0Yz/SnADqCsHgmWEKU3CN+2JocTwts9j4nB+MxeAd1g1m6Ce2pSV
	jM5UcHLPJbcgjwnXdiP8BP34mWLZ2MJiGeSAWwVOujVfip5hfo3ishLZYoB6v0iFADYrcP08fDE
	8zDj3sE/UUayIWjMTXZDz8yIB7B0uoz0TemcaX+Kz5U0r0stegzynM5vXqA==
X-Received: by 2002:a05:6358:41a4:b0:1a1:fdee:fb61 with SMTP id e5c5f4694b2df-1a2389a5634mr367042955d.5.1719145827738;
        Sun, 23 Jun 2024 05:30:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHAfkEjwvQnkygAVFLhs3Qcj4vW5ucD+/FCfUE4lSYygzDsV3fUayPyCSxNd4j9BxepCfttA==
X-Received: by 2002:a05:6358:41a4:b0:1a1:fdee:fb61 with SMTP id e5c5f4694b2df-1a2389a5634mr367039855d.5.1719145827166;
        Sun, 23 Jun 2024 05:30:27 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-716b4a73183sm3237701a12.39.2024.06.23.05.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jun 2024 05:30:26 -0700 (PDT)
Date: Sun, 23 Jun 2024 20:30:23 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] generic/711,xfs/537: actually fork these tests for
 exchange-range
Message-ID: <20240623123023.mtralyfxocv2rq3h@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
 <171891669174.3034840.5584811354339983628.stgit@frogsfrogsfrogs>
 <20240621161437.wn44gerhegmzn2q2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240621174948.GG3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621174948.GG3058325@frogsfrogsfrogs>

On Fri, Jun 21, 2024 at 10:49:48AM -0700, Darrick J. Wong wrote:
> On Sat, Jun 22, 2024 at 12:14:37AM +0800, Zorro Lang wrote:
> > On Thu, Jun 20, 2024 at 01:55:06PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Fork these tests to check the same things with exchange-range as they do
> > > for swapext, since the code porting swapext to commit-range has been
> > > dropped.
> > > 
> > > I was going to fork xfs/789 as well, but it turns out that generic/714
> > > covers this sufficiently so for that one, we just strike fiexchange from
> > > the group tag.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/generic/1221     |   45 ++++++++++++++++++++++++
> > >  tests/generic/1221.out |    2 +
> > >  tests/generic/711      |    2 +
> > >  tests/xfs/1215         |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/1215.out     |   13 +++++++
> > >  tests/xfs/789          |    2 +
> > 
> > Shouldn't the "xfs/537" (in subject) be xfs/789? I'll change that when
> > I merge it.
> 
> No.  generic/711 is forked to become generic/1221, and xfs/537 is forked
> to become xfs/1215.  Maybe I should say that explicitly?

OK, I'll revert my change, and add this explanation. Thanks!

Thanks,
Zorro

> 
> "Fork these tests to check the same things with exchange-range as they do
> for swapext, since the code porting swapext to commit-range has been
> dropped.  generic/711 is forked to generic/1221, and xfs/537 is forked
> to xfs/1215.
> 
> "I was going to fork xfs/789 as well, but it turns out that generic/714
> covers this sufficiently so for that one, we just strike fiexchange from
> the group tag."
> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > >  6 files changed, 151 insertions(+), 2 deletions(-)
> > >  create mode 100755 tests/generic/1221
> > >  create mode 100644 tests/generic/1221.out
> > >  create mode 100755 tests/xfs/1215
> > >  create mode 100644 tests/xfs/1215.out
> > > 
> > > 
> > > diff --git a/tests/generic/1221 b/tests/generic/1221
> > > new file mode 100755
> > > index 0000000000..5569f59734
> > > --- /dev/null
> > > +++ b/tests/generic/1221
> > > @@ -0,0 +1,45 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0-or-later
> > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 1221
> > > +#
> > > +# Make sure that exchangerange won't touch a swap file.
> > > +
> > > +. ./common/preamble
> > > +_begin_fstest auto quick fiexchange
> > > +
> > > +# Override the default cleanup function.
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	test -e "$dir/a" && swapoff $dir/a
> > > +	rm -r -f $tmp.* $dir
> > > +}
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +
> > > +# real QA test starts here
> > > +_require_xfs_io_command exchangerange
> > > +_require_test
> > > +
> > > +dir=$TEST_DIR/test-$seq
> > > +mkdir -p $dir
> > > +
> > > +# Set up a fragmented swapfile and a dummy donor file.
> > > +$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 32m -b 1m' -c fsync $dir/a >> $seqres.full
> > > +$here/src/punch-alternating $dir/a
> > > +$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 32m -b 1m' -c fsync $dir/a >> $seqres.full
> > > +$MKSWAP_PROG $dir/a >> $seqres.full
> > > +
> > > +$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 32m -b 1m' $dir/b >> $seqres.full
> > > +
> > > +swapon $dir/a || _notrun 'failed to swapon'
> > > +
> > > +# Now try to exchangerange.
> > > +$XFS_IO_PROG -c "exchangerange $dir/b" $dir/a
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/1221.out b/tests/generic/1221.out
> > > new file mode 100644
> > > index 0000000000..698ac87303
> > > --- /dev/null
> > > +++ b/tests/generic/1221.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 1221
> > > +exchangerange: Text file busy
> > > diff --git a/tests/generic/711 b/tests/generic/711
> > > index b107f976ef..792136306c 100755
> > > --- a/tests/generic/711
> > > +++ b/tests/generic/711
> > > @@ -7,7 +7,7 @@
> > >  # Make sure that swapext won't touch a swap file.
> > >  
> > >  . ./common/preamble
> > > -_begin_fstest auto quick fiexchange swapext
> > > +_begin_fstest auto quick swapext
> > >  
> > >  # Override the default cleanup function.
> > >  _cleanup()
> > > diff --git a/tests/xfs/1215 b/tests/xfs/1215
> > > new file mode 100755
> > > index 0000000000..5e7633c5ea
> > > --- /dev/null
> > > +++ b/tests/xfs/1215
> > > @@ -0,0 +1,89 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 1215
> > > +#
> > > +# Verify that XFS does not cause inode fork's extent count to overflow when
> > > +# exchanging ranges between files
> > > +. ./common/preamble
> > > +_begin_fstest auto quick collapse fiexchange
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/inject
> > > +
> > > +# real QA test starts here
> > > +
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_xfs_debug
> > > +_require_xfs_scratch_rmapbt
> > > +_require_xfs_io_command "fcollapse"
> > > +_require_xfs_io_command "exchangerange"
> > > +_require_xfs_io_error_injection "reduce_max_iextents"
> > > +
> > > +echo "* Exchange extent forks"
> > > +
> > > +echo "Format and mount fs"
> > > +_scratch_mkfs >> $seqres.full
> > > +_scratch_mount >> $seqres.full
> > > +
> > > +bsize=$(_get_file_block_size $SCRATCH_MNT)
> > > +
> > > +srcfile=${SCRATCH_MNT}/srcfile
> > > +donorfile=${SCRATCH_MNT}/donorfile
> > > +
> > > +echo "Create \$donorfile having an extent of length 67 blocks"
> > > +$XFS_IO_PROG -f -s -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" $donorfile \
> > > +       >> $seqres.full
> > > +
> > > +# After the for loop the donor file will have the following extent layout
> > > +# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
> > > +echo "Fragment \$donorfile"
> > > +for i in $(seq 5 10); do
> > > +	start_offset=$((i * bsize))
> > > +	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
> > > +done
> > > +
> > > +echo "Create \$srcfile having an extent of length 18 blocks"
> > > +$XFS_IO_PROG -f -s -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" $srcfile \
> > > +       >> $seqres.full
> > > +
> > > +echo "Fragment \$srcfile"
> > > +# After the for loop the src file will have the following extent layout
> > > +# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
> > > +for i in $(seq 1 7); do
> > > +	start_offset=$((i * bsize))
> > > +	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
> > > +done
> > > +
> > > +echo "Collect \$donorfile's extent count"
> > > +donor_nr_exts=$(_xfs_get_fsxattr nextents $donorfile)
> > > +
> > > +echo "Collect \$srcfile's extent count"
> > > +src_nr_exts=$(_xfs_get_fsxattr nextents $srcfile)
> > > +
> > > +echo "Inject reduce_max_iextents error tag"
> > > +_scratch_inject_error reduce_max_iextents 1
> > > +
> > > +echo "Exchange \$srcfile's and \$donorfile's extent forks"
> > > +$XFS_IO_PROG -f -c "exchangerange $donorfile" $srcfile >> $seqres.full 2>&1
> > > +
> > > +echo "Check for \$donorfile's extent count overflow"
> > > +nextents=$(_xfs_get_fsxattr nextents $donorfile)
> > > +
> > > +if (( $nextents == $src_nr_exts )); then
> > > +	echo "\$donorfile: Extent count overflow check failed"
> > > +fi
> > > +
> > > +echo "Check for \$srcfile's extent count overflow"
> > > +nextents=$(_xfs_get_fsxattr nextents $srcfile)
> > > +
> > > +if (( $nextents == $donor_nr_exts )); then
> > > +	echo "\$srcfile: Extent count overflow check failed"
> > > +fi
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/1215.out b/tests/xfs/1215.out
> > > new file mode 100644
> > > index 0000000000..48edd56376
> > > --- /dev/null
> > > +++ b/tests/xfs/1215.out
> > > @@ -0,0 +1,13 @@
> > > +QA output created by 1215
> > > +* Exchange extent forks
> > > +Format and mount fs
> > > +Create $donorfile having an extent of length 67 blocks
> > > +Fragment $donorfile
> > > +Create $srcfile having an extent of length 18 blocks
> > > +Fragment $srcfile
> > > +Collect $donorfile's extent count
> > > +Collect $srcfile's extent count
> > > +Inject reduce_max_iextents error tag
> > > +Exchange $srcfile's and $donorfile's extent forks
> > > +Check for $donorfile's extent count overflow
> > > +Check for $srcfile's extent count overflow
> > > diff --git a/tests/xfs/789 b/tests/xfs/789
> > > index 00b98020f2..e3a332d7cf 100755
> > > --- a/tests/xfs/789
> > > +++ b/tests/xfs/789
> > > @@ -7,7 +7,7 @@
> > >  # Simple tests of the old xfs swapext ioctl
> > >  
> > >  . ./common/preamble
> > > -_begin_fstest auto quick fiexchange swapext
> > > +_begin_fstest auto quick swapext
> > >  
> > >  # Override the default cleanup function.
> > >  _cleanup()
> > > 
> > > 
> > 
> > 
> 

