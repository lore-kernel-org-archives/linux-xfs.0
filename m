Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959D717C215
	for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2024 14:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726842791; cv=none; b=hx3bPUm+Fz+r/qNxpGv8OjCH9e29mh92dWZ0/J2slpIcowocpwZbE0c+VceSfeqM2BdamigLQG1iW+R0KogUj8f2wJfkPwCo4KReKJ9kxNnIjRgKS0h1z0kpb2hRt7FAQ1KYEJUeJovrjMBkIQVzmgntBJHOUJ+VOvwNsGptP9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726842791; c=relaxed/simple;
	bh=gnmz5umYLpA7o/lZDwMbK4Xm4PY7Lqdp4gVDqPdWYko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjNqZKuo7ZKc8embYXcCDgWPM4nKph5bnTzuFlA6kAC/xyL3xjrRfXRcjjVqbMwv47LX04wqopRDFcZ7dCem78kQTFzoJJV0z3rGuUPjGOn9gMKhlZjlOcIECalYMW1exLOgUP9NkQ9/Rxo5fMrSJqdZeInBFB0+GUPYt7bUzTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=frrx6JQU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="frrx6JQU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726842788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IGFwFrdRXjoa0NWpFoM3WWC1rp72IK/F5wYMdb5S2G8=;
	b=frrx6JQU2d1+nRzjrahFNHW2Rm5BLC7a4grSOi8J+l7GzLClz0W5MmQyNrnKEBPvHp4hcp
	s+RjKvCyA/n5Thw4IsIJbsIxSBDAyQUbkAKdtr+UharKej1lS15WN+S4ptA+GGHC57HOOc
	F+S85uSZ0O62EAPFz/058zzPjd/yoxw=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-5WYKpMmrPMOvDHlGq3DWTg-1; Fri, 20 Sep 2024 10:33:07 -0400
X-MC-Unique: 5WYKpMmrPMOvDHlGq3DWTg-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-71791a81824so2130930b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2024 07:33:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726842786; x=1727447586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGFwFrdRXjoa0NWpFoM3WWC1rp72IK/F5wYMdb5S2G8=;
        b=ACkTxNuqWX2LUCznCOYK5JeUdeRR6AWKS32rc/LwiZZtkdCpNWm0hvg2iieu1JacsK
         yuaQB7pkfz5JLBnTegQyz9v00JiCGzsN9YmxMS+zQCKfGcM8FOiICt6lkay1IVeb6uYP
         ypvC4gu1/F8QAFC+L36uIphM4wRjeTNuvXOA38Fp2kuizLBnOPYxcJ+sjlwMLF/sdhao
         8xF0Un8MZ92NFnvaGkQV3H9Vcccc8OfllPOZ4bt/1P6PkavgfmS69Hs+BnlffCFJHV4F
         9pkTABmFc8nntWQvWEVJOQVaL7Prv12QlHVuosmNht3ToexTLIshF+baa+UsoCef6xo5
         AsXA==
X-Gm-Message-State: AOJu0YwCxc4s6XgEUYqv/hr28AOsBrigFlilUWm5pt4ikpeCX0LbyPze
	S5EfV9fQNzGogCPJN6bxOnGNxsykwX/HgJ0q+eR76KHo0mMa+HnBhox2Y60XS8z+EQ/UeWUyBCu
	xX1l6o2O4FB47D4Qd4w3331M+cGxW4XTDYSIp+ueR438glWQhvk5GZ/37iw==
X-Received: by 2002:a05:6a21:1690:b0:1cf:6c64:f924 with SMTP id adf61e73a8af0-1d30a9fb5aemr5088228637.38.1726842785956;
        Fri, 20 Sep 2024 07:33:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeBk+f293SfOmVAzDgEJIlBRFep8KzqDHB19OXrxUjweA3QZqB7ceRCGt8YF4Kxicj7NOL7g==
