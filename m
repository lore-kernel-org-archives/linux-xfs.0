Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568195C603
	for <linux-xfs@vger.kernel.org>; Tue, 25 Mar 2025 01:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742864942; cv=none; b=gKImXzhjeJkoi62WiXgCpkCmDFSpxvK7tDD7ODj6WWzImhby4pBEV9m39WS6Rq0ZzH7T6zxKqKkxYRjVrqliM4DIFSPulmVPFz6zXYRm1MeO4Uu8UgbohJ3tb+JaEcAVyfSO4qHbK0OiCuTjBwxK+Ax7bSgzAdplgLnwvFCRpVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742864942; c=relaxed/simple;
	bh=AoXEBNM8qlyrvabLs7alMP4mU2kwUYbCpFve2qq8Rmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXi7lcnA/3iTzEitPdkhRGigVzubx9ceR8OVYFLC0PjctgYk6yk2O+IZsPNxsdqTFi5hIXX0kUR2odsnoh2VNLc5qXvCKMMsEOwYN8M+NVmMkaVS1Lkm8d38JoMQK7JLqBVQ2N8ldZ+s1x9J0OFohczLLsvsKReyLDDolelx/GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KHEr2Wgs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KHEr2Wgs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742864939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jc8kkd+Po/9R8BZ1MWkO2uWiFFts8DpxhP92zezDh/o=;
	b=KHEr2WgsIsHl1MqvPmTCNPoWGgN7vFiVTCcvAzfPjsMqLSzA4CO5wxsVI+IFgwVwAv4Vgb
	gJOUOCdBY7QAGMo92UAcfoR48uAtT0uqHDiEoyaHJUkbj8BcsjczB+aKXG7pb2dQyxFUbp
	j02U2g2AvG1lINDReT7pbdIorIYW6n0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-OBGXdUXnPSOWpGArzoKcZg-1; Mon, 24 Mar 2025 21:08:56 -0400
X-MC-Unique: OBGXdUXnPSOWpGArzoKcZg-1
X-Mimecast-MFC-AGG-ID: OBGXdUXnPSOWpGArzoKcZg_1742864936
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22647ff3cf5so71250635ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Mar 2025 18:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742864935; x=1743469735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jc8kkd+Po/9R8BZ1MWkO2uWiFFts8DpxhP92zezDh/o=;
        b=mwHr0hNDP/lpPAdjSa0WQKjRkseFDnxjoDz9M6QxhsmKHGd/qY6zNUoYzQMWioXW2q
         CitJyoJz+xfMJqjhfNedvvyWQ2p+MuNcFYiseNH/OHg/nI70kRky3khtXhEgTFII9JzY
         KxgLXCJ/duBHCvlrNuGlE5UBu5DAdoW0Gz0y/qZkzEYTW0xBsjZAqrzN08a/WcctM+in
         N/mSJfK5fMP3h2+Mj43YjDm2VXBwjhIlwpVqLEgfiOaOwJ6RYOqkCzb+iHWboKFusFo/
         k7zo5i5q4TeHMBv5yNuTW/7RjXfXIpfeiildywC2a5eZPnp9qg4iuexg0MsgXWossyCw
         RLww==
X-Forwarded-Encrypted: i=1; AJvYcCUADSlBH4epb2BrLFw29n8029mSe63Wsbi7700+mePFQbJDAm3P4RyA3iWAltfUaPAummwVl18TlmY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVL0AWbbRMVIecXZlBvnVNBnBh8janbfyxLqmtL44vmzVGaHt7
	FqyyJoDiTP4JsmvfggGZ/E0y/ssnzd0m/0+RaPZraduljUCMTttnrED8yTlsJvI0Nwt7kam1Rew
	CJL7YCOnrd6hqUVKt00dzcfUHGe4ah7eQTu0dDWcroNUqldyjhxPClbLAMw==
X-Gm-Gg: ASbGncsVXbiI/5OCCKuoApaD364si+CnWegjXimtrMbQWn30IOJjHGBQG0f62PNtuZo
	1wcIwxdGzbInt5tIu7hBGCZ+QaVmkainDMp74XGM8EC42sNSeEg0OtDU8LHbFPjmfbuSSuolEpQ
	dUmQECapBTIQU09MkK9I3mNa4pVbfNbGyXA4vrq75stApvk8/yisYqg6zKDKTNwuebVf7lmsLe9
	f2aWblj5eI/8/pmRVU5y4662QklYLpDGqi1ouE6MLEy+MLL4SI45M6kmzSyPVL4NyaHVSO7jbl/
	wn+lltr1+BiKZ7efkPaXs7CpJ9Ustxp68qDD+68Mf9ktpw2NNxoxwHLj
