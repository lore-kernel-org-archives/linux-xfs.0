Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FBA233732
	for <linux-xfs@vger.kernel.org>; Sat, 22 Mar 2025 20:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742673879; cv=none; b=NzBtNk0DlvRQcBylmPV9j/TjbQe0T/LLimQdsoji0mQt35qfP/YT8AqXSYS7F/BVXlvby6zJsqHrxpGCx2RgBo7xMHJugczSYUNO/R1Qz+OxdbWDRZZ2bO6oKZugGm0YbfHJPiRcF6kSlN9BBp7ZQF4jIOke8DLNpXoZFvkXfjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742673879; c=relaxed/simple;
	bh=wwDPnkbQhAjVAcg/yKogAyQ00vyBhz1V1zSY3MxY/DA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KEES/zaoJs5lBc8exc92tySGCvGnNoN+dEGdHFa1FCIK4Z6I3aVNps91BSPyoEzywNRM4coOpErUoNETuzlv+HG7pD1Gs8omVfRGbqhgxd/+/BDzfZo20PXJzytGhIvWW1pbhE7Z+5UDJ63juL3XutXxdVDoDEISextwckurnks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=It0TSzYX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="It0TSzYX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742673876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g7X0LlOduCWBqta4XcFzAZbwxgwL75gmQxTP98tLJws=;
	b=It0TSzYXHsMw0oeVvq4UqOQAiVFKJiaEaXg0dQtLFmXrcn49InphiMMW4zWzryLnVKHzAX
	v4F0+6HHL4/aOsED58Ib9nGCKDEHI2GshODiWr5qj0TQrDRBwh3xrUPinatVUKcvwPvrhA
	RIj6BtVxJ56uHKJyeL41ybYPASI/1gA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-jR2sys9aNv-6TyIOLvZKPQ-1; Sat, 22 Mar 2025 16:04:35 -0400
X-MC-Unique: jR2sys9aNv-6TyIOLvZKPQ-1
X-Mimecast-MFC-AGG-ID: jR2sys9aNv-6TyIOLvZKPQ_1742673874
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-22650077995so79198215ad.3
        for <linux-xfs@vger.kernel.org>; Sat, 22 Mar 2025 13:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742673874; x=1743278674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7X0LlOduCWBqta4XcFzAZbwxgwL75gmQxTP98tLJws=;
        b=p1BsqBxFG+HXH/bsvBqoKkRuEm5PQpQ7qysQdjwHFkUNdTImVsdFsX0Cs3geW8nrwi
         +xcWsVn32BBorUTdw9jaelbBOFFRM6qs7GOND3IMGhRlqFaHm2Gww8EURgHmdNJNjnI/
         97XrhaQ66FVAI4LqURZn3KlrTfRlRug//c3yxBlAl6ruh0NqJwkZVoF3dD9CXKBWmbig
         xmkPXaYUbIozFhs6acGqkiuimW8R3GQSzfh6zOcxCVezAI61QwB9caYZ/Onrb/Xqs/2W
         yl445yH6hKmDqfZSYpQPuBfJ2hlUBhj9nFpAKNksIZGA70uVNAHCBjjBbUj7PS/y4GT3
         R1ZA==
X-Forwarded-Encrypted: i=1; AJvYcCX4awW1F78OmYHGrcoFXfV4S4EhohVyQAqu29K/KSBYqUuPn3Tpndn5nC68HBzW6hvvGg+rUQA7/hE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSnXp4c+mCYWGbG1TtuKhtesAxCKkZqhydWrRoXPzsYJII7yAs
	5366sUMbj55rIArd5pUzpYBTKmLZhiuImT4IykaXj0mGJ/yXq4HxUKiJjhm5TuEpqFloS+2CKi0
	cChU5+u17fkDZ2OU+QruD50SgNLJbMduqXoigxsGA30NzhDuaX92Yk10XFg==