X-Received: by 2002:a05:6a21:1690:b0:1cf:6c64:f924 with SMTP id adf61e73a8af0-1d30a9fb5aemr5088183637.38.1726842785430;
        Fri, 20 Sep 2024 07:33:05 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944b7b636sm9902451b3a.129.2024.09.20.07.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2024 07:33:05 -0700 (PDT)
Date: Fri, 20 Sep 2024 22:33:01 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] generic: add a regression test for sub-block fsmap
 queries
Message-ID: <20240920143301.xbauye2osxxz3zao@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <172669301283.3083764.4996516594612212560.stgit@frogsfrogsfrogs>
 <172669301299.3083764.15063882630075709199.stgit@frogsfrogsfrogs>
 <20240919200703.xyn5tqv5knqzgiq3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240919201310.GL182218@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919201310.GL182218@frogsfrogsfrogs>

On Thu, Sep 19, 2024 at 01:13:10PM -0700, Darrick J. Wong wrote:
> On Fri, Sep 20, 2024 at 04:07:03AM +0800, Zorro Lang wrote:
> > On Wed, Sep 18, 2024 at 01:57:19PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Zizhi Wo found some bugs in the GETFSMAP implementation if it is fed
> > > sub-fsblock ranges.  Add a regression test for this.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/generic/1954     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/1954.out |   15 +++++++++
> > >  2 files changed, 94 insertions(+)
> > >  create mode 100755 tests/generic/1954
> > >  create mode 100644 tests/generic/1954.out
> > > 
> > > 
> > > diff --git a/tests/generic/1954 b/tests/generic/1954
> > > new file mode 100755
> > > index 0000000000..cfdfaf15e2
> > > --- /dev/null
> > > +++ b/tests/generic/1954
> > > @@ -0,0 +1,79 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 1954
> > > +#
> > > +# Regression test for sub-fsblock key handling errors in GETFSMAP.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto rmap fsmap
> > > +
> > > +_fixed_by_kernel_commit XXXXXXXXXXXX \
> > > +	"xfs: Fix the owner setting issue for rmap query in xfs fsmap"
> > > +_fixed_by_kernel_commit XXXXXXXXXXXX \
> > > +	"xfs: Fix missing interval for missing_owner in xfs fsmap"
> > 
> > These 2 patches have been merged:
> > 
> >   68415b349f3f xfs: Fix the owner setting issue for rmap query in xfs fsmap
> >   ca6448aed4f1 xfs: Fix missing interval for missing_owner in xfs fsmap
> > 
> > I'll help to update the commit id when I merge it.
> 
> Oops, will go fix that.
> 
> > > +
> > > +. ./common/filter
> > > +
> > > +_require_xfs_io_command "fsmap"
> > > +_require_scratch
> > > +
> > > +_scratch_mkfs >> $seqres.full
> > > +_scratch_mount
> > > +
> > > +blksz=$(_get_block_size "$SCRATCH_MNT")
> > > +if ((blksz < 2048)); then
> > > +	_notrun "test requires at least 4 bblocks per fsblock"
> > 
> > What if the device is hard 4k sector size?
> 
> Doesn't matter, because the bug is in converting GETFSMAP inputs that
> are a multiple of 512 but not a multiple of $fsblocksize.
> 
> > > +fi
> > > +
> > > +$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT >> $seqres.full
> > > +
> > > +find_freesp() {
> > > +	$XFS_IO_PROG -c 'fsmap -d' $SCRATCH_MNT | tr '.[]:' '    ' | \
> > > +		grep 'free space' | awk '{printf("%s:%s\n", $4, $5);}' | \
> > > +		head -n 1
> > > +}
> > > +
> > > +filter_fsmap() {
> > > +	_filter_xfs_io_numbers | sed \
> > > +		-e 's/inode XXXX data XXXX..XXXX/inode data/g' \
> > > +		-e 's/inode XXXX attr XXXX..XXXX/inode attr/g' \
> > > +		-e 's/: free space XXXX/: FREE XXXX/g' \
> > > +		-e 's/: [a-z].*XXXX/: USED XXXX/g'
> > 
> > As this's a generic test case, I tried it on btrfs and ext4. btrfs got
> > _notrun "xfs_io fsmap support is missing", ext4 got failure as:
> > 
> >   # diff -u /root/git/xfstests/tests/generic/1954.out /root/git/xfstests/results//default/generic/1954.out.bad
> >   --- /root/git/xfstests/tests/generic/1954.out   2024-09-20 03:51:02.545504285 +0800
> >   +++ /root/git/xfstests/results//default/generic/1954.out.bad    2024-09-20 03:58:51.505271227 +0800
> >   @@ -1,15 +1,11 @@
> >    QA output created by 1954
> >    test incorrect setting of high key
> >   -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> >    test missing free space extent
> >           XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> >    test whatever came before freesp
> >   -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> >    test whatever came after freesp
> >   -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> >    test crossing start of freesp
> >           XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> >           XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> >    test crossing end of freesp
> >           XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> >   -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> 
> Yep, we'll still have to patch ext4 for this.  btrfs doesn't support
> GETFSMAP.

Great, thanks for you clarify the ext4 part. I can merge this patch
with that commit id change, if you don't want to change it more than
that. Or feel free to add my RVB in V2.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > +}
> > > +
> > > +$XFS_IO_PROG -c 'fsmap -d' $SCRATCH_MNT | filter_fsmap >> $seqres.full
> > > +
> > > +freesp="$(find_freesp)"
> > > +
> > > +freesp_start="$(echo "$freesp" | cut -d ':' -f 1)"
> > > +freesp_end="$(echo "$freesp" | cut -d ':' -f 2)"
> > > +echo "$freesp:$freesp_start:$freesp_end" >> $seqres.full
> > > +
> > > +echo "test incorrect setting of high key"
> > > +$XFS_IO_PROG -c 'fsmap -d 0 3' $SCRATCH_MNT | filter_fsmap
> > > +
> > > +echo "test missing free space extent"
> > > +$XFS_IO_PROG -c "fsmap -d $((freesp_start + 1)) $((freesp_start + 2))" $SCRATCH_MNT | \
> > > +	filter_fsmap
> > > +
> > > +echo "test whatever came before freesp"
> > > +$XFS_IO_PROG -c "fsmap -d $((freesp_start - 3)) $((freesp_start - 2))" $SCRATCH_MNT | \
> > > +	filter_fsmap
> > > +
> > > +echo "test whatever came after freesp"
> > > +$XFS_IO_PROG -c "fsmap -d $((freesp_end + 2)) $((freesp_end + 3))" $SCRATCH_MNT | \
> > > +	filter_fsmap
> > > +
> > > +echo "test crossing start of freesp"
> > > +$XFS_IO_PROG -c "fsmap -d $((freesp_start - 2)) $((freesp_start + 1))" $SCRATCH_MNT | \
> > > +	filter_fsmap
> > > +
> > > +echo "test crossing end of freesp"
> > > +$XFS_IO_PROG -c "fsmap -d $((freesp_end - 1)) $((freesp_end + 2))" $SCRATCH_MNT | \
> > > +	filter_fsmap
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/1954.out b/tests/generic/1954.out
> > > new file mode 100644
> > > index 0000000000..6baec43511
> > > --- /dev/null
> > > +++ b/tests/generic/1954.out
> > > @@ -0,0 +1,15 @@
> > > +QA output created by 1954
> > > +test incorrect setting of high key
> > > +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> > > +test missing free space extent
> > > +	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> > > +test whatever came before freesp
> > > +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> > > +test whatever came after freesp
> > > +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> > > +test crossing start of freesp
> > > +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> > > +	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> > > +test crossing end of freesp
> > > +	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> > > +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> > > 
> > > 
> > 
> 