X-Received: by 2002:a17:902:ce03:b0:21f:4c8b:c4de with SMTP id d9443c01a7336-22780e177edmr225816275ad.42.1742864935412;
        Mon, 24 Mar 2025 18:08:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGatp1fedHP+j0kn5FprA43zJb4lxLlnVZztlZG0MCsiByJ48JhR3vea2fagRWuGbxmyC74Ew==
X-Received: by 2002:a17:902:ce03:b0:21f:4c8b:c4de with SMTP id d9443c01a7336-22780e177edmr225815725ad.42.1742864934759;
        Mon, 24 Mar 2025 18:08:54 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811bb0dfsm77682625ad.108.2025.03.24.18.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 18:08:54 -0700 (PDT)
Date: Tue, 25 Mar 2025 09:08:51 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test filesystem recovery with rdump
Message-ID: <20250325010851.3lzh3wclopjpygso@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <174259233514.743419.14108043386932063353.stgit@frogsfrogsfrogs>
 <174259233533.743419.11473495762149004746.stgit@frogsfrogsfrogs>
 <20250322200429.7xtqnvss64qbt4ib@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20250325005026.GI4001511@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325005026.GI4001511@frogsfrogsfrogs>

On Mon, Mar 24, 2025 at 05:50:26PM -0700, Darrick J. Wong wrote:
> On Sun, Mar 23, 2025 at 04:04:29AM +0800, Zorro Lang wrote:
> > On Fri, Mar 21, 2025 at 02:27:07PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Test how well we can dump a fully populated filesystem's contents.
> > > 
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  tests/xfs/1895     |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/1895.out |    6 ++
> > >  2 files changed, 159 insertions(+)
> > >  create mode 100755 tests/xfs/1895
> > >  create mode 100644 tests/xfs/1895.out
> > > 
> > > 
> > > diff --git a/tests/xfs/1895 b/tests/xfs/1895
> > > new file mode 100755
> > > index 00000000000000..18b534d328e9fd
> > > --- /dev/null
> > > +++ b/tests/xfs/1895
> > > @@ -0,0 +1,153 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2025 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 1895
> > > +#
> > > +# Populate a XFS filesystem, ensure that rdump can "recover" the contents to
> > > +# another directory, and compare the contents.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto scrub
> > > +
> > > +_cleanup()
> > > +{
> > > +	command -v _kill_fsstress &>/dev/null && _kill_fsstress
> > 
> > I'm wondering why you always do "command -v _kill_fsstress &>/dev/null" before
> > _kill_fsstress, isn't _kill_fsstress a common helper in common/rc ?
> 
> Yeah, I probably copy-pasta'd that from common/preamble.  Will remove it
> before the next posting, assuming you don't decide to fix+merge it.

I can "fix+merge" that:) if you don't have more changes, except:

  - command -v _kill_fsstress &>/dev/null && _kill_fsstress
  + _kill_fsstress

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > +	cd /
> > > +	test -e "$testfiles" && rm -r -f $testfiles
> > > +}
> > > +
> > > +_register_cleanup "_cleanup" BUS
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/populate
> > > +. ./common/fuzzy
> > > +
> > > +_require_xfs_db_command "rdump"
> > > +_require_test
> > > +_require_scratch
> > > +_require_scrub
> > > +_require_populate_commands
> > > +
> > > +make_md5()
> > > +{
> > > +	(cd $1 ; find . -type f -print0 | xargs -0 md5sum) > $tmp.md5.$2
> > > +}
> > > +
> > > +cmp_md5()
> > > +{
> > > +	(cd $1 ; md5sum --quiet -c $tmp.md5.$2)
> > > +}
> > > +
> > > +make_stat()
> > > +{
> > > +	# columns:	raw mode in hex,
> > > +	# 		major rdev for special
> > > +	# 		minor rdev for special
> > > +	# 		uid of owner
> > > +	# 		gid of owner
> > > +	# 		file type
> > > +	# 		total size
> > > +	# 		mtime
> > > +	# 		name
> > > +	# We can't directly control directory sizes so filter them.
> > > +	# Too many things can bump (or not) atime so don't test that.
> > > +	(cd $1 ; find . -print0 |
> > > +		xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n' |
> > > +		sed -e 's/ directory [1-9][0-9]* / directory SIZE /g' |
> > > +		sort) > $tmp.stat.$2
> > > +}
> > > +
> > > +cmp_stat()
> > > +{
> > > +	diff -u $tmp.stat.$1 $tmp.stat.$2
> > > +}
> > > +
> > > +make_stat_files() {
> > > +	for file in "${FILES[@]}"; do
> > > +		find "$1/$file" -print0 | xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n'
> > > +	done | sed \
> > > +		-e 's/ directory [1-9][0-9]* / directory SIZE /g' \
> > > +		-e "s| $1| DUMPDIR|g" \
> > > +		| sort > $tmp.stat.files.$2
> > > +}
> > > +
> > > +cmp_stat_files()
> > > +{
> > > +	diff -u $tmp.stat.files.$1 $tmp.stat.files.$2
> > > +}
> > > +
> > > +make_stat_dir() {
> > > +	find "$1" -print0 | \
> > > +		xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n' | sed \
> > > +		-e 's/ directory [1-9][0-9]* / directory SIZE /g' \
> > > +		-e "s| $1| DUMPDIR|g" \
> > > +		| sort > $tmp.stat.dir.$2
> > > +}
> > > +
> > > +cmp_stat_dir()
> > > +{
> > > +	diff -u $tmp.stat.dir.$1 $tmp.stat.dir.$2
> > > +}
> > > +
> > > +FILES=(
> > > +	"/S_IFDIR.FMT_INLINE"
> > > +	"/S_IFBLK"
> > > +	"/S_IFCHR"
> > > +	"/S_IFLNK.FMT_LOCAL"
> > > +	"/S_IFIFO"
> > > +	"/S_IFDIR.FMT_INLINE/00000001"
> > > +	"/ATTR.FMT_EXTENTS_REMOTE3K"
> > > +	"/S_IFREG.FMT_EXTENTS"
> > > +	"/S_IFREG.FMT_BTREE"
> > > +	"/BNOBT"
> > > +	"/S_IFDIR.FMT_BLOCK"
> > > +)
> > > +DIR="/S_IFDIR.FMT_LEAF"
> > > +
> > > +testfiles=$TEST_DIR/$seq
> > > +mkdir -p $testfiles
> > > +
> > > +echo "Format and populate"
> > > +_scratch_populate_cached nofill > $seqres.full 2>&1
> > > +_scratch_mount
> > > +
> > > +_run_fsstress -n 500 -d $SCRATCH_MNT/newfiles
> > > +
> > > +make_stat $SCRATCH_MNT before
> > > +make_md5 $SCRATCH_MNT before
> > > +make_stat_files $SCRATCH_MNT before
> > > +make_stat_dir $SCRATCH_MNT/$DIR before
> > > +_scratch_unmount
> > > +
> > > +echo "Recover filesystem"
> > > +dumpdir1=$testfiles/rdump
> > > +dumpdir2=$testfiles/sdump
> > > +dumpdir3=$testfiles/tdump
> > > +rm -r -f $dumpdir1 $dumpdir2 $dumpdir3
> > > +
> > > +# as of linux 6.12 fchownat does not work on symlinks
> > > +_scratch_xfs_db -c "rdump / $dumpdir1" | sed -e '/could not be set/d'
> > > +_scratch_xfs_db -c "rdump ${FILES[*]} $dumpdir2" | sed -e '/could not be set/d'
> > > +_scratch_xfs_db -c "rdump $DIR $dumpdir3" | sed -e '/could not be set/d'
> > > +
> > > +echo "Check file contents"
> > > +make_stat $dumpdir1 after
> > > +cmp_stat before after
> > > +cmp_md5 $dumpdir1 before
> > > +
> > > +echo "Check selected files contents"
> > > +make_stat_files $dumpdir2 after
> > > +cmp_stat_files before after
> > > +
> > > +echo "Check single dir extraction contents"
> > > +make_stat_dir $dumpdir3 after
> > > +cmp_stat_dir before after
> > > +
> > > +# remount so we can check this fs
> > > +_scratch_mount
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/1895.out b/tests/xfs/1895.out
> > > new file mode 100644
> > > index 00000000000000..de639ed3fc7e38
> > > --- /dev/null
> > > +++ b/tests/xfs/1895.out
> > > @@ -0,0 +1,6 @@
> > > +QA output created by 1895
> > > +Format and populate
> > > +Recover filesystem
> > > +Check file contents
> > > +Check selected files contents
> > > +Check single dir extraction contents
> > > 
> > 
> > 
> 