X-Gm-Gg: ASbGncupD/dE5BHygou516kX1SDWyRtFhI4Hswxkg0xNfJIddOGASHAPzF1zevy8XG4
	84P34aZedjn8/uf8Qhava3S6PeP7s+8mMQqvjYYshyfzpzeAIRTNpcV7YPAo1KBJ6a+aExUMB/p
	wK4d7hmRKBlO0nShustcv+/vO/DiZoLCfxDNVVwv+lpuzECA8RXJyLxxlCc17XKWdUo6QfK0VLe
	NBNGkEiXaJc2ecNRy04DTMmQSJx2sgvkWzdBtNy9N7yDrjhZlwxj3O4IqK14E0fPgGdzymQOw3j
	0qO28tb6mfXXMA2cGPVl7aRTFKCM2lr3fwTYzjq1X4P1s4zIth+EKPBW
X-Received: by 2002:a17:903:2410:b0:21f:dbb:20a6 with SMTP id d9443c01a7336-22780e011d2mr129987665ad.33.1742673873958;
        Sat, 22 Mar 2025 13:04:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEpbIPlUeh+YseI0/rScH2Yha5ZYI/UxFczOkSLSpa8fY6RRHBSk2E0hoYnx9cIC68J8vOiQ==
X-Received: by 2002:a17:903:2410:b0:21f:dbb:20a6 with SMTP id d9443c01a7336-22780e011d2mr129987355ad.33.1742673873362;
        Sat, 22 Mar 2025 13:04:33 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f3966esm39669185ad.13.2025.03.22.13.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Mar 2025 13:04:32 -0700 (PDT)
Date: Sun, 23 Mar 2025 04:04:29 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test filesystem recovery with rdump
Message-ID: <20250322200429.7xtqnvss64qbt4ib@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <174259233514.743419.14108043386932063353.stgit@frogsfrogsfrogs>
 <174259233533.743419.11473495762149004746.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174259233533.743419.11473495762149004746.stgit@frogsfrogsfrogs>

On Fri, Mar 21, 2025 at 02:27:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Test how well we can dump a fully populated filesystem's contents.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/1895     |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1895.out |    6 ++
>  2 files changed, 159 insertions(+)
>  create mode 100755 tests/xfs/1895
>  create mode 100644 tests/xfs/1895.out
> 
> 
> diff --git a/tests/xfs/1895 b/tests/xfs/1895
> new file mode 100755
> index 00000000000000..18b534d328e9fd
> --- /dev/null
> +++ b/tests/xfs/1895
> @@ -0,0 +1,153 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 1895
> +#
> +# Populate a XFS filesystem, ensure that rdump can "recover" the contents to
> +# another directory, and compare the contents.
> +#
> +. ./common/preamble
> +_begin_fstest auto scrub
> +
> +_cleanup()
> +{
> +	command -v _kill_fsstress &>/dev/null && _kill_fsstress

I'm wondering why you always do "command -v _kill_fsstress &>/dev/null" before
_kill_fsstress, isn't _kill_fsstress a common helper in common/rc ?

Thanks,
Zorro

> +	cd /
> +	test -e "$testfiles" && rm -r -f $testfiles
> +}
> +
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/populate
> +. ./common/fuzzy
> +
> +_require_xfs_db_command "rdump"
> +_require_test
> +_require_scratch
> +_require_scrub
> +_require_populate_commands
> +
> +make_md5()
> +{
> +	(cd $1 ; find . -type f -print0 | xargs -0 md5sum) > $tmp.md5.$2
> +}
> +
> +cmp_md5()
> +{
> +	(cd $1 ; md5sum --quiet -c $tmp.md5.$2)
> +}
> +
> +make_stat()
> +{
> +	# columns:	raw mode in hex,
> +	# 		major rdev for special
> +	# 		minor rdev for special
> +	# 		uid of owner
> +	# 		gid of owner
> +	# 		file type
> +	# 		total size
> +	# 		mtime
> +	# 		name
> +	# We can't directly control directory sizes so filter them.
> +	# Too many things can bump (or not) atime so don't test that.
> +	(cd $1 ; find . -print0 |
> +		xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n' |
> +		sed -e 's/ directory [1-9][0-9]* / directory SIZE /g' |
> +		sort) > $tmp.stat.$2
> +}
> +
> +cmp_stat()
> +{
> +	diff -u $tmp.stat.$1 $tmp.stat.$2
> +}
> +
> +make_stat_files() {
> +	for file in "${FILES[@]}"; do
> +		find "$1/$file" -print0 | xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n'
> +	done | sed \
> +		-e 's/ directory [1-9][0-9]* / directory SIZE /g' \
> +		-e "s| $1| DUMPDIR|g" \
> +		| sort > $tmp.stat.files.$2
> +}
> +
> +cmp_stat_files()
> +{
> +	diff -u $tmp.stat.files.$1 $tmp.stat.files.$2
> +}
> +
> +make_stat_dir() {
> +	find "$1" -print0 | \
> +		xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n' | sed \
> +		-e 's/ directory [1-9][0-9]* / directory SIZE /g' \
> +		-e "s| $1| DUMPDIR|g" \
> +		| sort > $tmp.stat.dir.$2
> +}
> +
> +cmp_stat_dir()
> +{
> +	diff -u $tmp.stat.dir.$1 $tmp.stat.dir.$2
> +}
> +
> +FILES=(
> +	"/S_IFDIR.FMT_INLINE"
> +	"/S_IFBLK"
> +	"/S_IFCHR"
> +	"/S_IFLNK.FMT_LOCAL"
> +	"/S_IFIFO"
> +	"/S_IFDIR.FMT_INLINE/00000001"
> +	"/ATTR.FMT_EXTENTS_REMOTE3K"
> +	"/S_IFREG.FMT_EXTENTS"
> +	"/S_IFREG.FMT_BTREE"
> +	"/BNOBT"
> +	"/S_IFDIR.FMT_BLOCK"
> +)
> +DIR="/S_IFDIR.FMT_LEAF"
> +
> +testfiles=$TEST_DIR/$seq
> +mkdir -p $testfiles
> +
> +echo "Format and populate"
> +_scratch_populate_cached nofill > $seqres.full 2>&1
> +_scratch_mount
> +
> +_run_fsstress -n 500 -d $SCRATCH_MNT/newfiles
> +
> +make_stat $SCRATCH_MNT before
> +make_md5 $SCRATCH_MNT before
> +make_stat_files $SCRATCH_MNT before
> +make_stat_dir $SCRATCH_MNT/$DIR before
> +_scratch_unmount
> +
> +echo "Recover filesystem"
> +dumpdir1=$testfiles/rdump
> +dumpdir2=$testfiles/sdump
> +dumpdir3=$testfiles/tdump
> +rm -r -f $dumpdir1 $dumpdir2 $dumpdir3
> +
> +# as of linux 6.12 fchownat does not work on symlinks
> +_scratch_xfs_db -c "rdump / $dumpdir1" | sed -e '/could not be set/d'
> +_scratch_xfs_db -c "rdump ${FILES[*]} $dumpdir2" | sed -e '/could not be set/d'
> +_scratch_xfs_db -c "rdump $DIR $dumpdir3" | sed -e '/could not be set/d'
> +
> +echo "Check file contents"
> +make_stat $dumpdir1 after
> +cmp_stat before after
> +cmp_md5 $dumpdir1 before
> +
> +echo "Check selected files contents"
> +make_stat_files $dumpdir2 after
> +cmp_stat_files before after
> +
> +echo "Check single dir extraction contents"
> +make_stat_dir $dumpdir3 after
> +cmp_stat_dir before after
> +
> +# remount so we can check this fs
> +_scratch_mount
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1895.out b/tests/xfs/1895.out
> new file mode 100644
> index 00000000000000..de639ed3fc7e38
> --- /dev/null
> +++ b/tests/xfs/1895.out
> @@ -0,0 +1,6 @@
> +QA output created by 1895
> +Format and populate
> +Recover filesystem
> +Check file contents
> +Check selected files contents
> +Check single dir extraction contents
> 

